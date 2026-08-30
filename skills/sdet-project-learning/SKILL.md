---
name: sdet-project-learning
description: >
  Almacena y recupera patrones de QA específicos del proyecto usando memoria persistente.
  Trigger: aprender del proyecto, recordar patrones, guardar convenciones QA
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-sdet
---

# Aprendizaje del proyecto (memoria persistente)

Almacena y recupera patrones de QA específicos del proyecto. Usalo cuando el usuario quiera recordar convenciones, aprender del proyecto o recuperar decisiones anteriores.

## Formato de almacenamiento

### Categorías de patrones

| Categoría | Ejemplo | Cuándo almacenar |
|----------|---------|---------------|
| **test-naming** | "Tests use `describe('Feature')` with `it('should X')`" | After analyzing test suite |
| **framework** | "Project uses Playwright with fixtures, not page objects" | When discovering framework patterns |
| **coverage** | "Payment module has no integration tests" | When finding coverage gaps |
| **cicd** | "PR checks run S+M class, nightly runs L class" | When learning CI/CD setup |
| **bug-pattern** | "Auth module frequently has regression in token refresh" | When discovering recurring bugs |
| **convention** | "All test files end with `.spec.ts`, not `.test.ts`" | When finding naming conventions |

### Comando de almacenamiento

Almacená los patrones usando el mecanismo de persistencia disponible en tu entorno. El formato de la clave siempre es:

```
qa-patterns/{project}/{pattern-name}
```

Content structure:
```
## Patrón: {name}
## Categoría: {category}
## Descripción: {what the pattern is}
## Ejemplo: {concrete example}
## Aplicar cuando: {conditions for using this pattern}
```

### Comando de recuperación

Buscá patrones por clave: `qa-patterns/{project}`

## Flujo de trabajo

### Fase de aprendizaje (cuando el usuario dice "Aprendé del proyecto")

1. **Analyze existing test suite** — Read test files, count patterns
2. **Identify conventions** — Naming, structure, frameworks used
3. **Find gaps** — What's tested, what's not
4. **Store patterns** — Save each pattern with category tag
5. **Report findings** — Tell user what was learned

### Fase de aplicación (al generar una salida específica del proyecto)

1. **Search for patterns** — Look up stored patterns for this project
2. **Apply patterns** — Follow stored conventions when generating code
3. **Informar adhesión** — Indicar al usuario qué patrones se siguieron

## Ejemplo de salida de aprendizaje

```markdown
# Aprendizaje del proyecto: {Project Name}

## Análisis completado

### Resumen de la suite de tests
- Total de archivos de tests: {N}
- Framework de tests: {Jest/Playwright/etc.}
- Ubicación de los tests: `{directory}`
- Patrón de archivos: `{pattern}`

### Patrones descubiertos

| Categoría | Patrón | Ejemplo |
|----------|---------|---------|
| test-naming | {description} | `{example}` |
| framework | {description} | `{example}` |
| convention | {description} | `{example}` |

### Brechas de cobertura encontradas
- {Área 1}: {Qué falta}
- {Área 2}: {Qué falta}

### Patrones almacenados
- ✅ `qa-patterns/{project}/test-naming-convention`
- ✅ `qa-patterns/{project}/framework-preference`
- ✅ `qa-patterns/{project}/coverage-gaps`
```

## Degradación controlada

Si la memoria persistente no está disponible en el entorno actual:
1. **Notificar al usuario**: "La memoria persistente no está disponible; los patrones del proyecto no se recordarán entre sesiones"
2. **Continuar trabajando**: Todos los demás skills funcionan normalmente
3. **Ofrecer alternativas**: Sugerir al usuario que anote manualmente los patrones importantes

## Ejemplo de entrada

```
Usuario: "Aprendé de la suite de tests de este proyecto y recordá los patrones"
```

## Ejemplo de salida

```markdown
# Aprendizaje del proyecto: aplicación de comercio electrónico

## Análisis completado

### Resumen de la suite de tests
- Total test files: 47
- Test framework: Playwright + TypeScript
- Test location: `tests/`
- File pattern: `*.spec.ts`

### Patrones descubiertos

| Categoría | Patrón | Ejemplo |
|----------|---------|---------|
| test-naming | Tests use `describe('Feature')` with `it('should X')` | `describe('Checkout')` / `it('should calculate total')` |
| framework | Uses Page Object Model pattern | `pages/LoginPage.ts`, `pages/CartPage.ts` |
| convention | Tests tagged with `@smoke`, `@functional`, `@regression` | `test.describe '{@smoke} Login', ...)` |
| cicd | Smoke tests run on every commit, regression on nightly | GitHub Actions workflow |

### Brechas de cobertura encontradas
- Payment module: No integration tests with Stripe
- User profile: No tests for avatar upload
- Search: No performance tests

### Patrones almacenados
- ✅ `qa-patterns/ecommerce/test-naming-convention`
- ✅ `qa-patterns/ecommerce/framework-patterns`
- ✅ `qa-patterns/ecommerce/test-tags`
- ✅ `qa-patterns/ecommerce/cicd-strategy`
- ✅ `qa-patterns/ecommerce/coverage-gaps`
```
