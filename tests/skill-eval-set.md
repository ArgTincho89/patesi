# Skill Eval Set — Patesi

> Run these prompts against the agent and verify the correct skill loads.
> For each prompt, the expected primary skill is the one loaded FIRST (before any other).

## Eval Cases

| # | Prompt (what the user says) | Expected primary skill | Expected secondary skill(s) |
|---|---------------------------|----------------------|---------------------------|
| 1 | "What's the difference between regression testing and confirmation testing according to ISTQB?" | sdet-istqb | — |
| 2 | "Create a test strategy for a new payment processing feature" | sdet-test-strategy | — |
| 3 | "Run a risk analysis on the user authentication module — it handles login, MFA, and session management" | sdet-risk-analysis | — |
| 4 | "Generate test cases for the shopping cart checkout flow" | sdet-test-cases | — |
| 5 | "Classify these 40 test cases into S/M/L/XL suites for our CI pipeline" | sdet-test-classification | — |
| 6 | "Set up a Playwright test automation framework with Page Object Model for our React app" | sdet-automation | — |
| 7 | "Create a Cypress E2E test suite for the user registration flow" | sdet-automation-cypress | — |
| 8 | "Generate Selenium WebDriver tests in Java with TestNG for the login page" | sdet-automation-selenium | sdet-lang-java |
| 9 | "Build an Appium test framework for our Android and iOS banking app" | sdet-automation-appium | — |
| 10 | "Create Robot Framework test suites for our REST API health checks" | sdet-automation-robot | — |
| 11 | "Show me pytest fixtures and parametrize patterns for API testing in Python" | sdet-lang-python | — |
| 12 | "Write Gherkin feature files for the user registration scenario" | sdet-methodology-gherkin | — |
| 13 | "Create Cucumber step definitions in Java for the login feature" | sdet-methodology-cucumber | sdet-lang-java |
| 14 | "Configure Maven pom.xml with Surefire plugin for running TestNG suites" | sdet-build-maven | — |
| 15 | "Set up a GitHub Actions workflow to run our Playwright tests on every PR" | sdet-cicd | — |
| 16 | "Classify the Seidor ERP project — it's a medium-complexity integration with 15 developers" | sdet-sqem-classification | — |
| 17 | "Evaluate QG3 criteria for our Seidor project with NAQ Alto" | sdet-sqem-gates | — |
| 18 | "What data quality controls apply to our GenAI chatbot project under SQEM?" | sdet-sqem-ia | — |

## How to Run

1. Pick a prompt from the table
2. Send it to Patesi as if you were the user
3. Verify the correct skill appears in the response (check for skill-specific content)
4. Check that NO wrong skills were loaded

## Expected Behavior Notes

- Cases 8 and 13 should load TWO skills (automation + language/methodology)
- SQEM cases (16-18) should only trigger in Modo A (Seidor projects)
- If the agent loads a skill not listed as expected, that's a false positive
- If the agent fails to load the expected skill, that's a false negative
