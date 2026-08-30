# Patesi - Verificador de consistencia interna
#
# Uso:
#   python scripts/check-consistency.py            checks rapidos (<2s)
#   python scripts/check-consistency.py --full      + idempotencia y paridad
#
# Sale con codigo 1 si encuentra algun problema.
#
# Principio de diseno: CERO FALSOS POSITIVOS. Un check que grita sin razon
# se termina ignorando, y un check ignorado da falsa seguridad. Si un caso
# es dudoso, se documenta como excepcion en vez de reportarlo.
#
# Implementacion unica en Python a proposito: los generadores tienen version
# .ps1 y .sh y ya aparecio un bug por divergencia entre ambas. Duplicar los
# checks duplicaria esa superficie.

import io, os, re, sys, json, subprocess, hashlib

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
os.chdir(ROOT)

FULL = '--full' in sys.argv
problems = []
notes = []


def fail(area, msg, fix=''):
    problems.append((area, msg, fix))


def read(path):
    return io.open(path, encoding='utf-8').read()


def skill_dirs():
    return sorted(d for d in os.listdir('skills')
                  if d.startswith('sdet-') and os.path.isdir(os.path.join('skills', d)))


# ---------------------------------------------------------------- utilidades
def strip_code(text, keep_markdown_fences=False):
    """Quita bloques de codigo. Si keep_markdown_fences, conserva el
    contenido de las fences ```markdown, que NO es codigo sino la plantilla
    de salida que el agente entrega al usuario."""
    out, inside, lang = [], False, ''
    for line in text.splitlines():
        m = re.match(r'^\s*```(\w*)', line)
        if m:
            if not inside:
                inside, lang = True, m.group(1)
                if keep_markdown_fences and lang == 'markdown':
                    inside = False
            else:
                inside, lang = False, ''
            continue
        if not inside:
            out.append(line)
    return '\n'.join(out)


def strip_inline_code(text):
    """Quita spans `...` — ahi vive codigo, nombres de API y comandos.
    Tambien quita cadenas entre comillas dobles: en los ejemplos son mensajes
    de la aplicacion bajo prueba, que se conservan en su idioma original a
    proposito (un error de la app no se traduce al citarlo)."""
    text = re.sub(r'`[^`\n]*`', ' ', text)
    return re.sub(r'"[^"\n]*"', ' ', text)


# =========================================================== CAPA 1 — estructura
def check_counts():
    """Los 4 lugares donde vive el catalogo deben coincidir."""
    dirs = len(skill_dirs())
    registry = len(re.findall(r'^\| `sdet-', read('.atl/skill-registry.md'), re.M))
    config = len(re.findall(r'^  - name:', read('config.yaml'), re.M))
    sysmd = read('system.md')
    block = sysmd.split('SKILL_TABLE_START')[1].split('SKILL_TABLE_END')[0]
    table = len(re.findall(r'`sdet-[a-z-]+`', block))

    counts = {'directorios': dirs, 'registry': registry,
              'config.yaml': config, 'system.md §8': table}
    if len(set(counts.values())) != 1:
        fail('conteos', 'el catalogo no coincide en los 4 lugares: %s' % counts,
             'corre scripts/generate-registry.ps1 (o .sh) y volve a verificar')
    else:
        notes.append('catalogo coherente en 4 lugares: %d skills' % dirs)


def check_markers():
    """Sin markers, toda regeneracion falla en silencio o a medias."""
    expected = [('config.yaml', 'SKILLS_BLOCK', 2),
                ('system.md', 'SKILL_TABLE', 2),
                ('system.md', 'COPILOT-EXTRACT', 6)]
    for path, marker, n in expected:
        got = read(path).count(marker)
        if got != n:
            fail('markers', '%s tiene %d ocurrencias de %s, se esperaban %d'
                 % (path, got, marker, n),
                 'restaura los markers antes de regenerar; sin ellos el generador falla')


