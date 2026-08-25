# Patesi — opencode Adapter

Use this adapter to compose the system prompt for opencode.

```json
{
  "agent": {
    "patesi": {
      "description": "Patesi — SDET AI Agent",
      "mode": "primary",
      "prompt": "{file:./agent.md}\n\n---\n\n{file:./system.md}",
      "tools": { "edit": true, "write": true }
    }
  }
}
```

## What this adapter does

1. Loads `agent.md` (identity, personality, core principles)
2. Loads `system.md` (behavioral rules, session protocol, framework hierarchy)
3. Skills are auto-discovered from `skills/` directory and loaded on-demand via the `skill` tool

## Installation

### Option A — Script (recommended)

```bash
# Linux/macOS
bash scripts/install.sh

# Windows
.\scripts\install.ps1
```

This copies the agent and all 13 skills to `~/.config/opencode/`. Then restart opencode and switch to patesi with **Tab** or `@patesi`.

### Option B — Manual

1. Copy `agent.md` to `~/.config/opencode/agents/patesi.md`
2. Copy `system.md` to `~/.config/opencode/agents/system.md` (same directory)
3. Copy all `skills/sdet-*/` directories to `~/.config/opencode/skills/`
4. Add to your `opencode.json`:

```json
{
  "agent": {
    "patesi": {
      "description": "Patesi — SDET AI Agent",
      "mode": "primary",
      "prompt": "{file:./agents/patesi.md}\n\n---\n\n{file:./agents/system.md}",
      "tools": { "edit": true, "write": true }
    }
  }
}
```

5. Restart opencode.

## Skills

Skills are loaded on-demand when the user's request matches a skill trigger. See `config.yaml` for the full skill registry.

### When to load skills

- User asks about ISTQB → `sdet-istqb`
- User asks about test strategy → `sdet-test-strategy`
- User asks for risk analysis → `sdet-risk-analysis`
- User asks to generate test cases → `sdet-test-cases`
- User asks to classify tests → `sdet-test-classification`
- User asks for Playwright/automation → `sdet-automation`
- User asks for CI/CD pipelines → `sdet-cicd`
- User asks to analyze an MR/PR → `sdet-mr-analysis`
- User asks to learn from project → `sdet-project-learning`
- Seidor project + need NAQ/classification → `sdet-sqem-classification`
- Seidor project + need gates → `sdet-sqem-gates`
- Seidor project + need controls/thresholds → `sdet-sqem-controls`
- Seidor project + AI/ML/GenAI → `sdet-sqem-ia`
