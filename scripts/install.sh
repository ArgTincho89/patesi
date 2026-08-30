#!/bin/bash
# Patesi - Instalador del agente SDET de IA para Linux/macOS
# Uso: bash install.sh

set -e

echo "🔧 Instalando Patesi - Agente SDET de IA para opencode..."

# Detectar el directorio de configuración de opencode
if [[ "$OSTYPE" == "darwin"* ]]; then
    OPENCODE_DIR="$HOME/.config/opencode"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OPENCODE_DIR="$HOME/.config/opencode"
else
    echo "❌ Sistema operativo no compatible: $OSTYPE"
    echo "Instalá manualmente. Consultá README.md"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

echo "📁 Directorio de configuración de opencode: $OPENCODE_DIR"
echo "📦 Fuente de Patesi: $REPO_DIR"

# Crear directorios
echo "📂 Creando directorios..."
mkdir -p "$OPENCODE_DIR/agents"
mkdir -p "$OPENCODE_DIR/skills"

# Copiar agente (v2.0: agent.md + system.md desde la raíz del repo)
echo "🤖 Instalando agente..."
cp "$REPO_DIR/agent.md" "$OPENCODE_DIR/agents/patesi.md"
cp "$REPO_DIR/system.md" "$OPENCODE_DIR/agents/system.md"
echo "   ✅ agents/patesi.md (desde agent.md)"
echo "   ✅ agents/system.md"

# Copiar skills
echo "📚 Instalando skills..."
for skill_dir in "$REPO_DIR/skills/sdet-"*; do
    skill_name=$(basename "$skill_dir")
    mkdir -p "$OPENCODE_DIR/skills/$skill_name"
    cp "$skill_dir/SKILL.md" "$OPENCODE_DIR/skills/$skill_name/SKILL.md"
    echo "   ✅ skills/$skill_name/SKILL.md"
done

echo ""
echo "🎉 Patesi se instaló correctamente!"
echo ""
echo "Próximos pasos:"
echo "  1. Agregá el agente a tu opencode.json:"
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
echo "  2. Reiniciá opencode"
echo "  3. Cambiá al agente SDET usando la tecla Tab"
echo ""
echo "Para más información, consultá README.md"
