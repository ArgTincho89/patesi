#!/bin/bash
# Patesi — Generador del registro de skills (fuente única de verdad)
# Lee el frontmatter de todos los skills/sdet-*/SKILL.md y genera:
#   1. .atl/skill-registry.md      — tabla Markdown (Skill, Category, Trigger, Path)
#   2. bloque de skills de config.yaml — directamente entre markers SKILLS_BLOCK
#   3. tabla de system.md §8           — directamente entre markers SKILL_TABLE
#
# Uso:
#   bash scripts/generate-registry.sh            — generar todas las salidas
#   bash scripts/generate-registry.sh --check    — comparar únicamente, salir con 1 si difieren
#
# Dependencias: bash 4+, sed, grep, date
# Codificación: todas las escrituras usan UTF-8 (sin BOM)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
SKILLS_DIR="$REPO_DIR/skills"

# --- Mapeo manual: frases de "Solicitud del usuario" curadas por humanos ---
# Formato: "nombre-del-skill|Frase del usuario"
declare -a HUMAN_PHRASES=(
    "sdet-istqb|Pregunta sobre ISTQB"
    "sdet-test-strategy|Estrategia de testing"
    "sdet-test-cases|Generar casos de prueba"
    "sdet-test-classification|Clasificar tests S/M/L/XL"
    "sdet-risk-analysis|Análisis de riesgos (feature/story)"
    "sdet-mr-analysis|Analizar MR/PR"
    "sdet-cicd|Pipelines CI/CD"
    "sdet-project-learning|Aprender del proyecto"
    "sdet-client-profile|Perfil / metodología de un cliente"
    "sdet-client-onboarding|Arranque con un cliente nuevo"
    "sdet-test-repo|Repositorio de pruebas / propuesta al desarrollador"
    "sdet-self-review|Auditoría interna del propio agente"
    "sdet-industry-practices|Buenas prácticas de la industria"
    "sdet-exploratory-testing|Testing exploratorio / charters"
    "sdet-api-testing|Testing de APIs / REST / GraphQL"
    "sdet-accessibility|Accesibilidad / WCAG / a11y"
    "sdet-performance|Performance / carga / percentiles"
    "sdet-security-testing|Seguridad / OWASP / SAST-DAST-SCA"
    "sdet-automation|Framework de Playwright"
    "sdet-automation-cypress|Framework de Cypress"
    "sdet-automation-selenium|Selenium (Java/Python)"
    "sdet-automation-appium|Appium / testing móvil"
    "sdet-automation-robot|Robot Framework"
    "sdet-lang-python|Patrones Python / pytest"
    "sdet-lang-java|Patrones Java / JUnit / TestNG"
    "sdet-lang-javascript|Patrones JavaScript / Jest / Vitest"
    "sdet-methodology-gherkin|Gherkin / BDD / feature files"
    "sdet-methodology-cucumber|Cucumber / step definitions"
    "sdet-build-maven|Maven / Gradle / build config"
    "sdet-sqem-classification|Clasificación proyecto Seidor"
    "sdet-sqem-gate-matrix|Qué gates aplican (tipología x NAQ)"
    "sdet-sqem-typology-tests|Qué probar en cada gate por tipología"
    "sdet-sqem-governance|Roles, aprobadores y excepciones Seidor"
    "sdet-sqem-gates|Puertas de calidad Seidor"
    "sdet-sqem-controls|Controles / umbrales Seidor"
    "sdet-sqem-ia|IA/ML/GenAI testing"
)

# --- Categorías de salida para agrupar config.yaml ---
# Formato: "clave_de_categoría|etiqueta_visible|skill1,skill2,..."
declare -a CATEGORY_DEFS=(
    "qa-core|Núcleo de QA|sdet-istqb,sdet-test-strategy,sdet-test-cases,sdet-test-classification,sdet-risk-analysis,sdet-mr-analysis,sdet-project-learning,sdet-industry-practices,sdet-exploratory-testing,sdet-api-testing,sdet-accessibility,sdet-performance,sdet-security-testing,sdet-client-profile,sdet-client-onboarding,sdet-test-repo,sdet-self-review"
    "pipelines|Pipelines|sdet-cicd"
    "automation|Automatización|sdet-automation,sdet-automation-cypress,sdet-automation-selenium,sdet-automation-appium,sdet-automation-robot"
    "languages|Lenguajes|sdet-lang-python,sdet-lang-java,sdet-lang-javascript"
    "methodologies|Metodologías y Build|sdet-methodology-gherkin,sdet-methodology-cucumber,sdet-build-maven"
    "sqem|SQEM (Seidor)|sdet-sqem-classification,sdet-sqem-gate-matrix,sdet-sqem-gates,sdet-sqem-typology-tests,sdet-sqem-controls,sdet-sqem-ia,sdet-sqem-governance"
)

