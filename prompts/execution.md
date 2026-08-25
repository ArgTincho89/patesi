# Patesi — Reglas de Ejecución

Este archivo define las reglas específicas para generar cada tipo de output.

---

## Generación de Estrategia de Testing

### Estructura (9 secciones obligatorias)

1. **Alcance** — Qué se testeá, qué no, por qué
2. **Niveles de testing** — Unit, integration, system, acceptance — cuáles aplican
3. **Tipos de testing** — Functional, NF, security, performance, accessibility — cuáles aplican
4. **Riesgos** — Top riesgos y cómo se abordan
5. **Criterios de salida** — Qué define "listo para producción"
6. **Entorno** — Requerimientos de entorno de testing
7. **Automatización** — Qué se automatiza, qué no, por qué
8. **Roles** — Quién hace qué
9. **Mitigaciones** — Qué hacer si algo sale mal

### Validación SQEM (Modo A)

Antes de presentar, validá contra SQEM:
- ¿El alcance cubre los controles requeridos por NAQ?
- ¿Los niveles de testing son apropiados para la tipología?
- ¿Los criterios de salida cumplen con las puertas de calidad?
- ¿Faltan entregables obligatorios?

---

## Generación de Análisis de Riesgos

### Matriz Ponderada (5 factores)

| Factor | Peso |
|--------|------|
| Impacto de negocio | 30% |
| Complejidad técnica | 25% |
| Frecuencia de cambio | 20% |
| Brecha de conocimiento | 15% |
| Dependencias | 10% |

### Output

Para cada riesgo:
- **Descripción**: Qué podría fallar
- **Impacto**: Consecuencia de negocio
- **Probabilidad**: Qué tan probable es
- **Puntaje**: Cálculo ponderado (0-100)
- **Prioridad**: P1 (crítico) / P2 (alto) / P3 (medio) / P4 (bajo)
- **Mitigación**: Qué hacer para reducir el riesgo
- **Tests recomendados**: Qué testear para cubrir este riesgo

---

## Generación de Casos de Prueba

### Formato TC-XXX

```
TC-XXX: [Título del caso]
- Precondiciones: [Qué debe ser verdad antes]
- Steps: [Pasos numerados]
- Expected result: [Resultado esperado]
- Priority: [P1/P2/P3/P4]
- Automation candidate: [Sí/No + justificación]
```

### Organización (OBLIGATORIA)

Siempre presentar por tres categorías:
1. **Happy path** — Flujo principal de éxito
2. **Unhappy path** — Inputs inválidos, fallos, errores
3. **Corner cases** — Boundary values, concurrencia, edge cases

### Priorización

| Prioridad | Cuándo |
|-----------|--------|
| **P1** | Crítico para negocio, happy path principal |
| **P2** | Importante, unhappy path principal |
| **P3** | Normal, edge cases importantes |
| **P4** | Bajo, edge cases raros |

---

## Generación de Clasificación de Tests (S/M/L/XL)

### Criterios

| Tamaño | Complejidad | Tiempo estimado | Dependencias |
|--------|-------------|----------------|--------------|
| **S** | Baja | <30 min | Ninguna |
| **M** | Media | 30-120 min | 1-2 |
| **L** | Alta | 2-8 hours | 3-5 |
| **XL** | Muy alta | >8 hours | >5 |

### Suite de Ejecución

| Suite | Cuándo correr | Ejecución |
|-------|---------------|-----------|
| **S** | Cada commit | Automática |
| **M** | Cada PR | Automática |
| **L** | Cada merge a main | Semi-automática |
| **XL** | Pre-release | Manual + automatizada |

---

## Generación de Framework Playwright

### Estructura

```
tests/
├── pages/           # Page Objects
│   ├── BasePage.ts
│   └── [PageName].ts
├── fixtures/        # Fixtures y test data
│   └── test-fixtures.ts
├── specs/           # Test cases
│   └── [feature].spec.ts
└── utils/           # Helpers
    └── test-utils.ts
```

### Reglas

- TypeScript estricto (no `any`)
- Page Object Model para UI tests
- Fixtures para test data
- Assertions con expect() nativo
- Tags para prioridad y tipo

---

## Generación de CI/CD

### Estructura por Pipeline

```yaml
name: [Nombre del pipeline]
on: [Trigger]
jobs:
  [job-name]:
    steps:
      - Checkout
      - Setup
      - Install
      - Lint
      - Unit tests
      - Integration tests
      - E2E tests (si aplica)
      - Report
```

### Reglas

- GitHub Actions como default (más común)
- GitLab CI como alternativa
- Jenkins cuando el usuario lo pida
- Incluir caching de dependencias
- Incluir reportes de cobertura
- Incluir notifications

---

## Generación de Análisis de MR

### Estructura

1. **Resumen** — Qué cambió este MR
2. **Archivos afectados** — Lista con impacto
3. **Tests impactados** — Qué tests se ven afectados
4. **Riesgos** — Qué podría romperse
5. **Recomendaciones** — Qué tests agregar/ejecutar
6. **Checklist** — Steps para verificar antes de merge

---

## Generación SQEM

### Clasificación NAQ

1. Colectar 5 factores (0-4 cada uno)
2. Calcular NAQ con fórmula
3. Aplicar overrides
4. Derivar delivery target
5. Listar gates aplicables
6. Listar controles obligatorios

### Evaluación de Gates

1. Identificar gate actual
2. Listar criterios del gate
3. Evaluar cada criterio (PASS/WARNING/FAIL/N/A)
4. Identificar gaps
5. Recomendar acciones
6. Dar veredicto final
