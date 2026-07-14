---
name: sdet-test-strategy
description: >
  Generates test strategies and test plans from user stories, requirements, or project context.
  Trigger: When user asks to create a test strategy, test plan, quality strategy, or testing approach.
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-sdet
---

# Test Strategy Generator

Creates comprehensive test strategies aligned with ISTQB methodology. Use this when the user needs to define how testing will be approached for a feature, sprint, or project.

## Input

The user may provide:
- **User stories** with acceptance criteria
- **Requirements documents**
- **Feature descriptions**
- **Project context** (tech stack, team, constraints)

If the user provides only a feature name or brief description, ask clarifying questions about scope, constraints, and risk tolerance before generating.

## Output Template

Generate the test strategy with ALL of the following sections:

```markdown
# Test Strategy: {Feature/Project Name}

## 1. Scope

### In Scope
- {List what will be tested}

### Out of Scope
- {List what will NOT be tested and why}

## 2. Test Levels

| Level | Applied | Rationale |
|-------|---------|-----------|
| Component | ✅/❌ | {Why or why not} |
| Integration | ✅/❌ | {Why or why not} |
| System | ✅/❌ | {Why or why not} |
| Acceptance | ✅/❌ | {Why or why not} |

## 3. Test Types

| Type | Applied | Rationale |
|------|---------|-----------|
| Functional | ✅/❌ | {Why or why not} |
| Non-functional (Performance) | ✅/❌ | {Why or why not} |
| Non-functional (Security) | ✅/❌ | {Why or why not} |
| Non-functional (Usability) | ✅/❌ | {Why or why not} |
| Structural | ✅/❌ | {Why or why not} |
| Regression | ✅/❌ | {Why or why not} |

## 4. Risk-Based Prioritization

| Risk Area | Level | Impact | Test Focus |
|-----------|-------|--------|------------|
| {Area 1} | High/Medium/Low | {What happens if it fails} | {What to test} |
| {Area 2} | High/Medium/Low | {What happens if it fails} | {What to test} |
| {Area 3} | High/Medium/Low | {What happens if it fails} | {What to test} |

## 5. Entry and Exit Criteria

### Entry Criteria
- [ ] Requirements are documented and reviewed
- [ ] Test environment is set up and verified
- [ ] Test data is prepared
- [ ] Build is deployed to test environment
- [ ] Smoke tests pass

### Exit Criteria
- [ ] All planned test cases executed
- [ ] P1/P2 defects resolved or accepted as known issues
- [ ] P3/P4 defects documented for future sprints
- [ ] Code coverage meets minimum threshold ({X}%)
- [ ] Test summary report generated

## 6. Test Environment Requirements

| Environment | Purpose | Configuration |
|-------------|---------|---------------|
| Development | Unit/component testing | Local machine |
| QA/Staging | System/acceptance testing | Mirror of production |
| Performance | Load/stress testing | Dedicated performance environment |

## 7. Automation Strategy

| Area | Automate? | Framework | Priority |
|------|-----------|-----------|----------|
| {Feature area 1} | Yes/No | {Framework} | High/Medium/Low |
| {Feature area 2} | Yes/No | {Framework} | High/Medium/Low |

### Automation Decision Criteria
- **Automate**: Repetitive tests, regression suite, data-driven tests, smoke tests
- **Manual only**: Exploratory testing, usability testing, ad-hoc testing, one-time tests

## 8. Roles and Responsibilities

| Role | Responsibility |
|------|---------------|
| {Role 1} | {What they do} |
| {Role 2} | {What they do} |

## 9. Risks and Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| {Risk 1} | High/Medium/Low | High/Medium/Low | {How to handle} |
| {Risk 2} | High/Medium/Low | High/Medium/Low | {How to handle} |
```

## Example Input

```
User story: As a registered user, I want to reset my password via email
so that I can regain access to my account if I forget my password.

Acceptance criteria:
- User can request password reset from login page
- System sends reset link via email within 5 minutes
- Reset link expires after 24 hours
- New password must meet security requirements
- User receives confirmation after successful reset
```

## Example Output

```markdown
# Test Strategy: Password Reset

## 1. Scope

### In Scope
- Password reset request flow (email submission)
- Email delivery and reset link generation
- Reset link validation and expiration
- Password update with validation
- Confirmation messaging
- Security considerations (link uniqueness, rate limiting)

### Out of Scope
- Login functionality (existing, already tested)
- Account creation flow
- Email template design (covered by design review)
- Third-party email service internals

## 2. Test Levels

| Level | Applied | Rationale |
|-------|---------|-----------|
| Component | ✅ | Test password validation logic, token generation |
| Integration | ✅ | Test email service integration, database operations |
| System | ✅ | End-to-end reset flow across UI, API, email |
| Acceptance | ✅ | User story acceptance criteria validation |

## 3. Test Types

| Type | Applied | Rationale |
|------|---------|-----------|
| Functional | ✅ | Core reset functionality |
| Security | ✅ | Token security, rate limiting, brute force protection |
| Usability | ✅ | Reset form clarity, email content |
| Performance | ❌ | Low-volume feature, not performance-critical |
| Regression | ✅ | Ensure reset doesn't break login |

## 4. Risk-Based Prioritization

| Risk Area | Level | Impact | Test Focus |
|-----------|-------|--------|------------|
| Security (token) | High | Account compromise if tokens weak | Token uniqueness, expiration, single-use |
| Email delivery | Medium | Users can't reset if email fails | Delivery confirmation, retry logic |
| Password validation | Medium | Weak passwords accepted | Complexity rules, common password check |
| Link expiration | Low | Old links usable | 24-hour expiration enforcement |

## 5. Entry and Exit Criteria

### Entry Criteria
- [ ] Password reset API endpoint implemented
- [ ] Email service configured and accessible
- [ ] QA environment with email testing (e.g., Mailhog)
- [ ] Test accounts with valid emails available

### Exit Criteria
- [ ] All P1/P2 test cases pass
- [ ] No open critical security defects
- [ ] Token expiration verified
- [ ] Rate limiting verified (max 3 requests/hour)
- [ ] Test summary report generated

## 6. Test Environment Requirements

| Environment | Purpose | Configuration |
|-------------|---------|---------------|
| QA | Functional testing | App + Mailhog (email capture) |
| Security | Token testing | App + database access for token inspection |

## 7. Automation Strategy

| Area | Automate? | Framework | Priority |
|------|-----------|-----------|----------|
| Happy path reset flow | Yes | Playwright + TS | High |
| Password validation rules | Yes | Jest unit tests | High |
| Token expiration | Yes | API tests | Medium |
| Email delivery | Semi | Mailhog API checks | Medium |
| Usability testing | No | Manual only | - |

## 8. Roles and Responsibilities

| Role | Responsibility |
|------|---------------|
| QA Engineer | Design and execute test cases, automate regression |
| Developer | Fix defects, review security aspects |
| Product Owner | Accept/reject story, clarify requirements |

## 9. Risks and Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Email service unreliable in QA | Medium | Can't test email flow | Use Mailhog/local SMTP, mock if needed |
| Token timing issues in tests | High | Flaky tests | Use deterministic time in tests |
| Security vulnerability undetected | Medium | Production risk | Include security checklist, OWASP Top 10 review |
```
