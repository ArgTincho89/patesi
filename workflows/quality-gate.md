# Workflow: Quality Gate Evaluation

This workflow defines how Patesi evaluates quality gates for Seidor projects.

---

## Triggers

- User asks "Are we ready for production?"
- User asks "Evaluate the quality gate"
- User asks "Can we pass QG{N}?"
- Reaching a gate milestone in the project

---

## Flow (Mode A — Seidor)

```
START (gate evaluation)
  │
  ├─► Identify which gate (QG0-QG7)
  │
  ├─► Load SQEM gate requirements
  │     ├─► sdet-sqem-gates (gate criteria)
  │     └─► sdet-sqem-controls (control requirements)
  │
  ├─► For each control in the gate:
  │     │
  │     ├─► Check: Is the control applicable? (tipologia matrix)
  │     │     ├─ N/A → Record as N/A with justification
  │     │     └─ Applicable → Continue
  │     │
  │     ├─► Check: Is there evidence?
  │     │     ├─ NO → Mark as FAIL
  │     │     └─ YES → Continue
  │     │
  │     ├─► Check: Does evidence meet NAQ threshold?
  │     │     ├─ NO → Mark as FAIL (or WARNING with mitigation plan)
  │     │     └─ YES → Mark as PASS
  │     │
  │     └─► Record decision with evidence reference
  │
  ├─► Compile gate assessment
  │     │
  │     ├─► Count: PASS / WARNING / FAIL / N/A
  │     ├─► Check: Any non-excepcionable FAIL? → HARD BLOCK
  │     ├─► Check: 0 blocking/critical defects? (nucleo comun)
  │     └─► Check: Go/No-Go decision recorded?
  │
  ├─► Generate Gate Report
  │     │
  │     ├─► Gate assessment table (control | status | evidence | owner)
  │     ├─► Blocking issues (if any)
  │     ├─► Recommendations
  │     └─► Go/No-Go recommendation
  │
  └─► Present to user
        └─► "QG{N} Assessment: {PASS/WARNING/FAIL}. {summary}. {recommendation}."
```

---

## Gate Decision Rules

| Decision | Condition | Action |
|----------|-----------|--------|
| **PASS** | All controls evidence within NAQ threshold | Advance to next gate |
| **WARNING** | Partial evidence, minor deviation | Conditional advance with mitigation plan |
| **FAIL** | Absent evidence or blocker breach | Does NOT advance. Formal exception required. |
| **N/A** | Not applicable by tipologia/NAQ | Excluded from scoring, recorded |

---

## Non-Excepable Criteria (Hard Block)

These always block production, regardless of exceptions:
- Open blocking/critical defect
- Serious security/data/compliance breach
- Minimum test evidence unavailable
- Mandatory rollback not defined (NAQ Alto)
- High risk without mitigation or formal acceptance

---

## Rules

1. ALWAYS reference the specific SQEM section for each control evaluation
2. NEVER mark a FAIL as PASS — integrity is non-negotiable
3. ALWAYS include evidence references (file paths, test reports, screenshots)
4. ALWAYS check nucleo comun (9 items) regardless of gate
5. If the user wants to proceed with a FAIL, require formal exception (SQEM section 8)
6. Generate the report in a format suitable for archival
