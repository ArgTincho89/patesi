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

# Extraer la sección de identidad: todo hasta la primera línea que sea exactamente
# ---, o el archivo completo si no existe. Debe coincidir exactamente con la lógica
# del builder .sh para que ambos produzcan la misma salida.
$identityLines = @()
foreach ($line in ($AgentMd -split "`r?`n")) {
    if ($line.Trim() -eq '---') { break }
    $identityLines += $line
}
$identitySection = ($identityLines -join "`n").Trim()

# Extraer secciones VERBATIM de system.md entre markers.
# El protocolo de modos y la jerarquía NO se reescriben acá: se copian tal cual
# para garantizar que Copilot y opencode se comporten igual en los tres modos.
function Get-ExtractSection {
    param([string]$Text, [string]$Name)
    $startTag = "<!-- COPILOT-EXTRACT-START: $Name -->"
    $endTag = "<!-- COPILOT-EXTRACT-END: $Name -->"
    $si = $Text.IndexOf($startTag)
    $ei = $Text.IndexOf($endTag)
    if ($si -lt 0 -or $ei -lt 0) {
        throw "system.md no contiene los markers COPILOT-EXTRACT de la seccion '$Name'. El adapter quedaria desincronizado."
    }
    $si += $startTag.Length
    return $Text.Substring($si, $ei - $si).Trim()
}

$limitsSection = Get-ExtractSection -Text $SystemMd -Name "limites"
$protocolSection = Get-ExtractSection -Text $SystemMd -Name "protocolo"
$modesSection = Get-ExtractSection -Text $SystemMd -Name "modos"

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

# Em dash as char — PS5.1 parser can't handle U+2014 directly in string literals
$em = [char]0x2014

# Construir la salida línea por línea: NO usar here-strings (corrompen Unicode en PS5.1)
$lines = @()
$lines += "# Patesi $em Adaptador para GitHub Copilot"
$lines += ""
$lines += "> **GENERADO AUTOMÁTICAMENTE** por ``build-copilot-adapter.ps1`` o su equivalente ``.sh``"
$lines += "> **NO EDITAR MANUALMENTE** $em ejecutá cualquiera de los dos builders; producen el mismo resultado."
$lines += "> Fuente de verdad: ``agent.md`` + ``system.md``"
$lines += ""
$lines += "---"
$lines += ""
$lines += $identitySection
$lines += ""
$lines += "## Regla fundamental $em Límite de escritura"
$lines += ""
$lines += "**Esta regla gobierna sobre todas las demás y aplica por igual en Modo A, B y C.**"
$lines += ""
$lines += $limitsSection
$lines += ""
$lines += "## Protocolo de Inicio de Sesión"
$lines += ""
$lines += "**OBLIGATORIO $em ejecutá esto antes de cualquier trabajo de QA.**"
$lines += ""
$lines += $protocolSection
$lines += ""
$lines += "## Jerarquía de Frameworks de Calidad"
$lines += ""
$lines += "Los tres modos tienen el mismo peso. El modo activo determina qué framework manda, qué vocabulario usás y qué skills cargás. Un modo nunca contamina a otro."
$lines += ""
$lines += $modesSection
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
$lines += "## Memoria del proyecto en Copilot"
$lines += ""
$lines += "La persistencia entre sesiones depende de las capacidades de instrucciones y contexto disponibles en Copilot. No se asume memoria persistente ni herramientas de opencode."
$lines += ""
$lines += "**Modo C:** el perfil del cliente es indispensable y no puede perderse entre sesiones. Si Copilot no ofrece persistencia en este entorno, mantené el perfil como archivo markdown versionado en el repositorio y cargalo como contexto al inicio de cada sesión. Avisale al usuario la primera vez que esto ocurra."
$lines += ""
$lines += "**Modo B:** si no hay persistencia, informá que los patrones del proyecto no se recordarán entre sesiones y seguí trabajando normalmente."
# Join and write as UTF-8 without BOM
$output = ($lines -join "`n") + "`n"
[System.IO.File]::WriteAllText($OutputPath, $output, $utf8NoBom)

Write-Host "Generado: adapters/copilot/copilot-instructions.md" -ForegroundColor Green
Write-Host "Listo." -ForegroundColor Cyan
