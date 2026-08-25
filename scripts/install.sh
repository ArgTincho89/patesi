#!/bin/bash
# Patesi - SDET AI Agent Installer for Linux/macOS
# Usage: bash install.sh

set -e

echo "🔧 Installing Patesi - SDET AI Agent for opencode..."

# Detect opencode config directory
if [[ "$OSTYPE" == "darwin"* ]]; then
    OPENCODE_DIR="$HOME/.config/opencode"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OPENCODE_DIR="$HOME/.config/opencode"
else
    echo "❌ Unsupported OS: $OSTYPE"
    echo "Please install manually. See README.md"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

echo "📁 OpenCode config directory: $OPENCODE_DIR"
echo "📦 Patesi source: $REPO_DIR"

# Create directories
echo "📂 Creating directories..."
mkdir -p "$OPENCODE_DIR/agents"
mkdir -p "$OPENCODE_DIR/skills"

# Copy agent (v2.0: agent.md + system.md from repo root)
echo "🤖 Installing agent..."
cp "$REPO_DIR/agent.md" "$OPENCODE_DIR/agents/patesi.md"
cp "$REPO_DIR/system.md" "$OPENCODE_DIR/agents/system.md"
echo "   ✅ agents/patesi.md (from agent.md)"
echo "   ✅ agents/system.md"

# Copy skills
echo "📚 Installing skills..."
for skill_dir in "$REPO_DIR/skills/sdet-"*; do
    skill_name=$(basename "$skill_dir")
    mkdir -p "$OPENCODE_DIR/skills/$skill_name"
    cp "$skill_dir/SKILL.md" "$OPENCODE_DIR/skills/$skill_name/SKILL.md"
    echo "   ✅ skills/$skill_name/SKILL.md"
done

echo ""
echo "🎉 Patesi installed successfully!"
echo ""
echo "Next steps:"
echo "  1. Add the agent to your opencode.json:"
echo ""
echo '     {'
echo '       "agent": {'
echo '         "patesi": {'
echo '           "description": "Patesi — Agente SDET de IA",'
echo '           "mode": "primary",'
echo '           "prompt": "{file:./agents/patesi.md}\n\n---\n\n{file:./agents/system.md}",'
echo '           "tools": { "edit": true, "write": true }'
echo '         }'
echo '       }'
echo '     }'
echo ""
echo "  2. Restart opencode"
echo "  3. Switch to the SDET agent using Tab key"
echo ""
echo "For more information, see README.md"