def check_frontmatter():
    """Todo skill necesita frontmatter valido para entrar al catalogo."""
    for d in skill_dirs():
        path = os.path.join('skills', d, 'SKILL.md')
        if not os.path.exists(path):
            fail('frontmatter', '%s no tiene SKILL.md' % d, 'crealo o borra el directorio')
            continue
        txt = read(path)
        m = re.match(r'^---\s*\n(.*?)\n---', txt, re.S)
        if not m:
            fail('frontmatter', '%s: sin frontmatter' % d, 'agrega el bloque --- al inicio')
            continue
        fm = m.group(1)
        if not re.search(r'^name:\s*\S', fm, re.M):
            fail('frontmatter', '%s: falta name:' % d)
        if 'Trigger:' not in fm:
            fail('frontmatter', '%s: falta Trigger: en la descripcion' % d,
                 'sin el, el generador usa la descripcion como trigger')
        if not re.search(r'^\s+category:\s*\S', fm, re.M):
            fail('frontmatter', '%s: falta metadata.category' % d,
                 'el generador lo necesita para agrupar en config.yaml')
        name = re.search(r'^name:\s*(\S+)', fm, re.M)
        if name and name.group(1) != d:
            fail('frontmatter', '%s: el name del frontmatter es "%s"' % (d, name.group(1)),
                 'name y nombre de directorio deben coincidir')


def check_references():
    """Todo skill citado en el nucleo o los adapters debe existir."""
    existing = set(skill_dirs())
    sources = ['system.md', 'agent.md', 'adapters/opencode/patesi.md',
               'adapters/copilot/copilot-instructions.md', 'README.md']
    for src in sources:
        if not os.path.exists(src):
            continue
        for ref in set(re.findall(r'`(sdet-[a-z0-9-]+)`', read(src))):
            if ref not in existing:
                fail('referencias', '%s cita `%s`, que no existe' % (src, ref),
                     'corregi el nombre o crea el skill')
    # inverso: todo skill debe ser alcanzable desde el catalogo
    registry = read('.atl/skill-registry.md')
    for d in existing:
        if '`%s`' % d not in registry:
            fail('referencias', '%s no aparece en el registry' % d,
                 'regenera el catalogo')


def check_git_hygiene():
    """Archivos ignorados pero trackeados, y temporales olvidados."""
    try:
        tracked = subprocess.check_output(['git', 'ls-files'], text=True).split('\n')
    except Exception:
        notes.append('git no disponible: se omite la higiene de repositorio')
        return
    for f in tracked:
        if not f:
            continue
        if f.endswith('.tmp'):
            fail('git', '%s esta trackeado y es un temporal' % f, 'git rm --cached %s' % f)
        if f == '.atl/.skill-registry.cache.json':
            fail('git', '%s esta trackeado pese al .gitignore' % f,
                 'git rm --cached %s — lo escribe una herramienta externa' % f)
    for f in os.listdir('.'):
        if f.endswith('.tmp'):
            fail('git', 'quedo %s en la raiz' % f,
                 'lo deja generate-registry.sh si se interrumpe; borralo')


def check_token_budget():
    """Ningun skill puede pasar de 4000 tokens; el nucleo de 12000."""
    MAX_SKILL, MAX_CORE = 4000, 12000
    for d in skill_dirs():
        path = os.path.join('skills', d, 'SKILL.md')
        words = len(read(path).split())
        est = int(words * 1.3)
        if est > MAX_SKILL:
            fail('presupuesto', '%s estima %d tokens (max %d)' % (d, est, MAX_SKILL),
                 'divide el skill o recorta contenido')
    core = len(read('agent.md').split()) + len(read('system.md').split())
    est = int(core * 1.3)
    if est > MAX_CORE:
        fail('presupuesto', 'el nucleo estima %d tokens (max %d)' % (est, MAX_CORE),
             'move contenido del nucleo a un skill')
    else:
        notes.append('nucleo agnostico: ~%d/%d tokens' % (est, MAX_CORE))


