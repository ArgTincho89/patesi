---
name: sdet-risk-analysis
description: >
  Analiza user stories, features y cambios de código para detectar riesgos de testing usando una matriz de riesgos ponderada.
  Trigger: análisis de riesgos, testing basado en riesgos, riesgo de user story, priorización
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-sdet
---

# Motor de análisis de riesgos

Analiza features y user stories para identificar riesgos de testing y priorizar el esfuerzo. Usalo cuando el usuario necesite entender qué es riesgoso y dónde enfocar el testing.

## Matriz de riesgos

Puntuá cada factor de 1 (menor) a 5 (mayor):

| Factor | Peso | Qué mide | 1 | 3 | 5 |
|--------|--------|-----------------|---|---|---|
| **Impacto de negocio** | 30% | Ingresos, usuarios y reputación si falla | Herramienta interna | Feature orientada al cliente | Núcleo de pagos/autenticación |
| **Complejidad técnica** | 25% | Complejidad del código, integraciones y tecnología nueva | CRUD simple | Múltiples integraciones | Algoritmo nuevo, distribuido |
| **Frecuencia de cambio** | 20% | Cada cuánto cambia esta área | Estable (meses) | Moderada (semanas) | Constante (diaria) |
| **Brecha de cobertura de tests** | 15% | Cobertura existente de tests | Bien testeada (>80%) | Parcial (40-80%) | Sin tests (<40%) |
| **Riesgo de dependencias** | 10% | Dependencias externas y de terceros | Autosuficiente | 1-2 dependencias | Muchas dependencias externas |

## Cálculo del puntaje de riesgo

> **Nota**: Esta matriz es para análisis estratégico de features/user stories.
> Para análisis de MRs/PRs específicos (scope limitado al cambio), usá `sdet-mr-analysis`
> que usa una matriz simplificada de 4 factores con promedio simple.

```
Score = (Business × 0.30) + (Complexity × 0.25) + (Change × 0.20) + (Gap × 0.15) + (Dependency × 0.10)
```

| Rango de puntaje | Nivel de riesgo | Acción |
|-------------|------------|--------|
| **4.0 - 5.0** | 🔴 ALTO | Se requiere testing exhaustivo. Agregá tests de integración y regresión. Considerá contract testing para dependencias. Bloqueá el merge si faltan tests. |
| **2.5 - 3.9** | 🟡 MEDIO | Testing estándar. Tests de la feature y regresión. Incluilos en el pipeline CI/CD. |
| **1.0 - 2.4** | 🟢 BAJO | Testing mínimo. Un smoke test es suficiente. Automatizá solo si se repite. |

## Formato de salida

```markdown
# Análisis de riesgos: {Feature/User Story}

## Resumen

| Factor | Puntaje (1-5) | Peso | Ponderado |
|--------|-------------|--------|----------|
| Business Impact | {X} | 30% | {X × 0.30} |
| Technical Complexity | {X} | 25% | {X × 0.25} |
| Change Frequency | {X} | 20% | {X × 0.20} |
| Test Coverage Gap | {X} | 15% | {X × 0.15} |
| Dependency Risk | {X} | 10% | {X × 0.10} |
| **Total** | | | **{sum}** |

## Nivel de riesgo: {🔴 ALTO / 🟡 MEDIO / 🟢 BAJO}

## Enfoque de testing recomendado

{Specific testing recommendations based on the risk level and factor scores}

## Riesgos clave identificados

| # | Risk | Factor | Severity | Mitigation |
|---|------|--------|----------|------------|
| 1 | {Risk description} | {Which factor flagged it} | High/Medium/Low | {How to mitigate} |
| 2 | {Risk description} | {Which factor flagged it} | High/Medium/Low | {How to mitigate} |

## Priorización de tests

| Prioridad | Tipo de test | Justificación |
|----------|-----------|-----------|
| P1 | {Qué probar primero} | {Por qué} |
| P2 | {Qué probar después} | {Por qué} |
| P3 | {Qué probar si hay tiempo} | {Por qué} |
```

## Ejemplo de análisis

### Entrada

```
Feature: Payment processing with Stripe integration
- Handles credit card payments
- Integrates with Stripe API
- Stores transaction records
- No existing test coverage (new feature)
```

### Salida

```markdown
# Análisis de riesgos: Procesamiento de pagos

## Resumen

| Factor | Score (1-5) | Weight | Weighted |
|--------|-------------|--------|----------|
| Business Impact | 5 | 30% | 1.50 |
| Technical Complexity | 4 | 25% | 1.00 |
| Change Frequency | 3 | 20% | 0.60 |
| Test Coverage Gap | 5 | 15% | 0.75 |
| Dependency Risk | 4 | 10% | 0.40 |
| **Total** | | | **4.25** |

## Nivel de riesgo: 🔴 ALTO

## Enfoque de testing recomendado

SE REQUIERE TESTING EXHAUSTIVO:
1. Tests unitarios para la lógica de pagos (mock de Stripe)
2. Tests de integración con el modo de test de Stripe
3. Tests de contrato para las interacciones con la API de Stripe
4. Tests E2E para el flujo completo de pago
5. Tests de manejo de errores (tarjetas rechazadas, fallos de red)
6. Tests de seguridad (manejo de datos de tarjetas, cumplimiento PCI)

BLOQUEAR MERGE: ningún código de pagos debe integrarse sin sus tests correspondientes.

## Riesgos clave identificados

| # | Risk | Factor | Severity | Mitigation |
|---|------|--------|----------|------------|
| 1 | Financial loss from payment errors | Business Impact | High | Comprehensive test suite + monitoring |
| 2 | Stripe API changes break integration | Dependency Risk | High | Contract tests, pin Stripe version |
| 3 | No existing test coverage | Coverage Gap | High | Write tests before implementation (TDD) |
| 4 | Complex error handling scenarios | Technical Complexity | Medium | Map all Stripe error codes, test each |

## Priorización de tests

| Prioridad | Tipo de test | Justificación |
|----------|-----------|-----------|
| P1 | Unit tests for payment calculation | Core logic, must be correct |
| P1 | Stripe integration tests (test mode) | Critical integration point |
| P1 | Error handling (declined, timeout) | Financial impact |
| P2 | Transaction record storage | Data integrity |
| P2 | Webhook handling | asynchronous events |
| P3 | Performance under load | Payment peak times |
| P3 | Security audit | PCI compliance |
```
