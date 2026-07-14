---
name: sdet-istqb
description: >
  ISTQB Foundation and Advanced Core knowledge reference.
  Trigger: When user asks about ISTQB terminology, test levels, test types, test techniques, certification, or testing standards.
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-sdet
---

# ISTQB Knowledge Reference

Condensed reference from ISTQB Foundation Level v4.0 and Advanced Core syllabi. Use this to answer questions about testing methodology, terminology, and techniques.

## Test Process

The ISTQB test process consists of test planning, monitoring, control, analysis, design, implementation, execution, and completion activities. These are iterative and can overlap.

| Activity | Purpose | Key Outputs |
|----------|---------|-------------|
| **Planning** | Define scope, approach, resources | Test plan, entry/exit criteria |
| **Monitoring** | Track progress against plan | Status reports, metrics |
| **Control** | Take corrective action | Rework, re-prioritization |
| **Analysis** | Understand what to test | Test conditions, requirements |
| **Design** | Determine how to test | Test cases, test procedures |
| **Implementation** | Prepare for execution | Test scripts, test data, environment |
| **Execution** | Run tests and record results | Test results, defects |
| **Completion** | Finalize and lessons learned | Summary reports, closure |

## Test Levels

| Level | Scope | Who Tests | Typical Activities |
|-------|-------|-----------|-------------------|
| **Component** | Individual software component/module | Developers | Unit tests, component integration tests |
| **Integration** | Interactions between integrated components | Developers + Testers | API tests, interface tests, contract tests |
| **System** | Complete integrated system | Testers | End-to-end tests, functional tests, system tests |
| **Acceptance** | System against business requirements | Users + Testers | UAT, alpha/beta testing, acceptance tests |

## Test Types

| Type | What It Tests | Examples |
|------|--------------|----------|
| **Functional** | What the system does | Login, search, checkout, calculations |
| **Non-functional** | How well the system performs | Performance, security, usability, reliability |
| **Structural** | Internal code structure | Code coverage, path testing, branch testing |
| **Change-related** | Impact of changes | Regression, confirmation, confirmation testing |

## Black-Box Techniques

### Equivalence Partitioning (EP)

Divide input data into partitions where all values in a partition are treated equivalently by the system.

**Example**: Age field accepting 18-65
- Invalid: < 18 (partition 1)
- Valid: 18-65 (partition 2)
- Invalid: > 65 (partition 3)

### Boundary Value Analysis (BVA)

Test at boundaries between partitions, where defects cluster.

**Example**: Age field accepting 18-65
- Test values: 17, 18, 19, 64, 65, 66
- For multi-dimensional: test combinations at boundaries

### Decision Tables

Model business rules with conditions and actions.

| Rule | R1 | R2 | R3 | R4 |
|------|----|----|----|----|
| **Condition 1**: VIP customer | Y | Y | N | N |
| **Condition 2**: Order > $100 | Y | N | Y | N |
| **Action**: Discount | 20% | 10% | 5% | 0% |

### State Transition Testing

Model system behavior as states with transitions triggered by events.

```
[Idle] --login--> [Authenticated] --logout--> [Idle]
[Authenticated] --timeout--> [Locked]
[Locked] --reset--> [Idle]
```

### Use Case Testing

Derive test cases from use cases or user stories. Focus on main success scenario, alternative flows, and exception flows.

## White-Box Techniques

| Technique | Coverage Criterion | What It Measures |
|-----------|-------------------|------------------|
| **Statement** | Every executable statement | Minimum coverage |
| **Decision (Branch)** | Every decision outcome (T/F) | Branch coverage |
| **MC/DC** | Each condition independently affects decision | Modified Condition/Decision Coverage |
| **Path** | Every possible execution path | Maximum coverage (often impractical) |

## Test Design Techniques

### Error Guessing

Use experience to guess where defects are most likely. Common targets:
- Boundary values
- Null/empty inputs
- Special characters
- Date transitions (month-end, year-end)
- Resource exhaustion

### Exploratory Testing

Simultaneous learning, test design, and execution. Use charters to guide exploration:
- **Explore** [feature] **with** [data/config] **to discover** [risks]

### Checklist-Based Testing

Use checklists derived from:
- Common defect categories
- Regulatory requirements
- Heuristics (e.g., FEW HICCUPPS)

## Test Automation Considerations

| Factor | Automate | Don't Automate |
|--------|----------|----------------|
| Repetitive | ✅ Yes | |
| High risk | ✅ Yes | |
| Data-driven | ✅ Yes | |
| Exploratory | | ❌ No |
| Usability | | ❌ No |
| One-time tests | | ❌ No |
| Creative/judgment | | ❌ No |

## Defect Management

| Phase | Activity |
|-------|----------|
| **Identification** | Detect and report defect |
| **Classification** | Severity, priority, type |
| **Investigation** | Root cause analysis |
| **Resolution** | Fix or workarounds |
| **Verification** | Confirm fix works |
| **Closure** | Close defect report |

### Defect Taxonomy

| Category | Examples |
|----------|----------|
| Requirements | Ambiguous, missing, contradictory |
| Architecture | Design flaws, integration issues |
| Code | Logic errors, runtime exceptions |
| Environment | Configuration, compatibility |
| Data | Corruption, format, migration |

## Test Estimation Techniques

| Technique | Description | When to Use |
|-----------|-------------|-------------|
| **Wideband Delphi** | Expert consensus through iterative estimation | Complex features, team estimation |
| **Three-point** | Optimistic + Most Likely + Pessimistic | When uncertainty is high |
| **Function Point** | Based on functional complexity | Large systems, historical data available |
| **Use Case Points** | Derived from use case complexity | Use case-driven projects |
| **Story Points** | Agile estimation (relative sizing) | Agile teams with velocity data |