# --- Extraer campos del frontmatter de un archivo SKILL.md ---
extract_frontmatter() {
    local skill_file="$1"
    sed -n '/^---$/,/^---$/p' "$skill_file" | sed '1d;$d'
}

extract_name() {
    local frontmatter="$1"
    echo "$frontmatter" | grep -m1 '^name:' | sed 's/^name: *//' | tr -d '\r'
}

extract_trigger() {
    local frontmatter="$1"
    echo "$frontmatter" | grep -i 'Trigger:' | head -1 | sed 's/.*Trigger: *//' | tr -d '\r'
}

extract_description() {
    local frontmatter="$1"
    echo "$frontmatter" | grep '^  ' | grep -viE '^\s*(Trigger:|name:|description:|license:|metadata:|category:|author:|version:)' | head -1 | sed 's/^  *//' | tr -d '\r'
}

extract_category() {
    local frontmatter="$1"
    echo "$frontmatter" | grep -m1 -E '^  category:' | sed 's/^  category: *//' | tr -d '\r'
}

# --- Analizar el argumento de modo ---
CHECK_MODE=false
while [[ $# -gt 0 ]]; do
    case "$1" in
        --check) CHECK_MODE=true; shift ;;
        *) shift ;;
    esac
done

echo "Generando el registro de skills desde el frontmatter de SKILL.md..."

# --- Analizar todos los skills ---
declare -a SKILL_NAMES=()
declare -a SKILL_TRIGGERS=()
declare -a SKILL_CATEGORIES=()
declare -a SKILL_DESCRIPTIONS=()
declare -a SKILL_PATHS=()
COUNT=0
SKIPPED=0

for skill_dir in "$SKILLS_DIR"/sdet-*; do
    [ -d "$skill_dir" ] || continue
    skill_name=$(basename "$skill_dir")
    skill_file="$skill_dir/SKILL.md"

    if [ ! -f "$skill_file" ]; then
        echo "  SKIP: $skill_name -- no SKILL.md"
        SKIPPED=$((SKIPPED + 1))
        continue
    fi

    frontmatter=$(extract_frontmatter "$skill_file")
    if [ -z "$frontmatter" ]; then
        echo "  SKIP: $skill_name -- no frontmatter"
        SKIPPED=$((SKIPPED + 1))
        continue
    fi

    name=$(extract_name "$frontmatter")
    [ -z "$name" ] && name="$skill_name"

    trigger=$(extract_trigger "$frontmatter")
    description=$(extract_description "$frontmatter")
    category=$(extract_category "$frontmatter")
    [ -n "$category" ] || echo "  AVISO: $name -- no se encontró metadata.category"
    [ -z "$trigger" ] && trigger="$description"
    [ -z "$description" ] && description="$trigger"

    relative_path="skills/$skill_name/SKILL.md"

    SKILL_NAMES+=("$name")
    SKILL_TRIGGERS+=("$trigger")
    SKILL_CATEGORIES+=("$category")
    SKILL_DESCRIPTIONS+=("$description")
    SKILL_PATHS+=("$relative_path")
    COUNT=$((COUNT + 1))

    echo "  OK: $name"
done

echo ""
echo "Procesados $COUNT skills ($SKIPPED omitidos)"

# --- Helper: encontrar el índice de un skill por nombre ---
find_skill_index() {
    local search_name="$1"
    for i in "${!SKILL_NAMES[@]}"; do
        if [[ "${SKILL_NAMES[$i]}" == "$search_name" ]]; then
            echo "$i"
            return 0
        fi
    done
    return 1
}

