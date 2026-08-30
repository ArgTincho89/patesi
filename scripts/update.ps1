# Patesi - Update Script for Windows
# Uso: .\scripts\update.ps1

$ErrorActionPreference = "Stop"

Write-Host "Actualizando Patesi..." -ForegroundColor Cyan

# Find repo root (script is in scripts/, repo is one level up)
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoDir = Split-Path -Parent $ScriptDir
$OpenCodeDir = "$env:USERPROFILE\.config\opencode"

# Check if opencode dir exists
if (-not (Test-Path $OpenCodeDir)) {
    Write-Host "ERROR: no se encontró la configuración de opencode en $OpenCodeDir" -ForegroundColor Red
    Write-Host "Ejecutá primero install.ps1." -ForegroundColor Yellow
    exit 1
}

# Git pull
Write-Host "Descargando los últimos cambios..." -ForegroundColor Yellow
Set-Location $RepoDir
git pull origin main
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: falló git pull" -ForegroundColor Red
    exit 1
}

# Copiar agente (v2.0: agent.md + system.md desde la raíz del repo)
Write-Host "Copiando agente..." -ForegroundColor Yellow
Copy-Item -Path "$RepoDir\agent.md" -Destination "$OpenCodeDir\agents\patesi.md" -Force
Copy-Item -Path "$RepoDir\system.md" -Destination "$OpenCodeDir\agents\system.md" -Force
Write-Host "   OK agents/patesi.md (from agent.md)" -ForegroundColor Green
Write-Host "   OK agents/system.md" -ForegroundColor Green

# Copiar skills
Write-Host "Copiando skills..." -ForegroundColor Yellow
Get-ChildItem -Path "$RepoDir\skills\sdet-*" -Directory | ForEach-Object {
    $skillName = $_.Name
    $destDir = "$OpenCodeDir\skills\$skillName"
    New-Item -ItemType Directory -Force -Path $destDir | Out-Null
    Copy-Item -Path "$($_.FullName)\SKILL.md" -Destination "$destDir\SKILL.md" -Force
    Write-Host "   OK skills/$skillName/SKILL.md" -ForegroundColor Green
}

Write-Host ""
Write-Host "Patesi actualizado!" -ForegroundColor Green
Write-Host "Reiniciá opencode para usar la nueva versión." -ForegroundColor Cyan
