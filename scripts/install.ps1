# Patesi - SDET AI Agent Installer for Windows
# Usage: .\install.ps1

$ErrorActionPreference = "Stop"

Write-Host "🔧 Installing Patesi - SDET AI Agent for opencode..." -ForegroundColor Cyan

# Detect opencode config directory
$OpenCodeDir = "$env:USERPROFILE\.config\opencode"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoDir = Split-Path -Parent $ScriptDir

Write-Host "📁 OpenCode config directory: $OpenCodeDir" -ForegroundColor Gray
Write-Host "📦 Patesi source: $RepoDir" -ForegroundColor Gray

# Create directories
Write-Host "📂 Creating directories..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path "$OpenCodeDir\agents" | Out-Null
New-Item -ItemType Directory -Force -Path "$OpenCodeDir\skills" | Out-Null

# Copy agent (v2.0: agent.md + system.md from repo root)
Write-Host "🤖 Installing agent..." -ForegroundColor Yellow
Copy-Item -Path "$RepoDir\agent.md" -Destination "$OpenCodeDir\agents\patesi.md" -Force
Copy-Item -Path "$RepoDir\system.md" -Destination "$OpenCodeDir\agents\system.md" -Force
Write-Host "   ✅ agents/patesi.md (from agent.md)" -ForegroundColor Green
Write-Host "   ✅ agents/system.md" -ForegroundColor Green

# Copy skills
Write-Host "📚 Installing skills..." -ForegroundColor Yellow
Get-ChildItem -Path "$RepoDir\skills\sdet-*" -Directory | ForEach-Object {
    $skillName = $_.Name
    $destDir = "$OpenCodeDir\skills\$skillName"
    New-Item -ItemType Directory -Force -Path $destDir | Out-Null
    Copy-Item -Path "$($_.FullName)\SKILL.md" -Destination "$destDir\SKILL.md" -Force
    Write-Host "   ✅ skills/$skillName/SKILL.md" -ForegroundColor Green
}

Write-Host ""
Write-Host "🎉 Patesi installed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host '  1. Add the agent to your opencode.json:' -ForegroundColor Cyan
Write-Host '     {' -ForegroundColor Gray
Write-Host '       "agent": {' -ForegroundColor Gray
Write-Host '         "patesi": {' -ForegroundColor Gray
Write-Host '           "description": "Patesi — Agente SDET de IA",' -ForegroundColor Gray
Write-Host '           "mode": "primary",' -ForegroundColor Gray
Write-Host '           "prompt": "{file:./agents/patesi.md}\n\n---\n\n{file:./agents/system.md}",' -ForegroundColor Gray
Write-Host '           "tools": { "edit": true, "write": true }' -ForegroundColor Gray
Write-Host '         }' -ForegroundColor Gray
Write-Host '       }' -ForegroundColor Gray
Write-Host '     }' -ForegroundColor Gray
Write-Host ""
Write-Host "  2. Restart opencode" -ForegroundColor Cyan
Write-Host "  3. Switch to the SDET agent using Tab key" -ForegroundColor Cyan
