---
name: sdet-test-cases
description: >
  Generates structured test cases with proper format, priority, and traceability.
  Trigger: When user asks to generate test cases, create test scenarios, design test cases, or write test specifications.
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-sdet
---

# Test Case Generator

Creates structured, traceable test cases following ISTQB best practices. Use this when the user needs test cases for a feature, user story, or requirement.

## Test Case Format

Every test case MUST follow this structure:

```markdown
| Field | Required | Description |
|-------|----------|-------------|
| `id` | Yes | Unique identifier (TC-XXX format) |
| `title` | Yes | Short, descriptive name |
| `priority` | Yes | P1 (critical), P2 (high), P3 (medium), P4 (low) |
| `preconditions` | Yes | What must be true before execution |
| `steps` | Yes | Ordered list of actions |
| `expected_results` | Yes | Expected outcome per step |
| `test_data` | No | Specific data values needed |
| `automation_candidate` | Yes | true/false with rationale |
| `requirements_trace` | No | Linked requirement ID |
```

## Priority Definitions

| Priority | Definition | When to Use |
|----------|------------|-------------|
| **P1** | Critical path, blocks release | Core functionality, security, data integrity |
| **P2** | High priority, should be in release | Important features, common user flows |
| **P3** | Medium priority, can defer | Edge cases, secondary features |
| **P4** | Low priority, nice to have | Cosmetic, rare scenarios |

## Test Case Generation Rules

### Happy Path (Always Include)
- At least one test case for the main success scenario
- Use valid, typical data
- Follow the expected user flow

### Negative Tests (Always Include)
- Invalid inputs (wrong type, format, range)
- Missing required fields
- Unauthorized access attempts
- Boundary violations

### Edge Cases (Include When Relevant)
- Empty inputs
- Maximum/minimum values
- Special characters
- Concurrent operations
- Network failures (for integrations)

### Data-Driven Tests (When Applicable)
- Multiple valid inputs
- Boundary values (BVA)
- Equivalence partitions

## Output Format

Generate test cases as a structured table:

```markdown
# Test Cases: {Feature Name}

## Summary

| Total | P1 | P2 | P3 | P4 | Auto Candidate |
|-------|----|----|----|----|----------------|
| {N} | {X} | {X} | {X} | {X} | {Y}/{N} |

## Test Cases

### TC-001: {Title}

- **Priority**: P{X}
- **Preconditions**: {What must be true}
- **Automation**: {true/false} — {Rationale}
- **Requirements**: {REQ-XXX}

**Steps**:
1. {Action 1}
2. {Action 2}
3. {Action 3}

**Expected Results**:
1. {Result 1}
2. {Result 2}
3. {Result 3}

**Test Data**:
- {Data item 1}: {Value}
- {Data item 2}: {Value}

---

### TC-002: {Title}
...
```

## Example Input

```
Feature: User registration with email validation

Acceptance criteria:
- User can register with email, password, and name
- Email must be valid format
- Password must be at least 8 characters with 1 uppercase, 1 number
- System sends verification email
- User cannot register with existing email
```

## Example Output

