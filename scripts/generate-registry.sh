#!/bin/bash
# Patesi — Skill Registry Generator (Single Source of Truth)
# Reads all skills/sdet-*/SKILL.md frontmatter and generates:
#   1. .atl/skill-registry.md      — markdown table
#   2. config.yaml skills block    — directly between SKILLS_BLOCK markers
#   3. system.md §8 table           — directly between SKILL_TABLE markers
#
# Usage:
#   bash scripts/generate-registry.sh            — generate all outputs
#   bash scripts/generate-registry.sh --check    — compare only, exit 1 if different
#
# Dependencies: bash 4+, sed, grep, date
# Encoding: All file writes use UTF-8 (no BOM)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
SKILLS_DIR="$REPO_DIR/skills"

# --- Manual mapping: human-curated "Solicitud del usuario" phrases ---
# Format: "skill-name|User phrase"
declare -a HUMAN_PHRASES=(
    "sdet-istqb|Pregunta sobre ISTQB"
    "sdet-test-strategy|Estrategia de testing"
    "sdet-test-cases|Generar casos de prueba"
    "sdet-test-classification|Clasificar tests S/M/L/XL"
    "sdet-risk-analysis|Analisis de riesgos (feature/story)"
    "sdet-mr-analysis|Analizar MR/PR"
    "sdet-cicd|Pipelines CI/CD"
    "sdet-project-learning|Aprender del proyecto"
    "sdet-automation|Framework Playwright"
    "sdet-automation-cypress|Framework Cypress"
    "sdet-automation-selenium|Selenium (Java/Python)"
    "sdet-automation-appium|Appium / testing movil"
    "sdet-automation-robot|Robot Framework"
    "sdet-lang-python|Patrones Python / pytest"
    "sdet-lang-java|Patrones Java / JUnit / TestNG"
    "sdet-lang-javascript|Patrones JavaScript / Jest / Vitest"
    "sdet-methodology-gherkin|Gherkin / BDD / feature files"
    "sdet-methodology-cucumber|Cucumber / step definitions"
    "sdet-build-maven|Maven / Gradle / build config"
    "sdet-sqem-classification|Clasificacion proyecto Seidor"
    "sdet-sqem-gates|Puertas de calidad Seidor"
    "sdet-sqem-controls|Controles / umbrales Seidor"
    "sdet-sqem-ia|IA/ML/GenAI testing"
)

# --- Output categories for config.yaml grouping ---
# Format: "category_key|display_label|skill1,skill2,..."
declare -a CATEGORY_DEFS=(
    "qa-core|QA Core|sdet-istqb,sdet-test-strategy,sdet-test-cases,sdet-test-classification,sdet-risk-analysis,sdet-mr-analysis,sdet-project-learning"
    "pipelines|Pipelines|sdet-cicd"
    "automation|Automatizacion|sdet-automation,sdet-automation-cypress,sdet-automation-selenium,sdet-automation-appium,sdet-automation-robot"
    "languages|Lenguajes|sdet-lang-python,sdet-lang-java,sdet-lang-javascript"
    "methodologies|Metodologias y Build|sdet-methodology-gherkin,sdet-methodology-cucumber,sdet-build-maven"
    "sqem|SQEM (Seidor)|sdet-sqem-classification,sdet-sqem-gates,sdet-sqem-controls,sdet-sqem-ia"
)

# --- Extract frontmatter fields from a SKILL.md file ---
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

# --- Parse mode argument ---
CHECK_MODE=false
if [[ "${1:-}" == "--check" ]]; then
    CHECK_MODE=true
fi

echo "Generating skill registry from SKILL.md frontmatter..."

# --- Parse all skills ---
declare -a SKILL_NAMES=()
declare -a SKILL_TRIGGERS=()
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
    [ -z "$trigger" ] && trigger="$description"
    [ -z "$description" ] && description="$trigger"

    relative_path="skills/$skill_name/SKILL.md"

    SKILL_NAMES+=("$name")
    SKILL_TRIGGERS+=("$trigger")
    SKILL_DESCRIPTIONS+=("$description")
    SKILL_PATHS+=("$relative_path")
    COUNT=$((COUNT + 1))

    echo "  OK: $name"
done