# =========================================================== CAPA 2 — contenido
# Palabras cuya forma sin tilde nunca es correcta en castellano.
ACENTOS = {
    'Analisis': 'Análisis', 'analisis': 'análisis',
    'Clasificacion': 'Clasificación', 'clasificacion': 'clasificación',
    'Construccion': 'Construcción', 'construccion': 'construcción',
    'Aceptacion': 'Aceptación', 'aceptacion': 'aceptación',
    'Garantia': 'Garantía', 'garantia': 'garantía',
    'Ejecucion': 'Ejecución', 'ejecucion': 'ejecución',
    'Operacion': 'Operación', 'operacion': 'operación',
    'Integracion': 'Integración', 'integracion': 'integración',
    'Regresion': 'Regresión', 'regresion': 'regresión',
    'Tipologia': 'Tipología', 'tipologia': 'tipología',
    'Semaforo': 'Semáforo', 'Barometro': 'Barómetro', 'Comite': 'Comité',
    'estatico': 'estático', 'tecnicos': 'técnicos', 'tecnica': 'técnica',
    'critica': 'crítica', 'Critico': 'Crítico', 'critico': 'crítico',
    'mision': 'misión', 'codigo': 'código', 'produccion': 'producción',
    'metrica': 'métrica', 'metricas': 'métricas',
}

# Terminos ingleses que en este repo son legitimos y no deben reportarse.
INGLES_OK = re.compile(
    r'\b(the|and|or)\b(?=[^\n]*\b(Given|When|Then|describe|it|test|expect)\b)', re.I)

PALABRAS_INGLES = re.compile(
    r'\b(the|and|should|must|with|from|which|that|are|were|been|this|these|'
    r'those|when|where|will|would|could|about|there|their)\b', re.I)


def check_acentos():
    """Los acentos rotos se regeneraban desde el mapa de los generadores:
    hay que revisar tambien el codigo, no solo el markdown."""
    targets = [os.path.join('skills', d, 'SKILL.md') for d in skill_dirs()]
    targets += ['system.md', 'agent.md', 'README.md', 'config.yaml',
                'scripts/generate-registry.ps1', 'scripts/generate-registry.sh',
                'adapters/opencode/patesi.md', 'adapters/opencode/tools.md']
    for path in targets:
        if not os.path.exists(path):
            continue
        txt = read(path)
        for bad, good in ACENTOS.items():
            for m in re.finditer(r'(?<![\w\-/])%s(?![\w\-])' % re.escape(bad), txt):
                line = txt[:m.start()].count('\n') + 1
                fail('acentos', '%s:%d "%s" deberia ser "%s"' % (path, line, bad, good),
                     'si el archivo es generado, corregi tambien el mapa del generador')


def check_idioma():
    """Dos barridos: prosa fuera de fences, Y dentro de fences ```markdown,
    que no son codigo sino la plantilla que el agente entrega al usuario.
    Ese segundo barrido es el que dos auditorias no hicieron."""
    for d in skill_dirs():
        path = os.path.join('skills', d, 'SKILL.md')
        txt = read(path)
        for etiqueta, cuerpo in (('prosa', strip_code(txt)),
                                 ('plantilla de salida', _only_markdown_fences(txt))):
            cuerpo = strip_inline_code(cuerpo)
            for i, line in enumerate(cuerpo.splitlines(), 1):
                if line.strip().startswith('Trigger:'):
                    continue
                hits = PALABRAS_INGLES.findall(line)
                if len(hits) >= 2:
                    fail('idioma', '%s [%s] ingles residual: "%s"'
                         % (d, etiqueta, line.strip()[:70]),
                         'traduci al castellano; las fences ```markdown son entregables, no codigo')


def _only_markdown_fences(text):
    out, inside = [], False
    for line in text.splitlines():
        m = re.match(r'^\s*```(\w*)', line)
        if m:
            inside = (m.group(1) == 'markdown') if not inside else False
            continue
        if inside:
            out.append(line)
    return '\n'.join(out)


TIPOLOGIAS = [
    'Nuevo desarrollo', 'Mantenimiento evolutivo', 'Mantenimiento correctivo',
    'Hotfix / Emergencia', 'Transformación / migración',
    'Integraciones / APIs / datos', 'Producto digital / canal usuario',
    'Paquetizado (SAP/Salesforce', 'Producto de mercado', 'IA / ML / GenAI',
    'Data & Analytics / BI', 'Infraestructura / DevOps / Cloud',
    'RPA / Automatización', 'Ciberseguridad', 'Consultoría',
]


