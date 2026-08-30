#!/bin/bash
# Patesi - Update Script for Linux/macOS
# Uso: bash adapters/opencode/scripts/update.sh

set -e

echo "Actualizando Patesi..."

# Find repo root (script is in scripts/, repo is one level up)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$(dirname "$(dirname "$SCRIPT_DIR")")")"
OPENCODE_DIR="$HOME/.config/opencode"

# Check if opencode dir exists
if [ ! -d "$OPENCODE_DIR" ]; then
    echo "ERROR: no se encontró la configuración de opencode en $OPENCODE_DIR"
    echo "Ejecutá primero install.sh."
    exit 1
fi

# Git pull
echo "Descargando los últimos cambios..."
cd "$REPO_DIR"
git pull origin main

# Copiar agente (v2.0: agent.md + system.md desde la raíz del repo)
echo "Copiando agente..."
cp "$REPO_DIR/agent.md" "$OPENCODE_DIR/agents/patesi.md"
cp "$REPO_DIR/system.md" "$OPENCODE_DIR/agents/system.md"
echo "   OK agents/patesi.md (from agent.md)"
echo "   OK agents/system.md"

# Copiar skills
echo "Copiando skills..."
for skill_dir in "$REPO_DIR/skills/sdet-"*; do
    skill_name=$(basename "$skill_dir")
    mkdir -p "$OPENCODE_DIR/skills/$skill_name"
    cp "$skill_dir/SKILL.md" "$OPENCODE_DIR/skills/$skill_name/SKILL.md"
    echo "   OK skills/$skill_name/SKILL.md"
done

echo ""
echo "Patesi actualizado!"
echo "Reiniciá opencode para usar la nueva versión."
