---
name: sdet-methodology-cucumber
description: >
  Cucumber framework integration with Gherkin for BDD test automation.
  Trigger: When user asks about Cucumber, Cucumber-JVM, step definitions, glue code, or BDD test automation.
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-sdet
---

# Cucumber BDD Framework Integration

Cucumber-JVM (Java) and Cucumber.js/TypeScript patterns for turning Gherkin features into executable tests.

## Project Structure

### Java (Cucumber-JVM)

```
src/
├── main/java/com/example/
│   └── steps/
│       ├── LoginSteps.java
│       ├── RegistrationSteps.java
│       └── hooks/
│           ├── TestHooks.java
│           └── ApiHooks.java
└── test/
    ├── java/com/example/
    │   └── runners/
    │       └── TestRunner.java
    └── resources/
        ├── features/
        │   ├── auth/
        │   │   ├── login.feature
        │   │   └── registration.feature
        │   └── shopping/
        │       └── cart.feature
        └── test.properties
```

### JavaScript/TypeScript (Cucumber.js)

```
tests/
├── features/
│   ├── auth/
│   │   ├── login.feature
│   │   └── registration.feature
│   └── steps/
│       ├── login.steps.ts
│       └── common.steps.ts
├── support/
│   ├── world.ts              # World context
│   ├── hooks.ts              # Before/After hooks
│   └── parameters.ts         # Custom parameter types
└── cucumber.js               # Cucumber config
```

## Java: Step Definitions

```java
import io.cucumber.java.en.*;
import io.cucumber.java.Before;
import io.cucumber.java.After;
import static org.assertj.core.api.Assertions.*;

public class LoginSteps {

    private LoginPage loginPage;
    private DashboardPage dashboardPage;

    @Before
    public void setUp() {
        loginPage = new LoginPage(DriverFactory.getDriver());
        dashboardPage = new DashboardPage(DriverFactory.getDriver());
    }

    @Given("the user is on the login page")
    public void userIsOnLoginPage() {
        loginPage.navigate();
    }

    @Given("a user exists with email {string}")
    public void userExists(String email) {
        apiClient.createUser(email, "TestPass123");
    }

    @When("the user enters email {string}")
    public void userEntersEmail(String email) {
        loginPage.enterEmail(email);
    }

    @When("the user enters password {string}")
    public void userEntersPassword(String password) {
        loginPage.enterPassword(password);
    }

    @When("the user clicks {string}")
    public void userClicks(String buttonText) {
        loginPage.clickButton(buttonText);
    }

    @Then("the user should see {string}")
    public void userShouldSee(String message) {
        assertThat(loginPage.getDisplayedMessage()).contains(message);
    }

    @Then("the user should be redirected to the dashboard")
    public void userRedirectedToDashboard() {
        assertThat(dashboardPage.isLoaded()).isTrue();
    }
}
```

### DataTable Steps

```java
@When("I submit the following user details:")
public void submitUserDetails(DataTable table) {
    Map<String, String> data = table.asMap(String.class, String.class);
    registrationPage.fillName(data.get("name"));
    registrationPage.fillEmail(data.get("email"));
    registrationPage.fillPassword(data.get("password"));
    registrationPage.submit();
}
```

### Custom Parameter Types

```java
import io.cucumber.java.ParameterType;

@ParameterType(".*")
public UserStatus status(String value) {
    return UserStatus.valueOf(value.toUpperCase());
}

@Given("a user with status {userStatus}")
public void userWithStatus(UserStatus status) {
    apiClient.createUserWithStatus(status);
}
```

## Java: Cucumber Runner (JUnit 5 Platform)

```java
import io.cucumber.junit.platform.engine.Constants;
import org.junit.platform.suite.api.*;

@Suite
@IncludeEngines("cucumber")
@SelectClasspathResource("features")
@ConfigurationParameter(
    key = Constants.GLUE_PROPERTY_NAME,
    value = "com.example.steps"
)
@ConfigurationParameter(
    key = Constants.PLUGIN_PROPERTY_NAME,
    value = "pretty, html:target/cucumber-reports/cucumber.html, json:target/cucumber-reports/cucumber.json"
)
public class CucumberTestSuite {}
```

## Java: Hooks

```java
import io.cucumber.java.Before;
import io.cucumber.java.After;
import io.cucumber.java.Scenario;

public class TestHooks {

    @Before(order = 0)
    public void setupDriver() {
        DriverFactory.initDriver();
    }

    @Before(value = "@ui", order = 1)
    public void setupBrowser() {
        DriverFactory.getDriver().manage().window().maximize();
    }

    @Before(value = "@api", order = 1)
    public void setupApiClient() {
        apiClient = new ApiClient(baseUrl);
    }

    @After
    public void tearDown(Scenario scenario) {
        if (scenario.isFailed()) {
            byte[] screenshot = DriverFactory.getDriver()
                .getScreenshotAs(OutputType.BYTES);
            scenario.attach(screenshot, "image/png", scenario.getName());
        }
        DriverFactory.quitDriver();
    }

    @After(value = "@cleanup")
    public void cleanTestData() {
        apiClient.deleteAllTestUsers();
    }
}
```

## TypeScript: Step Definitions

```typescript
import { Given, When, Then, Before, After } from '@cucumber/cucumber';
import { expect } from '@playwright/test';
import { CustomWorld } from './world';

Before(function (this: CustomWorld) {
    this.page = this.browser.newPage();
});

After(async function (this: CustomWorld) {
    if (this.page) await this.page.close();
});

Given('the user is on the login page', async function (this: CustomWorld) {
    await this.page.goto('http://localhost:3000/login');
});

When('the user enters email {string}', async function (this: CustomWorld, email: string) {
    await this.page.getByLabel('Email').fill(email);
});

When('the user clicks {string}', async function (this: CustomWorld, buttonText: string) {
    await this.page.getByRole('button', { name: buttonText }).click();
});

Then('the user should see {string}', async function (this: CustomWorld, message: string) {
    await expect(this.page.getByText(message)).toBeVisible();
});
```

## TypeScript: World Context

```typescript
import { World, setWorldConstructor } from '@cucumber/cucumber';
import { Browser, Page } from '@playwright/test';

export class CustomWorld extends World {
    browser!: Browser;
    page!: Page;
    testUser?: { id: string; email: string };
}

setWorldConstructor(CustomWorld);
```

## TypeScript: Cucumber Config

```typescript
// cucumber.js
module.exports = {
    default: {
        requireModule: ['ts-node/register'],
        require: ['tests/features/steps/**/*.ts', 'tests/features/support/**/*.ts'],
        paths: ['tests/features/**/*.feature'],
        format: ['progress', 'html:cucumber-report.html'],
        formatOptions: { snippetInterface: 'async-await' },
        publishQuiet: true,
    },
};
```

## Common Libraries

| Library | Language | Purpose |
|---------|----------|---------|
| `io.cucumber:cucumber-java` | Java | Step definitions |
| `io.cucumber:cucumber-junit-platform-engine` | Java | JUnit 5 integration |
| `@cucumber/cucumber` | JS/TS | Core Cucumber.js |
| `@cucumber/pretty-formatter` | JS/TS | Improved output |
| `cucumber-html-reporter` | JS/TS | HTML reports |

## Trigger Keywords

Load this skill when the user says any of:
- "Cucumber", "Cucumber-JVM", "Cucumber.js", "step definitions"
- "glue code", "BDD automation", "Cucumber runner"
- "feature file to code", "Given/When/Then implementation"
- "Cucumber en Java", "Cucumber TypeScript", "automatizar Cucumber"