echo ""
echo "Parsed $COUNT skills ($SKIPPED skipped)"

# --- Helper: find skill index by name ---
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

# --- Helper: replace content between markers in a file ---
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
        echo "  STALE: $file_path -- markers not found"
        return 1
    fi

    # Extract: before start marker + new content + after end marker
    local tmp_file="${file_path}.tmp"
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
        echo "  STALE: $file_path -- end marker not found"
        return 1
    fi

    mv "$tmp_file" "$file_path"
    return 0
}

# --- Output 1: .atl/skill-registry.md ---
DATE=$(date +%Y-%m-%d)

{
    echo "# Skill Registry -- patesi"
    echo ""
    echo "<!-- AUTO-GENERATED by scripts/generate-registry.sh -- DO NOT EDIT MANUALLY -->"
    echo "<!-- Run: bash scripts/generate-registry.sh -->"
    echo ""
    echo "Last updated: $DATE"
    echo ""
    echo "## Skills"
    echo ""
    echo "| Skill | Trigger / description | Scope | Path |"
    echo "|-------|----------------------|-------|------|"

    for cat_def in "${CATEGORY_DEFS[@]}"; do
        IFS='|' read -r _cat_key _cat_label cat_skills <<< "$cat_def"
        IFS=',' read -ra skill_list <<< "$cat_skills"
        for sname in "${skill_list[@]}"; do
            idx=$(find_skill_index "$sname" 2>/dev/null) || continue
            echo "| \`${SKILL_NAMES[$idx]}\` | ${SKILL_TRIGGERS[$idx]} | project | \`${SKILL_PATHS[$idx]}\` |"
        done
    done

    echo ""
    echo "## Loading protocol"
    echo ""
    echo "1. Match task context and target files against the \`Trigger / description\` column."
    echo "2. Pass only the matching \`Path\` values to the subagent under \`## Skills to load before work\`."
    echo "3. Instruct the subagent to read those exact \`SKILL.md\` files before reading, writing, reviewing, testing, or creating artifacts."
    echo "4. If no matching skill exists, proceed without project skill injection and report \`skill_resolution: none\`."
} > /tmp/patesi_registry_content.md

# --- Output 2: config.yaml skills block (between markers) ---
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

# --- Output 3: system.md §8 table (between markers) ---
SYS_TABLE_CONTENT="<!-- SKILL_TABLE_START -- auto-generated by scripts/generate-registry.sh -- DO NOT EDIT MANUALLY -->"
SYS_TABLE_CONTENT+=$'\n'"| Solicitud del usuario | Skill a cargar |"
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
        echo "$MISMATCHES file(s) stale. Run generate-registry.sh to refresh."
        exit 1
    else
        echo "All files fresh."
        exit 0
    fi
fi

# --- Write mode: generate files ---
echo ""
echo "=== GENERATING ==="

# Ensure .atl directory exists
mkdir -p "$REPO_DIR/.atl"

# Write 1: .atl/skill-registry.md
cp /tmp/patesi_registry_content.md "$REPO_DIR/.atl/skill-registry.md"
echo "Generated: .atl/skill-registry.md ($COUNT skills)"

# Write 2: config.yaml skills block (between markers)
if update_marked_section "$REPO_DIR/config.yaml" "# SKILLS_BLOCK_START" "# SKILLS_BLOCK_END" "$CONFIG_SKILLS_CONTENT"; then
    echo "Generated: config.yaml skills block (between markers)"
else
    echo "FAILED: config.yaml -- could not update skills block"
fi

# Write 3: system.md §8 table (between markers)
if update_marked_section "$REPO_DIR/system.md" "SKILL_TABLE_START" "SKILL_TABLE_END" "$SYS_TABLE_CONTENT"; then
    echo "Generated: system.md §8 table (between markers)"
else
    echo "FAILED: system.md -- could not update skill table"
fi

# Cleanup legacy skills-block.yaml if it exists
if [ -f "$REPO_DIR/skills-block.yaml" ]; then
    rm -f "$REPO_DIR/skills-block.yaml"
    echo "Removed legacy: skills-block.yaml"
fi

# Cleanup temp files
rm -f /tmp/patesi_registry_content.md

echo ""
echo "Done. $COUNT skills processed. 3 files updated."
