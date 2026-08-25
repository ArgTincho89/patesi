# Patesi — Skill Registry Generator (Single Source of Truth)
# Reads all skills/sdet-*/SKILL.md frontmatter and generates:
#   1. .atl/skill-registry.md      — markdown table
#   2. config.yaml skills block    — directly between SKILLS_BLOCK markers
#   3. system.md §8 table           — directly between SKILL_TABLE markers
#
# Usage:
#   .\scripts\generate-registry.ps1            — generate all outputs
#   .\scripts\generate-registry.ps1 --check    — compare only, exit 1 if different
#
# Requires: PowerShell 5.1+
# Encoding: This script MUST be saved as UTF-8 WITH BOM so PS5.1 reads
#           accented string literals correctly. Output files are UTF-8 WITHOUT BOM.

param(
    [switch]$check
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoDir = Split-Path -Parent $ScriptDir
$SkillsDir = Join-Path $RepoDir "skills"

# --- Manual mapping: human-curated "Solicitud del usuario" phrases ---
$humanPhrases = @{
    "sdet-istqb"                  = "Pregunta sobre ISTQB"
    "sdet-test-strategy"          = "Estrategia de testing"
    "sdet-test-cases"             = "Generar casos de prueba"
    "sdet-test-classification"    = "Clasificar tests S/M/L/XL"
    "sdet-risk-analysis"          = "Analisis de riesgos (feature/story)"
    "sdet-mr-analysis"            = "Analizar MR/PR"
    "sdet-cicd"                   = "Pipelines CI/CD"
    "sdet-project-learning"       = "Aprender del proyecto"
    "sdet-automation"             = "Framework Playwright"
    "sdet-automation-cypress"     = "Framework Cypress"
    "sdet-automation-selenium"    = "Selenium (Java/Python)"
    "sdet-automation-appium"      = "Appium / testing movil"
    "sdet-automation-robot"       = "Robot Framework"
    "sdet-lang-python"            = "Patrones Python / pytest"
    "sdet-lang-java"              = "Patrones Java / JUnit / TestNG"
    "sdet-lang-javascript"        = "Patrones JavaScript / Jest / Vitest"
    "sdet-methodology-gherkin"    = "Gherkin / BDD / feature files"
    "sdet-methodology-cucumber"   = "Cucumber / step definitions"
    "sdet-build-maven"            = "Maven / Gradle / build config"
    "sdet-sqem-classification"    = "Clasificacion proyecto Seidor"
    "sdet-sqem-gates"             = "Puertas de calidad Seidor"
    "sdet-sqem-controls"          = "Controles / umbrales Seidor"
    "sdet-sqem-ia"                = "IA/ML/GenAI testing"
}

# --- Output categories for config.yaml grouping ---
$categories = [ordered]@{
    "qa-core"      = @("sdet-istqb", "sdet-test-strategy", "sdet-test-cases", "sdet-test-classification", "sdet-risk-analysis", "sdet-mr-analysis", "sdet-project-learning")
    "pipelines"    = @("sdet-cicd")
    "automation"   = @("sdet-automation", "sdet-automation-cypress", "sdet-automation-selenium", "sdet-automation-appium", "sdet-automation-robot")
    "languages"    = @("sdet-lang-python", "sdet-lang-java", "sdet-lang-javascript")
    "methodologies"= @("sdet-methodology-gherkin", "sdet-methodology-cucumber", "sdet-build-maven")
    "sqem"         = @("sdet-sqem-classification", "sdet-sqem-gates", "sdet-sqem-controls", "sdet-sqem-ia")
}

$categoryLabels = @{
    "qa-core"       = "QA Core"
    "pipelines"     = "Pipelines"
    "automation"    = "Automatizacion"
    "languages"     = "Lenguajes"
    "methodologies" = "Metodologias y Build"
    "sqem"          = "SQEM (Seidor)"
}

# --- Parse all skills ---
Write-Host "Generating skill registry from SKILL.md frontmatter..." -ForegroundColor Cyan

$skillDirs = Get-ChildItem -Path $SkillsDir -Directory -Filter "sdet-*" | Sort-Object Name
$allSkills = @()
$skipped = 0

foreach ($skillDir in $skillDirs) {
    $skillFile = Join-Path $skillDir.FullName "SKILL.md"
    if (-not (Test-Path $skillFile)) {
        Write-Host "  SKIP: $($skillDir.Name) -- no SKILL.md" -ForegroundColor Yellow
        $skipped++
        continue
    }

    # Read as UTF-8 explicitly (PS5.1 defaults to system ANSI, corrupts accented chars)
    $content = [System.IO.File]::ReadAllText($skillFile, [System.Text.UTF8Encoding]::new($false))

    # Extract frontmatter between --- delimiters
    if ($content -match '(?s)^---\s*\r?\n(.*?)\r?\n---') {
        $frontmatter = $matches[1]
    } else {
        Write-Host "  SKIP: $($skillDir.Name) -- no frontmatter" -ForegroundColor Yellow
        $skipped++
        continue
    }

    $fmLines = $frontmatter -split '\r?\n'

    # Extract name
    $name = ""
    if ($frontmatter -match '(?m)^name:\s*(.+)$') { $name = $matches[1].Trim() }
    if (-not $name) { $name = $skillDir.Name }

    # Extract Trigger: from frontmatter (search all lines)
    $trigger = ""
    $triggerLine = $fmLines | Where-Object { $_ -match 'Trigger:' } | Select-Object -First 1
    if ($triggerLine) {
        $trigger = ($triggerLine -replace '(?i)Trigger:\s*', '').Trim()
    }

    # Extract first description line (indented, not Trigger/name/description/metadata/license/category/author/version)
    $skipPattern = '^\s*(Trigger:|name:|description:|license:|metadata:|category:|author:|version:)'
    $descLine = $fmLines | Where-Object { $_ -match '^\s{2}\S' -and $_ -notmatch $skipPattern } | Select-Object -First 1
    $description = if ($descLine) { $descLine.Trim() } else { $trigger }

    if (-not $trigger) {
        Write-Host "  WARN: $name -- no Trigger: found, using description as trigger" -ForegroundColor Yellow
        $trigger = $description
    }

    $relativePath = "skills/$($skillDir.Name)/SKILL.md"

    $allSkills += [PSCustomObject]@{
        Name        = $name
        Trigger     = $trigger
        Description = $description
        Path        = $relativePath
    }

    Write-Host "  OK: $name" -ForegroundColor Green
}

Write-Host ""
Write-Host "Parsed $($allSkills.Count) skills ($skipped skipped)" -ForegroundColor Cyan

# Build lookup: name -> skill object
$skillMap = @{}
foreach ($s in $allSkills) { $skillMap[$s.Name] = $s }

# --- Output 1: .atl/skill-registry.md ---
$date = Get-Date -Format "yyyy-MM-dd"
$registryLines = @()
$registryLines += "# Skill Registry -- patesi"
$registryLines += ""
$registryLines += "<!-- AUTO-GENERATED by scripts/generate-registry.ps1 -- DO NOT EDIT MANUALLY -->"
$registryLines += "<!-- Run: .\scripts\generate-registry.ps1 -->"
$registryLines += ""
$registryLines += "Last updated: $date"
$registryLines += ""
$registryLines += "## Skills"
$registryLines += ""
$registryLines += "| Skill | Trigger / description | Scope | Path |"
$registryLines += "|-------|----------------------|-------|------|"

foreach ($catKey in $categories.Keys) {
    foreach ($skillName in $categories[$catKey]) {
        if ($skillMap.ContainsKey($skillName)) {
            $s = $skillMap[$skillName]
            $registryLines += "| ``$($s.Name)`` | $($s.Trigger) | project | ``$($s.Path)`` |"
        }
    }
}

$registryLines += ""
$registryLines += "## Loading protocol"
$registryLines += ""
$registryLines += "1. Match task context and target files against the ``Trigger / description`` column."
$registryLines += "2. Pass only the matching ``Path`` values to the subagent under ``## Skills to load before work``."
$registryLines += "3. Instruct the subagent to read those exact ``SKILL.md`` files before reading, writing, reviewing, testing, or creating artifacts."
$registryLines += "4. If no matching skill exists, proceed without project skill injection and report ``skill_resolution: none``."

$registryContent = ($registryLines -join "`n") + "`n"

# --- Output 2: config.yaml skills block (between markers) ---
$configLines = @()
$firstCategory = $true

foreach ($catKey in $categories.Keys) {
    $catSkills = @()
    foreach ($skillName in $categories[$catKey]) {
        if ($skillMap.ContainsKey($skillName)) {
            $catSkills += $skillMap[$skillName]
        }
    }
    if ($catSkills.Count -eq 0) { continue }

    if (-not $firstCategory) { $configLines += "" }
    $firstCategory = $false
    $configLines += "  # --- $($categoryLabels[$catKey]) ---"

    foreach ($s in $catSkills) {
        $configLines += "  - name: $($s.Name)"
        $configLines += "    trigger: $($s.Trigger.ToLower())"
    }
}

$configSkillsBlock = ($configLines -join "`n") + "`n"

# --- Output 3: system.md §8 table (between markers) ---
$sysLines = @()
$sysLines += "<!-- SKILL_TABLE_START -- auto-generated by scripts/generate-registry.ps1 -- DO NOT EDIT MANUALLY -->"
$sysLines += "| Solicitud del usuario | Skill a cargar |"
$sysLines += "|----------------------|----------------|"

foreach ($catKey in $categories.Keys) {
    foreach ($skillName in $categories[$catKey]) {
        if ($humanPhrases.ContainsKey($skillName)) {
            $sysLines += "| $($humanPhrases[$skillName]) | ``$skillName`` |"
        }
    }
}

$sysLines += "<!-- SKILL_TABLE_END -->"
$sysTableContent = ($sysLines -join "`n") + "`n"

# --- Helper: replace content between markers in a file ---
function Update-MarkedSection {
    param(
        [string]$FilePath,
        [string]$StartMarker,
        [string]$EndMarker,
        [string]$NewContent
    )

    if (-not (Test-Path $FilePath)) {
        Write-Host "  MISSING: $FilePath" -ForegroundColor Red
        return $false
    }

    $fullContent = [System.IO.File]::ReadAllText($FilePath, [System.Text.UTF8Encoding]::new($false))
    $startIdx = $fullContent.IndexOf($StartMarker)
    $endIdx = $fullContent.IndexOf($EndMarker)

    if ($startIdx -lt 0 -or $endIdx -lt 0) {
        Write-Host "  STALE: $FilePath -- markers not found ($StartMarker / $EndMarker)" -ForegroundColor Red
        return $false
    }

    # Include the end marker line itself
    $endLineEnd = $fullContent.IndexOf("`n", $endIdx)
    if ($endLineEnd -lt 0) { $endLineEnd = $fullContent.Length }

    $before = $fullContent.Substring(0, $startIdx)
    $after = $fullContent.Substring($endLineEnd)
    $newFull = $before + $NewContent + $after

    [System.IO.File]::WriteAllText($FilePath, $newFull, [System.Text.UTF8Encoding]::new($false))
    return $true
}

# --- Check mode: compare and report ---
if ($check) {
    Write-Host ""
    Write-Host "=== CHECK MODE ===" -ForegroundColor Yellow

    $mismatches = 0

    # Check 1: .atl/skill-registry.md
    $registryFile = Join-Path $RepoDir ".atl\skill-registry.md"
    if (Test-Path $registryFile) {
        $existing = [System.IO.File]::ReadAllText($registryFile, [System.Text.Encoding]::UTF8)
        if ($existing -ne $registryContent) {
            Write-Host "  STALE: .atl/skill-registry.md" -ForegroundColor Red
            $mismatches++
        } else {
            Write-Host "  FRESH: .atl/skill-registry.md" -ForegroundColor Green
        }
    } else {
        Write-Host "  MISSING: .atl/skill-registry.md" -ForegroundColor Red
        $mismatches++
    }

    # Check 2: config.yaml skills block (between markers)
    $configFile = Join-Path $RepoDir "config.yaml"
    if (Test-Path $configFile) {
        $existingConfig = [System.IO.File]::ReadAllText($configFile, [System.Text.Encoding]::UTF8)
        $startTag = "# SKILLS_BLOCK_START"
        $endTag = "# SKILLS_BLOCK_END"
        $cfgStart = $existingConfig.IndexOf($startTag)
        $cfgEnd = $existingConfig.IndexOf($endTag)
        if ($cfgStart -ge 0 -and $cfgEnd -ge 0) {
            # Extract existing block between markers (exclusive of markers)
            $afterStart = $existingConfig.Substring($cfgStart + $startTag.Length)
            $blockEnd = $afterStart.IndexOf("`n$endTag")
            if ($blockEnd -ge 0) {
                $existingBlock = $afterStart.Substring(0, $blockEnd).Trim() + "`n"
                $expectedBlock = "skills:`n" + $configSkillsBlock.TrimEnd() + "`n"
                if ($existingBlock.TrimEnd() -ne $expectedBlock.TrimEnd()) {
                    Write-Host "  STALE: config.yaml skills block" -ForegroundColor Red
                    $mismatches++
                } else {
                    Write-Host "  FRESH: config.yaml skills block" -ForegroundColor Green
                }
            } else {
                Write-Host "  STALE: config.yaml -- end marker not found after start" -ForegroundColor Red
                $mismatches++
            }
        } else {
            Write-Host "  STALE: config.yaml -- skills block markers not found" -ForegroundColor Red
            $mismatches++
        }
    } else {
        Write-Host "  MISSING: config.yaml" -ForegroundColor Red
        $mismatches++
    }

    # Check 3: system.md §8 table (between markers)
    $systemFile = Join-Path $RepoDir "system.md"
    if (Test-Path $systemFile) {
        $existingSys = [System.IO.File]::ReadAllText($systemFile, [System.Text.Encoding]::UTF8)
        $sysStartTag = "<!-- SKILL_TABLE_START"
        $sysEndTag = "<!-- SKILL_TABLE_END -->"
        $sysStart = $existingSys.IndexOf($sysStartTag)
        $sysEnd = $existingSys.IndexOf($sysEndTag)
        if ($sysStart -ge 0 -and $sysEnd -ge 0) {
            $afterSysStart = $existingSys.Substring($sysStart)
            $sysBlockEnd = $afterSysStart.IndexOf("$sysEndTag`n")
            if ($sysBlockEnd -lt 0) { $sysBlockEnd = $afterSysStart.IndexOf($sysEndTag) }
            if ($sysBlockEnd -ge 0) {
                $existingSysBlock = $afterSysStart.Substring(0, $sysBlockEnd + $sysEndTag.Length) + "`n"
                if ($existingSysBlock.TrimEnd() -ne $sysTableContent.TrimEnd()) {
                    Write-Host "  STALE: system.md §8 table" -ForegroundColor Red
                    $mismatches++
                } else {
                    Write-Host "  FRESH: system.md §8 table" -ForegroundColor Green
                }
            } else {
                Write-Host "  STALE: system.md -- end marker not found" -ForegroundColor Red
                $mismatches++
            }
        } else {
            Write-Host "  STALE: system.md -- skill table markers not found" -ForegroundColor Red
            $mismatches++
        }
    } else {
        Write-Host "  MISSING: system.md" -ForegroundColor Red
        $mismatches++
    }

    if ($mismatches -gt 0) {
        Write-Host ""
        Write-Host "$mismatches file(s) stale. Run generate-registry.ps1 to refresh." -ForegroundColor Red
        exit 1
    } else {
        Write-Host ""
        Write-Host "All files fresh." -ForegroundColor Green
        exit 0
    }
}

# --- Write mode: generate files ---
Write-Host ""
Write-Host "=== GENERATING ===" -ForegroundColor Yellow

# Ensure .atl directory exists
$atlDir = Join-Path $RepoDir ".atl"
if (-not (Test-Path $atlDir)) {
    New-Item -ItemType Directory -Path $atlDir -Force | Out-Null
}

# Write 1: .atl/skill-registry.md
$registryPath = Join-Path $RepoDir ".atl\skill-registry.md"
[System.IO.File]::WriteAllText($registryPath, $registryContent, [System.Text.UTF8Encoding]::new($false))
Write-Host "Generated: .atl/skill-registry.md ($($allSkills.Count) skills)" -ForegroundColor Green

# Write 2: config.yaml skills block (between markers)
$configFile = Join-Path $RepoDir "config.yaml"
if (Update-MarkedSection -FilePath $configFile -StartMarker "# SKILLS_BLOCK_START" -EndMarker "# SKILLS_BLOCK_END" -NewContent "# SKILLS_BLOCK_START`nskills:`n$configSkillsBlock# SKILLS_BLOCK_END") {
    Write-Host "Generated: config.yaml skills block (between markers)" -ForegroundColor Green
} else {
    Write-Host "FAILED: config.yaml -- could not update skills block" -ForegroundColor Red
}

# Write 3: system.md §8 table (between markers)
$systemFile = Join-Path $RepoDir "system.md"
if (Update-MarkedSection -FilePath $systemFile -StartMarker "<!-- SKILL_TABLE_START" -EndMarker "<!-- SKILL_TABLE_END -->" -NewContent $sysTableContent) {
    Write-Host "Generated: system.md §8 table (between markers)" -ForegroundColor Green
} else {
    Write-Host "FAILED: system.md -- could not update skill table" -ForegroundColor Red
}

# Cleanup legacy skills-block.yaml if it exists
$legacyBlock = Join-Path $RepoDir "skills-block.yaml"
if (Test-Path $legacyBlock) {
    Remove-Item $legacyBlock -Force
    Write-Host "Removed legacy: skills-block.yaml" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Done. $($allSkills.Count) skills processed. 3 files updated." -ForegroundColor Cyan
