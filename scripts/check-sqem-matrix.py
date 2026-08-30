# Patesi - Verificador de la matriz de gates SQEM
#
# Uso:  python scripts/check-sqem-matrix.py     (desde la raiz del repo)
# Sale con codigo 1 si encuentra alguna diferencia.
#
# Por que existe: la matriz de skills/sdet-sqem-gate-matrix/ se extrajo del
# configurador de gobernanza de la Oficina de Calidad. Son 480 celdas. Este
# script las valida contra una fuente DISTINTA (la tabla §6.4 del Modelo
# extendido) y contra las reglas de §6.5.
#
# Cuando Seidor publique una version nueva de la normativa, actualiza
# BASE_6_4 con su tabla §6.4 y volve a correrlo antes de tocar la matriz.
# Check 1 (cruzado): las filas base (NAQ "—") deben coincidir con la tabla §6.4
#                    del "Modelo extendido", que es un documento DISTINTO del
#                    configurador del que se extrajo la matriz resuelta.
# Check 2 (estructural): cada fila con NAQ debe ser coherente con su fila base
#                    bajo las reglas de §6.5; toda desviacion se lista para
#                    revision manual contra las notas documentadas.

import io, re, sys

MATRIX = 'skills/sdet-sqem-gate-matrix/SKILL.md'

# --- Fuente independiente: tabla §6.4 del Modelo extendido v1.2 -------------
# F=Formal L=Ligero C=Condicional Fc=Formal condicional (si hay codigo/dev/...)
# NA=No aplica
BASE_6_4 = {
    'Nuevo desarrollo':                 ['F','F','F','F','F','F','F','F'],
    'Mantenimiento evolutivo':          ['L','L','C','Fc','C','C','F','L'],
    'Mantenimiento correctivo':         ['L','L','NA','Fc','C','C','F','L'],
    'Hotfix / Emergencia':              ['NA','L','NA','L','L','NA','F','L'],
    'Transformación / migración':       ['F','F','F','F','F','F','F','F'],
    'Integraciones / APIs / datos':     ['F','F','F','F','F','C','F','F'],
    'Producto digital / canal usuario': ['F','F','F','F','F','F','F','F'],
    'Paquetizado (SAP/Salesforce)':     ['F','F','C','Fc','F','F','F','F'],
    'Producto de mercado':              ['F','F','F','F','F','F','F','F'],
    'IA / ML / GenAI':                  ['F','F','F','Fc','F','F','F','F'],
    'Data & Analytics / BI':            ['F','F','F','F','F','F','F','F'],
    'Infraestructura / DevOps / Cloud': ['F','F','F','F','F','C','F','F'],
    'RPA / Automatización':             ['F','F','C','F','F','F','F','F'],
    'Ciberseguridad':                   ['F','F','F','Fc','F','C','F','F'],
    'Consultoría':                      ['F','F','L','NA','NA','F','NA','L'],
}

def norm(cell):
    """Reduce una celda del markdown a su simbolo base, sin notas."""
    c = cell.strip()
    c = re.sub(r'[①②③④⑤⑥⑦⑧]', '', c)          # quitar marcadores de nota
    c = re.sub(r'\([^)]*\)', '', c)            # quitar parentesis explicativos
    c = c.strip()
    if c == '—':
        return 'NA'
    return c

# --- Parseo del markdown ---------------------------------------------------
rows = []
for line in io.open(MATRIX, encoding='utf-8'):
    if not line.startswith('|'):
        continue
    cells = [c.strip() for c in line.strip().strip('|').split('|')]
    if len(cells) != 10:
        continue
    if cells[1] not in ('—', 'Bajo', 'Medio', 'Alto'):
        continue
    rows.append((cells[0], cells[1], cells[2:10]))

print("filas parseadas: %d (esperado 60)" % len(rows))
errors = 0
if len(rows) != 60:
    print("  ERROR: cantidad de filas incorrecta")
    errors += 1

tipologias = []
for t, _, _ in rows:
    if t not in tipologias:
        tipologias.append(t)
print("tipologias distintas: %d (esperado 15)" % len(tipologias))
if len(tipologias) != 15:
    print("  ERROR: cantidad de tipologias incorrecta")
    errors += 1

# cada tipologia debe tener exactamente las 4 bandas, en orden
for t in tipologias:
    bandas = [b for tt, b, _ in rows if tt == t]
    if bandas != ['—', 'Bajo', 'Medio', 'Alto']:
        print("  ERROR: %s tiene bandas %s" % (t, bandas))
        errors += 1

# --- CHECK 1: filas base contra §6.4 del Modelo extendido ------------------
print("\n=== CHECK 1 — filas base (NAQ '—') vs §6.4 del Modelo extendido ===")
c1 = 0
for t, banda, cells in rows:
    if banda != '—':
        continue
    if t not in BASE_6_4:
        print("  ERROR: tipologia '%s' no esta en §6.4" % t)
        c1 += 1
        continue
    got = [norm(c) for c in cells]
    exp = BASE_6_4[t]
    for i, (g, e) in enumerate(zip(got, exp)):
        if g != e:
            print("  DIFF %-34s QG%d: matriz=%-3s §6.4=%-3s" % (t, i, g, e))
            c1 += 1
for t in BASE_6_4:
    if t not in tipologias:
        print("  ERROR: falta la tipologia '%s' en la matriz" % t)
        c1 += 1
print("  diferencias: %d" % c1)
errors += c1

# --- CHECK 2: coherencia estructural de las filas con NAQ ------------------
# Reglas §6.5:
#   - NA nunca cambia
#   - Fc nunca lo resuelve el NAQ (permanece Fc en toda banda)
#   - una celda solo puede endurecerse o mantenerse: NA<L<C<F no aplica como
#     orden estricto, pero C->L y C->F son resoluciones validas, y L->F es
#     elevacion valida. F->L o F->C serian una relajacion inesperada.
print("\n=== CHECK 2 — coherencia estructural de las filas con NAQ vs su base ===")
RANK = {'NA': 0, 'L': 1, 'C': 2, 'F': 3, 'Fc': 2}
base = {t: [norm(c) for c in cells] for t, b, cells in rows if b == '—'}
c2 = 0
relajaciones = []
for t, banda, cells in rows:
    if banda == '—':
        continue
    got = [norm(c) for c in cells]
    for i, (g, b0) in enumerate(zip(got, base[t])):
        if b0 == 'NA' and g != 'NA':
            print("  ERROR %-34s %-5s QG%d: base NA -> %s (NA no cambia)" % (t, banda, i, g))
            c2 += 1
        if b0 == 'Fc' and g != 'Fc':
            print("  ERROR %-34s %-5s QG%d: base Fc -> %s (el NAQ no resuelve Fc)" % (t, banda, i, g))
            c2 += 1
        if b0 == 'F' and g in ('L', 'C'):
            relajaciones.append((t, banda, i, b0, g))
        if b0 == 'C' and g == 'L' and banda == 'Alto':
            relajaciones.append((t, banda, i, b0, g))
print("  errores duros: %d" % c2)
errors += c2

print("\n  relajaciones a revisar manualmente (no son error por si mismas):")
if not relajaciones:
    print("    ninguna")
for t, banda, i, b0, g in relajaciones:
    print("    %-34s %-5s QG%d: %s -> %s" % (t, banda, i, b0, g))

print("\n=== RESULTADO: %d error(es) ===" % errors)
sys.exit(1 if errors else 0)
