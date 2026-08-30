---
name: sdet-lang-javascript
description: >
  Patrones de testing JavaScript/TypeScript para trabajo SDET.
  Trigger: JavaScript testing, TypeScript testing, Jest, Vitest, Node.js testing
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-sdet
---

# Patrones de testing JavaScript/TypeScript para SDET

Patrones de Jest y Vitest, mocking, testing asíncrono y configuración de proyectos para automatización de tests JS/TS.

## Estructura del proyecto

```
tests/
├── unit/
│   └── {module}.test.ts
├── integration/
│   └── {feature}.test.ts
├── e2e/
│   └── {feature}.spec.ts
├── fixtures/
│   └── test-data.ts
├── helpers/
│   ├── api-client.ts
│   └── db-helpers.ts
├── setup.ts                # Global test setup
└── tsconfig.json
```

## Configuración de Jest

### jest.config.ts

```typescript
import type { Config } from 'jest';

const config: Config = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  roots: ['<rootDir>/tests'],
  testMatch: ['**/*.test.ts'],
  setupFilesAfterSetup: ['<rootDir>/tests/setup.ts'],
  coverageDirectory: 'coverage',
  collectCoverageFrom: [
    'src/**/*.ts',
    '!src/**/*.d.ts',
    '!src/index.ts',
  ],
  coverageThresholds: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80,
    },
  },
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/src/$1',
  },
};

export default config;
```

### Scripts de package.json

```json
{
  "scripts": {
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "test:unit": "jest --testPathPattern=unit",
    "test:integration": "jest --testPathPattern=integration",
    "test:ci": "jest --ci --coverage --forceExit"
  }
}
```

## Configuración de Vitest

### vitest.config.ts

```typescript
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    globals: true,
    environment: 'node',
    include: ['tests/**/*.test.ts'],
    coverage: {
      provider: 'v8',
      reporter: ['text', 'html', 'lcov'],
      thresholds: {
        branches: 80,
        functions: 80,
        lines: 80,
        statements: 80,
      },
    },
    setupFiles: ['tests/setup.ts'],
  },
  resolve: {
    alias: {
      '@': '/src',
    },
  },
});
```

## Patrones de tests

### Test unitario básico

```typescript
import { describe, it, expect, beforeEach, vi } from 'vitest'; // or jest
import { UserService } from '../src/services/user-service';
import { UserRepository } from '../src/repositories/user-repository';

describe('UserService', () => {
  let service: UserService;
  let mockRepo: jest.Mocked<UserRepository>;

  beforeEach(() => {
    mockRepo = {
      findById: vi.fn(),
      findByEmail: vi.fn(),
      save: vi.fn(),
      delete: vi.fn(),
    } as unknown as jest.Mocked<UserRepository>;

    service = new UserService(mockRepo);
  });

  describe('createUser', () => {
    it('should create user with valid data', async () => {
      const input = { name: 'John', email: 'john@test.com' };
      mockRepo.save.mockResolvedValue({ id: 1, ...input });

      const result = await service.createUser(input);

      expect(result).toEqual({ id: 1, name: 'John', email: 'john@test.com' });
      expect(mockRepo.save).toHaveBeenCalledWith(input);
    });

    it('should throw on duplicate email', async () => {
      mockRepo.findByEmail.mockResolvedValue({ id: 1, email: 'john@test.com' });

      await expect(
        service.createUser({ name: 'John', email: 'john@test.com' })
      ).rejects.toThrow('Email already exists');
    });
  });
});
```

### Tests parametrizados

```typescript
describe('login validation', () => {
  it.each([
    ['valid@example.com', 200],
    ['invalid-email', 422],
    ['', 422],
    ['missing@domain', 422],
  ])('email "%s" should return status %d', async (email, expectedStatus) => {
    const response = await loginApi(email, 'password123');
    expect(response.status).toBe(expectedStatus);
  });
});

describe('role permissions', () => {
  it.each(['admin', 'editor', 'viewer'] as const)(
    'user with role "%s" should have correct access',
    async (role) => {
      const client = await authenticateAs(role);
      const response = await client.get('/admin/dashboard');
      expect(response.status).toBe(role === 'admin' ? 200 : 403);
    }
  );
});
```

