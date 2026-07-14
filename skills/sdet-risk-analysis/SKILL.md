---
name: sdet-risk-analysis
description: >
  Analyzes user stories, features, and code changes for testing risks using a weighted risk matrix.
  Trigger: When user asks for risk analysis, risk-based testing, user story risk assessment, or test prioritization.
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-sdet
---

# Risk Analysis Engine

Analyzes features and user stories to identify testing risks and prioritize test effort. Use this when the user needs to understand what's risky and where to focus testing.

## Risk Matrix

Score each factor from 1 (lowest) to 5 (highest):

| Factor | Weight | What It Measures | 1 | 3 | 5 |
|--------|--------|-----------------|---|---|---|
| **Business Impact** | 30% | Revenue, users, reputation if it fails | Internal tool | Customer-facing feature | Payment/auth core |
| **Technical Complexity** | 25% | Code complexity, integrations, novel tech | Simple CRUD | Multiple integrations | New algorithm, distributed |
| **Change Frequency** | 20% | How often this area changes | Stable (months) | Moderate (weeks) | Constant (daily) |
| **Test Coverage Gap** | 15% | Existing test coverage | Well tested (>80%) | Partial (40-80%) | Untested (<40%) |
| **Dependency Risk** | 10% | External dependencies, third-party | Self-contained | 1-2 dependencies | Many external deps |

## Risk Score Calculation

```
Score = (Business × 0.30) + (Complexity × 0.25) + (Change × 0.20) + (Gap × 0.15) + (Dependency × 0.10)
```

| Score Range | Risk Level | Action |
|-------------|------------|--------|
| **4.0 - 5.0** | 🔴 HIGH | Comprehensive testing required. Add integration + regression tests. Consider contract testing for dependencies. Block merge if tests missing. |
| **2.5 - 3.9** | 🟡 MEDIUM | Standard testing. Feature + regression tests. Include in CI/CD pipeline. |
| **1.0 - 2.4** | 🟢 LOW | Minimal testing. Smoke test sufficient. Automate only if repeated. |

## Output Format

```markdown
# Risk Analysis: {Feature/User Story}

## Summary

| Factor | Score (1-5) | Weight | Weighted |
|--------|-------------|--------|----------|
| Business Impact | {X} | 30% | {X × 0.30} |
| Technical Complexity | {X} | 25% | {X × 0.25} |
| Change Frequency | {X} | 20% | {X × 0.20} |
| Test Coverage Gap | {X} | 15% | {X × 0.15} |
| Dependency Risk | {X} | 10% | {X × 0.10} |
| **Total** | | | **{sum}** |

## Risk Level: {🔴 HIGH / 🟡 MEDIUM / 🟢 LOW}

## Recommended Test Approach

{Specific testing recommendations based on the risk level and factor scores}

## Key Risks Identified

| # | Risk | Factor | Severity | Mitigation |
|---|------|--------|----------|------------|
| 1 | {Risk description} | {Which factor flagged it} | High/Medium/Low | {How to mitigate} |
| 2 | {Risk description} | {Which factor flagged it} | High/Medium/Low | {How to mitigate} |

## Test Prioritization

| Priority | Test Type | Rationale |
|----------|-----------|-----------|
| P1 | {What to test first} | {Why} |
| P2 | {What to test next} | {Why} |
| P3 | {What to test if time permits} | {Why} |
```

## Example Analysis

### Input

```
Feature: Payment processing with Stripe integration
- Handles credit card payments
- Integrates with Stripe API
- Stores transaction records
- No existing test coverage (new feature)
```

### Output

```markdown
# Risk Analysis: Payment Processing

## Summary

| Factor | Score (1-5) | Weight | Weighted |
|--------|-------------|--------|----------|
| Business Impact | 5 | 30% | 1.50 |
| Technical Complexity | 4 | 25% | 1.00 |
| Change Frequency | 3 | 20% | 0.60 |
| Test Coverage Gap | 5 | 15% | 0.75 |
| Dependency Risk | 4 | 10% | 0.40 |
| **Total** | | | **4.25** |

## Risk Level: 🔴 HIGH

## Recommended Test Approach

COMPREHENSIVE TESTING REQUIRED:
1. Unit tests for payment logic (mock Stripe)
2. Integration tests with Stripe test mode
3. Contract tests for Stripe API interactions
4. E2E tests for complete payment flow
5. Error handling tests (declined cards, network failures)
6. Security tests (card data handling, PCI compliance)

BLOCK MERGE: No payment code merges without corresponding tests.

## Key Risks Identified

| # | Risk | Factor | Severity | Mitigation |
|---|------|--------|----------|------------|
| 1 | Financial loss from payment errors | Business Impact | High | Comprehensive test suite + monitoring |
| 2 | Stripe API changes break integration | Dependency Risk | High | Contract tests, pin Stripe version |
| 3 | No existing test coverage | Coverage Gap | High | Write tests before implementation (TDD) |
| 4 | Complex error handling scenarios | Technical Complexity | Medium | Map all Stripe error codes, test each |

## Test Prioritization

| Priority | Test Type | Rationale |
|----------|-----------|-----------|
| P1 | Unit tests for payment calculation | Core logic, must be correct |
| P1 | Stripe integration tests (test mode) | Critical integration point |
| P1 | Error handling (declined, timeout) | Financial impact |
| P2 | Transaction record storage | Data integrity |
| P2 | Webhook handling | asynchronous events |
| P3 | Performance under load | Payment peak times |
| P3 | Security audit | PCI compliance |
```

## Trigger Keywords

Load this skill when the user says any of:
- "risk analysis", "risk assessment", "risk-based"
- "what's risky", "where should I focus testing"
- "prioritize testing", "test prioritization"
- "analyze this user story", "analyze this feature"
- "qué riesgos tiene", "análisis de riesgos"
