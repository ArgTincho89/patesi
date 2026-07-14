---
name: sdet-mr-analysis
description: >
  Analyzes merge requests and pull requests for test impact and breakage potential.
  Trigger: When user asks to analyze MR, PR, merge request, pull request, code review for testing, or test impact analysis.
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-sdet
---

# Merge Request Analyzer

Analyzes merge requests/PRs and identifies potential test impact, breakage risk, and recommended actions. Use this when the user wants to understand what tests to run or what might break from a code change.

## Analysis Output

The analysis MUST produce:

1. **Changed Files Summary** — List of modified files with change type (added/modified/deleted)
2. **Impact Assessment** — Which existing tests might be affected
3. **Risk Level** — Low/Medium/High based on change scope and location
4. **Recommended Tests** — Which test classes to run for validation
5. **Missing Coverage** — Areas changed but not covered by existing tests

## Output Format

```markdown
# MR Analysis: {MR/PR Title}

## Summary

| Metric | Value |
|--------|-------|
| Files changed | {N} |
| Lines added | {N} |
| Lines deleted | {N} |
| Risk level | {🟢 Low / 🟡 Medium / 🔴 High} |

## Changed Files

| File | Change Type | Impact Area | Risk |
|------|------------|-------------|------|
| {path} | Added/Modified/Deleted | {Module/Feature} | High/Medium/Low |

## Impact Assessment

### Affected Modules
- **{Module 1}**: {How it's affected}
- **{Module 2}**: {How it's affected}

### Affected Test Files
| Test File | Status | Reason |
|-----------|--------|--------|
| {test file} | May need update | {Why} |
| {test file} | No impact | {Why} |

## Risk Analysis

| Risk Factor | Score | Justification |
|-------------|-------|---------------|
| Change scope | {1-5} | {N} files changed |
| Critical path impact | {1-5} | {Affects login/payment/etc.} |
| Test coverage | {1-5} | {X}% of changed code has tests |
| Dependency impact | {1-5} | {Number of dependent modules} |

**Overall Risk: {🔴 HIGH / 🟡 MEDIUM / 🟢 LOW}**

## Recommended Tests

### Must Run (Before Merge)
- {TC-XXX}: {Test name} — {Why}

### Should Run (Before Deploy)
- {TC-XXX}: {Test name} — {Why}

### Consider Running
- {TC-XXX}: {Test name} — {Why}

## Missing Coverage

| Changed Area | Has Tests? | Recommendation |
|-------------|------------|----------------|
| {File/Function} | ❌ No | Add tests before merge |
| {File/Function} | ⚠️ Partial | Expand test coverage |
| {File/Function} | ✅ Yes | Verify tests pass |

## Recommendations

1. **{Action 1}**: {Specific recommendation}
2. **{Action 2}**: {Specific recommendation}
3. **{Action 3}**: {Specific recommendation}
```

## Risk Level Determination

| Factor | Low (1) | Medium (3) | High (5) |
|--------|---------|------------|----------|
| Files changed | 1-3 | 4-10 | 10+ |
| Critical path | No | Indirect | Direct (auth, payment, data) |
| Test coverage | >80% | 40-80% | <40% |
| Dependencies | None | 1-2 modules | 3+ modules |

**Score calculation**: Average of all factors
- 1.0 - 2.0: 🟢 LOW
- 2.1 - 3.5: 🟡 MEDIUM
- 3.6 - 5.0: 🔴 HIGH

## Example Analysis

### Input

```
MR: "Refactor user authentication to use JWT tokens"
Files changed:
- src/auth/login.ts (modified)
- src/auth/token.ts (new)
- src/auth/middleware.ts (modified)
- src/routes/api.ts (modified)
- tests/auth/login.test.ts (modified)
```

### Output

```markdown
# MR Analysis: Refactor user authentication to use JWT tokens

## Summary

| Metric | Value |
|--------|-------|
| Files changed | 5 |
| Lines added | ~200 |
| Lines deleted | ~80 |
| Risk level | 🔴 High |

## Changed Files

| File | Change Type | Impact Area | Risk |
|------|------------|-------------|------|
| src/auth/login.ts | Modified | Authentication | High |
| src/auth/token.ts | Added | Authentication | High |
| src/auth/middleware.ts | Modified | Auth middleware | High |
| src/routes/api.ts | Modified | API routing | Medium |
| tests/auth/login.test.ts | Modified | Auth tests | Medium |

## Impact Assessment

### Affected Modules
- **Authentication**: Core login flow refactored — all auth tests must pass
- **API Routes**: Middleware changes affect ALL protected routes
- **Session Management**: Token-based auth replaces session-based

### Affected Test Files
| Test File | Status | Reason |
|-----------|--------|--------|
| tests/auth/login.test.ts | Updated | Must verify new JWT flow |
| tests/auth/middleware.test.ts | Needs update | Middleware behavior changed |
| tests/routes/api.test.ts | May need update | Protected routes use new middleware |

## Risk Analysis

| Risk Factor | Score | Justification |
|-------------|-------|---------------|
| Change scope | 4 | 5 files, core auth module |
| Critical path impact | 5 | Authentication is critical path |
| Test coverage | 3 | Auth tests exist but middleware untested |
| Dependency impact | 4 | ALL protected routes depend on auth |

**Overall Risk: 🔴 HIGH**

## Recommended Tests

### Must Run (Before Merge)
- TC-AUTH-001: Login with valid credentials — Verify JWT token generation
- TC-AUTH-002: Login with invalid credentials — Verify error handling
- TC-AUTH-003: Token expiration — Verify expired tokens are rejected
- TC-AUTH-004: Protected route access — Verify middleware works with JWT

### Should Run (Before Deploy)
- TC-AUTH-005: Token refresh flow — Verify seamless token renewal
- TC-API-001: All API endpoints with authentication — Verify no regression

### Consider Running
- TC-PERF-001: Login performance — JWT may be faster/slower than sessions

## Missing Coverage

| Changed Area | Has Tests? | Recommendation |
|-------------|------------|----------------|
| src/auth/token.ts | ❌ No (new file) | MUST add tests before merge |
| src/auth/middleware.ts | ⚠️ Partial | Expand tests for edge cases |
| src/auth/login.test.ts | ✅ Yes | Verify all scenarios still pass |

## Recommendations

1. **BLOCK MERGE**: New file `src/auth/token.ts` has no tests — add unit tests
2. **ADD TESTS**: JWT token validation edge cases (expired, malformed, missing)
3. **INTEGRATION TESTS**: Test full auth flow with real API calls
4. **PERFORMANCE**: Benchmark JWT vs session auth before/after
5. **SECURITY REVIEW**: JWT implementation should be reviewed for security best practices
```

## Trigger Keywords

Load this skill when the user says any of:
- "MR analysis", "PR analysis", "merge request review"
- "pull request review", "code review for testing"
- "what might break", "test impact analysis"
- "análisis de MR", "revisión de PR"