### Testing asíncrono

```typescript
describe('Async operations', () => {
  it('should resolve promise with correct value', async () => {
    const result = await fetchUser(1);
    expect(result.name).toBe('John');
  });

  it('should reject promise on error', async () => {
    await expect(fetchUser(999))
      .rejects.toThrow('User not found');
  });

  it('should handle timeout', async () => {
    await expect(
      withTimeout(slowOperation(), 1000)
    ).rejects.toThrow('Operation timed out');
  });

  it('should retry on failure', async () => {
    const mockFn = vi.fn()
      .mockRejectedValueOnce(new Error('Network error'))
      .mockResolvedValueOnce('success');

    const result = await retry(mockFn, 2);
    expect(result).toBe('success');
    expect(mockFn).toHaveBeenCalledTimes(2);
  });
});
```

### Patrones de mocking

```typescript
import { vi } from 'vitest'; // or jest.fn()

// Mock a module
vi.mock('../src/services/email-service', () => ({
  sendEmail: vi.fn().mockResolvedValue({ sent: true }),
}));

// Mock a specific method
const mockSendEmail = sendEmail as jest.MockedFunction<typeof sendEmail>;
mockSendEmail.mockResolvedValue({ sent: true });

// Spy on a method (preserves original)
const spy = vi.spyOn(logger, 'error');
// ... call code ...
expect(spy).toHaveBeenCalledWith(expect.stringContaining('failed'));

// Mock timers
vi.useFakeTimers();
vi.setSystemTime(new Date('2024-01-15'));

// Mock environment variables
vi.stubEnv('API_URL', 'http://mock-api.test');
```

### Patrón de fixtures

```typescript
import { test as base, expect } from '@playwright/test'; // or jest fixture

type TestFixtures = {
  apiClient: ApiClient;
  testUser: User;
};

export const test = base.extend<TestFixtures>({
  apiClient: async ({}, use) => {
    const client = new ApiClient(process.env.API_URL);
    await use(client);
    await client.close();
  },

  testUser: async ({ apiClient }, use) => {
    const user = await apiClient.createUser({
      name: 'Test User',
      email: `test-${Date.now()}@example.com`,
    });
    await use(user);
    await apiClient.deleteUser(user.id);
  },
});

export { expect };
```

## supertest (Express/Fastify API Testing)

```typescript
import request from 'supertest';
import { app } from '../src/app';

describe('POST /users', () => {
  it('should create a new user', async () => {
    const response = await request(app)
      .post('/users')
      .send({ name: 'John', email: 'john@test.com' })
      .expect(201);

    expect(response.body).toMatchObject({
      name: 'John',
      email: 'john@test.com',
    });
    expect(response.body.id).toBeDefined();
  });

  it('should return 422 for invalid email', async () => {
    await request(app)
      .post('/users')
      .send({ name: 'John', email: 'invalid' })
      .expect(422);
  });
});
```

## testing-library (Component Testing)

```typescript
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import { LoginForm } from './LoginForm';

describe('LoginForm', () => {
  it('should show error on invalid credentials', async () => {
    render(<LoginForm onSubmit={jest.fn().mockRejectedValue(new Error('Invalid'))} />);

    fireEvent.change(screen.getByLabelText('Email'), {
      target: { value: 'bad@test.com' },
    });
    fireEvent.change(screen.getByLabelText('Password'), {
      target: { value: 'wrong' },
    });
    fireEvent.click(screen.getByRole('button', { name: 'Log in' }));

    await waitFor(() => {
      expect(screen.getByRole('alert')).toHaveTextContent('Invalid credentials');
    });
  });
});
```

## Librerías habituales

| Librería | Propósito |
|---------|---------|
| `jest` / `vitest` | Test runner + assertions |
| `@testing-library/react` | React component testing |
| `@testing-library/jest-dom` | DOM matchers |
| `supertest` | Express/Fastify API testing |
| `msw` | Mock Service Worker (API mocking) |
| `nock` | HTTP request interception |
| `faker` | Test data generation |
| `zod` | Schema validation in tests |
