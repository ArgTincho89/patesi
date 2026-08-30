# Patesi — Constructor del adaptador de Copilot
# Regenera adapters/copilot/copilot-instructions.md desde agent.md + system.md
#
# Uso: .\scripts\build-copilot-adapter.ps1
#
# Codificación: este script DEBE guardarse como UTF-8 CON BOM para que PS5.1 lea
#               correctamente los literales con tildes. La salida es UTF-8 SIN BOM.
#               IMPORTANTE: no usar here-strings (@"...") porque corrompen Unicode en PS5.1.

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoDir = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $ScriptDir))

# Leer archivos fuente con UTF-8 explícito (sin BOM) para evitar corrupción ANSI de PS5.1
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
$AgentMd = [System.IO.File]::ReadAllText((Join-Path $RepoDir "agent.md"), $utf8NoBom)
$SystemMd = [System.IO.File]::ReadAllText((Join-Path $RepoDir "system.md"), $utf8NoBom)
$OutputPath = Join-Path $RepoDir "adapters\copilot\copilot-instructions.md"

Write-Host "Construyendo el adaptador de Copilot desde agent.md + system.md..." -ForegroundColor Cyan

# Extraer la sección de identidad del agente (todo antes del primer ---)
$identitySection = ($AgentMd -split '---')[0].Trim()

# Construir la lista de skills desde config.yaml
$ConfigContent = [System.IO.File]::ReadAllText((Join-Path $RepoDir "config.yaml"), $utf8NoBom)
$skillLines = @()
$inSkills = $false
foreach ($line in ($ConfigContent -split "`n")) {
    if ($line -match '^skills:') { $inSkills = $true; continue }
    if ($inSkills -and $line -match '^\s+- name: (.+)$') {
        $skillName = $matches[1].Trim()
        $skillLines += "- ``$skillName``"
    }
    if ($inSkills -and $line -match '^[a-z]' -and $line -notmatch '^\s') { break }
}

# Obtener la fecha actual
$date = Get-Date -Format "yyyy-MM-dd"

# Em dash as char — PS5.1 parser can't handle U+2014 directly in string literals
$em = [char]0x2014

# Construir la salida línea por línea: NO usar here-strings (corrompen Unicode en PS5.1)
$lines = @()
$lines += "# Patesi - Adaptador para GitHub Copilot"
$lines += ""
$lines += "> **GENERADO AUTOMÁTICAMENTE** por ``adapters/copilot/scripts/build-copilot-adapter.ps1``"
$lines += "> **NO EDITAR MANUALMENTE** - ejecutá ``.\adapters\copilot\scripts\build-copilot-adapter.ps1`` para regenerar."
$lines += "> Fuente de verdad: ``agent.md`` + ``system.md``"
$lines += "> Última generación: $date"
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
$lines += "3. **Si Seidor**: Disponé del contenido de ``sdet-sqem-classification``, recorré sus factores y comunicá el NAQ derivado; no solicites el resultado al usuario"
$lines += "4. **Guardá el contexto** en memoria del proyecto"
$lines += ""
$lines += "## Jerarquía de Frameworks"
$lines += ""
$lines += "### Modo A $em Proyecto Seidor"
$lines += "El **SQEM es LA REFERENCIA ABSOLUTA**. ISTQB complementa."
$lines += "- En NAQ Alto, verificá la sub-banda **misión crítica** definida por ``sdet-sqem-classification``; cuando aplica, cambia los entregables y controles."
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
$lines += "## Disponibilidad del conocimiento especializado"
$lines += ""
$lines += "El contenido de los skills requeridos debe estar disponible antes de generar una respuesta. En Copilot, hacé disponible el SKILL.md relevante como contexto de instrucciones o archivos adjuntos; este adapter no depende de herramientas de opencode."
$lines += ""
$lines += ($skillLines -join "`n")
$lines += ""
$lines += "**Skills de automatización**: Playwright, Cypress, Selenium, Appium, Robot Framework"
$lines += "**Skills de lenguaje**: Python, Java, JavaScript/TypeScript"
$lines += "**Skills de metodología**: Gherkin/BDD, Cucumber, Maven/Gradle"
$lines += ""
$lines += "> La persistencia entre sesiones depende de las capacidades de instrucciones y contexto disponibles en Copilot. No se asume memoria persistente ni herramientas de opencode."
# Join and write as UTF-8 without BOM
$output = ($lines -join "`n") + "`n"
[System.IO.File]::WriteAllText($OutputPath, $output, $utf8NoBom)

Write-Host "Generado: adapters/copilot/copilot-instructions.md" -ForegroundColor Green
Write-Host "Listo." -ForegroundColor Cyan
