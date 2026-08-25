# Workflow: Session Start

This workflow defines what happens when Patesi begins a new session or conversation.

---

## Triggers

- User starts a new conversation
- User switches to a different project
- User says "let us work on {project}" or similar

---

## Flow

```
START
  │
  ├─► Check for existing project context
  │     ├─► memory/{project}/context.yaml exists?
  │     │     ├─ YES → Load context → Confirm with user → READY
  │     │     └─ NO  → Continue to elicitation
  │     │
  │     └─► Engram qa-patterns/{project}/ exists?
  │           ├─ YES → Load context → Confirm with user → READY
  │           └─ NO  → Continue to elicitation
  │
  ├─► Elicitation (if no context found)
  │     │
  │     ├─► Ask: "Is this a Seidor project, personal, or client-governed?"
  │     │     ├─ Seidor    → NAQ Classification
  │     │     ├─ Personal  → ISTQB mode → Save context → READY
  │     │     └─ Client    → Client mode → Save context → READY
  │     │
  │     └─► NAQ Classification (Seidor only)
  │           │
  │           ├─► Ask 5 NAQ factors (0-4 each)
  │           ├─► Ask primary tipologia (+ secondary if any)
  │           ├─► Calculate NAQ score
  │           ├─► Apply override rules
  │           ├─► Derive: delivery target, gates, controls, thresholds
  │           └─► Save context → READY
  │
  └─► READY
        └─► Begin QA work
```

---

## Context File Format

```yaml
# ~/.config/opencode/patesi-memory/{project}/context.yaml
project_id: string       # URL-safe identifier
name: string             # Human-readable project name
mode: seidor | personal | client
last_session: date       # ISO 8601

# Seidor-specific fields (null if personal/client)
naq: bajo | medio | alto
naq_score: float         # Calculated NAQ value
naq_factors:
  criticidad: int        # 0-4
  visibilidad: int       # 0-4
  interoperabilidad: int # 0-4
  sensibilidad: int      # 0-4
  complejidad: int       # 0-4
tipologia: string        # Primary tipologia
tipologia_secundaria: string  # Secondary (if any)
delivery_target: basico | integrado | continuo

# Project metadata
tech_stack: string
test_frameworks: string
ci_cd_platform: string
```

---

## Rules

1. NEVER skip the elicitation for a new project
2. NEVER assume the project type — always ask
3. NEVER mix contexts from different projects
4. ALWAYS persist the classification after elicitation
5. If Engram is unavailable, use file-based memory
6. If both are unavailable, warn the user and proceed without persistence
