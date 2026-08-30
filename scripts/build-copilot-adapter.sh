#!/bin/bash
# Patesi — Copilot Adapter Builder
# Regenerates adapters/copilot/copilot-instructions.md from agent.md + system.md
#
# Uso: bash scripts/build-copilot-adapter.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

AGENT_MD="$REPO_DIR/agent.md"
SYSTEM_MD="$REPO_DIR/system.md"
OUTPUT="$REPO_DIR/adapters/copilot/copilot-instructions.md"
CONFIG="$REPO_DIR/config.yaml"

echo "Construyendo el adaptador de Copilot desde agent.md + system.md..."

# Extraer identidad (antes del primer ---)
IDENTITY=$(sed '/^---$/q' "$AGENT_MD" | sed '$d')

# Extraer nombres de skills desde config.yaml
SKILL_LIST=$(grep '^- name:' "$CONFIG" | sed 's/^- name: /- `/' | sed 's/$/`/')

# Obtener la fecha actual
TODAY=$(date +%Y-%m-%d)

cat > "$OUTPUT" << HEREDOC
# Patesi — Adaptador para GitHub Copilot

> **GENERADO AUTOMÁTICAMENTE** por \`scripts/build-copilot-adapter.sh\`
> **NO EDITAR MANUALMENTE** — ejecutá \`bash scripts/build-copilot-adapter.sh\` para regenerar.
> Fuente de verdad: \`agent.md\` + \`system.md\`
> Última generación: $TODAY

---

$IDENTITY

## Protocolo de Inicio de Sesión

Al iniciar una sesión, ejecutá este protocolo:

1. **¿Existe contexto del proyecto?** → Cargalo y confirmá
2. **¿Qué tipo de proyecto es?** → Seidor / Personal / Gobernado por cliente
3. **Si Seidor**: Preguntá NAQ (Bajo/Medio/Alto). Si no sabe, calculá por factores
4. **Guardá el contexto** en memoria del proyecto

## Jerarquía de Frameworks

### Modo A — Proyecto Seidor
El **SQEM es LA REFERENCIA ABSOLUTA**. ISTQB complementa.
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

## Skills

Los skills se cargan bajo demanda. No cargues proactivamente.

$SKILL_LIST

**Skills de automatización**: Playwright, Cypress, Selenium, Appium, Robot Framework
**Skills de lenguaje**: Python, Java, JavaScript/TypeScript
**Skills de metodología**: Gherkin/BDD, Cucumber, Maven/Gradle

> **Nota**: \`sdet-project-learning\` requiere Engram MCP (específico de opencode).
> En Copilot, este skill funcionará con capacidades reducidas — informá al usuario que la memoria
> entre sesiones no está disponible sin Engram.

## Idioma

Combiná el idioma del usuario. Por defecto en castellano.
HEREDOC

echo "Generado: adapters/copilot/copilot-instructions.md"
echo "Listo."