# --- Helper: reemplazar contenido entre markers en un archivo ---
update_marked_section() {
    local file_path="$1"
    local start_marker="$2"
    local end_marker="$3"
    local new_content="$4"

    if [ ! -f "$file_path" ]; then
        echo "  MISSING: $file_path"
        return 1
    fi

    if ! grep -q "$start_marker" "$file_path" || ! grep -q "$end_marker" "$file_path"; then
        echo "  DESACTUALIZADO: $file_path -- no se encontraron los markers"
        return 1
    fi

    # Extraer: antes del marker inicial + contenido nuevo + después del marker final
    #
    # IMPORTANTE: el temporal se TRUNCA al empezar y se limpia si el script se
    # interrumpe. Sin esto, un .tmp parcial de una corrida abortada sobrevivia,
    # la corrida siguiente le apilaba contenido con >> y el mv final pisaba el
    # archivo real con el resultado corrupto. Asi se perdieron 297 lineas de
    # system.md, incluidos los markers COPILOT-EXTRACT.
    local tmp_file
    tmp_file="$(mktemp "${file_path}.XXXXXX.tmp")"
    trap 'rm -f "$tmp_file"' RETURN INT TERM
    : > "$tmp_file"
    local in_section=false
    local found_end=false

    while IFS= read -r line || [ -n "$line" ]; do
        if echo "$line" | grep -q "$start_marker"; then
            echo "$new_content" >> "$tmp_file"
            in_section=true
            continue
        fi
        if echo "$line" | grep -q "$end_marker"; then
            in_section=false
            found_end=true
            continue
        fi
        if [ "$in_section" = false ]; then
            echo "$line" >> "$tmp_file"
        fi
    done < "$file_path"

    if [ "$found_end" = false ]; then
        rm -f "$tmp_file"
        echo "  DESACTUALIZADO: $file_path -- no se encontró el marker final"
        return 1
    fi

    # Verificacion antes de pisar: el resultado no puede quedar drasticamente
    # mas corto que el original. Si lo esta, algo se corrompio y es preferible
    # abortar sin tocar el archivo.
    local orig_lines new_lines
    orig_lines=$(wc -l < "$file_path")
    new_lines=$(wc -l < "$tmp_file")
    if [ "$new_lines" -lt $(( orig_lines / 2 )) ]; then
        rm -f "$tmp_file"
        echo "  ABORTADO: $file_path -- el resultado tendria $new_lines lineas frente a $orig_lines. No se sobrescribe."
        return 1
    fi

    mv "$tmp_file" "$file_path"
    trap - RETURN INT TERM
    return 0
}

# --- Salida 1: .atl/skill-registry.md ---
DATE=$(date +%Y-%m-%d)

{
    echo "# Registro de skills -- patesi"
    echo ""
    echo "<!-- GENERADO AUTOMÁTICAMENTE -- NO EDITAR MANUALMENTE -->"
    echo "<!-- Catálogo de conocimiento; el adapter resuelve su disponibilidad concreta -->"
    echo ""
    echo "Última actualización: $DATE"
    echo ""
    echo "## Skills"
    echo ""
    echo "| Skill | Category | Trigger | Path |"
    echo "|-------|----------|---------|------|"

    for cat_def in "${CATEGORY_DEFS[@]}"; do
        IFS='|' read -r _cat_key _cat_label cat_skills <<< "$cat_def"
        IFS=',' read -ra skill_list <<< "$cat_skills"
        for sname in "${skill_list[@]}"; do
            idx=$(find_skill_index "$sname" 2>/dev/null) || continue
            echo "| \`${SKILL_NAMES[$idx]}\` | ${SKILL_CATEGORIES[$idx]} | ${SKILL_TRIGGERS[$idx]} | \`${SKILL_PATHS[$idx]}\` |"
        done
    done

    echo ""
    echo "## Catálogo de conocimiento"
    echo ""
    echo "Este registry es un catálogo agnóstico de conocimiento. Cada adapter resuelve la disponibilidad y el mecanismo de resolución concretos. \`sdet-automation\` es el skill default de Playwright. La separación entre Gherkin/BDD (especificaciones) y Cucumber (integración y step definitions) es intencional."
} > /tmp/patesi_registry_content.md

