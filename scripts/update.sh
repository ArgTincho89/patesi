#!/bin/bash
# Patesi - Update Script for Linux/macOS
# Usage: bash scripts/update.sh

set -e

echo "Updating Patesi..."

# Find repo root (script is in scripts/, repo is one level up)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
OPENCODE_DIR="$HOME/.config/opencode"

# Check if opencode dir exists
if [ ! -d "$OPENCODE_DIR" ]; then
    echo "ERROR: opencode config not found at $OPENCODE_DIR"
    echo "Run install.sh first."
    exit 1
fi

# Git pull
echo "Pulling latest changes..."
cd "$REPO_DIR"
git pull origin main

# Copy agent
echo "Copying agent..."
cp "$REPO_DIR/agents/patesi.md" "$OPENCODE_DIR/agents/patesi.md"
echo "   OK agents/patesi.md"

# Copy skills
echo "Copying skills..."
for skill_dir in "$REPO_DIR/skills/sdet-"*; do
    skill_name=$(basename "$skill_dir")
    mkdir -p "$OPENCODE_DIR/skills/$skill_name"
    cp "$skill_dir/SKILL.md" "$OPENCODE_DIR/skills/$skill_name/SKILL.md"
    echo "   OK skills/$skill_name/SKILL.md"
done

echo ""
echo "Patesi updated!"
echo "Restart opencode to use the new version."
