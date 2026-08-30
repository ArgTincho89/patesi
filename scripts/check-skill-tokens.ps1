# Patesi — Skill Token Validator
# Verifica que cada SKILL.md tenga menos de 4K tokens (aproximadamente).
# Usa el recuento de palabras como proxy: ~1.3 tokens por palabra en contenido técnico mixto.
#
# Uso:
#   .\scripts\check-skill-tokens.ps1            — show token estimates for all skills
#   .\scripts\check-skill-tokens.ps1 --max 4000 — falla si algún skill supera el máximo
#   .\scripts\check-skill-tokens.ps1 --check    — igual que --max 4000, sale con 1 si alguno supera el máximo

param(
    [int]$max = 4000,
    [switch]$check
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoDir = Split-Path -Parent $ScriptDir
$SkillsDir = Join-Path $RepoDir "skills"

# Tokens aproximados por palabra para contenido técnico mixto en inglés y castellano
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

# Ordenar por tokens estimados de forma descendente
$results = $results | Sort-Object EstTokens -Descending

# Mostrar
Write-Host ""
Write-Host "Estimaciones de tokens por skill (máximo: $max)" -ForegroundColor Cyan
Write-Host ("-" * 55)
Write-Host ("{0,-35} {1,6} {2,8} {3,6}" -f "Skill", "Lines", "Est.Tok", "Status")
Write-Host ("-" * 55)

foreach ($r in $results) {
    $color = if ($r.Status -eq "EXCEED") { "Red" } else { "Green" }
    Write-Host ("{0,-35} {1,6} {2,8} {3,6}" -f $r.Skill, $r.Lines, $r.EstTokens, $r.Status) -ForegroundColor $color
}

Write-Host ("-" * 55)
Write-Host "Total de skills: $($results.Count) | Excedidos: $exceeded" -ForegroundColor $(if ($exceeded -gt 0) { "Red" } else { "Green" })

if ($check -and $exceeded -gt 0) {
    Write-Host ""
    Write-Host "$exceeded skill(s) superan el presupuesto de ${max} tokens." -ForegroundColor Red
    exit 1
}
