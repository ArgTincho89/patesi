#!/bin/bash
# Patesi — Validador de tokens estimados
# Verifica cada SKILL.md contra 4000 tokens y el núcleo combinado
# (agent.md + system.md) contra un presupuesto separado de 12000 tokens.
# Uses word count as a proxy: ~1.3 tokens per word for English/Spanish mixed content.
#
# Uso:
#   bash scripts/check-skill-tokens.sh            — show token estimates for all skills
#   bash scripts/check-skill-tokens.sh --max 4000 — falla si algún skill supera el máximo
#   bash scripts/check-skill-tokens.sh --check    — igual que --max 4000, sale con 1 si alguno supera el máximo

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
SKILLS_DIR="$REPO_DIR/skills"

MAX_TOKENS=4000
CHECK_MODE=false

# Analizar argumentos
while [[ $# -gt 0 ]]; do
    case "$1" in
        --max) MAX_TOKENS="$2"; shift 2 ;;
        --check) CHECK_MODE=true; shift ;;
        *) shift ;;
    esac
done

TOKENS_PER_WORD=1.3
CORE_MAX_TOKENS=12000
EXCEEDED=0
COUNT=0

echo ""
echo "Estimaciones de tokens por skill (máximo: $MAX_TOKENS)"
echo "-------------------------------------------------------"
printf "%-35s %6s %8s %6s\n" "Skill" "Lines" "Est.Tok" "Status"
echo "-------------------------------------------------------"

for skill_dir in "$SKILLS_DIR"/sdet-*; do
    [ -d "$skill_dir" ] || continue
    skill_name=$(basename "$skill_dir")
    skill_file="$skill_dir/SKILL.md"
    [ -f "$skill_file" ] || continue

    lines=$(wc -l < "$skill_file")
    words=$(wc -w < "$skill_file")
    est_tokens=$(echo "$words * $TOKENS_PER_WORD" | bc | cut -d. -f1)

    if [ "$est_tokens" -gt "$MAX_TOKENS" ]; then
        status="EXCEED"
        EXCEEDED=$((EXCEEDED + 1))
        color="\033[0;31m"
    else
        status="OK"
        color="\033[0;32m"
    fi

    printf "${color}%-35s %6s %8s %6s\033[0m\n" "$skill_name" "$lines" "$est_tokens" "$status"
    COUNT=$((COUNT + 1))
done

echo "-------------------------------------------------------"
if [ "$EXCEEDED" -gt 0 ]; then
    echo -e "\033[0;31mTotal de skills: $COUNT | Excedidos: $EXCEEDED\033[0m"
else
    echo -e "\033[0;32mTotal de skills: $COUNT | Excedidos: 0\033[0m"
fi

core_words=0
for core_file in "$REPO_DIR/agent.md" "$REPO_DIR/system.md"; do
    [ -f "$core_file" ] || continue
    file_words=$(wc -w < "$core_file")
    core_words=$((core_words + file_words))
done
core_est_tokens=$(echo "$core_words * $TOKENS_PER_WORD" | bc | cut -d. -f1)
if [ "$core_est_tokens" -gt "$CORE_MAX_TOKENS" ]; then
    core_status="EXCEED"
else
    core_status="OK"
fi
echo "Núcleo agnóstico combinado (agent.md + system.md): $core_words palabras, $core_est_tokens tokens estimados / $CORE_MAX_TOKENS presupuesto ($core_status)"

if $CHECK_MODE && { [ "$EXCEEDED" -gt 0 ] || [ "$core_status" = "EXCEED" ]; }; then
    echo ""
    [ "$EXCEEDED" -gt 0 ] && echo -e "\033[0;31m$EXCEEDED skill(s) superan el presupuesto de $MAX_TOKENS tokens.\033[0m"
    [ "$core_status" = "EXCEED" ] && echo -e "\033[0;31mEl núcleo agnóstico combinado supera el presupuesto de $CORE_MAX_TOKENS tokens.\033[0m"
    exit 1
fi
