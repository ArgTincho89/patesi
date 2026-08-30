# Patesi - Instalador del agente SDET de IA para Windows
# Uso: .\install.ps1

$ErrorActionPreference = "Stop"

Write-Host "🔧 Instalando Patesi - Agente SDET de IA para opencode..." -ForegroundColor Cyan

# Detectar el directorio de configuración de opencode
$OpenCodeDir = "$env:USERPROFILE\.config\opencode"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoDir = Split-Path -Parent $ScriptDir

Write-Host "📁 Directorio de configuración de opencode: $OpenCodeDir" -ForegroundColor Gray
Write-Host "📦 Fuente de Patesi: $RepoDir" -ForegroundColor Gray

# Crear directorios
Write-Host "📂 Creando directorios..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path "$OpenCodeDir\agents" | Out-Null
New-Item -ItemType Directory -Force -Path "$OpenCodeDir\skills" | Out-Null

# Copiar agente (v2.0: agent.md + system.md desde la raíz del repo)
Write-Host "🤖 Instalando agente..." -ForegroundColor Yellow
Copy-Item -Path "$RepoDir\agent.md" -Destination "$OpenCodeDir\agents\patesi.md" -Force
Copy-Item -Path "$RepoDir\system.md" -Destination "$OpenCodeDir\agents\system.md" -Force
Write-Host "   ✅ agents/patesi.md (desde agent.md)" -ForegroundColor Green
Write-Host "   ✅ agents/system.md" -ForegroundColor Green

# Copiar skills
Write-Host "📚 Instalando skills..." -ForegroundColor Yellow
Get-ChildItem -Path "$RepoDir\skills\sdet-*" -Directory | ForEach-Object {
    $skillName = $_.Name
    $destDir = "$OpenCodeDir\skills\$skillName"
    New-Item -ItemType Directory -Force -Path $destDir | Out-Null
    Copy-Item -Path "$($_.FullName)\SKILL.md" -Destination "$destDir\SKILL.md" -Force
    Write-Host "   ✅ skills/$skillName/SKILL.md" -ForegroundColor Green
}

Write-Host ""
Write-Host "🎉 Patesi se instaló correctamente!" -ForegroundColor Green
Write-Host ""
Write-Host "Próximos pasos:" -ForegroundColor Cyan
Write-Host '  1. Agregá el agente a tu opencode.json:' -ForegroundColor Cyan
Write-Host "Configuración JSON del agente:" -ForegroundColor Gray
Write-Host "  agent: patesi" -ForegroundColor Gray
Write-Host "  description: Patesi - Agente SDET de IA" -ForegroundColor Gray
Write-Host "  mode: primary" -ForegroundColor Gray
Write-Host "  prompt: agent.md + system.md" -ForegroundColor Gray
Write-Host "  tools: edit, write" -ForegroundColor Gray
Write-Host ""
Write-Host "  2. Reiniciá opencode" -ForegroundColor Cyan
Write-Host "  3. Cambiá al agente SDET usando la tecla Tab" -ForegroundColor Cyan