def check_tipologias():
    """Las 15 tipologias se nombran en 3 skills. Si divergen, la matriz deja
    de ser legible desde la clasificacion — ese bug ya ocurrio (1 de 15)."""
    for skill in ('sdet-sqem-classification', 'sdet-sqem-gate-matrix',
                  'sdet-sqem-typology-tests'):
        path = os.path.join('skills', skill, 'SKILL.md')
        if not os.path.exists(path):
            continue
        txt = read(path)
        faltan = [t for t in TIPOLOGIAS if t not in txt]
        if faltan:
            fail('tipologias', '%s no usa los nombres canonicos: %s'
                 % (skill, ', '.join(faltan)),
                 'los nombres canonicos son los de §5.2 de la normativa')


def check_matriz_notas():
    """Los marcadores de nota deben estar definidos y usados, y ninguna fila
    base puede llevar marcadores que dependan del NAQ."""
    path = 'skills/sdet-sqem-gate-matrix/SKILL.md'
    if not os.path.exists(path):
        return
    txt = read(path)
    M = '①②③④⑤⑥⑦⑧'
    idx = {c: i + 1 for i, c in enumerate(M)}
    definidos = {idx[c] for c in re.findall(r'- \*\*([' + M + r'])\*\*', txt)}
    tabla = txt.split('## Matriz resuelta')[1].split('## Cómo comunicar')[0]
    usados = {idx[c] for c in re.findall('[' + M + ']', tabla)}
    if usados - definidos:
        fail('matriz', 'marcadores usados sin definir: %s' % sorted(usados - definidos))
    if definidos - usados:
        fail('matriz', 'marcadores definidos sin usar: %s' % sorted(definidos - usados))
    NAQ_DEPENDIENTES = {2, 3, 4, 6}
    for line in tabla.splitlines():
        if not line.startswith('|'):
            continue
        cells = [c.strip() for c in line.strip().strip('|').split('|')]
        if len(cells) != 10 or cells[1] != '—':
            continue
        for c in cells[2:]:
            for m in re.findall('[' + M + ']', c):
                if idx[m] in NAQ_DEPENDIENTES:
                    fail('matriz', 'la fila base de "%s" lleva el marcador %s, que depende '
                         'del NAQ' % (cells[0], m),
                         'en la fila base el NAQ no esta definido: nada puede estar resuelto')


def check_citas_sqem():
    """Todo lo que un skill SQEM afirma deberia citar su §. Contenido sin
    seccion citada es sospechoso de ser invencion propia."""
    for d in [s for s in skill_dirs() if s.startswith('sdet-sqem-')]:
        txt = read(os.path.join('skills', d, 'SKILL.md'))
        citas = len(re.findall(r'§\d', txt))
        if citas < 3:
            fail('trazabilidad', '%s cita solo %d secciones de la normativa' % (d, citas),
                 'toda afirmacion normativa debe llevar su § o es sospechosa de invencion')
        else:
            notes.append('%s: %d citas a la normativa' % (d, citas))


# =========================================================== CAPA 1b — costosos
def _run(cmd):
    return subprocess.run(cmd, shell=True, capture_output=True, text=True)


def check_idempotencia():
    """Generar dos veces debe dejar el repo igual. Si no, cada regeneracion
    ensucia el arbol y el ruido esconde los cambios reales."""
    watched = ['system.md', 'config.yaml', '.atl/skill-registry.md']
    gen = ('powershell -NoProfile -Command ".\\scripts\\generate-registry.ps1"'
           if os.name == 'nt' else 'bash scripts/generate-registry.sh')
    before = {f: hashlib.md5(open(f, 'rb').read()).hexdigest() for f in watched}
    r = _run(gen)
    if r.returncode != 0:
        # Sin esta guarda el check pasaba solo: si el generador no corre, los
        # tres hashes son iguales y la idempotencia parece perfecta.
        if _shell_no_disponible(r):
            notes.append('idempotencia NO verificada: no se pudo ejecutar el '
                         'generador en esta maquina')
        else:
            fail('idempotencia', 'el generador fallo', r.stderr.strip()[:200])
        return
    mid = {f: hashlib.md5(open(f, 'rb').read()).hexdigest() for f in watched}
    _run(gen)
    after = {f: hashlib.md5(open(f, 'rb').read()).hexdigest() for f in watched}
    for f in watched:
        if mid[f] != after[f]:
            fail('idempotencia', '%s cambia en cada corrida del generador' % f,
                 'el generador agrega contenido en vez de reemplazarlo')
        elif before[f] != mid[f]:
            fail('idempotencia', '%s estaba desactualizado respecto del generador' % f,
                 'commitea la regeneracion')


