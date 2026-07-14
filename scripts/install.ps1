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

# Copy agent
Write-Host "🤖 Installing agent..." -ForegroundColor Yellow
Copy-Item -Path "$RepoDir\agents\sdet.md" -Destination "$OpenCodeDir\agents\sdet.md" -Force
Write-Host "   ✅ agents/sdet.md" -ForegroundColor Green

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
Write-Host "  1. Add the agent to your opencode.json (see examples/opencode.json)"
Write-Host "  2. Restart opencode"
Write-Host "  3. Switch to the SDET agent using Tab key"
Write-Host ""
Write-Host "For more information, see README.md" -ForegroundColor Gray
