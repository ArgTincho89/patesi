# Patesi — Copilot Adapter Builder
# Regenerates adapters/copilot/copilot-instructions.md from agent.md + system.md
#
# Usage: .\scripts\build-copilot-adapter.ps1

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoDir = Split-Path -Parent $ScriptDir

$AgentMd = Get-Content -Path (Join-Path $RepoDir "agent.md") -Raw -Encoding UTF8
$SystemMd = Get-Content -Path (Join-Path $RepoDir "system.md") -Raw -Encoding UTF8
$OutputPath = Join-Path $RepoDir "adapters\copilot\copilot-instructions.md"

Write-Host "Building Copilot adapter from agent.md + system.md..." -ForegroundColor Cyan

# Extract the agent identity section (everything before first ---)
$identitySection = ($AgentMd -split '---')[0].Trim()

# Extract key sections from system.md
$sessionProtocol = ""
$frameworkHierarchy = ""
$riskOrientation = ""

if ($SystemMd -match '(?s)## 1\. Protocolo de Inicio de Sesión.*?(?=## 2\.)') {
    $sessionProtocol = $matches[0].Trim()
}
if ($SystemMd -match '(?s)## 2\. Jerarquía de Frameworks de Calidad.*?(?=## 3\.)') {
    $frameworkHierarchy = $matches[0].Trim()
}
if ($SystemMd -match '(?s)## 3\. Orientación a Riesgo y Cobertura.*?(?=## 4\.)') {
    $riskOrientation = $matches[0].Trim()
}

# Build the skill list from config.yaml
$ConfigContent = Get-Content -Path (Join-Path $RepoDir "config.yaml") -Raw -Encoding UTF8
$skillLines = @()
$inSkills = $false
foreach ($line in ($ConfigContent -split "`n")) {
    if ($line -match '^skills:') { $inSkills = $true; continue }
    if ($inSkills -and $line -match '^- name: (.+)$') {
        $skillName = $matches[1].Trim()
        $skillLines += "- ``$skillName``"
    }
    if ($inSkills -and $line -match '^[a-z]' -and $line -notmatch '^\s') { break }
}

$adapter = @"
# Patesi — Adaptador para GitHub Copilot

> **AUTO-GENERATED** por ``scripts/build-copilot-adapter.ps1``
> **NO EDITAR MANUALMENTE** — ejecutá ``.\scripts\build-copilot-adapter.ps1`` para regenerar.
> Fuente de verdad: ``agent.md`` + ``system.md``

---

$identitySection

## Protocolo de Inicio de Sesión

Al iniciar una sesión, ejecutá este protocolo:

1. **¿Existe contexto del proyecto?** → Cargalo y confirmá
2. **¿Qué tipo de proyecto es?** → Seidor / Personal / Gobernado por cliente
3. **Si Seidor**: Preguntá NAQ (Bajo/Medio/Alto). Si no sabe, calculá por factores
4. **Guardá el contexto** en memoria del proyecto

## Jerarquía de Frameworks

### Modo A — Proyecto Seidor
El **SQEM es LA REFERENCIA ABSOLUTA**. ISTQB complementa.
- Citar SQEM: _"Según SQEM sección X.Y..."_
- Señalar desviaciones y pedir excepción formal
- Nunca saltar requisitos SQEM silenciosamente

### Modo B — Proyecto Personal
**ISTQB es la referencia primaria.** SQEM no aplica.

### Modo C — Proyecto Gobernado por Cliente
El framework del cliente tiene precedencia. SQEM como checklist de suficiencia.

## Orientación a Riesgo

Cada propuesta DEBE incluir:
- Evaluación de riesgo
- Métricas de cobertura (happy/unhappy/corner %)
- Priorización P1-P4
- Gaps de cobertura explícitos

## Skills

Los skills se cargan bajo demanda. No cargues proactivamente.

$($skillLines -join "`n")

**Skills de automatización**: Playwright, Cypress, Selenium, Appium, Robot Framework
**Skills de lenguaje**: Python, Java, JavaScript/TypeScript
**Skills de metodología**: Gherkin/BDD, Cucumber, Maven/Gradle

> **Nota**: ``sdet-project-learning`` requiere Engram MCP (específico de opencode).
> En Copilot, este skill degradará gracefully — informá al usuario que la memoria
> entre sesiones no está disponible sin Engram.

## Idioma

Combiná el idioma del usuario. Por defecto en castellano.
"@

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
[System.IO.File]::WriteAllText($OutputPath, $adapter, $utf8NoBom)
Write-Host "Generated: adapters/copilot/copilot-instructions.md" -ForegroundColor Green
Write-Host "Done." -ForegroundColor Cyan
