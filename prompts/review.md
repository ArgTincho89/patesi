# Review Prompt

Use this prompt when Patesi needs to review its own output before presenting it to the user.

---

## Self-Review Checklist

Before presenting any deliverable, verify:

### Completeness

- [ ] All required sections are present
- [ ] No section is empty or placeholder-only
- [ ] Templates are filled with actual content, not just field names

### Accuracy

- [ ] ISTQB terminology is used correctly
- [ ] SQEM citations reference the correct section numbers (Mode A)
- [ ] Risk scores are calculated correctly
- [ ] Priority assignments (P1-P4) are justified

### Coverage

- [ ] Happy path, unhappy path, AND corner cases are all covered
- [ ] Coverage analysis is present with percentages
- [ ] Coverage gaps are explicitly listed with rationale
- [ ] No important scenario is silently omitted

### Consistency

- [ ] Terminology is consistent throughout the document
- [ ] Risk levels align with the calculated scores
- [ ] Priority assignments align with the risk assessment
- [ ] Test classification aligns with the test cases

### Project Scope

- [ ] No references to other projects
- [ ] Project-specific conventions are followed (from memory)
- [ ] SQEM classification matches the project (Mode A)
- [ ] Technology references match the project stack

### Quality

- [ ] Every recommendation has a backing (ISTQB/SQEM/industry/risk)
- [ ] No vague or ungrounded advice
- [ ] Code examples are syntactically correct
- [ ] Markdown formatting is clean and readable

---

## Common Issues to Catch

1. **Happy-path-only strategies** — If the strategy only covers the golden path, flag it and add unhappy/corner cases
2. **Missing exit criteria** — Every strategy MUST have exit criteria
3. **No risk justification** — Every priority assignment MUST explain why
4. **SQEM deviation without exception** — If the proposal deviates from SQEM (Mode A), it MUST go through the exception protocol
5. **Scope creep** — If the output goes beyond what the user asked, trim it
6. **Project context leakage** — If patterns from another project appear, remove them

---

## When to Ask the User

Ask the user before presenting if:
- You are unsure about a risk assessment
- The SQEM classification is ambiguous
- There are multiple valid approaches with different tradeoffs
- The output is significantly different from what was expected
- You identified a gap that the user should decide on (risk acceptance)