```markdown
# Test Cases: User Registration

## Summary

| Total | P1 | P2 | P3 | P4 | Auto Candidate |
|-------|----|----|----|----|----------------|
| 8 | 3 | 3 | 2 | 0 | 7/8 |

## Test Cases

### TC-001: Successful registration with valid data

- **Priority**: P1
- **Preconditions**: User does not have an existing account
- **Automation**: true — Core happy path, repeatable
- **Requirements**: REQ-REG-001

**Steps**:
1. Navigate to registration page
2. Enter valid email: "newuser@example.com"
3. Enter valid password: "SecurePass1"
4. Enter name: "Test User"
5. Click "Register" button

**Expected Results**:
1. Registration page loads correctly
2. Email field accepts input
3. Password field accepts input (masked)
4. Name field accepts input
5. System creates account, sends verification email, redirects to "Check your email" page

**Test Data**:
- Email: newuser@example.com
- Password: SecurePass1
- Name: Test User

---

### TC-002: Registration rejected - invalid email format

- **Priority**: P1
- **Preconditions**: Registration page is accessible
- **Automation**: true — Data-driven, easy to automate
- **Requirements**: REQ-REG-002

**Steps**:
1. Navigate to registration page
2. Enter email: "notanemail"
3. Enter valid password: "SecurePass1"
4. Enter name: "Test User"
5. Click "Register" button

**Expected Results**:
1. Registration page loads correctly
2. Email field accepts input
3. Password field accepts input
4. Name field accepts input
5. System shows error: "Please enter a valid email address"

---

### TC-003: Registration rejected - weak password

- **Priority**: P1
- **Preconditions**: Registration page is accessible
- **Automation**: true — Data-driven, easy to automate
- **Requirements**: REQ-REG-003

**Steps**:
1. Navigate to registration page
2. Enter valid email: "user@example.com"
3. Enter weak password: "password"
4. Enter name: "Test User"
5. Click "Register" button

**Expected Results**:
1. Registration page loads correctly
2. Email field accepts input
3. Password field accepts input
4. Name field accepts input
5. System shows error: "Password must be at least 8 characters with 1 uppercase letter and 1 number"

---

### TC-004: Registration rejected - duplicate email

- **Priority**: P2
- **Preconditions**: User "existing@example.com" already exists
- **Automation**: true — Requires test data setup
- **Requirements**: REQ-REG-004

**Steps**:
1. Navigate to registration page
2. Enter email: "existing@example.com"
3. Enter valid password: "SecurePass1"
4. Enter name: "Duplicate User"
5. Click "Register" button

**Expected Results**:
1. Registration page loads correctly
2. Email field accepts input
3. Password field accepts input
4. Name field accepts input
5. System shows error: "An account with this email already exists"

---

### TC-005: Registration with empty name field

- **Priority**: P2
- **Preconditions**: Registration page is accessible
- **Automation**: true — Edge case, easy to automate
- **Requirements**: REQ-REG-005

**Steps**:
1. Navigate to registration page
2. Enter valid email: "noname@example.com"
3. Enter valid password: "SecurePass1"
4. Leave name field empty
5. Click "Register" button

**Expected Results**:
1. Registration page loads correctly
2. Email field accepts input
3. Password field accepts input
4. Name field is empty
5. System shows error: "Name is required"

---

### TC-006: Verification email contains valid reset link

- **Priority**: P2
- **Preconditions**: User has just registered
- **Automation**: true — Requires email service mock
- **Requirements**: REQ-REG-006

**Steps**:
1. Complete successful registration (TC-001)
2. Open verification email
3. Click verification link

**Expected Results**:
1. Registration completes successfully
2. Email received within 5 minutes with subject "Verify your email"
3. Link opens page showing "Email verified successfully"

---

### TC-007: Registration with maximum length inputs

- **Priority**: P3
- **Preconditions**: Registration page is accessible
- **Automation**: true — Boundary testing
- **Requirements**: REQ-REG-007

**Steps**:
1. Navigate to registration page
2. Enter email with 254 characters (max valid email)
3. Enter password with 128 characters (max allowed)
4. Enter name with 100 characters
5. Click "Register" button

**Expected Results**:
1. Registration page loads correctly
2-4. Fields accept maximum length inputs
5. System processes registration (success or appropriate error)

---

### TC-008: Registration form retains values after validation error

- **Priority**: P3
- **Preconditions**: Registration page is accessible
- **Automation**: false — UX behavior, manual verification preferred
- **Requirements**: REQ-REG-008

**Steps**:
1. Navigate to registration page
2. Enter email: "valid@example.com"
3. Enter weak password: "123"
4. Enter name: "Test User"
5. Click "Register" button
6. Observe form after error message

**Expected Results**:
1. Registration page loads correctly
2-4. Fields accept input
5. System shows password error
6. Email and name fields retain their values (user doesn't need to re-enter)
```

## Trigger Keywords

Load this skill when the user says any of:
- "generate test cases", "create test cases", "write test cases"
- "test scenarios", "test design", "test specifications"
- "design tests for", "tests for this feature"
- "casos de prueba", "diseñar tests", "generar tests"
