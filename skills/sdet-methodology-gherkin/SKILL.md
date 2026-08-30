---
name: sdet-methodology-gherkin
description: >
  Metodología Gherkin/BDD para escribir especificaciones ejecutables.
  Trigger: Gherkin, BDD, feature files, Given/When/Then, behavior-driven development
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-sdet
---

# Metodología Gherkin / BDD

Escritura de especificaciones ejecutables con sintaxis Gherkin. Cubre estructura de feature files, diseño de escenarios y buenas prácticas.

## Estructura de feature files

```gherkin
@feature-tag
Feature: User Registration
  As a new user
  I want to create an account
  So that I can access the platform

  Background:
    Given the registration page is open
    And the API is available

  @smoke
  Scenario: Successful registration with valid data
    When I fill in "Name" with "John Doe"
    And I fill in "Email" with "john@example.com"
    And I fill in "Password" with "SecurePass123"
    And I click "Register"
    Then I should see "Registration successful"
    And I should be redirected to the dashboard

  @regression
  Scenario: Registration fails with duplicate email
    Given a user exists with email "john@example.com"
    When I fill in "Email" with "john@example.com"
    And I click "Register"
    Then I should see "Email already registered"
```

## Scenario Outline (data-driven)

```gherkin
Scenario Outline: Login validation
  When I enter email "<email>" and password "<password>"
  And I click "Login"
  Then I should see "<result>"

  Examples:
    | email              | password     | result                |
    | valid@test.com     | Pass123      | Welcome back          |
    | invalid-email      | Pass123      | Invalid email format  |
    | valid@test.com     |              | Password is required  |
    |                    | Pass123      | Email is required     |
    | valid@test.com     | WrongPass    | Invalid credentials   |
```

## Tablas de datos

```gherkin
Scenario: Create user with full profile
  When I submit the following user:
    | field    | value            |
    | name     | John Doe         |
    | email    | john@example.com |
    | role     | admin            |
    | phone    | +1234567890      |
  Then the user should be created successfully

Scenario: Filter products by multiple criteria
  When I filter products:
    | category | min_price | max_price | in_stock |
    | Electronics | 50     | 500       | true     |
  Then I should see products matching all criteria
```

## Background

Usá `Background` para precondiciones compartidas por TODOS los escenarios de una feature:

```gherkin
Feature: Shopping Cart

  Background:
    Given I am logged in as "customer@test.com"
    And the following products exist:
      | name         | price |
      | Laptop       | 999   |
      | Mouse        | 25    |

  Scenario: Add product to cart
    When I add "Laptop" to my cart
    Then my cart total should be $999

  Scenario: Remove product from cart
    When I add "Laptop" to my cart
    And I remove "Laptop" from my cart
    Then my cart should be empty
```

## Tags

```gherkin
@smoke              # Quick sanity checks
@regression         # Suite completa de regresión
@api                # API-only tests
@ui                 # UI/browser tests
@slow               # Long-running tests
@wip                # Work in progress (excluded from CI)
@skip               # Temporarily disabled
```

Run by tag:
```bash
# Cucumber
--tags @smoke

# Behave
--tags=@smoke

# Multiple tags
--tags @smoke or @regression
--tags @api and not @slow
```

## Reutilización de escenarios con Examples

```gherkin
Feature: Password reset

  Background:
    Given I am on the password reset page

  Scenario: Reset via email
    When I enter my email "user@test.com"
    And I click "Send Reset Link"
    Then I should see "Check your email"

  Scenario: Invalid email format
    When I enter my email "not-an-email"
    And I click "Send Reset Link"
    Then I should see "Invalid email format"
```

## Soporte multilingüe

```gherkin
# Spanish example
Feature: Registro de usuario

  Scenario: Registro exitoso
    When I fill in "Nombre" with "Juan"
    And I click "Registrar"
    Then I should see "Registro exitoso"

# Portuguese example
Feature: Cadastro de usuário

  Scenario: Cadastro bem-sucedido
    When I fill in "Nome" with "João"
    And I click "Cadastrar"
    Then I should see "Cadastro realizado"
```

## Buenas prácticas

### 1. Un escenario = un comportamiento

```gherkin
# GOOD: Focused scenario
Scenario: Show error for invalid email format
  When I enter email "invalid-email"
  And I click "Submit"
  Then I should see "Invalid email format"

# BAD: Multiple behaviors in one scenario
Scenario: Login handles all cases
  When I enter valid credentials
  And I click submit
  Then I see dashboard
  And if I enter wrong password I see error
  And if I enter invalid email I see format error
```

### 2. Usá lenguaje centrado en el usuario

```gherkin
# GOOD
Scenario: Cannot purchase out-of-stock item
  Given "Laptop" is out of stock
  When I try to add "Laptop" to my cart
  Then I should see "Currently unavailable"

# BAD (technical implementation details)
Scenario: API returns 409 when inventory count is zero
  When POST /cart with product_id=123
  Then response status is 409
```

### 3. Mantené los escenarios independientes

```gherkin
# GOOD
Scenario: User logs in successfully
  Given I am on the login page
  When I enter valid credentials
  Then I should see the dashboard

# BAD (depends on another scenario's state)
Scenario: User logs in
Scenario: User sees dashboard  # assumes login happened
```

### 4. Sé específico, no vago

```gherkin
# GOOD
Scenario: Show error for empty email
  When I enter email ""
  Then I should see "Email is required"

# BAD
Scenario: Handle edge cases
  When I enter bad data
  Then something should happen
```

### 5. Convención de nombres de archivos

```
features/
├── auth/
│   ├── login.feature
│   ├── registration.feature
│   └── password-reset.feature
├── shopping/
│   ├── cart.feature
│   └── checkout.feature
└── users/
    ├── profile.feature
    └── settings.feature
```

## Antipatrones

| Antipatrón | Problema | Corrección |
|---|---|---|
| **Sobrecarga de reutilización de steps** | Steps demasiado genéricos, difíciles de mantener | Escribir steps específicos y con propósito |
| **Steps de implementación** | `Given the database has a row` | Usar lenguaje de negocio en su lugar |
| **Escenarios gigantes** | Más de 20 steps en un solo escenario | Dividir en escenarios más chicos |
| **Estado compartido** | Los escenarios dependen entre sí | Cada escenario prepara su propio estado |
| **Steps de UI para API** | `Given the API returns 200` | Mantener los escenarios de API enfocados en la API |
| **Aserciones vagas** | `Then everything should work` | Ser explícito sobre los resultados esperados |
