---
name: sdet-automation
description: >
  Generates Playwright + TypeScript test automation frameworks with Page Object Model pattern.
  Trigger: When user asks to generate test automation framework, create Playwright tests, build Page Objects, or set up test automation.
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-sdet
---

# Test Automation Framework Generator

Generates Playwright + TypeScript test automation frameworks following industry best practices. Use this when the user needs to automate tests with Playwright.

## Framework Structure

Generate this directory structure:

```
tests/
├── fixtures/
│   └── base.ts              # Custom test fixtures
├── pages/
│   ├── BasePage.ts          # Abstract base page
│   └── {Feature}Page.ts     # Feature-specific page objects
├── specs/
│   └── {feature}.spec.ts    # Test specifications
├── utils/
│   ├── test-data.ts          # Test data generators
│   └── api-helpers.ts        # API test utilities
├── playwright.config.ts      # Playwright configuration
├── tsconfig.json             # TypeScript configuration
└── package.json              # Dependencies
```

## Page Object Pattern

### BasePage.ts

```typescript
import { Page, Locator } from '@playwright/test';

export abstract class BasePage {
  readonly page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  async navigate(path: string = '') {
    await this.page.goto(path);
  }

  async getTitle(): Promise<string> {
    return await this.page.title();
  }

  async waitForPageLoad(): Promise<void> {
    await this.page.waitForLoadState('networkidle');
  }

  async screenshot(name: string): Promise<void> {
    await this.page.screenshot({ path: `screenshots/${name}.png` });
  }
}
```

### FeaturePage.ts

```typescript
import { Page, Locator, expect } from '@playwright/test';
import { BasePage } from './BasePage';

export class {Feature}Page extends BasePage {
  // Locators
  readonly heading: Locator;
  readonly inputField: Locator;
  readonly submitButton: Locator;
  readonly errorMessage: Locator;
  readonly successMessage: Locator;

  constructor(page: Page) {
    super(page);
    // Define locators using best practices:
    // - Prefer getByRole, getByLabel, getByPlaceholder, getByText
    // - Use data-testid as fallback
    // - Avoid CSS selectors when possible
    this.heading = page.getByRole('heading', { name: '{Feature}' });
    this.inputField = page.getByLabel('{Input Label}');
    this.submitButton = page.getByRole('button', { name: 'Submit' });
    this.errorMessage = page.getByRole('alert');
    this.successMessage = page.getByText('{Success message}');
  }

  async navigate() {
    await super.navigate('/{feature-route}');
    await this.waitForPageLoad();
  }

  async fillForm(data: { field1: string; field2: string }) {
    await this.inputField.fill(data.field1);
    // Fill other fields...
  }

  async submit() {
    await this.submitButton.click();
  }

  async expectError(message: string) {
    await expect(this.errorMessage).toContainText(message);
  }

  async expectSuccess(message: string) {
    await expect(this.successMessage).toContainText(message);
  }
}
```

## Test Spec Pattern

```typescript
import { test, expect } from '@playwright/test';
import { {Feature}Page } from '../pages/{Feature}Page';

test.describe('{Feature}', () => {
  let {feature}Page: {Feature}Page;

  test.beforeEach(async ({ page }) => {
    {feature}Page = new {Feature}Page(page);
    await {feature}Page.navigate();
  });

  test('should display {feature} page correctly', async () => {
    await expect({feature}Page.heading).toBeVisible();
  });

  test('should {happy path action}', async () => {
    // Arrange
    const testData = { /* ... */ };

    // Act
    await {feature}Page.fillForm(testData);
    await {feature}Page.submit();

    // Assert
    await {feature}Page.expectSuccess('{expected message}');
  });

  test('should show error for {error condition}', async () => {
    // Arrange
    const invalidData = { /* ... */ };

    // Act
    await {feature}Page.fillForm(invalidData);
    await {feature}Page.submit();

    // Assert
    await {feature}Page.expectError('{error message}');
  });
});
```

## Fixtures Pattern

```typescript
import { test as base } from '@playwright/test';
import { {Feature}Page } from '../pages/{Feature}Page';

type TestFixtures = {
  {feature}Page: {Feature}Page;
};

export const test = base.extend<TestFixtures>({
  {feature}Page: async ({ page }, use) => {
    const {feature}Page = new {Feature}Page(page);
    await {feature}Page.navigate();
    await use({feature}Page);
  },
});

export { expect } from '@playwright/test';
```

## API Test Helpers

