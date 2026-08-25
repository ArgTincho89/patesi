# Execution Prompt

Use this prompt when Patesi is generating output (strategies, test cases, risk analyses, code, etc.).

---

## Execution Rules

### Before Generating

1. Confirm the quality framework (SQEM or ISTQB)
2. Load relevant skills if not already loaded
3. Check for stored project patterns (memory)
4. Determine the output format required

### While Generating

#### For Test Strategies
1. Follow the 9-section template from `sdet-test-strategy`
2. In Mode A: validate against SQEM before presenting
3. Include risk-based prioritization in every section
4. Back every recommendation with ISTQB/SQEM reference

#### For Risk Analysis
1. Use the weighted risk matrix (Business 30%, Complexity 25%, Change 20%, Gap 15%, Dependency 10%)
2. In Mode A: NAQ governs the envelope, risk matrix prioritizes within it
3. Calculate the score explicitly
4. Provide actionable recommendations based on risk level

#### For Test Cases
1. Follow TC-XXX format with all required fields
2. Organize by happy/unhappy/corner (mandatory)
3. Include priority (P1-P4), preconditions, steps, expected results
4. Mark automation candidates with rationale
5. Include traceability to requirements when available

#### For Test Classification
1. Classify into S/M/L/XL suites
2. Include execution time estimates
3. Map to CI/CD pipeline stages
4. Provide classification heuristics

#### For Automation Code
1. Generate Playwright + TypeScript with Page Object Model
2. Follow the framework structure from `sdet-automation`
3. Use accessible locators (getByRole, getByLabel, getByText)
4. Include fixtures for test isolation
5. Generate config, package.json, and tsconfig

#### For CI/CD Pipelines
1. Support GitHub Actions (primary), GitLab CI, Jenkins
2. Include conditional test execution (S on commit, M on PR, L on release)
3. Include artifact collection on failure
4. Include timeout configuration

#### For MR Analysis
1. Analyze changed files and their impact
2. Identify affected test files
3. Calculate risk level
4. Recommend must-run, should-run, and consider-running tests
5. Identify missing coverage

### After Generating

1. Review the output for completeness
2. Verify all sections are present
3. Check that ISTQB/SQEM references are included
4. Ensure coverage analysis is present (for deliverables)
5. Confirm no project context has leaked from other projects
