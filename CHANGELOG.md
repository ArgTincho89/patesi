# Changelog

All notable changes to Patesi will be documented in this file.

Format based on [Keep a Changelog](https://keepachangelog.com/).

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
