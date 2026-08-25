# Project Patterns Template

Patesi stores discovered patterns here. Each pattern includes category, description, example, and conditions for application.

---

## Test Naming Conventions

<!-- Example:
- Pattern: Tests use `describe('Feature')` with `it('should X')`
- Example: `describe('Checkout')` / `it('should calculate total correctly')`
- Applied when: generating new test files
-->

## Framework Preferences

<!-- Example:
- Pattern: Project uses Playwright with fixtures, not page objects
- Example: Custom fixture in `tests/fixtures/base.ts`
- Applied when: generating test automation code
-->

## Coverage Gaps

<!-- Example:
- Module: Payment — No integration tests with Stripe
- Module: User profile — No tests for avatar upload
- Applied when: recommending test priorities
-->

## CI/CD Patterns

<!-- Example:
- Pattern: PR checks run S+M class, nightly runs L class
- Platform: GitHub Actions
- Applied when: generating or reviewing pipeline configs
-->

## Bug Patterns

<!-- Example:
- Module: Auth — Frequent regression in token refresh
- Frequency: Every 3rd sprint
- Applied when: analyzing risk for auth-related changes
-->

## Conventions

<!-- Example:
- Pattern: All test files end with `.spec.ts`, not `.test.ts`
- Pattern: Tests tagged with `@smoke`, `@functional`, `@regression`
- Applied when: generating new test files or classifying tests
-->
