---
name: sdet-test-classification
description: >
  Classifies test cases into S/M/L/XL suites for CI/CD integration and test organization.
  Trigger: When user asks to classify tests, organize test suites, determine test execution strategy, or set up test tiers.
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-sdet
---

# Test Suite Classifier

Classifies test cases into size-based suites for optimized CI/CD execution. Use this when the user needs to organize tests for pipeline integration or determine what runs when.

## Classification Taxonomy

| Class | Name | Scope | Execution Time | When to Run |
|-------|------|-------|---------------|-------------|
| **S** | Smoke | Core functionality, critical path | < 5 min | Every commit, every deploy |
| **M** | Functional | Feature-level tests | 5-30 min | Every PR, pre-merge |
| **L** | Regression | Full feature + integration | 30-120 min | Release candidates, nightly |
| **XL** | Full Regression | Complete system, end-to-end | 2+ hours | Major releases, quarterly |

## Classification Criteria

### S (Smoke) Tests

**What**: The absolute minimum to verify the system isn't broken.

**Criteria**:
- Critical path (login, core navigation, key transactions)
- Takes < 5 minutes total
- Must pass before ANY deployment
- Fail = system is down

**Examples**:
- User can log in
- Homepage loads
- API health check passes
- Database connection works

### M (Functional) Tests

**What**: Feature-level tests covering specific user stories or requirements.

**Criteria**:
- Covers individual features end-to-end
- Takes 5-30 minutes total
- Runs on every PR to catch regressions early
- Fail = feature is broken

**Examples**:
- User can complete registration flow
- Search returns correct results
- Shopping cart calculations are correct
- Email notifications send successfully

### L (Regression) Tests

**What**: Comprehensive tests covering multiple features and their interactions.

**Criteria**:
- Cross-feature integration tests
- Takes 30-120 minutes total
- Runs on release candidates and nightly builds
- Fail = regression detected

**Examples**:
- Full checkout flow with payment
- User management (CRUD + permissions)
- Data export/import across modules
- Third-party integrations

### XL (Full Regression) Tests

**What**: Complete system test including all features, edge cases, and non-functional tests.

**Criteria**:
- Everything in S + M + L
- Plus performance, security, accessibility
- Takes 2+ hours total
- Runs before major releases

**Examples**:
- Complete application walkthrough
- Performance benchmarks
- Security scan
- Accessibility audit

## Classification Output Format

```markdown
# Test Classification: {Feature/Project}

## Summary

| Class | Count | Est. Time | Trigger | Purpose |
|-------|-------|-----------|---------|---------|
| S | {N} | {X} min | Every commit | Critical path verification |
| M | {N} | {X} min | Every PR | Feature-level testing |
| L | {N} | {X} min | Release candidate | Regression detection |
| XL | {N} | {X} min | Major release | Full system validation |

## S Tests (Smoke)
- {TC-XXX}: {Title}
- {TC-XXX}: {Title}

## M Tests (Functional)
- {TC-XXX}: {Title}
- {TC-XXX}: {Title}

## L Tests (Regression)
- {TC-XXX}: {Title}
- {TC-XXX}: {Title}

## XL Tests (Full Regression)
- {TC-XXX}: {Title}
- {TC-XXX}: {Title}

## CI/CD Integration

| Pipeline Stage | Tests | Timeout | On Failure |
|---------------|-------|---------|------------|
| Pre-commit | S | 5 min | Block commit |
| PR validation | S + M | 30 min | Block merge |
| Release candidate | S + M + L | 2 hours | Block release |
| Major release | S + M + L + XL | 4 hours | Manual review |
```

## Classification Heuristics

When classifying a test case, consider:

1. **Is it on the critical path?** → S (if yes and fast enough)
2. **Does it test a specific feature?** → M
3. **Does it cross feature boundaries?** → L
4. **Is it comprehensive/system-wide?** → XL
5. **How long does it take?** → Adjust class if time doesn't fit
6. **How often does it fail?** → Frequently failing tests should be S or M (catch early)

## Example Input

```
Test cases for an e-commerce checkout:
- TC-001: User can view cart (P1)
- TC-002: Cart total calculates correctly (P1)
- TC-003: User can apply discount code (P2)
- TC-004: User can enter shipping address (P1)
- TC-005: User can select shipping method (P2)
- TC-006: Payment processing with valid card (P1)
- TC-007: Payment declined handling (P1)
- TC-008: Order confirmation email sends (P2)
- TC-009: Inventory decreases after purchase (P2)
- TC-010: Full checkout flow E2E (P1)
- TC-011: Checkout with multiple items (P2)
- TC-012: Checkout performance under load (P3)
```

## Example Output

```markdown
# Test Classification: E-Commerce Checkout

## Summary

| Class | Count | Est. Time | Trigger | Purpose |
|-------|-------|-----------|---------|---------|
| S | 2 | 2 min | Every commit | Cart loads, payment works |
| M | 6 | 12 min | Every PR | Feature-level checkout |
| L | 3 | 25 min | Release candidate | Integration flows |
| XL | 1 | 45 min | Major release | Full E2E + performance |

## S Tests (Smoke)
- TC-001: User can view cart
- TC-006: Payment processing with valid card

## M Tests (Functional)
- TC-002: Cart total calculates correctly
- TC-004: User can enter shipping address
- TC-005: User can select shipping method
- TC-007: Payment declined handling
- TC-011: Checkout with multiple items
- TC-008: Order confirmation email sends

## L Tests (Regression)
- TC-003: User can apply discount code
- TC-009: Inventory decreases after purchase
- TC-010: Full checkout flow E2E

## XL Tests (Full Regression)
- TC-012: Checkout performance under load

## CI/CD Integration

| Pipeline Stage | Tests | Timeout | On Failure |
|---------------|-------|---------|------------|
| Pre-commit | S (TC-001, TC-006) | 5 min | Block commit |
| PR validation | S + M (8 tests) | 15 min | Block merge |
| Release candidate | S + M + L (11 tests) | 45 min | Block release |
| Major release | All (12 tests) | 60 min | Manual review |
```

## Trigger Keywords

Load this skill when the user says any of:
- "classify tests", "test classification", "test suites"
- "S/M/L/XL", "smoke tests", "regression tests"
- "CI/CD test strategy", "what tests run when"
- "organize tests", "test tiers", "test pyramid"
- "clasificar tests", "suites de testing"
