# Patesi — Knowledge: ISTQB References

## ISTQB Foundation v4.0 — Key References

### Test Levels (ISTQB Foundation Syllabus v4.0 — Section 5)

| Level | What | Who |
|-------|------|-----|
| **Component/Unit** | Individual components, white-box, developer | Dev |
| **Integration** | Component interaction, interfaces, contracts | Dev/QA |
| **System** | Complete system, black-box, functional + NF | QA |
| **Acceptance** | Business validation, user scenarios | PO/Client |

### Test Types (ISTQB Foundation Syllabus v4.0 — Section 5.2)

| Type | Purpose |
|------|---------|
| **Functional** | Does the system do what it should? |
| **Non-functional** (Performance, Security, Usability, etc.) | How well does it do it? |
| **Black-box** | Tests based on specifications, no code knowledge |
| **White-box** | Tests based on code structure, coverage of paths |
| **Change-related** (Confirmation, Regression, Retest) | Testing after changes |

### Test Techniques (ISTQB Foundation Syllabus v4.0 — Section 6)

#### Specification-based (Black-box)

| Technique | How | Example |
|-----------|-----|---------|
| **Equivalence Partitioning (EP)** | Divide inputs into partitions, test one per partition | Input 1-100: test with 1, 50, 101 |
| **Boundary Value Analysis (BVA)** | Test at boundaries of partitions | Test with 0, 1, 99, 100, 101 |
| **Decision Table** | Rules from conditions + actions | Login: user+pass correct → dashboard |
| **State Transition** | States and transitions | Order: pending → paid → shipped → delivered |
| **Use Case Testing** | Flows from use cases | Login success, login failure, forgot password |

#### Structure-based (White-box)

| Technique | Coverage |
|-----------|----------|
| **Statement Coverage** | Every line executed at least once |
| **Branch Coverage** | Every decision outcome (true/false) |
| **Path Coverage** | Every possible path through the code |

#### Experience-based

| Technique | When |
|-----------|------|
| **Error Guessing** | Use experience to guess where defects hide |
| **Exploratory Testing** | Simultaneous learning, test design, and execution |
| **Checklist-based Testing** | Follow a checklist of common defects |

### ISTQB Test Design Techniques — Coverage Targets

| Technique | Minimum Coverage |
|-----------|-----------------|
| Statement coverage | >=80% for critical code |
| Branch coverage | >=70% for critical code |
| MC/DC (Modified Condition/Decision Coverage) | For safety-critical systems |

### Test Process (ISTQB Foundation Syllabus v4.0 — Section 4)

| Activity | Description |
|----------|-------------|
| **Test Planning** | Define scope, approach, resources, schedule |
| **Test Monitoring & Control** | Track progress against plan |
| **Test Analysis** | Analyze test basis, identify test conditions |
| **Test Design** | Design test cases, test data, test environment |
| **Test Implementation** | Prepare test suites, environment, data |
| **Test Execution** | Run tests, log results, report defects |
| **Test Completion** | Lessons learned, metrics, archive |

### Defect Lifecycle (ISTQB Foundation Syllabus v4.0 — Section 4.5)

```
New → Open → Fix → Retest → Closed
       ↓
     Deferred
       ↓
     Reopened (if fix fails)
```

### Traceability Matrix

| From | To |
|------|-----|
| Requirements → Test Cases | 100% of critical requirements covered |
| Test Cases → Defects | Every defect traced to failing test |
| Defects → Requirements | Every defect traced to requirement |

---

## ISTQB Advanced Core — Key References

### Test Management (Advanced Syllabus — Module 2)

| Concept | Description |
|---------|-------------|
| **Test Policy** | Organization-level statement of testing goals |
| **Test Strategy** | Project-level approach, scope, techniques |
| **Test Plan** | Detailed plan for a specific test level |
| **Risk-based Test Management** | Use risk to prioritize test effort |
| **Defect Taxonomy** | Classification of defect types for analysis |
| **Test Metrics** | KPIs: pass rate, defect density, coverage, DDE, DER |

### Test Automation (Advanced Syllabus — Module 4)

| Concept | Description |
|---------|-------------|
| **Automation Pyramid** | Many unit > fewer API > fewest UI tests |
| **ROI of Automation** | Calculate: (manual cost x frequency) vs automation cost |
| **Framework Selection** | Based on: tech stack, team skill, maintenance cost |
| **Automation Anti-patterns** | Testing UI for business logic, ignoring test data, brittle locators |

### Risk-based Testing (Advanced Syllabus — Module 2)

| Risk Factor | Weight in Patesi |
|-------------|-----------------|
| Business impact | 30% |
| Technical complexity | 25% |
| Change frequency | 20% |
| Knowledge gap | 15% |
| Dependencies | 10% |

---

## Industry Standards Referenced

| Standard | When Patesi Uses It |
|----------|-------------------|
| **ISTQB Foundation v4.0** | Terminology, test levels, techniques |
| **ISTQB Advanced Core** | Test management, risk, automation |
| **ISO/IEC 25010** | SQEM quality model (8 characteristics) |
| **OWASP Top 10** | Security testing guidance |
| **WCAG 2.1** | Accessibility testing (web projects) |

---

## Key Metrics Reference

| Metric | Definition | Target |
|--------|-----------|--------|
| **DDE** (Defect Detection Effectiveness) | Defects found in testing / total defects found | >=88% Bajo, >=92% Medio, >=95% Alto |
| **DER** (Defect Escape Rate) | Defects found in production / total defects | <=12% Bajo, <=8% Medio, <=5% Alto |
| **Test Coverage** | Requirements with test cases / total requirements | 100% critical, >=80% overall |
| **Code Coverage** | Lines/branches covered by tests / total | Varies by NAQ (see SQEM controls) |
| **Automation Rate** | Automated tests / total tests | >=70% regression in CI/CD |
| **Defect Density** | Defects / KLOC (thousand lines of code) | Context-dependent |
