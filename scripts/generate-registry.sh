#!/bin/bash
# Patesi — Skill Registry Generator (Single Source of Truth)
# Reads all skills/sdet-*/SKILL.md frontmatter and generates:
#   1. .atl/skill-registry.md  — markdown table (writes to file)
#   2. skills-block.yaml        — skills: block for config.yaml (writes to file)
#   3. system.md §8 table       — user request → skill mapping (prints to stdout)
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
    # Extract frontmatter between --- delimiters (lines 2..N-1)
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
    # First indented line that is not Trigger:, name:, description:, license:, metadata:, category:, author:, version:
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

# --- Output 2: skills-block.yaml ---
{
    echo "skills:"
    first_category=true
    for cat_def in "${CATEGORY_DEFS[@]}"; do
        IFS='|' read -r cat_key cat_label cat_skills <<< "$cat_def"
        IFS=',' read -ra skill_list <<< "$cat_skills"

        # Check if any skills from this category exist
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
            echo ""
        fi
        echo "  # --- $cat_label ---"

        for sname in "${skill_list[@]}"; do
            idx=$(find_skill_index "$sname" 2>/dev/null) || continue
            trigger_lower=$(echo "${SKILL_TRIGGERS[$idx]}" | tr '[:upper:]' '[:lower:]')
            echo "  - name: ${SKILL_NAMES[$idx]}"
            echo "    trigger: $trigger_lower"
        done
    done
} > /tmp/patesi_config_block.yaml

# --- Output 3: system.md §8 table (stdout capture) ---
{
    echo "| Solicitud del usuario | Skill a cargar |"
    echo "|----------------------|----------------|"
    for cat_def in "${CATEGORY_DEFS[@]}"; do
        IFS='|' read -r cat_key _cat_label cat_skills <<< "$cat_def"
        IFS=',' read -ra skill_list <<< "$cat_skills"
        for sname in "${skill_list[@]}"; do
            # Find the human phrase for this skill
            for phrase_entry in "${HUMAN_PHRASES[@]}"; do
                IFS='|' read -r phrase_skill phrase_text <<< "$phrase_entry"
                if [[ "$phrase_skill" == "$sname" ]]; then
                    echo "| $phrase_text | \`$sname\` |"
                    break
                fi
            done
        done
    done
} > /tmp/patesi_system_table.md

# --- Check mode: compare and report ---
if $CHECK_MODE; then
    echo ""
    echo "=== CHECK MODE ==="

    MISMATCHES=0

    # Check registry
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

    # Check config.yaml skills block
    CONFIG_FILE="$REPO_DIR/config.yaml"
    if [ -f "$CONFIG_FILE" ]; then
        # Extract skills block from existing config.yaml (from "skills:" to end of file)
        sed -n '/^skills:/,$p' "$CONFIG_FILE" > /tmp/patesi_existing_block.yaml
        if diff -q /tmp/patesi_config_block.yaml /tmp/patesi_existing_block.yaml >/dev/null 2>&1; then
            echo "  FRESH: config.yaml skills block"
        else
            echo "  STALE: config.yaml skills block"
            MISMATCHES=$((MISMATCHES + 1))
        fi
    else
        echo "  MISSING: config.yaml"
        MISMATCHES=$((MISMATCHES + 1))
    fi

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

# Write .atl/skill-registry.md
cp /tmp/patesi_registry_content.md "$REPO_DIR/.atl/skill-registry.md"
echo "Generated: .atl/skill-registry.md ($COUNT skills)"

# Write skills-block.yaml
cp /tmp/patesi_config_block.yaml "$REPO_DIR/skills-block.yaml"
echo "Generated: skills-block.yaml"

# Print system.md §8 table to stdout
echo ""
echo "=== system.md §8 table (copy into system.md § 8) ==="
cat /tmp/patesi_system_table.md
echo "=== end ==="

# Cleanup temp files
rm -f /tmp/patesi_registry_content.md /tmp/patesi_config_block.yaml /tmp/patesi_system_table.md

echo ""
echo "Done. $COUNT skills processed."