# --- Salida 2: bloque de skills de config.yaml (entre markers) ---
CONFIG_SKILLS_CONTENT="skills:"
first_category=true
for cat_def in "${CATEGORY_DEFS[@]}"; do
    IFS='|' read -r cat_key cat_label cat_skills <<< "$cat_def"
    IFS=',' read -ra skill_list <<< "$cat_skills"

    found_any=false
    for sname in "${skill_list[@]}"; do
        if find_skill_index "$sname" >/dev/null 2>&1; then
            found_any=true
            break
        fi
    done
    $found_any || continue

    if $first_category; then
        first_category=false
    else
        CONFIG_SKILLS_CONTENT+=$'\n'
    fi
    CONFIG_SKILLS_CONTENT+=$'\n'"  # --- $cat_label ---"

    for sname in "${skill_list[@]}"; do
        idx=$(find_skill_index "$sname" 2>/dev/null) || continue
        trigger_lower=$(echo "${SKILL_TRIGGERS[$idx]}" | tr '[:upper:]' '[:lower:]')
        CONFIG_SKILLS_CONTENT+=$'\n'"  - name: ${SKILL_NAMES[$idx]}"
        CONFIG_SKILLS_CONTENT+=$'\n'"    trigger: $trigger_lower"
    done
done

# --- Salida 3: tabla §8 de system.md (entre markers) ---
SYS_TABLE_CONTENT="<!-- SKILL_TABLE_START -- generado automáticamente -- NO EDITAR MANUALMENTE -->"
SYS_TABLE_CONTENT+=$'\n'"| Solicitud del usuario | Conocimiento requerido |"
SYS_TABLE_CONTENT+=$'\n'"|----------------------|----------------|"
for cat_def in "${CATEGORY_DEFS[@]}"; do
    IFS='|' read -r cat_key _cat_label cat_skills <<< "$cat_def"
    IFS=',' read -ra skill_list <<< "$cat_skills"
    for sname in "${skill_list[@]}"; do
        for phrase_entry in "${HUMAN_PHRASES[@]}"; do
            IFS='|' read -r phrase_skill phrase_text <<< "$phrase_entry"
            if [[ "$phrase_skill" == "$sname" ]]; then
                SYS_TABLE_CONTENT+=$'\n'"| $phrase_text | \`$sname\` |"
                break
            fi
        done
    done
done
SYS_TABLE_CONTENT+=$'\n'"<!-- SKILL_TABLE_END -->"

