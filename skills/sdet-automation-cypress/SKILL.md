---
name: sdet-automation-cypress
description: >
  Generates Cypress test automation frameworks with JavaScript/TypeScript.
  Trigger: When user asks to generate Cypress tests, create Cypress automation framework, or set up Cypress E2E testing.
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-sdet
---

# Cypress Test Automation Framework Generator

Generates Cypress E2E test automation frameworks following industry best practices. Use this when the user needs to automate tests with Cypress.

## Framework Structure

Generate this directory structure:

```
cypress/
├── e2e/
│   └── {feature}/
│       └── {feature}.cy.ts        # Test specs
├── fixtures/
│   ├── users.json                  # Test data
│   └── api-responses.json          # API mocks
├── support/
│   ├── commands.ts                 # Custom commands
│   ├── e2e.ts                      # Support file (imports)
│   └── pages/
│       ├── BasePage.ts             # Abstract base page
│       └── {Feature}Page.ts        # Page objects
├── plugins/
│   └── index.ts                    # Plugin configuration
├── tsconfig.json                   # TypeScript config
├── cypress.config.ts               # Cypress configuration
└── package.json                    # Dependencies
```

## Page Object Pattern

### BasePage.ts

```typescript
export class BasePage {
  protected baseUrl: string;

  constructor() {
    this.baseUrl = Cypress.env('baseUrl') || 'http://localhost:3000';
  }

  visit(path: string = '') {
    cy.visit(`${this.baseUrl}${path}`);
    this.waitForPageLoad();
  }

  waitForPageLoad() {
    cy.window().its('document.readyState').should('equal', 'complete');
  }

  getTitle(): Cypress.Chainable<string> {
    return cy.title();
  }

  screenshot(name: string) {
    cy.screenshot(name);
  }

  getAlert(): Cypress.Chainable {
    return cy.get('[role="alert"]');
  }
}
```

### FeaturePage.ts

```typescript
import { BasePage } from './BasePage';

export class {Feature}Page extends BasePage {
  readonly heading = () => cy.get('h1');
  readonly inputField = () => cy.getByLabel('{Input Label}');
  readonly submitButton = () => cy.getByRole('button', { name: 'Submit' });
  readonly errorMessage = () => this.getAlert();
  readonly successMessage = () => cy.getByText('{Success message}');

  visitPage() {
    this.visit('/{feature-route}');
    this.waitForPageLoad();
  }

  fillForm(data: { field1: string; field2: string }) {
    this.inputField().type(data.field1);
  }

  submit() {
    this.submitButton().click();
  }

  expectError(message: string) {
    this.errorMessage().should('contain.text', message);
  }

  expectSuccess(message: string) {
    this.successMessage().should('contain.text', message);
  }
}
```

## Custom Commands Pattern

### commands.ts

```typescript
declare global {
  namespace Cypress {
    interface Chainable {
      login(email: string, password: string): Chainable<void>;
      getByLabel(label: string): Chainable<JQuery>;
      getByRole(role: string, options?: { name: string }): Chainable<JQuery>;
    }
  }
}

Cypress.Commands.add('login', (email: string, password: string) => {
  cy.session([email, password], () => {
    cy.visit('/login');
    cy.getByLabel('Email').type(email);
    cy.getByLabel('Password').type(password);
    cy.getByRole('button', { name: 'Log in' }).click();
    cy.url().should('include', '/dashboard');
  });
});

Cypress.Commands.add('getByLabel', (label: string) => {
  cy.get(`[aria-label="${label}"]`);
});

Cypress.Commands.add('getByRole', (role: string, options?: { name: string }) => {
  const selector = options?.name
    ? `[role="${role}"]:contains("${options.name}")`
    : `[role="${role}"]`;
  cy.get(selector);
});

export {};
```

## Cypress Config Template

```typescript
import { defineConfig } from 'cypress';

export default defineConfig({
  e2e: {
    baseUrl: process.env.BASE_URL || 'http://localhost:3000',
    specPattern: 'cypress/e2e/**/*.cy.{js,jsx,ts,tsx}',
    supportFile: 'cypress/support/e2e.ts',
    viewportWidth: 1280,
    viewportHeight: 720,
    video: false,
    screenshotOnRunFailure: true,
    retries: {
      runMode: 2,
      openMode: 0,
    },
    env: {
      apiUrl: process.env.API_URL || 'http://localhost:3001',
    },
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
  },
});
```

## Package.json Template

```json
{
  "name": "cypress-e2e-tests",
  "version": "1.0.0",
  "scripts": {
    "test": "cypress run",
    "test:headed": "cypress run --headed",
    "test:chrome": "cypress run --browser chrome",
    "test:firefox": "cypress run --browser firefox",
    "open": "cypress open",
    "cy:run": "cypress run --spec 'cypress/e2e/**/*.cy.ts'",
    "cy:open": "cypress open --config-file cypress.config.ts"
  },
  "devDependencies": {
    "cypress": "^13.15.0",
    "typescript": "^5.7.0"
  }
}
```

## Example Generated Code

### Input

```
Login page with email and password fields, submit button, and error messages
```

### Output

**LoginPage.ts**:
```typescript
import { BasePage } from './BasePage';

export class LoginPage extends BasePage {
  readonly emailInput = () => cy.getByLabel('Email');
  readonly passwordInput = () => cy.getByLabel('Password');
  readonly loginButton = () => cy.getByRole('button', { name: 'Log in' });
  readonly errorMessage = () => this.getAlert();
  readonly forgotPasswordLink = () => cy.getByRole('link', { name: 'Forgot password?' });

  visitPage() {
    this.visit('/login');
    this.waitForPageLoad();
  }

  login(email: string, password: string) {
    this.emailInput().type(email);
    this.passwordInput().type(password);
    this.loginButton().click();
  }

  expectError(message: string) {
    this.errorMessage().should('contain.text', message);
  }
}
```

**login.cy.ts**:
```typescript
import { LoginPage } from '../../support/pages/LoginPage';

describe('Login', () => {
  let loginPage: LoginPage;

  beforeEach(() => {
    loginPage = new LoginPage();
    loginPage.visitPage();
  });

  it('should login successfully with valid credentials', () => {
    loginPage.login('user@example.com', 'ValidPass1');
    cy.url().should('include', '/dashboard');
  });

  it('should show error for invalid email', () => {
    loginPage.login('invalid-email', 'ValidPass1');
    loginPage.expectError('Please enter a valid email');
  });

  it('should show error for wrong password', () => {
    loginPage.login('user@example.com', 'WrongPass');
    loginPage.expectError('Invalid email or password');
  });

  it('should show error for empty fields', () => {
    loginPage.login('', '');
    loginPage.expectError('Email is required');
  });
});
```

## Trigger Keywords

Load this skill when the user says any of:
- "Cypress", "Cypress tests", "Cypress E2E", "Cypress automation"
- "generate Cypress framework", "Cypress Page Object"
- "automate with Cypress", "Cypress custom commands"
- "pruebas con Cypress", "automatizar con Cypress", "framework de Cypress"
