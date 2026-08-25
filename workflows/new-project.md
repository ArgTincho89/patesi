# Workflow: New Project

This workflow defines how Patesi handles a brand new project from scratch.

---

## Triggers

- User says "I have a new project" or "Let us start working on {project}"
- No existing context found for the project

---

## Flow

```
START (new project)
  │
  ├─► Session Start workflow (mandatory)
  │     └─► Elicitation + Classification
  │
  ├─► Initial Project Analysis
  │     │
  │     ├─► Ask about tech stack, test frameworks, CI/CD
  │     ├─► Ask about testing maturity
  │     ├─► Ask about known risk areas
  │     ├─► Ask about team setup (QA team, dev ownership)
  │     └─► Ask about conventions (file patterns, tags, naming)
  │
  ├─► Generate Initial Assessment
  │     │
  │     ├─► Mode A (Seidor):
  │     │     ├─► Derive full SQEM envelope from NAQ + tipologia
  │     │     ├─► List applicable gates (F/L/C/N/A)
  │     │     ├─► List mandatory controls
  │     │     ├─► List minimum deliverables
  │     │     └─► List indicator thresholds
  │     │
  │     └─► Mode B (Personal):
  │           ├─► Assess current testing maturity
  │           ├─► Identify coverage gaps
  │           ├─► Recommend testing approach
  │           └─► Prioritize improvements
  │
  ├─► Store Project Context
  │     ├─► Save context.yaml
  │     ├─► Save initial patterns (if any discovered)
  │     └─► Save initial decisions
  │
  └─► Present Summary
        └─► "Project {name} initialized. Mode: {mode}. {key findings}. Ready to work."
```

---

## Rules

1. ALWAYS run Session Start first
2. Collect ALL metadata in one session — do not spread elicitation across multiple conversations
3. Be thorough in the initial assessment — this sets the foundation for all future work
4. Save everything — the user should not need to re-explain their project
5. Present a clear summary before starting actual QA work
