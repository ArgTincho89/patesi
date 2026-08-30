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
| **Componente** | Componente o módulo de software individual | Desarrolladores | Tests unitarios, tests de integración de componentes |
| **Integración** | Interacciones entre componentes integrados | Desarrolladores + testers | Tests de API, tests de interfaz, contract tests |
| **Sistema** | Sistema completo integrado | Testers | Tests end-to-end, tests funcionales, tests de sistema |
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

Dividí los datos de entrada en particiones donde el sistema trata de forma equivalente a todos los valores de una misma partición.

**Ejemplo**: campo de edad que acepta 18-65
- Inválido: < 18 (partición 1)
- Válido: 18-65 (partición 2)
- Inválido: > 65 (partición 3)

### Boundary Value Analysis (BVA)

Probá en los límites entre particiones, donde se concentran los defectos.

**Ejemplo**: campo de edad que acepta 18-65
- Valores de test: 17, 18, 19, 64, 65, 66
- Para casos multidimensionales: probar combinaciones en los límites

### Decision Tables

Modelá reglas de negocio con condiciones y acciones.

| Regla | R1 | R2 | R3 | R4 |
|------|----|----|----|----|
| **Condición 1**: cliente VIP | S | S | N | N |
| **Condición 2**: pedido > $100 | S | N | S | N |
| **Acción**: descuento | 20% | 10% | 5% | 0% |

### State Transition Testing

Modelá el comportamiento del sistema como estados con transiciones disparadas por eventos.

```
[Idle] --login--> [Authenticated] --logout--> [Idle]
[Authenticated] --timeout--> [Locked]
[Locked] --reset--> [Idle]
```

### Use Case Testing

Derivá casos de prueba desde casos de uso o user stories. Enfocate en el escenario principal de éxito, los flujos alternativos y los flujos de excepción.

## Técnicas de caja blanca

| Técnica | Criterio de cobertura | Qué mide |
|-----------|-------------------|------------------|
| **Statement** | Cada sentencia ejecutable | Cobertura mínima |
| **Decision (Branch)** | Cada resultado de decisión (V/F) | Cobertura de ramas |
| **MC/DC** | Cada condición afecta la decisión de forma independiente | Modified Condition/Decision Coverage |
| **Path** | Cada camino de ejecución posible | Cobertura máxima (a menudo impracticable) |

## Técnicas de diseño de tests

### Error Guessing

Usá la experiencia para intuir dónde es más probable que haya defectos. Objetivos habituales:
- Valores de borde
- Entradas nulas o vacías
- Caracteres especiales
- Transiciones de fecha (fin de mes, fin de año)
- Agotamiento de recursos

### Exploratory Testing

Aprendizaje, diseño y ejecución de tests en simultáneo. Usá charters para guiar la exploración:
- **Explorar** [feature] **con** [datos/configuración] **para descubrir** [riesgos]

### Checklist-Based Testing

Usá checklists derivados de:
- Categorías comunes de defectos
- Requisitos regulatorios
- Heurísticas (por ejemplo, FEW HICCUPPS)

## Consideraciones de automatización de tests

| Factor | Automatizar | No automatizar |
|--------|-------------|----------------|
| Repetitivo | ✅ Sí | |
| Alto riesgo | ✅ Sí | |
| Data-driven | ✅ Sí | |
| Exploratorio | | ❌ No |
| Usabilidad | | ❌ No |
| Tests de una sola vez | | ❌ No |
| Creatividad/criterio | | ❌ No |

## Gestión de defectos

| Fase | Actividad |
|-------|----------|
| **Identificación** | Detectar y reportar el defecto |
| **Clasificación** | Severidad, prioridad, tipo |
| **Investigación** | Análisis de causa raíz |
| **Resolución** | Corrección o workarounds |
| **Verificación** | Confirmar que la corrección funciona |
| **Cierre** | Cerrar el reporte de defecto |

### Taxonomía de defectos

| Categoría | Ejemplos |
|----------|----------|
| Requisitos | Ambiguos, faltantes, contradictorios |
| Arquitectura | Fallos de diseño, problemas de integración |
| Código | Errores de lógica, excepciones en tiempo de ejecución |
| Entorno | Configuración, compatibilidad |
| Datos | Corrupción, formato, migración |

## Técnicas de estimación de tests

| Técnica | Descripción | Cuándo usarla |
|-----------|-------------|-------------|
| **Wideband Delphi** | Consenso de expertos mediante estimación iterativa | Features complejas, estimación en equipo |
| **Three-point** | Optimista + Más probable + Pesimista | Cuando la incertidumbre es alta |
| **Function Point** | Basada en la complejidad funcional | Sistemas grandes con datos históricos disponibles |
| **Use Case Points** | Derivada de la complejidad de los casos de uso | Proyectos guiados por casos de uso |
| **Story Points** | Estimación ágil (dimensionamiento relativo) | Equipos ágiles con datos de velocity |
