# Patesi — Skill Token Validator
# Checks that each SKILL.md is under 4K tokens (approximate).
# Uses word count as a proxy: ~1.3 tokens per word for English/Spanish mixed content.
#
# Usage:
#   .\scripts\check-skill-tokens.ps1            — show token estimates for all skills
#   .\scripts\check-skill-tokens.ps1 --max 4000 — fail if any skill exceeds max tokens
#   .\scripts\check-skill-tokens.ps1 --check    — same as --max 4000, exit 1 if any exceed

param(
    [int]$max = 4000,
    [switch]$check
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoDir = Split-Path -Parent $ScriptDir
$SkillsDir = Join-Path $RepoDir "skills"

# Approximate tokens per word for mixed English/Spanish technical content
$TOKENS_PER_WORD = 1.3

$skillDirs = Get-ChildItem -Path $SkillsDir -Directory -Filter "sdet-*" | Sort-Object Name
$results = @()
$exceeded = 0

foreach ($skillDir in $skillDirs) {
    $skillFile = Join-Path $skillDir.FullName "SKILL.md"
    if (-not (Test-Path $skillFile)) { continue }

    $content = [System.IO.File]::ReadAllText($skillFile, [System.Text.UTF8Encoding]::new($false))
    $lines = ($content -split "`n").Count
    $words = ($content -split '\s+' | Where-Object { $_ -ne '' }).Count
    $estTokens = [math]::Round($words * $TOKENS_PER_WORD)
    $status = if ($estTokens -gt $max) { "EXCEED"; $exceeded++ } else { "OK" }

    $results += [PSCustomObject]@{
        Skill     = $skillDir.Name
        Lines     = $lines
        Words     = $words
        EstTokens = $estTokens
        Status    = $status
    }
}

# Sort by estimated tokens descending
$results = $results | Sort-Object EstTokens -Descending

# Display
Write-Host ""
Write-Host "Skill Token Estimates (max: $max)" -ForegroundColor Cyan
Write-Host ("-" * 55)
Write-Host ("{0,-35} {1,6} {2,8} {3,6}" -f "Skill", "Lines", "Est.Tok", "Status")
Write-Host ("-" * 55)

foreach ($r in $results) {
    $color = if ($r.Status -eq "EXCEED") { "Red" } else { "Green" }
    Write-Host ("{0,-35} {1,6} {2,8} {3,6}" -f $r.Skill, $r.Lines, $r.EstTokens, $r.Status) -ForegroundColor $color
}

Write-Host ("-" * 55)
Write-Host "Total skills: $($results.Count) | Exceeded: $exceeded" -ForegroundColor $(if ($exceeded -gt 0) { "Red" } else { "Green" })

if ($check -and $exceeded -gt 0) {
    Write-Host ""
    Write-Host "$exceeded skill(s) exceed ${max} token budget." -ForegroundColor Red
    exit 1
}