# --- Check mode: compare and report ---
if $CHECK_MODE; then
    echo ""
    echo "=== CHECK MODE ==="

    MISMATCHES=0

    # Check 1: registry
    REGISTRY_FILE="$REPO_DIR/.atl/skill-registry.md"
    if [ -f "$REGISTRY_FILE" ]; then
        if diff -q /tmp/patesi_registry_content.md "$REGISTRY_FILE" >/dev/null 2>&1; then
            echo "  FRESH: .atl/skill-registry.md"
        else
            echo "  STALE: .atl/skill-registry.md"
            MISMATCHES=$((MISMATCHES + 1))
        fi
    else
        echo "  MISSING: .atl/skill-registry.md"
        MISMATCHES=$((MISMATCHES + 1))
    fi

    # Check 2: config.yaml skills block
    CONFIG_FILE="$REPO_DIR/config.yaml"
    if [ -f "$CONFIG_FILE" ]; then
        # Extract existing block between markers
        if grep -q "# SKILLS_BLOCK_START" "$CONFIG_FILE" && grep -q "# SKILLS_BLOCK_END" "$CONFIG_FILE"; then
            sed -n '/# SKILLS_BLOCK_START/,/# SKILLS_BLOCK_END/p' "$CONFIG_FILE" | sed '1d;$d' > /tmp/patesi_existing_block.yaml
            echo "$CONFIG_SKILLS_CONTENT" > /tmp/patesi_expected_block.yaml
            if diff -q /tmp/patesi_expected_block.yaml /tmp/patesi_existing_block.yaml >/dev/null 2>&1; then
                echo "  FRESH: config.yaml skills block"
            else
                echo "  STALE: config.yaml skills block"
                MISMATCHES=$((MISMATCHES + 1))
            fi
        else
            echo "  STALE: config.yaml -- skills block markers not found"
            MISMATCHES=$((MISMATCHES + 1))
        fi
    else
        echo "  MISSING: config.yaml"
        MISMATCHES=$((MISMATCHES + 1))
    fi

    # Check 3: system.md §8 table
    SYSTEM_FILE="$REPO_DIR/system.md"
    if [ -f "$SYSTEM_FILE" ]; then
        if grep -q "SKILL_TABLE_START" "$SYSTEM_FILE" && grep -q "SKILL_TABLE_END" "$SYSTEM_FILE"; then
            sed -n '/SKILL_TABLE_START/,/SKILL_TABLE_END/p' "$SYSTEM_FILE" > /tmp/patesi_existing_sys.md
            echo "$SYS_TABLE_CONTENT" > /tmp/patesi_expected_sys.md
            if diff -q /tmp/patesi_expected_sys.md /tmp/patesi_existing_sys.md >/dev/null 2>&1; then
                echo "  FRESH: system.md §8 table"
            else
                echo "  STALE: system.md §8 table"
                MISMATCHES=$((MISMATCHES + 1))
            fi
        else
            echo "  STALE: system.md -- skill table markers not found"
            MISMATCHES=$((MISMATCHES + 1))
        fi
    else
        echo "  MISSING: system.md"
        MISMATCHES=$((MISMATCHES + 1))
    fi

    rm -f /tmp/patesi_existing_block.yaml /tmp/patesi_expected_block.yaml /tmp/patesi_existing_sys.md /tmp/patesi_expected_sys.md

    echo ""
    if [ "$MISMATCHES" -gt 0 ]; then
        echo "$MISMATCHES archivo(s) desactualizado(s). Ejecutá generate-registry.sh para actualizar."
        exit 1
    else
        echo "Todos los archivos están actualizados."
        exit 0
    fi
fi

# --- Modo de escritura: generar archivos ---
echo ""
echo "=== GENERANDO ==="

# Asegurar que exista el directorio .atl
mkdir -p "$REPO_DIR/.atl"

# Escribir 1: .atl/skill-registry.md
cp /tmp/patesi_registry_content.md "$REPO_DIR/.atl/skill-registry.md"
echo "Generado: .atl/skill-registry.md ($COUNT skills)"

# Contador de escrituras fallidas. Si alguna falla, el script termina con código
# distinto de cero: un derivado sin actualizar NO puede reportarse como exito,
# porque se commitea silenciosamente y rompe las regeneraciones siguientes.
WRITE_FAILURES=0

# Escribir 2: bloque de skills de config.yaml (entre markers)
if update_marked_section "$REPO_DIR/config.yaml" "# SKILLS_BLOCK_START" "# SKILLS_BLOCK_END" "$CONFIG_SKILLS_CONTENT"; then
    echo "Generado: bloque de skills de config.yaml (entre markers)"
else
    echo "FALLÓ: config.yaml -- no se pudo actualizar el bloque de skills"
    WRITE_FAILURES=$((WRITE_FAILURES + 1))
fi

# Escribir 3: tabla §8 de system.md (entre markers)
if update_marked_section "$REPO_DIR/system.md" "SKILL_TABLE_START" "SKILL_TABLE_END" "$SYS_TABLE_CONTENT"; then
    echo "Generado: tabla de system.md §8 (entre markers)"
else
    echo "FALLÓ: system.md -- no se pudo actualizar la tabla de skills"
    WRITE_FAILURES=$((WRITE_FAILURES + 1))
fi

# Limpiar skills-block.yaml heredado si existe
if [ -f "$REPO_DIR/skills-block.yaml" ]; then
    rm -f "$REPO_DIR/skills-block.yaml"
    echo "Eliminado el archivo heredado: skills-block.yaml"
fi

# Cleanup temp files
rm -f /tmp/patesi_registry_content.md

echo ""
if [ "$WRITE_FAILURES" -gt 0 ]; then
    echo "ERROR: $WRITE_FAILURES derivado(s) NO se actualizaron. Restaura los markers antes de commitear."
    exit 1
fi
echo "Listo. $COUNT skills procesados. 3 archivos actualizados."
