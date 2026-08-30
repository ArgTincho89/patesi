---
name: sdet-test-classification
description: >
  Clasifica casos de prueba en suites S/M/L/XL para integración CI/CD y organización de tests.
  Trigger: clasificación de tests, suites S/M/L/XL, estrategia CI/CD, tiers de testing
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-sdet
---

# Clasificador de suites de tests

Clasifica casos de prueba en suites por tamaño para optimizar la ejecución CI/CD. Usalo cuando el usuario necesite organizar tests para integrarlos al pipeline o determinar cuándo se ejecutan.

## Taxonomía de clasificación

| Clase | Nombre | Alcance | Tiempo de ejecución | Cuándo ejecutar |
|-------|------|-------|---------------|-------------|
| **S** | Smoke | Funcionalidad principal, camino crítico | < 5 min | Cada commit, cada deploy |
| **M** | Functional | Tests a nivel de feature | 5-30 min | Cada PR, antes del merge |
| **L** | Regression | Full feature + integration | 30-120 min | Release candidates, nightly |
| **XL** | Full Regression | Complete system, end-to-end | 2+ hours | Major releases, quarterly |

## Criterios de clasificación

### S (Smoke) Tests

**Qué**: El mínimo absoluto para verificar que el sistema no esté roto.

**Criteria**:
- Critical path (login, core navigation, key transactions)
- Takes < 5 minutes total
- Must pass before ANY deployment
- Fail = system is down

**Examples**:
- User can log in
- Homepage loads
- API health check passes
- Database connection works

### M (Functional) Tests

**Qué**: Tests a nivel de feature que cubren user stories o requisitos específicos.

**Criteria**:
- Covers individual features end-to-end
- Takes 5-30 minutes total
- Runs on every PR to catch regressions early
- Fail = feature is broken

**Examples**:
- User can complete registration flow
- Search returns correct results
- Shopping cart calculations are correct
- Email notifications send successfully

### L (Regression) Tests

**Qué**: Tests completos que cubren múltiples features y sus interacciones.

**Criteria**:
- Cross-feature integration tests
- Takes 30-120 minutes total
- Runs on release candidates and nightly builds
- Fail = regression detected

**Examples**:
- Full checkout flow with payment
- User management (CRUD + permissions)
- Data export/import across modules
- Third-party integrations

### XL (Full Regression) Tests

**Qué**: Test completo del sistema que incluye todas las features, edge cases y tests no funcionales.

**Criteria**:
- Everything in S + M + L
- Plus performance, security, accessibility
- Takes 2+ hours total
- Runs before major releases

**Examples**:
- Complete application walkthrough
- Performance benchmarks
- Security scan
- Accessibility audit

## Formato de salida de clasificación

```markdown
# Test Classification: {Feature/Project}

## Resumen

| Clase | Cantidad | Tiempo estimado | Trigger | Propósito |
|-------|-------|-----------|---------|---------|
| S | {N} | {X} min | Cada commit | Verificación del camino crítico |
| M | {N} | {X} min | Cada PR | Testing a nivel de feature |
| L | {N} | {X} min | Candidato a release | Detección de regresiones |
| XL | {N} | {X} min | Release mayor | Validación completa del sistema |

## S Tests (Smoke)
- {TC-XXX}: {Title}
- {TC-XXX}: {Title}

## M Tests (Functional)
- {TC-XXX}: {Title}
- {TC-XXX}: {Title}

## L Tests (Regression)
- {TC-XXX}: {Title}
- {TC-XXX}: {Title}

## XL Tests (Full Regression)
- {TC-XXX}: {Title}
- {TC-XXX}: {Title}

## Integración CI/CD

| Etapa del pipeline | Tests | Timeout | Ante fallo |
|---------------|-------|---------|------------|
| Pre-commit | S | 5 min | Bloquear commit |
| Validación de PR | S + M | 30 min | Bloquear merge |
| Candidato a release | S + M + L | 2 horas | Bloquear release |
| Release mayor | S + M + L + XL | 4 horas | Revisión manual |
```

## Heurísticas de clasificación

When classifying a test case, consider:

1. **Is it on the critical path?** → S (if yes and fast enough)
2. **Does it test a specific feature?** → M
3. **Does it cross feature boundaries?** → L
4. **Is it comprehensive/system-wide?** → XL
5. **How long does it take?** → Adjust class if time doesn't fit
6. **How often does it fail?** → Frequently failing tests should be S or M (catch early)

## Ejemplo de entrada

```
Test cases for an e-commerce checkout:
- TC-001: User can view cart (P1)
- TC-002: Cart total calculates correctly (P1)
- TC-003: User can apply discount code (P2)
- TC-004: User can enter shipping address (P1)
- TC-005: User can select shipping method (P2)
- TC-006: Payment processing with valid card (P1)
- TC-007: Payment declined handling (P1)
- TC-008: Order confirmation email sends (P2)
- TC-009: Inventory decreases after purchase (P2)
- TC-010: Full checkout flow E2E (P1)
- TC-011: Checkout with multiple items (P2)
- TC-012: Checkout performance under load (P3)
```

## Ejemplo de salida

```markdown
# Test Classification: E-Commerce Checkout

## Summary

| Clase | Cantidad | Tiempo estimado | Trigger | Propósito |
|-------|-------|-----------|---------|---------|
| S | 2 | 2 min | Cada commit | Carga del carrito, pago funcional |
| M | 6 | 12 min | Cada PR | Checkout a nivel de feature |
| L | 3 | 25 min | Candidato a release | Flujos de integración |
| XL | 1 | 45 min | Major release | Full E2E + performance |

## S Tests (Smoke)
- TC-001: User can view cart
- TC-006: Payment processing with valid card

## M Tests (Functional)
- TC-002: Cart total calculates correctly
- TC-004: User can enter shipping address
- TC-005: User can select shipping method
- TC-007: Payment declined handling
- TC-011: Checkout with multiple items
- TC-008: Order confirmation email sends

## L Tests (Regression)
- TC-003: User can apply discount code
- TC-009: Inventory decreases after purchase
- TC-010: Full checkout flow E2E

## XL Tests (Full Regression)
- TC-012: Checkout performance under load

## CI/CD Integration

| Etapa del pipeline | Tests | Timeout | Ante fallo |
|---------------|-------|---------|------------|
| Pre-commit | S (TC-001, TC-006) | 5 min | Bloquear commit |
| Validación de PR | S + M (8 tests) | 15 min | Bloquear merge |
| Candidato a release | S + M + L (11 tests) | 45 min | Bloquear release |
| Release mayor | Todos (12 tests) | 60 min | Revisión manual |
```
