#!/bin/bash
# Patesi — Copilot Adapter Builder
# Regenerates adapters/copilot/copilot-instructions.md from agent.md + system.md
#
# Uso: bash adapters/copilot/scripts/build-copilot-adapter.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$(dirname "$(dirname "$SCRIPT_DIR")")")"

AGENT_MD="$REPO_DIR/agent.md"
SYSTEM_MD="$REPO_DIR/system.md"
OUTPUT="$REPO_DIR/adapters/copilot/copilot-instructions.md"
CONFIG="$REPO_DIR/config.yaml"

echo "Construyendo el adaptador de Copilot desde agent.md + system.md..."

# Extraer identidad: todo hasta la primera línea que sea exactamente ---, o el
# archivo completo si no existe. Sin el guard, `sed '$d'` borraba la última línea
# real de agent.md y el adapter perdía contenido de identidad.
if grep -qx -- '---' "$AGENT_MD"; then
    IDENTITY=$(sed '/^---$/q' "$AGENT_MD" | sed '$d')
else
    IDENTITY=$(cat "$AGENT_MD")
fi

# Extraer secciones VERBATIM de system.md entre markers.
# El protocolo de modos y la jerarquía NO se reescriben acá: se copian tal cual
# para garantizar que Copilot y opencode se comporten igual en los tres modos.
extract_section() {
    local name="$1"
    local out
    out=$(awk -v n="$name" '
        $0 == "<!-- COPILOT-EXTRACT-START: " n " -->" { inside=1; next }
        $0 == "<!-- COPILOT-EXTRACT-END: " n " -->"   { inside=0 }
        inside { print }
    ' "$SYSTEM_MD" | sed -e '/./,$!d' | awk 'NF {p=NR} {a[NR]=$0} END {for(i=1;i<=p;i++) print a[i]}')
    if [ -z "$out" ]; then
        echo "ERROR: system.md no contiene los markers COPILOT-EXTRACT de la seccion '$name'. El adapter quedaria desincronizado." >&2
        exit 1
    fi
    printf '%s' "$out"
}

PROTOCOL_SECTION=$(extract_section "protocolo")
MODES_SECTION=$(extract_section "modos")

# Extraer nombres de skills desde config.yaml
SKILL_LIST=$(grep -E '^\s+- name:' "$CONFIG" | sed -E 's/^\s+- name: /- `/' | sed 's/$/`/')

# Obtener la fecha actual
TODAY=$(date +%Y-%m-%d)

# Em dash literal (el builder .ps1 lo inyecta como variable; acá replicamos el mismo
# valor para que ambas salidas sean byte a byte idénticas)
EM="—"

cat > "$OUTPUT" << HEREDOC
# Patesi $EM Adaptador para GitHub Copilot

> **GENERADO AUTOMÁTICAMENTE** por \`build-copilot-adapter.ps1\` o su equivalente \`.sh\`
> **NO EDITAR MANUALMENTE** — ejecutá cualquiera de los dos builders; producen el mismo resultado.
> Fuente de verdad: \`agent.md\` + \`system.md\`
> Última generación: $TODAY

---

$IDENTITY

## Protocolo de Inicio de Sesión

**OBLIGATORIO — ejecutá esto antes de cualquier trabajo de QA.**

$PROTOCOL_SECTION

## Jerarquía de Frameworks de Calidad

Los tres modos tienen el mismo peso. El modo activo determina qué framework manda, qué vocabulario usás y qué skills cargás. Un modo nunca contamina a otro.

$MODES_SECTION

## Orientación a Riesgo

Cada propuesta DEBE incluir:
- Evaluación de riesgo
- Métricas de cobertura (happy/unhappy/corner %)
- Priorización P1-P4
- Gaps de cobertura explícitos

## Disponibilidad del conocimiento especializado

El contenido de los skills requeridos debe estar disponible antes de generar una respuesta. En Copilot, hacé disponible el SKILL.md relevante como contexto de instrucciones o archivos adjuntos; este adapter no depende de herramientas de opencode.

$SKILL_LIST

**Skills de automatización**: Playwright, Cypress, Selenium, Appium, Robot Framework
**Skills de lenguaje**: Python, Java, JavaScript/TypeScript
**Skills de metodología**: Gherkin/BDD, Cucumber, Maven/Gradle

## Memoria del proyecto en Copilot

La persistencia entre sesiones depende de las capacidades de instrucciones y contexto disponibles en Copilot. No se asume memoria persistente ni herramientas de opencode.

**Modo C:** el perfil del cliente es indispensable y no puede perderse entre sesiones. Si Copilot no ofrece persistencia en este entorno, mantené el perfil como archivo markdown versionado en el repositorio y cargalo como contexto al inicio de cada sesión. Avisale al usuario la primera vez que esto ocurra.

**Modo B:** si no hay persistencia, informá que los patrones del proyecto no se recordarán entre sesiones y seguí trabajando normalmente.
HEREDOC

echo "Generado: adapters/copilot/copilot-instructions.md"
echo "Listo."
