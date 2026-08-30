# Patesi - doctor
#
# Responde en segundos a la pregunta que mas tiempo hace perder:
# "¿estoy corriendo lo que creo que estoy corriendo?"
#
# Uso: python scripts/patesi-doctor.py
#
# Existe porque `git pull` NO actualiza a Patesi: el agente vive en
# ~/.config/opencode/, no en el repo. Ya paso una vez tener 9 skills
# instalados y sin system.md mientras el repo tenia todo.

import io, os, re, sys, subprocess, hashlib

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
os.chdir(ROOT)

OK, WARN, BAD = 'ok', 'aviso', 'problema'
avisos, problemas = [], []


def line(estado, texto):
    marca = {'ok': '  ', 'aviso': '! ', 'problema': 'X '}[estado]
    print('%s%s' % (marca, texto))
    if estado == WARN:
        avisos.append(texto)
    elif estado == BAD:
        problemas.append(texto)


def git(*args):
    try:
        return subprocess.check_output(('git',) + args, text=True,
                                       stderr=subprocess.DEVNULL).strip()
    except Exception:
        return ''


def sha(path):
    return hashlib.sha256(open(path, 'rb').read()).hexdigest()


def opencode_dir():
    home = os.path.expanduser('~')
    for cand in (os.path.join(home, '.config', 'opencode'),
                 os.path.join(os.environ.get('USERPROFILE', home), '.config', 'opencode')):
        if os.path.isdir(cand):
            return cand
    return None


print('Patesi — doctor\n')

# ------------------------------------------------------------------ 1. repo
print('REPOSITORIO')
head = git('log', '--oneline', '-1')
line(OK, 'HEAD: %s' % (head or 'desconocido'))

sucio = git('status', '--porcelain')
if sucio:
    n = len([l for l in sucio.split('\n') if l.strip()])
    line(WARN, 'arbol con %d archivo(s) sin commitear' % n)
else:
    line(OK, 'arbol limpio')

git('fetch', 'origin', '-q')
div = git('rev-list', '--left-right', '--count', 'main...origin/main')
if div:
    adelante, atras = (div.split() + ['?', '?'])[:2]
    if adelante == '0' and atras == '0':
        line(OK, 'sincronizado con origin/main')
    else:
        line(WARN, 'divergencia con origin/main: %s adelante, %s atras' % (adelante, atras))
else:
    line(WARN, 'no se pudo comparar con origin/main')

# ------------------------------------------------------- 2. instalacion real
print('\nINSTALACION (lo que Patesi realmente ejecuta)')
oc = opencode_dir()
if not oc:
    line(WARN, 'no se encontro ~/.config/opencode — opencode no instalado en esta maquina')
else:
    line(OK, 'directorio: %s' % oc)

    pares = [('agent.md', os.path.join(oc, 'agents', 'patesi.md')),
             ('system.md', os.path.join(oc, 'agents', 'system.md'))]
    for origen, destino in pares:
        if not os.path.exists(destino):
            line(BAD, '%s NO esta instalado' % os.path.basename(destino))
            continue
        if sha(origen) == sha(destino):
            line(OK, '%s identico al repo' % os.path.basename(destino))
        else:
            line(BAD, '%s DIFIERE del repo' % os.path.basename(destino))

    repo_skills = {d for d in os.listdir('skills') if d.startswith('sdet-')}
    inst_dir = os.path.join(oc, 'skills')
    inst_skills = ({d for d in os.listdir(inst_dir) if d.startswith('sdet-')}
                   if os.path.isdir(inst_dir) else set())

    faltan = repo_skills - inst_skills
    sobran = inst_skills - repo_skills
    if not faltan and not sobran:
        distintos = [s for s in sorted(repo_skills)
                     if os.path.exists(os.path.join(inst_dir, s, 'SKILL.md'))
                     and sha(os.path.join('skills', s, 'SKILL.md'))
                     != sha(os.path.join(inst_dir, s, 'SKILL.md'))]
        if distintos:
            line(BAD, '%d skill(s) instalados con contenido distinto: %s'
                 % (len(distintos), ', '.join(distintos[:4])))
        else:
            line(OK, '%d/%d skills instalados e identicos' % (len(inst_skills), len(repo_skills)))
    else:
        if faltan:
            line(BAD, 'faltan %d skill(s): %s' % (len(faltan), ', '.join(sorted(faltan)[:5])))
        if sobran:
            line(WARN, 'sobran %d skill(s) de una version anterior: %s'
                 % (len(sobran), ', '.join(sorted(sobran)[:5])))

    if problemas:
        line(WARN, 'ejecuta adapters/opencode/scripts/install.ps1 (o .sh) y reinicia opencode')

# ------------------------------------------------------------- 3. fuentes
print('\nFUENTES NORMATIVAS')
if not os.path.exists('SOURCES.yaml'):
    line(WARN, 'no existe SOURCES.yaml — no se puede saber que version alimenta los skills')
else:
    txt = io.open('SOURCES.yaml', encoding='utf-8').read()
    for m in re.finditer(r'-\s+id:\s*(\S+).*?nombre:\s*"([^"]+)".*?version:\s*"([^"]+)".*?fecha:\s*"([^"]+)"',
                         txt, re.S):
        _id, nombre, version, fecha = m.groups()
        line(OK, '%s — v%s (%s)' % (nombre, version, fecha))
    borrador = txt.count('BORRADOR')
    if borrador:
        line(WARN, '%d fuente(s) en estado BORRADOR con umbrales provisionales v0' % borrador)
    faltantes = len(re.findall(r'^\s+-\s+nombre:', txt.split('faltantes:')[-1], re.M)) if 'faltantes:' in txt else 0
    if faltantes:
        line(WARN, '%d fuente(s) referenciadas por la normativa que todavia no tenemos' % faltantes)

# ------------------------------------------------------------ 4. verificacion
print('\nVERIFICACION')
for script, etiqueta in (('scripts/check-consistency.py', 'consistencia interna'),
                         ('scripts/check-sqem-matrix.py', 'matriz de gates SQEM')):
    if not os.path.exists(script):
        line(WARN, 'falta %s' % script)
        continue
    r = subprocess.run([sys.executable, script], capture_output=True, text=True)
    if r.returncode == 0:
        line(OK, '%s: sin problemas' % etiqueta)
    else:
        line(BAD, '%s: FALLA — corre `python %s` para el detalle' % (etiqueta, script))

# ------------------------------------------------------------ 5. evaluacion
print('\nEVALUACION DE COMPORTAMIENTO')
for f, etiqueta in (('tests/smoke-comportamiento.md', 'smoke (8 casos, ~5 min)'),
                    ('tests/guiones-evaluacion.md', 'guiones completos')):
    if os.path.exists(f):
        line(OK, '%s disponible en %s' % (etiqueta, f))
    else:
        line(WARN, 'falta %s' % f)
line(WARN, 'la evaluacion de comportamiento es MANUAL: ningun check la reemplaza')

# ------------------------------------------------------------------ resumen
print('\n' + '-' * 60)
if problemas:
    print('%d problema(s) y %d aviso(s).' % (len(problemas), len(avisos)))
    sys.exit(1)
if avisos:
    print('Sin problemas. %d aviso(s) para revisar.' % len(avisos))
    sys.exit(0)
print('Todo en orden.')
sys.exit(0)
