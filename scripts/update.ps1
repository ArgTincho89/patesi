# Patesi - Update Script for Windows
# Usage: .\scripts\update.ps1

$ErrorActionPreference = "Stop"

Write-Host "Updating Patesi..." -ForegroundColor Cyan

# Find repo root (script is in scripts/, repo is one level up)
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoDir = Split-Path -Parent $ScriptDir
$OpenCodeDir = "$env:USERPROFILE\.config\opencode"

# Check if opencode dir exists
if (-not (Test-Path $OpenCodeDir)) {
    Write-Host "ERROR: opencode config not found at $OpenCodeDir" -ForegroundColor Red
    Write-Host "Run install.ps1 first." -ForegroundColor Yellow
    exit 1
}

# Git pull
Write-Host "Pulling latest changes..." -ForegroundColor Yellow
Set-Location $RepoDir
git pull origin main
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: git pull failed" -ForegroundColor Red
    exit 1
}

# Copy agent
Write-Host "Copying agent..." -ForegroundColor Yellow
Copy-Item -Path "$RepoDir\agents\patesi.md" -Destination "$OpenCodeDir\agents\patesi.md" -Force
Write-Host "   OK agents/patesi.md" -ForegroundColor Green

# Copy skills
Write-Host "Copying skills..." -ForegroundColor Yellow
Get-ChildItem -Path "$RepoDir\skills\sdet-*" -Directory | ForEach-Object {
    $skillName = $_.Name
    $destDir = "$OpenCodeDir\skills\$skillName"
    New-Item -ItemType Directory -Force -Path $destDir | Out-Null
    Copy-Item -Path "$($_.FullName)\SKILL.md" -Destination "$destDir\SKILL.md" -Force
    Write-Host "   OK skills/$skillName/SKILL.md" -ForegroundColor Green
}

Write-Host ""
Write-Host "Patesi updated!" -ForegroundColor Green
Write-Host "Restart opencode to use the new version." -ForegroundColor Cyan
