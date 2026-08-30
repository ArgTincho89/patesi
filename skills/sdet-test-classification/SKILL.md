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
| **L** | Regression | Feature completa + integración | 30-120 min | Candidatos a release, builds nocturnos |
| **XL** | Full Regression | Sistema completo, end-to-end | 2 horas o más | Releases mayores, trimestrales |

## Criterios de clasificación

### S (Smoke) Tests

**Qué**: El mínimo absoluto para verificar que el sistema no esté roto.

**Criterios**:
- Camino crítico (login, navegación principal, transacciones clave)
- Tarda menos de 5 minutos en total
- Debe pasar antes de CUALQUIER despliegue
- Fallo = el sistema está caído

**Ejemplos**:
- El usuario puede iniciar sesión
- La home carga
- El health check de la API pasa
- La conexión a la base de datos funciona

### M (Functional) Tests

**Qué**: Tests a nivel de feature que cubren user stories o requisitos específicos.

**Criterios**:
- Cubre features individuales de punta a punta
- Tarda entre 5 y 30 minutos en total
- Se ejecuta en cada PR para detectar regresiones temprano
- Fallo = la feature está rota

**Ejemplos**:
- El usuario puede completar el flujo de registro
- La búsqueda devuelve resultados correctos
- Los cálculos del carrito de compras son correctos
- Las notificaciones por email se envían correctamente

### L (Regression) Tests

**Qué**: Tests completos que cubren múltiples features y sus interacciones.

**Criterios**:
- Tests de integración entre features
- Tarda entre 30 y 120 minutos en total
- Se ejecuta en candidatos a release y builds nocturnos
- Fallo = regresión detectada

**Ejemplos**:
- Flujo completo de checkout con pago
- Gestión de usuarios (CRUD + permisos)
- Exportación/importación de datos entre módulos
- Integraciones con terceros

### XL (Full Regression) Tests

**Qué**: Test completo del sistema que incluye todas las features, edge cases y tests no funcionales.

**Criterios**:
- Todo lo de S + M + L
- Más performance, seguridad y accesibilidad
- Tarda 2 horas o más en total
- Se ejecuta antes de releases mayores

**Ejemplos**:
- Recorrido completo de la aplicación
- Benchmarks de performance
- Escaneo de seguridad
- Auditoría de accesibilidad

## Formato de salida de clasificación

```markdown
# Clasificación de tests: {Feature/Proyecto}

## Resumen

| Clase | Cantidad | Tiempo estimado | Trigger | Propósito |
|-------|-------|-----------|---------|---------|
| S | {N} | {X} min | Cada commit | Verificación del camino crítico |
| M | {N} | {X} min | Cada PR | Testing a nivel de feature |
| L | {N} | {X} min | Candidato a release | Detección de regresiones |
| XL | {N} | {X} min | Release mayor | Validación completa del sistema |

## S Tests (Smoke)
- {TC-XXX}: {Título}
- {TC-XXX}: {Título}

## M Tests (Functional)
- {TC-XXX}: {Título}
- {TC-XXX}: {Título}

## L Tests (Regression)
- {TC-XXX}: {Título}
- {TC-XXX}: {Título}

## XL Tests (Full Regression)
- {TC-XXX}: {Título}
- {TC-XXX}: {Título}

## Integración CI/CD

| Etapa del pipeline | Tests | Timeout | Ante fallo |
|---------------|-------|---------|------------|
| Pre-commit | S | 5 min | Bloquear commit |
| Validación de PR | S + M | 30 min | Bloquear merge |
| Candidato a release | S + M + L | 2 horas | Bloquear release |
| Release mayor | S + M + L + XL | 4 horas | Revisión manual |
```

## Heurísticas de clasificación

Al clasificar un caso de prueba, considerá:

1. **¿Está en el camino crítico?** → S (si es así y es lo bastante rápido)
2. **¿Prueba una feature específica?** → M
3. **¿Cruza los límites entre features?** → L
4. **¿Es exhaustivo o abarca todo el sistema?** → XL
5. **¿Cuánto tarda?** → Ajustá la clase si el tiempo no encaja
6. **¿Con qué frecuencia falla?** → Los tests que fallan seguido deberían ser S o M (detección temprana)

## Ejemplo de entrada

```
Casos de prueba para el checkout de un comercio electrónico:
- TC-001: El usuario puede ver el carrito (P1)
- TC-002: El total del carrito se calcula correctamente (P1)
- TC-003: El usuario puede aplicar un código de descuento (P2)
- TC-004: El usuario puede ingresar la dirección de envío (P1)
- TC-005: El usuario puede seleccionar el método de envío (P2)
- TC-006: Procesamiento de pago con tarjeta válida (P1)
- TC-007: Manejo de pago rechazado (P1)
- TC-008: Se envía el email de confirmación del pedido (P2)
- TC-009: El inventario disminuye tras la compra (P2)
- TC-010: Flujo completo de checkout E2E (P1)
- TC-011: Checkout con varios ítems (P2)
- TC-012: Performance del checkout bajo carga (P3)
```

## Ejemplo de salida

```markdown
# Clasificación de tests: checkout de comercio electrónico

## Resumen

| Clase | Cantidad | Tiempo estimado | Trigger | Propósito |
|-------|-------|-----------|---------|---------|
| S | 2 | 2 min | Cada commit | Carga del carrito, pago funcional |
| M | 6 | 12 min | Cada PR | Checkout a nivel de feature |
| L | 3 | 25 min | Candidato a release | Flujos de integración |
| XL | 1 | 45 min | Release mayor | E2E completo + performance |

## S Tests (Smoke)
- TC-001: El usuario puede ver el carrito
- TC-006: Procesamiento de pago con tarjeta válida

## M Tests (Functional)
- TC-002: El total del carrito se calcula correctamente
- TC-004: El usuario puede ingresar la dirección de envío
- TC-005: El usuario puede seleccionar el método de envío
- TC-007: Manejo de pago rechazado
- TC-011: Checkout con varios ítems
- TC-008: Se envía el email de confirmación del pedido

## L Tests (Regression)
- TC-003: El usuario puede aplicar un código de descuento
- TC-009: El inventario disminuye tras la compra
- TC-010: Flujo completo de checkout E2E

## XL Tests (Full Regression)
- TC-012: Performance del checkout bajo carga

## Integración CI/CD

| Etapa del pipeline | Tests | Timeout | Ante fallo |
|---------------|-------|---------|------------|
| Pre-commit | S (TC-001, TC-006) | 5 min | Bloquear commit |
| Validación de PR | S + M (8 tests) | 15 min | Bloquear merge |
| Candidato a release | S + M + L (11 tests) | 45 min | Bloquear release |
| Release mayor | Todos (12 tests) | 60 min | Revisión manual |
```
