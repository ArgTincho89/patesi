# Changelog

All notable changes to Patesi will be documented in this file.

Format based on [Keep a Changelog](https://keepachangelog.com/).

## [2.0.1] - 2026-08-25

### Fixed
- **Broken installer**: Scripts now reference `agent.md` + `system.md` from repo root (not deleted `agents/patesi.md`)
- **Orphaned content**: Merged `prompts/`, `workflows/`, and `knowledge/` into `system.md` as single source of truth; removed redundant directories
- **NAQ duplication**: NAQ formula/gates/controls no longer duplicated across 5 files; `system.md` references skills for full details
- **Skill registry**: Replaced absolute Windows paths with relative paths
- **config.yaml**: Removed stale Cursor reference
- **examples/opencode.json**: Aligned with actual `agent.md` + `system.md` composition

## [2.0.0] - 2026-08-25

### Added

#### Architecture
- **Agent restructure**: Separated monolithic `patesi.md` into modular architecture
  - `agent.md` — Agent identity, personality, core principles
  - `system.md` — Complete behavioral spec: session protocol, framework hierarchy, risk orientation, planning flow, generation rules, auto-review checklist, QA workflow
  - `config.yaml` — Agent configuration, permissions, skill registry
- **Tools documentation**: `tools/README.md` with complete tool reference
- **Memory templates**: Project memory structure
  - `memory/_template/context.yaml` — Project context template
  - `memory/_template/patterns.md` — Pattern storage template
  - `memory/_template/decisions.md` — Decision logging template
- **Adapters**: IDE-specific integration files
  - `adapters/opencode/patesi.md` — opencode adapter with `{file:}` composition
  - `adapters/copilot/copilot-instructions.md` — GitHub Copilot adapter

#### SQEM Skills (4 new)
- **sdet-sqem-classification**: NAQ calculation, tipologia selection, delivery target derivation, nucleo comun, governance roles
- **sdet-sqem-gates**: QG0-QG7 criteria, F/L/C/N/A matrix by tipologia, QG-Express, exception management
- **sdet-sqem-controls**: Control catalog by gate x NAQ, coverage thresholds, SonarQube profiles, indicators, dashboards
- **sdet-sqem-ia**: Annex IA controls for AI/ML/GenAI: data quality, golden dataset, hallucination rate, red-teaming, EU AI Act

#### Multi-project Support
- Elicitation flow: Session start detects project type (Seidor/Personal/Client-governed)
- NAQ classification with override rules
- Project-scoped memory isolation via `~/.config/opencode/patesi-memory/{project}/`
- Framework hierarchy: Mode A (SQEM), Mode B (ISTQB), Mode C (Client-governed)

### Changed
- Skills auto-discovered from `skills/` directory (13 total: 9 original + 4 SQEM)
- opencode system prompt composed via `{file:agent.md}\n\n---\n\n{file:system.md}`
- README updated with new architecture and installation instructions
- Skill registry updated with SQEM skills

### Removed
- **Cursor support** (`.cursorrules` deleted)
- `agents/patesi.md` (replaced by `agent.md` + `system.md` at repo root)
- `patesi.md` monolith (replaced by `agent.md` + `system.md`)
- `prompts/` directory (merged into `system.md`)
- `workflows/` directory (merged into `system.md`)
- `knowledge/` directory (redundant with skills)
- Old `.github/copilot-instructions.md` (replaced by `adapters/copilot/copilot-instructions.md`)
- All Shagaluf references (personal project removed from agent scope)

---

## [1.0.0] - 2026-07-14

### Added

#### Agent
- SDET agent `patesi` with ISTQB-aligned QA methodology
- Direct, no-BS writing style without profanity
- Case awareness: mandatory happy/unhappy/corner case coverage
- Risk and coverage orientation: explicit metrics in every proposal
- Best practices backing: ISTQB/industry/rationale required for every recommendation
- Company quality protocol support (placeholder for future integration)
- Multi-project support via global skills + per-project overrides

#### Skills (9 total)
- **sdet-istqb**: ISTQB Foundation v4.0 + Advanced Core condensed reference
- **sdet-test-strategy**: Test strategy generator from user stories with 9-section template
- **sdet-risk-analysis**: Weighted risk matrix (Business 30%, Complexity 25%, Change 20%, Gap 15%, Dependency 10%)
- **sdet-test-cases**: Structured test case generator with TC-XXX format, priority P1-P4
- **sdet-test-classification**: S/M/L/XL test suite classifier for CI/CD integration
- **sdet-automation**: Playwright + TypeScript framework generator with Page Object Model
- **sdet-cicd**: CI/CD pipeline generator (GitHub Actions, GitLab CI, Jenkins)
- **sdet-mr-analysis**: Merge request analyzer for test impact and breakage potential
- **sdet-project-learning**: Per-project QA pattern learning via Engram persistent memory

#### Scripts
- `install.ps1`: Windows installer
- `install.sh`: Linux/macOS installer
- `update.ps1`: Windows updater (git pull + copy)
- `update.sh`: Linux/macOS updater (git pull + copy)

#### Documentation
- README in Spanish (castellano) with full installation and usage guide
- Example `opencode.json` configuration
- ISTQB syllabi download links
- Apache 2.0 License

### Decisions
- Agent named "Patesi" (not "sdet") to avoid confusion with file-based auto-discovery
- Agent file named `patesi.md` (not `sdet.md`) for clean opencode agent list
- Skills use `sdet-` prefix for namespace consistency
- ISTQB knowledge condensed inline (under 4K tokens) for context efficiency
- File-based agent (in `agents/` directory) for maintainability over inline config

---

## How to Update

**Windows:**
```powershell
.\scripts\update.ps1
```

**Linux/macOS:**
```bash
bash scripts/update.sh
```

Then restart opencode.
