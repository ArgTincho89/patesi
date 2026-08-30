# Patesi — Validador de tokens estimados
# Verifica que cada SKILL.md tenga menos de 4K tokens y que el núcleo combinado
# (agent.md + system.md) tenga menos de 12000 tokens (aproximadamente).
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
$CORE_MAX_TOKENS = 12000

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

$coreFiles = @((Join-Path $RepoDir "agent.md"), (Join-Path $RepoDir "system.md"))
$coreWords = 0
foreach ($coreFile in $coreFiles) {
    if (Test-Path $coreFile) {
        $coreContent = [System.IO.File]::ReadAllText($coreFile, [System.Text.UTF8Encoding]::new($false))
        $coreWords += ($coreContent -split '\s+' | Where-Object { $_ -ne '' }).Count
    }
}
$coreEstTokens = [math]::Round($coreWords * $TOKENS_PER_WORD)
$coreStatus = if ($coreEstTokens -gt $CORE_MAX_TOKENS) { "EXCEED" } else { "OK" }

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
Write-Host "Núcleo agnóstico combinado (agent.md + system.md): $coreWords palabras, $coreEstTokens tokens estimados / $CORE_MAX_TOKENS presupuesto ($coreStatus)" -ForegroundColor $(if ($coreStatus -eq "EXCEED") { "Red" } else { "Green" })

if ($check -and ($exceeded -gt 0 -or $coreStatus -eq "EXCEED")) {
    Write-Host ""
    if ($exceeded -gt 0) { Write-Host "$exceeded skill(s) superan el presupuesto de ${max} tokens." -ForegroundColor Red }
    if ($coreStatus -eq "EXCEED") { Write-Host "El núcleo agnóstico combinado supera el presupuesto de $CORE_MAX_TOKENS tokens." -ForegroundColor Red }
    exit 1
}
