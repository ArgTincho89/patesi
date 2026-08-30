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
| Impacto de negocio | {X} | 30% | {X × 0.30} |
| Complejidad técnica | {X} | 25% | {X × 0.25} |
| Frecuencia de cambio | {X} | 20% | {X × 0.20} |
| Brecha de cobertura de tests | {X} | 15% | {X × 0.15} |
| Riesgo de dependencias | {X} | 10% | {X × 0.10} |
| **Total** | | | **{suma}** |

## Nivel de riesgo: {🔴 ALTO / 🟡 MEDIO / 🟢 BAJO}

## Enfoque de testing recomendado

{Recomendaciones de testing concretas según el nivel de riesgo y los puntajes por factor}

## Riesgos clave identificados

| # | Riesgo | Factor | Severidad | Mitigación |
|---|--------|--------|-----------|------------|
| 1 | {Descripción del riesgo} | {Qué factor lo detectó} | Alta/Media/Baja | {Cómo mitigarlo} |
| 2 | {Descripción del riesgo} | {Qué factor lo detectó} | Alta/Media/Baja | {Cómo mitigarlo} |

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
Feature: procesamiento de pagos con integración de Stripe
- Gestiona pagos con tarjeta de crédito
- Se integra con la API de Stripe
- Almacena registros de transacciones
- Sin cobertura de tests existente (feature nueva)
```

### Salida

```markdown
# Análisis de riesgos: Procesamiento de pagos

## Resumen

| Factor | Puntaje (1-5) | Peso | Ponderado |
|--------|---------------|------|-----------|
| Impacto de negocio | 5 | 30% | 1.50 |
| Complejidad técnica | 4 | 25% | 1.00 |
| Frecuencia de cambio | 3 | 20% | 0.60 |
| Brecha de cobertura de tests | 5 | 15% | 0.75 |
| Riesgo de dependencias | 4 | 10% | 0.40 |
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

| # | Riesgo | Factor | Severidad | Mitigación |
|---|--------|--------|-----------|------------|
| 1 | Pérdida financiera por errores de pago | Impacto de negocio | Alta | Suite de tests exhaustiva + monitoreo |
| 2 | Cambios en la API de Stripe rompen la integración | Riesgo de dependencias | Alta | Contract tests, fijar la versión de Stripe |
| 3 | No hay cobertura de tests existente | Brecha de cobertura | Alta | Escribir tests antes de implementar (TDD) |
| 4 | Escenarios complejos de manejo de errores | Complejidad técnica | Media | Mapear todos los códigos de error de Stripe y testear cada uno |

## Priorización de tests

| Prioridad | Tipo de test | Justificación |
|----------|-----------|-----------|
| P1 | Tests unitarios del cálculo de pagos | Lógica central, tiene que ser correcta |
| P1 | Tests de integración con Stripe (modo test) | Punto de integración crítico |
| P1 | Manejo de errores (rechazo, timeout) | Impacto financiero |
| P2 | Almacenamiento de registros de transacciones | Integridad de datos |
| P2 | Manejo de webhooks | Eventos asincrónicos |
| P3 | Performance bajo carga | Picos de pagos |
| P3 | Auditoría de seguridad | Cumplimiento PCI |
```
