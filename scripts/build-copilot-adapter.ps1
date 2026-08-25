# Patesi — Copilot Adapter Builder
# Regenerates adapters/copilot/copilot-instructions.md from agent.md + system.md
#
# Usage: .\scripts\build-copilot-adapter.ps1
#
# Encoding: This script MUST be saved as UTF-8 WITH BOM so PS5.1 reads
#           accented string literals correctly. Output is UTF-8 WITHOUT BOM.
#           IMPORTANT: No here-strings (@"...") — they corrupt Unicode in PS5.1.

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoDir = Split-Path -Parent $ScriptDir

# Read source files using explicit UTF-8 (no BOM) to avoid PS5.1 ANSI corruption
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
$AgentMd = [System.IO.File]::ReadAllText((Join-Path $RepoDir "agent.md"), $utf8NoBom)
$SystemMd = [System.IO.File]::ReadAllText((Join-Path $RepoDir "system.md"), $utf8NoBom)
$OutputPath = Join-Path $RepoDir "adapters\copilot\copilot-instructions.md"

Write-Host "Building Copilot adapter from agent.md + system.md..." -ForegroundColor Cyan

# Extract the agent identity section (everything before first ---)
$identitySection = ($AgentMd -split '---')[0].Trim()

# Build the skill list from config.yaml
$ConfigContent = [System.IO.File]::ReadAllText((Join-Path $RepoDir "config.yaml"), $utf8NoBom)
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

# Get today's date
$date = Get-Date -Format "yyyy-MM-dd"

# Em dash as char — PS5.1 parser can't handle U+2014 directly in string literals
$em = [char]0x2014

# Build output line by line — NO here-strings (they corrupt Unicode in PS5.1)
$lines = @()
$lines += "# Patesi - Adaptador para GitHub Copilot"
$lines += ""
$lines += "> **AUTO-GENERATED** por ``scripts/build-copilot-adapter.ps1``"
$lines += "> **NO EDITAR MANUALMENTE** - ejecutá ``.\scripts\build-copilot-adapter.ps1`` para regenerar."
$lines += "> Fuente de verdad: ``agent.md`` + ``system.md``"
$lines += "> Last generated: $date"
$lines += ""
$lines += "---"
$lines += ""
$lines += $identitySection
$lines += ""
$lines += "## Protocolo de Inicio de Sesión"
$lines += ""
$lines += "Al iniciar una sesión, ejecutá este protocolo:"
$lines += ""
$lines += "1. **¿Existe contexto del proyecto?** → Cargalo y confirmá"
$lines += "2. **¿Qué tipo de proyecto es?** → Seidor / Personal / Gobernado por cliente"
$lines += "3. **Si Seidor**: Preguntá NAQ (Bajo/Medio/Alto). Si no sabe, calculá por factores"
$lines += "4. **Guardá el contexto** en memoria del proyecto"
$lines += ""
$lines += "## Jerarquía de Frameworks"
$lines += ""
$lines += "### Modo A $em Proyecto Seidor"
$lines += "El **SQEM es LA REFERENCIA ABSOLUTA**. ISTQB complementa."
$lines += "- Citar SQEM: _""Según SQEM sección X.Y...""_"
$lines += "- Señalar desviaciones y pedir excepción formal"
$lines += "- Nunca saltar requisitos SQEM silenciosamente"
$lines += ""
$lines += "### Modo B $em Proyecto Personal"
$lines += "**ISTQB es la referencia primaria.** SQEM no aplica."
$lines += ""
$lines += "### Modo C $em Proyecto Gobernado por Cliente"
$lines += "El framework del cliente tiene precedencia. SQEM como checklist de suficiencia."
$lines += ""
$lines += "## Orientación a Riesgo"
$lines += ""
$lines += "Cada propuesta DEBE incluir:"
$lines += "- Evaluación de riesgo"
$lines += "- Métricas de cobertura (happy/unhappy/corner %)"
$lines += "- Priorización P1-P4"
$lines += "- Gaps de cobertura explícitos"
$lines += ""
$lines += "## Skills"
$lines += ""
$lines += "Los skills se cargan bajo demanda. No cargues proactivamente."
$lines += ""
$lines += ($skillLines -join "`n")
$lines += ""
$lines += "**Skills de automatización**: Playwright, Cypress, Selenium, Appium, Robot Framework"
$lines += "**Skills de lenguaje**: Python, Java, JavaScript/TypeScript"
$lines += "**Skills de metodología**: Gherkin/BDD, Cucumber, Maven/Gradle"
$lines += ""
$lines += "> **Nota**: ``sdet-project-learning`` requiere Engram MCP (específico de opencode)."
$lines += "> En Copilot, este skill degradará gracefully $em informá al usuario que la memoria"
$lines += "> entre sesiones no está disponible sin Engram."
$lines += ""
$lines += "## Idioma"
$lines += ""
$lines += "Combiná el idioma del usuario. Por defecto en castellano."

# Join and write as UTF-8 without BOM
$output = ($lines -join "`n") + "`n"
[System.IO.File]::WriteAllText($OutputPath, $output, $utf8NoBom)

Write-Host "Generated: adapters/copilot/copilot-instructions.md" -ForegroundColor Green
Write-Host "Done." -ForegroundColor Cyan
