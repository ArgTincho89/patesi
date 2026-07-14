---
name: sdet-project-learning
description: >
  Stores and retrieves project-specific QA patterns using Engram memory.
  Trigger: When user asks to remember project patterns, learn from project, store QA conventions, or recall past testing decisions.
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-sdet
---

# Project Learning (Engram Integration)

Stores and retrieves project-specific QA patterns using Engram persistent memory. Use this when the user wants to remember conventions, learn from the project, or recall past decisions.

## Storage Format

### Pattern Categories

| Category | Example | When to Store |
|----------|---------|---------------|
| **test-naming** | "Tests use `describe('Feature')` with `it('should X')`" | After analyzing test suite |
| **framework** | "Project uses Playwright with fixtures, not page objects" | When discovering framework patterns |
| **coverage** | "Payment module has no integration tests" | When finding coverage gaps |
| **cicd** | "PR checks run S+M class, nightly runs L class" | When learning CI/CD setup |
| **bug-pattern** | "Auth module frequently has regression in token refresh" | When discovering recurring bugs |
| **convention** | "All test files end with `.spec.ts`, not `.test.ts`" | When finding naming conventions |

### Storage Command

```javascript
mem_save(
  title: "qa-patterns/{project}/{pattern-name}",
  topic_key: "qa-patterns/{project}/{pattern-name}",
  type: "pattern",
  project: "{project}",
  content: `## Pattern: {name}
## Category: {category}
## Description: {what the pattern is}
## Example: {concrete example}
## Applied When: {conditions for using this pattern}`
)
```

### Retrieval Command

```javascript
mem_search(
  query: "qa-patterns/{project}",
  project: "{project}"
)
```

## Workflow

### Learning Phase (When User Says "Learn from Project")

1. **Analyze existing test suite** — Read test files, count patterns
2. **Identify conventions** — Naming, structure, frameworks used
3. **Find gaps** — What's tested, what's not
4. **Store patterns** — Save each pattern to Engram with category tag
5. **Report findings** — Tell user what was learned

### Application Phase (When Generating Project-Specific Output)

1. **Search for patterns** — Query Engram for project patterns
2. **Apply patterns** — Follow stored conventions when generating code
3. **Report adherence** — Tell user which patterns were followed

## Example Learning Output

```markdown
# Project Learning: {Project Name}

## Analysis Complete

### Test Suite Overview
- Total test files: {N}
- Test framework: {Jest/Playwright/etc.}
- Test location: `{directory}`
- File pattern: `{pattern}`

### Patterns Discovered

| Category | Pattern | Example |
|----------|---------|---------|
| test-naming | {description} | `{example}` |
| framework | {description} | `{example}` |
| convention | {description} | `{example}` |

### Coverage Gaps Found
- {Area 1}: {What's missing}
- {Area 2}: {What's missing}

### Patterns Stored to Engram
- ✅ `qa-patterns/{project}/test-naming-convention`
- ✅ `qa-patterns/{project}/framework-preference`
- ✅ `qa-patterns/{project}/coverage-gaps`
```

## Graceful Degradation

If Engram is unavailable:
1. **Notify the user**: "Engram is not available — project patterns won't be remembered"
2. **Continue working**: All other skills function normally
3. **Offer alternatives**: Suggest the user manually note important patterns

## Example Input

```
User: "Learn from this project's test suite and remember the patterns"
```

## Example Output

```markdown
# Project Learning: E-Commerce App

## Analysis Complete

### Test Suite Overview
- Total test files: 47
- Test framework: Playwright + TypeScript
- Test location: `tests/`
- File pattern: `*.spec.ts`

### Patterns Discovered

| Category | Pattern | Example |
|----------|---------|---------|
| test-naming | Tests use `describe('Feature')` with `it('should X')` | `describe('Checkout')` / `it('should calculate total')` |
| framework | Uses Page Object Model pattern | `pages/LoginPage.ts`, `pages/CartPage.ts` |
| convention | Tests tagged with `@smoke`, `@functional`, `@regression` | `test.describe '{@smoke} Login', ...)` |
| cicd | Smoke tests run on every commit, regression on nightly | GitHub Actions workflow |

### Coverage Gaps Found
- Payment module: No integration tests with Stripe
- User profile: No tests for avatar upload
- Search: No performance tests

### Patterns Stored to Engram
- ✅ `qa-patterns/ecommerce/test-naming-convention`
- ✅ `qa-patterns/ecommerce/framework-patterns`
- ✅ `qa-patterns/ecommerce/test-tags`
- ✅ `qa-patterns/ecommerce/cicd-strategy`
- ✅ `qa-patterns/ecommerce/coverage-gaps`
```

## Trigger Keywords

Load this skill when the user says any of:
- "learn from project", "remember patterns", "project conventions"
- "store QA patterns", "recall past decisions"
- "what did we learn", "what patterns does this project use"
- "aprender del proyecto", "recordar patrones", "convenciones del proyecto"
