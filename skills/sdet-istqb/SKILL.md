---
name: sdet-istqb
description: >
  Referencia de conocimiento de ISTQB Foundation y Advanced Core.
  Trigger: terminología ISTQB, niveles de testing, técnicas, certificación, estándares
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-sdet
---

# Referencia de conocimiento ISTQB

Referencia condensada de los syllabi ISTQB Foundation Level v4.0 y Advanced Core. Usala para responder preguntas sobre metodología, terminología y técnicas de testing.

## Proceso de testing

El proceso de testing de ISTQB consta de actividades de planificación, monitoreo, control, análisis, diseño, implementación, ejecución y finalización. Son iterativas y pueden superponerse.

| Actividad | Propósito | Salidas clave |
|----------|---------|-------------|
| **Planificación** | Define alcance, enfoque y recursos | Plan de tests, criterios de entrada/salida |
| **Monitoreo** | Seguir el progreso frente al plan | Informes de estado, métricas |
| **Control** | Tomar acciones correctivas | Retrabajo, repriorización |
| **Análisis** | Entender qué probar | Condiciones de test, requisitos |
| **Diseño** | Determinar cómo probar | Casos de prueba, procedimientos de test |
| **Implementación** | Preparar la ejecución | Scripts de tests, datos de test, entorno |
| **Ejecución** | Ejecutar tests y registrar resultados | Resultados de tests, defectos |
| **Finalización** | Finalizar y registrar lecciones aprendidas | Informes resumidos, cierre |

## Niveles de testing

| Nivel | Alcance | Quién prueba | Actividades habituales |
|-------|-------|-----------|-------------------|
| **Component** | Individual software component/module | Developers | Unit tests, component integration tests |
| **Integration** | Interactions between integrated components | Developers + Testers | API tests, interface tests, contract tests |
| **System** | Complete integrated system | Testers | End-to-end tests, functional tests, system tests |
| **Aceptación** | Sistema frente a los requisitos de negocio | Usuarios + testers | UAT, testing alfa/beta, tests de aceptación |

## Tipos de testing

| Tipo | Qué prueba | Ejemplos |
|------|--------------|----------|
| **Funcional** | Qué hace el sistema | Login, búsqueda, checkout, cálculos |
| **No funcional** | Qué tan bien funciona el sistema | Rendimiento, seguridad, usabilidad, confiabilidad |
| **Estructural** | Estructura interna del código | Cobertura de código, testing de caminos y ramas |
| **Relacionada con cambios** | Impacto de los cambios | Regresión, confirmación, testing de confirmación |

## Técnicas de caja negra

### Equivalence Partitioning (EP)

Divide input data into partitions where all values in a partition are treated equivalently by the system.

**Ejemplo**: campo de edad que acepta 18-65
- Inválido: < 18 (partición 1)
- Válido: 18-65 (partición 2)
- Inválido: > 65 (partición 3)

### Boundary Value Analysis (BVA)

Test at boundaries between partitions, where defects cluster.

**Ejemplo**: campo de edad que acepta 18-65
- Valores de test: 17, 18, 19, 64, 65, 66
- Para casos multidimensionales: probar combinaciones en los límites

### Decision Tables

Model business rules with conditions and actions.

| Rule | R1 | R2 | R3 | R4 |
|------|----|----|----|----|
| **Condition 1**: VIP customer | Y | Y | N | N |
| **Condition 2**: Order > $100 | Y | N | Y | N |
| **Action**: Discount | 20% | 10% | 5% | 0% |

### State Transition Testing

Model system behavior as states with transitions triggered by events.

```
[Idle] --login--> [Authenticated] --logout--> [Idle]
[Authenticated] --timeout--> [Locked]
[Locked] --reset--> [Idle]
```

### Use Case Testing

Derive test cases from use cases or user stories. Focus on main success scenario, alternative flows, and exception flows.

## Técnicas de caja blanca

| Técnica | Criterio de cobertura | Qué mide |
|-----------|-------------------|------------------|
| **Statement** | Every executable statement | Minimum coverage |
| **Decision (Branch)** | Every decision outcome (T/F) | Branch coverage |
| **MC/DC** | Each condition independently affects decision | Modified Condition/Decision Coverage |
| **Path** | Every possible execution path | Maximum coverage (often impractical) |

## Técnicas de diseño de tests

### Error Guessing

Use experience to guess where defects are most likely. Common targets:
- Boundary values
- Null/empty inputs
- Special characters
- Date transitions (month-end, year-end)
- Resource exhaustion

### Exploratory Testing

Simultaneous learning, test design, and execution. Use charters to guide exploration:
- **Explore** [feature] **with** [data/config] **to discover** [risks]

### Checklist-Based Testing

Usá checklists derivados de:
- Common defect categories
- Requisitos regulatorios
- Heuristics (e.g., FEW HICCUPPS)

## Consideraciones de automatización de tests

| Factor | Automate | Don't Automate |
|--------|----------|----------------|
| Repetitive | ✅ Yes | |
| High risk | ✅ Yes | |
| Data-driven | ✅ Yes | |
| Exploratory | | ❌ No |
| Usability | | ❌ No |
| One-time tests | | ❌ No |
| Creative/judgment | | ❌ No |

## Gestión de defectos

| Phase | Activity |
|-------|----------|
| **Identification** | Detect and report defect |
| **Classification** | Severity, priority, type |
| **Investigation** | Root cause analysis |
| **Resolution** | Fix or workarounds |
| **Verification** | Confirm fix works |
| **Closure** | Close defect report |

### Defect Taxonomy

| Category | Examples |
|----------|----------|
| Requisitos | Ambiguos, faltantes, contradictorios |
| Architecture | Design flaws, integration issues |
| Code | Logic errors, runtime exceptions |
| Entorno | Configuración, compatibilidad |
| Data | Corruption, format, migration |

## Técnicas de estimación de tests

| Técnica | Descripción | Cuándo usarla |
|-----------|-------------|-------------|
| **Wideband Delphi** | Expert consensus through iterative estimation | Complex features, team estimation |
| **Three-point** | Optimistic + Most Likely + Pessimistic | When uncertainty is high |
| **Function Point** | Based on functional complexity | Large systems, historical data available |
| **Use Case Points** | Derived from use case complexity | Use case-driven projects |
| **Story Points** | Agile estimation (relative sizing) | Agile teams with velocity data |