```typescript
import { APIRequestContext, expect } from '@playwright/test';

export class ApiHelpers {
  private request: APIRequestContext;
  private baseUrl: string;

  constructor(request: APIRequestContext, baseUrl: string) {
    this.request = request;
    this.baseUrl = baseUrl;
  }

  async get<T>(path: string, headers?: Record<string, string>): Promise<T> {
    const response = await this.request.get(`${this.baseUrl}${path}`, {
      headers,
    });
    expect(response.ok()).toBeTruthy();
    return response.json() as Promise<T>;
  }

  async post<T>(path: string, data: unknown, headers?: Record<string, string>): Promise<T> {
    const response = await this.request.post(`${this.baseUrl}${path}`, {
      data,
      headers,
    });
    expect(response.ok()).toBeTruthy();
    return response.json() as Promise<T>;
  }

  async put<T>(path: string, data: unknown, headers?: Record<string, string>): Promise<T> {
    const response = await this.request.put(`${this.baseUrl}${path}`, {
      data,
      headers,
    });
    expect(response.ok()).toBeTruthy();
    return response.json() as Promise<T>;
  }

  async delete(path: string, headers?: Record<string, string>): Promise<void> {
    const response = await this.request.delete(`${this.baseUrl}${path}`, {
      headers,
    });
    expect(response.ok()).toBeTruthy();
  }
}
```

## Playwright Config Template

```typescript
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './specs',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [
    ['html', { open: 'never' }],
    ['junit', { outputFile: 'test-results/junit.xml' }],
  ],
  use: {
    baseURL: process.env.BASE_URL || 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
  ],
  webServer: process.env.CI
    ? undefined
    : {
        command: 'npm run dev',
        url: 'http://localhost:3000',
        reuseExistingServer: true,
      },
});
```

## Package.json Template

```json
{
  "name": "e2e-tests",
  "version": "1.0.0",
  "scripts": {
    "test": "npx playwright test",
    "test:chromium": "npx playwright test --project=chromium",
    "test:headed": "npx playwright test --headed",
    "test:debug": "npx playwright test --debug",
    "test:ui": "npx playwright test --ui",
    "report": "npx playwright show-report"
  },
  "devDependencies": {
    "@playwright/test": "^1.50.0",
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
import { Page, Locator, expect } from '@playwright/test';
import { BasePage } from './BasePage';

export class LoginPage extends BasePage {
  readonly emailInput: Locator;
  readonly passwordInput: Locator;
  readonly loginButton: Locator;
  readonly errorMessage: Locator;
  readonly forgotPasswordLink: Locator;

  constructor(page: Page) {
    super(page);
    this.emailInput = page.getByLabel('Email');
    this.passwordInput = page.getByLabel('Password');
    this.loginButton = page.getByRole('button', { name: 'Log in' });
    this.errorMessage = page.getByRole('alert');
    this.forgotPasswordLink = page.getByRole('link', { name: 'Forgot password?' });
  }

  async navigate() {
    await super.navigate('/login');
    await this.waitForPageLoad();
  }

  async login(email: string, password: string) {
    await this.emailInput.fill(email);
    await this.passwordInput.fill(password);
    await this.loginButton.click();
  }

  async expectError(message: string) {
    await expect(this.errorMessage).toContainText(message);
  }
}
```

**login.spec.ts**:
```typescript
import { test, expect } from '@playwright/test';
import { LoginPage } from '../pages/LoginPage';

test.describe('Login', () => {
  let loginPage: LoginPage;

  test.beforeEach(async ({ page }) => {
    loginPage = new LoginPage(page);
    await loginPage.navigate();
  });

  test('should login successfully with valid credentials', async ({ page }) => {
    await loginPage.login('user@example.com', 'ValidPass1');
    await expect(page).toHaveURL('/dashboard');
  });

  test('should show error for invalid email', async () => {
    await loginPage.login('invalid-email', 'ValidPass1');
    await loginPage.expectError('Please enter a valid email');
  });

  test('should show error for wrong password', async () => {
    await loginPage.login('user@example.com', 'WrongPass');
    await loginPage.expectError('Invalid email or password');
  });

  test('should show error for empty fields', async () => {
    await loginPage.login('', '');
    await loginPage.expectError('Email is required');
  });
});
```

## Trigger Keywords

Load this skill when the user says any of:
- "Playwright", "test automation", "Page Object", "E2E tests"
- "generate test framework", "automation framework"
- "automate tests", "write automated tests"
- "framework de testing", "automatizar tests"
