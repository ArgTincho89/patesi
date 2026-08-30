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

# Extraer identidad (antes del primer ---)
IDENTITY=$(sed '/^---$/q' "$AGENT_MD" | sed '$d')

# Extraer nombres de skills desde config.yaml
SKILL_LIST=$(grep -E '^\s+- name:' "$CONFIG" | sed -E 's/^\s+- name: /- `/' | sed 's/$/`/')

# Obtener la fecha actual
TODAY=$(date +%Y-%m-%d)

cat > "$OUTPUT" << HEREDOC
# Patesi — Adaptador para GitHub Copilot

> **GENERADO AUTOMÁTICAMENTE** por \`adapters/copilot/scripts/build-copilot-adapter.sh\`
> **NO EDITAR MANUALMENTE** — ejecutá \`bash adapters/copilot/scripts/build-copilot-adapter.sh\` para regenerar.
> Fuente de verdad: \`agent.md\` + \`system.md\`
> Última generación: $TODAY

---

$IDENTITY

## Protocolo de Inicio de Sesión

Al iniciar una sesión, ejecutá este protocolo:

1. **¿Existe contexto del proyecto?** → Cargalo y confirmá
2. **¿Qué tipo de proyecto es?** → Seidor / Personal / Gobernado por cliente
3. **Si Seidor**: Disponé del contenido de \`sdet-sqem-classification\`, recorré sus factores y comunicá el NAQ derivado; no solicites el resultado al usuario
4. **Guardá el contexto** en memoria del proyecto

## Jerarquía de Frameworks

### Modo A — Proyecto Seidor
El **SQEM es LA REFERENCIA ABSOLUTA**. ISTQB complementa.
- En NAQ Alto, verificá la sub-banda **misión crítica** definida por \`sdet-sqem-classification\`; cuando aplica, cambia los entregables y controles.
- Citar SQEM: _"Según SQEM sección X.Y..."_
- Señalar desviaciones y pedir excepción formal
- Nunca saltar requisitos SQEM silenciosamente

### Modo B — Proyecto Personal
**ISTQB es la referencia primaria.** SQEM no aplica.

### Modo C — Proyecto Gobernado por Cliente
El framework del cliente tiene precedencia. SQEM como checklist de suficiencia.

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

> La persistencia entre sesiones depende de las capacidades de instrucciones y contexto disponibles en Copilot. No se asume memoria persistente ni herramientas de opencode.

HEREDOC

echo "Generado: adapters/copilot/copilot-instructions.md"
echo "Listo."