def _shell_no_disponible(r):
    """Distingue 'el builder fallo' de 'el shell no existe en esta maquina'.

    En Windows, `bash` desde PowerShell cae en la WSL rota del usuario en vez
    de en Git Bash. Eso no es un fallo de paridad: es que el check no se pudo
    correr. Reportarlo como FALLA seria un falso positivo, y un check con
    falsos positivos se termina ignorando."""
    err = (r.stderr or '') + (r.stdout or '')
    err = err.replace('\x00', '')  # la WSL escupe UTF-16
    marcas = ('execvpe', 'wsl.conf', 'WSL (', 'no se reconoce',
              'not recognized', 'command not found', 'No such file or directory')
    return r.returncode == 127 or any(m in err for m in marcas)


def check_paridad_builders():
    """Los dos builders del adapter de Copilot deben producir lo mismo. Si
    divergen, el resultado depende de que shell uses."""
    out = 'adapters/copilot/copilot-instructions.md'
    ps1 = 'powershell -NoProfile -Command ".\\adapters\\copilot\\scripts\\build-copilot-adapter.ps1"'
    sh = 'bash adapters/copilot/scripts/build-copilot-adapter.sh'
    primero, segundo = (ps1, sh) if os.name == 'nt' else (sh, ps1)

    salidas = []
    for cmd in (primero, segundo):
        r = _run(cmd)
        if r.returncode != 0:
            if _shell_no_disponible(r):
                notes.append('paridad NO verificada: no se pudo ejecutar `%s` en '
                             'esta maquina. Corre el check desde Git Bash o mira '
                             'el CI.' % cmd.split()[0])
                return
            fail('paridad', 'un builder fallo', r.stderr.strip()[:200])
            return
        salidas.append(open(out, 'rb').read())

    if salidas[0] != salidas[1]:
        fail('paridad', 'los builders .ps1 y .sh producen adapters distintos',
             'el comportamiento de Patesi dependeria de que shell uses')


# =========================================================== ejecucion
FAST = [
    ('conteos del catalogo', check_counts),
    ('markers de generacion', check_markers),
    ('frontmatter de skills', check_frontmatter),
    ('referencias cruzadas', check_references),
    ('higiene de git', check_git_hygiene),
    ('presupuesto de tokens', check_token_budget),
    ('acentos', check_acentos),
    ('idioma', check_idioma),
    ('nombres de tipologia', check_tipologias),
    ('notas de la matriz', check_matriz_notas),
    ('citas a la normativa', check_citas_sqem),
]
SLOW = [
    ('idempotencia de generadores', check_idempotencia),
    ('paridad de builders', check_paridad_builders),
]


def main():
    print('Patesi — verificacion de consistencia%s\n' % (' (completa)' if FULL else ''))
    for name, fn in FAST + (SLOW if FULL else []):
        n = len(problems)
        try:
            fn()
        except Exception as e:
            fail(name, 'el check reviento: %s' % e)
        estado = 'OK' if len(problems) == n else 'FALLA'
        print('  [%-5s] %s' % (estado, name))

    if not FULL:
        print('\n  (omitidos por costo: idempotencia y paridad — corre con --full)')

    if notes:
        print('\nInformacion:')
        for n in notes[:8]:
            print('  · %s' % n)

    if problems:
        print('\n%d problema(s):\n' % len(problems))
        for area, msg, fix in problems:
            print('  [%s] %s' % (area, msg))
            if fix:
                print('      -> %s' % fix)
        return 1
    print('\nSin problemas.')
    return 0


if __name__ == '__main__':
    sys.exit(main())
