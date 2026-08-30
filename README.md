# 🧪 Patesi

**Agente SDET de IA** — Ingeniero QA con conocimiento ISTQB y SQEM, estrategia de testing, automatización, análisis de riesgos y aprendizaje por proyecto.

Soporta exactamente **opencode** y **GitHub Copilot**.

---

## Qué es Patesi

Patesi es un agente de IA especializado en Quality Engineering. No es un chatbot genérico con conocimiento de testing — es un **ingeniero SDET senior** que:

- Aplica **ISTQB Foundation v4.0 + Advanced Core** como base metodológica
- Ejecuta el **SQEM (Seidor Quality Engineering Model)** cuando trabaja en proyectos Seidor
- Genera estrategias, casos de prueba, análisis de riesgos, automatización y pipelines CI/CD
- **Aprende** las convenciones de tu proyecto y las aplica consistentemente
- Se adapta a tres modos de operación según el contexto del proyecto

---

## Los Tres Modos de Operación

Toda sesión empieza con una única pregunta:

> **¿Vamos a trabajar sobre un proyecto de Seidor, un proyecto personal o de un cliente?**

De la respuesta salen tres formas de trabajar distintas. **Los tres modos tienen el mismo peso**: ninguno es el modo por defecto y Patesi nunca asume cuál corresponde.

### Modo A — Proyecto Seidor

El **SQEM es la referencia absoluta**. ISTQB complementa pero nunca reemplaza.

```
Usuario: "Creame una estrategia de testing para el módulo de pagos"
Patesi: → Recorre los factores de NAQ → Deriva delivery target
         → Genera estrategia validada contra SQEM, citando sección
```

Cada recomendación cita la sección SQEM aplicable. Si el usuario propone algo que viola SQEM, Patesi lo señala y pide excepción formal.

### Modo B — Proyecto Personal

**Las buenas prácticas de la industria son la referencia primaria**, apoyadas en el cuerpo de conocimiento de ISTQB. SQEM no aplica y no se menciona.

Lo que distingue a este modo es el **contrato docente**: cada recomendación explica el porqué, para que el usuario aprenda el criterio y no solo reciba la conclusión.

Se apoya en `sdet-industry-practices` (práctica moderna de ingeniería), `sdet-istqb` (técnicas y terminología) y `sdet-exploratory-testing` (cuando el producto es nuevo o desconocido), más los skills de área: `sdet-api-testing`, `sdet-accessibility`, `sdet-performance` y `sdet-security-testing`. ISTQB aporta el nombre de la técnica; industria aporta cómo se aplica hoy.

Dos reglas que evitan que el contrato docente se vuelva ruido: **se enseña una vez y después se referencia** —lo ya explicado queda registrado y no se repite—, y **la ceremonia se ajusta al riesgo real**: una estrategia de Modo B tiene un núcleo de 5 secciones, no 9.

Ejemplo completo de una sesión bien ejecutada: [examples/interaccion-modo-b.md](examples/interaccion-modo-b.md).

```
Usuario: "Analizá los riesgos de mi app de recetas"
Patesi: → Matriz de riesgos ponderada, explicando por qué cada factor pesa lo que pesa
         → Nombra las técnicas que aplica y qué hace cada una
         → Ajusta la ceremonia al riesgo real del proyecto
```

**La decisión final siempre es del usuario.** Si elegís un camino distinto al recomendado, Patesi explica el riesgo concreto una vez, ofrece la mitigación más barata y después hace exactamente lo que pediste, completo. Sin repetir la advertencia ni entregar trabajo degradado.

### Modo C — Proyecto de un Cliente

El framework de calidad del cliente tiene prioridad sobre todo lo demás. Patesi indaga cómo trabaja ese cliente, **lo registra en un perfil vivo y lo actualiza en cada iteración**.

```
Usuario: "Preparemos la estrategia de pruebas para el cliente Acme"
Patesi: → ¿Existe perfil de Acme? Lo carga y confirma qué sabe
         → Lo que Acme no define lo cubre con ISTQB, declarándolo como fallback
         → Todo dato nuevo sobre Acme queda registrado en el momento
```

Regla clave: **todo hueco del framework del cliente se cubre con buenas prácticas de ISTQB y se declara como tal.** Patesi nunca presenta una suposición como si fuera norma del cliente.

La iteración 10 con un cliente es mejor que la 1 porque Patesi ya no vuelve a preguntar lo que aprendió.

Si el cliente entrega documentación de calidad, `sdet-client-onboarding` la convierte en un perfil inicial poblado; el mantenimiento continuo lo lleva `sdet-client-profile`. Regla de ambos: **un documento del cliente no es lo mismo que una regla confirmada del cliente** — lo que se deduce por interpretación queda como fallback hasta que el usuario lo confirme.

---

## Flujo de Sesión

Al iniciar una sesión, Patesi ejecuta este protocolo:

```
1. ¿Existe contexto del proyecto?
   ├── SÍ → Lo cargo, confirmo: "Trabajando en {proyecto}. Modo: {modo}. ¿Continuamos?"
   └── NO → Pregunto:

2. "¿Vamos a trabajar sobre un proyecto de Seidor,
    un proyecto personal o de un cliente?"
   ├── Seidor  → Modo A → Clasificación NAQ según sdet-sqem-classification
   ├── Personal → Modo B → Industria + ISTQB, con contrato docente activo
   └── Cliente  → Modo C → Cargo sdet-client-profile, elicito y registro

3. Guardo el contexto del modo en memoria
   ├── A → qa-patterns/{proyecto}/sqem-classification
   ├── B → qa-patterns/{proyecto}/context
   └── C → qa-patterns/{proyecto}/client-profile

4. LISTO — Preparado para trabajar
```

Patesi **nunca asume el modo**: no lo deduce del nombre del repo, del stack ni del tipo de tarea. Si la respuesta es ambigua, repregunta.

### Clasificación NAQ (Proyectos Seidor)

En proyectos Seidor, Patesi obtiene NAQ y tipologías usando el contenido especializado de `sdet-sqem-classification`. De esa clasificación deriva el delivery target, las puertas, los controles, los umbrales y los entregables; la fórmula y las reglas vigentes viven en ese skill.

La NAQ tiene cuatro overrides reales:

1. Criticidad de negocio = 4 **o** sensibilidad de datos = 4.
2. Criticidad de negocio >= 3 **y** sensibilidad de datos >= 3.
3. Impacto en la seguridad de personas, violación legal grave o continuidad operativa crítica.
4. Sistema de IA de alto riesgo según EU AI Act.

Las reglas completas y la precedencia están en `sdet-sqem-classification`.

---

## Arquitectura

```
patesi/
│
├── agent.md                         Núcleo: identidad, personalidad y principios
├── system.md                        Núcleo: comportamiento y protocolos agnósticos
├── config.yaml                      Núcleo: configuración y catálogo de conocimiento
│
├── skills/                          Conocimiento especializado del núcleo
│   │
│   │  ── Núcleo de QA ──
│   ├── sdet-istqb/                  Referencia ISTQB Foundation + Advanced
│   ├── sdet-test-strategy/          Generador de estrategias (9 secc. / 5 en Modo B)
│   ├── sdet-risk-analysis/          Matriz ponderada de riesgos (5 factores)
│   ├── sdet-test-cases/             Generador TC-XXX con happy/unhappy/corner
│   ├── sdet-test-classification/    Clasificador S/M/L/XL para CI/CD
│   ├── sdet-mr-analysis/            Análisis de impacto en MRs/PRs (4 factores)
│   ├── sdet-project-learning/       Aprendizaje de patrones (persistencia según entorno)
│   ├── sdet-industry-practices/     Práctica moderna: suite, flaky, datos, contratos
│   ├── sdet-exploratory-testing/    SBTM: charters, heurísticas, notas de sesión
│   ├── sdet-api-testing/            REST y GraphQL: contrato, códigos, idempotencia
│   ├── sdet-accessibility/          WCAG, teclado, lectores de pantalla
│   ├── sdet-performance/            Carga, estrés, soak, percentiles
│   ├── sdet-security-testing/       OWASP Top 10, control de acceso, SAST/DAST/SCA
│   │
│   │  ── Modo C (cliente) ──
│   ├── sdet-client-profile/         Perfil vivo del cliente + fallback declarado
│   ├── sdet-client-onboarding/      Arranque desde la documentación del cliente
│   │
│   │  ── Frameworks de automatización ──
│   ├── sdet-automation/             Playwright por defecto + TypeScript + POM
│   ├── sdet-automation-cypress/     Cypress E2E
│   ├── sdet-automation-selenium/    Selenium (Java + Python)
│   ├── sdet-automation-appium/      Appium (Android + iOS)
│   ├── sdet-automation-robot/       Robot Framework (kw-driven)
│   │
│   │  ── Lenguajes ──
│   ├── sdet-lang-python/            pytest + fixtures + parametrize
│   ├── sdet-lang-java/              JUnit + Mockito + TestNG
│   ├── sdet-lang-javascript/        Jest + Vitest + Testing Library
│   │
│   │  ── Metodologías y Build ──
│   ├── sdet-methodology-gherkin/    Gherkin/BDD patterns
│   ├── sdet-methodology-cucumber/   Cucumber step definitions
│   ├── sdet-build-maven/            Maven + Gradle config
│   │
│   │  ── Pipelines ──
│   ├── sdet-cicd/                   GitHub Actions / GitLab CI / Jenkins
│   │
│   │  ── SQEM (Seidor) ──
│   ├── sdet-sqem-classification/    NAQ + tipología + delivery target
│   ├── sdet-sqem-gates/             QG0-QG7 + matriz F/L/C/N/A
│   ├── sdet-sqem-controls/          Controles por gate × NAQ + SonarQube
│   └── sdet-sqem-ia/                Controles IA/ML/GenAI (Anexo IA)
│
├── memory/                          MEMORIA POR PROYECTO
│   └── _template/
│       ├── context.yaml             Contexto del proyecto (NAQ, stack, convenciones)
│       ├── patterns.md              Patrones aprendidos
│       └── decisions.md             Decisiones de arquitectura
│
├── tools/
│   └── README.md                    Capacidades abstractas del núcleo
│
├── adapters/                        ÚNICAS INTEGRACIONES CONCRETAS SOPORTADAS
│   ├── opencode/                    Integración, instalación, actualización y entorno opencode
│   └── copilot/                     Integración, instrucciones y builder de Copilot
│
│
├── scripts/
│   ├── generate-registry.sh / .ps1  Generador agnóstico del skill registry
│   └── check-skill-tokens.sh/.ps1  Validación agnóstica de tokens
│
├── tests/
│   └── skill-eval-set.md            Eval set para validar triggers de skills
│
└── .atl/
    └── skill-registry.md            Registry auto-generado (no editar manualmente)
```

### Núcleo y adapters

`agent.md` y `system.md` son el núcleo agnóstico: definen identidad, comportamiento, protocolos y reglas sin asumir un runtime. `config.yaml`, `skills/`, `memory/`, `tools/` y los scripts comunes de generación/validación también son agnósticos.

La integración, instalación, actualización, builder y ejemplos de entorno de cada runtime viven exclusivamente dentro de `adapters/opencode/` o `adapters/copilot/`. El núcleo solo requiere que el contenido especializado pertinente esté disponible antes de generar.

Cada skill es un directorio con un `SKILL.md` que contiene metadata y conocimiento especializado. El catálogo de solicitud → conocimiento requerido es:

| Solicitud | Conocimiento requerido |
|-------------|-------------------|
| "¿Qué es Boundary Value Analysis?" | `sdet-istqb` |
| "Creame una estrategia de testing" | `sdet-test-strategy` |
| "Analizá los riesgos de este feature" | `sdet-risk-analysis` |
| "Generame casos de prueba" | `sdet-test-cases` |
| "Clasificá estos tests en S/M/L/XL" | `sdet-test-classification` |
| "Generame un framework Playwright" | `sdet-automation` |
| "Generame tests Cypress" | `sdet-automation-cypress` |
| "Automatizá con Selenium + Java" | `sdet-automation-selenium` + `sdet-lang-java` |
| "Testeá la app móvil con Appium" | `sdet-automation-appium` |
| "Creame tests Robot Framework" | `sdet-automation-robot` |
| "¿Cómo uso pytest en Python?" | `sdet-lang-python` |
| "Patrones de testing en Java" | `sdet-lang-java` |
| "Jest vs Vitest, ¿cuál uso?" | `sdet-lang-javascript` |
| "Escribí escenarios Gherkin" | `sdet-methodology-gherkin` |
| "Creame step definitions Cucumber" | `sdet-methodology-cucumber` |
| "Configurá Maven para tests" | `sdet-build-maven` |
| "Creame un pipeline de GitHub Actions" | `sdet-cicd` |
| "Analizá este MR" | `sdet-mr-analysis` |
| "Aprendé de este proyecto" | `sdet-project-learning` * |
| "¿Pirámide de tests o trofeo?" / "tengo tests flaky" | `sdet-industry-practices` |
| "Hagamos una sesión de testing exploratorio" | `sdet-exploratory-testing` |
| "Testeá esta API REST" | `sdet-api-testing` |
| "¿Mi sitio es accesible?" | `sdet-accessibility` |
| "¿Aguanta 200 usuarios simultáneos?" | `sdet-performance` |
| "Revisá la seguridad de este endpoint" | `sdet-security-testing` |
| "Trabajemos con el cliente Acme" | `sdet-client-profile` * |
| "Te paso la normativa de calidad del cliente" | `sdet-client-onboarding` + `sdet-client-profile` * |
| "Clasificá este proyecto Seidor" | `sdet-sqem-classification` |
| "¿Estamos listos para QG4?" | `sdet-sqem-gates` |
| "¿Qué controles necesito para NAQ Alto?" | `sdet-sqem-controls` |
| "Testeá este modelo de IA" | `sdet-sqem-ia` |

\* Requiere persistencia de memoria. Si el entorno no la soporta, funcionará con capacidades reducidas.

`sdet-automation` es el skill default para Playwright. La separación de triggers entre `sdet-methodology-gherkin` (Gherkin/BDD para especificaciones) y `sdet-methodology-cucumber` (Cucumber para integración y step definitions) es intencional.

**Conocimiento combinado**: una solicitud puede requerir contenido de varios skills (por ejemplo, automatización Selenium, Java y Cucumber).

---

## SQEM — Protocolo de Calidad Seidor

El SQEM es el protocolo de ingeniería de calidad de Seidor. Patesi lo ejecuta como referencia absoluta en proyectos Seidor.

### Las 15 Tipologías de Proyecto

| # | Tipología | Preocupación principal |
|---|-----------|----------------------|
| 1 | **Desarrollo Nuevo** | Testing F + NF completo |
| 2 | **Mantenimiento Evolutivo** | Análisis de impacto, regresión selectiva |
| 3 | **Mantenimiento Correctivo** | Confirmación de defecto, regresión selectiva |
| 4 | **Hotfix / Emergencia** | QG-Express: revisión por pares + smoke + rollback |
| 5 | **Transformación / Migración** | Baseline, validación de migración, rollback |
| 6 | **Integraciones / APIs / Datos** | Contract testing, resiliencia, seguridad |
| 7 | **Producto Digital / Canal Usuario** | E2E, usabilidad, accesibilidad, compatibilidad |
| 8 | **Embalado (SAP/Salesforce/...)** | Config vs estándar, UAT, seguridad por roles |
| 9 | **Producto Mercado (COTS/SaaS)** | Requisitos vs producto, revisión de config |
| 10 | **IA / ML / GenAI** | Calidad de datos, evaluación de LLM, IA responsable |
| 11 | **Datos y analítica / BI** | Calidad de datos, reconciliación, linaje |
| 12 | **Infra / DevOps / Cloud** | IaC, hardening, DR, observabilidad |
| 13 | **RPA / Automatización** | Proceso E2E, manejo de excepciones |
| 14 | **Ciberseguridad** | SAST/DAST/SCA, pentest, modelado de amenazas |
| 15 | **Consultoría** | Revisión por pares, control de calidad documental |

### Las 8 Puertas de Calidad

```
QG0 → QG1 → QG2 → QG3 → QG4 → QG5 → QG6 → QG7
Inicio  Req    Diseño  Código  Pruebas  UAT   Go-Live  Cierre
```

| Gate | Qué evalúa |
|------|-----------|
| **QG0** | ¿Tenemos alcance, riesgos, NAQ y plan? |
| **QG1** | ¿Los requisitos están completos, testables, trazables? |
| **QG2** | ¿El diseño cubre funcional y no-funcional? |
| **QG3** | ¿El código pasa code review, estático, cobertura, SonarQube? |
| **QG4** | ¿El sistema integrado pasa pruebas con 0 bloqueantes/críticos? |
| **QG5** | ¿El cliente/PO acepta formalmente? |
| **QG6** | ¿Hay runbook, rollback probado, smoke pre-prod, monitoreo? |
| **QG7** | ¿Se estabilizó, transfirió a AMS/RUN, documentó lecciones? |

### Núcleo Común NO Negociable

Estos 9 ítems aplican a TODOS los proyectos Seidor sin importar NAQ o tipología:

1. NAQ asignado + ficha de proyecto completada
2. Criterios de aceptación definidos
3. Gestión de defectos en ALM
4. **Smoke test pre y post deploy**
5. **0 defectos bloqueantes/críticos abiertos**
6. **Go/No-Go registrado** (aunque sea ligero)
7. Plan de deploy y rollback
8. Nomenclatura estándar y trazabilidad
9. **GDPR en datos de test** (nunca datos reales sin enmascarar)

---

## Instalación e integración

Patesi soporta exactamente dos runtimes. La documentación concreta, los scripts y los ejemplos de entorno están separados por adapter:

- [`adapters/opencode/`](adapters/opencode/): composición, instalación, actualización, permisos y herramientas de opencode.
- [`adapters/copilot/`](adapters/copilot/): instrucciones y builder de GitHub Copilot.

El núcleo no contiene comandos, rutas de instalación ni configuración específica de un runtime.

---

---

## Ejemplos de Uso

```
# Estrategia de Testing
"Creame una estrategia de testing para autenticación de usuarios"

# Análisis de Riesgos
"Analizá los riesgos del feature de procesamiento de pagos"

# Casos de Prueba
"Generame casos de prueba para reset de contraseña"

# Automatización
"Generame un framework de Playwright para la página de login"

# CI/CD
"Creame un workflow de GitHub Actions para mi suite de tests"

# Análisis de MRs
"Analizá este MR buscando posibles roturas"

# SQEM (Proyectos Seidor)
"Clasificá este proyecto según SQEM"
"Evaluá si estamos listos para QG4"
"¿Qué controles necesito para NAQ Alto en tipología Integraciones?"

# IA/ML/GenAI
"Testeá este modelo de LLM para alucinaciones"
"Generame un golden dataset para evaluar el RAG"
```

---

## Memoria de Proyecto

Patesi aprende de tu proyecto y aplica las convenciones en cada respuesta.

### En la Sesión Actual

Al inicio, Patesi detecta si hay contexto previo o hace preguntas de elicitation para entender:
- Tipo de proyecto (Seidor / Personal / Client-governed)
- Stack tecnológico
- Frameworks de testing en uso
- Áreas de riesgo conocidas

### Entre Sesiones

La memoria se almacena fuera del repositorio mediante la capacidad de persistencia disponible en el adapter activo. La configuración concreta y la ubicación dependen del entorno y se documentan dentro de su adapter.

### Qué Guarda Patesi

| Tipo | Ejemplo |
|------|---------|
| **Patrones** | "Usamos `.spec.ts` no `.test.ts`", "Fixtures, no page objects" |
| **Decisiones** | "Elegimos Playwright sobre Cypress por WebKit", "Cobertura mínima 80%" |
| **Bugs recurrentes** | "El módulo de pagos tiene bugs con timezone" |
| **Convenciones** | "Tests en `src/__tests__/`, mocks en `__mocks__/`" |
| **SQEM** | "NAQ Alto, tipología Integraciones, delivery Continuo" |

### Aislamiento Multi-Proyecto

**CRÍTICO**: Toda la memoria está scoped al proyecto activo. Patesi NUNCA mezcla contexto entre proyectos.

---

## Contribuciones

### Agregar un nuevo skill

1. Creá `skills/sdet-{nombre}/SKILL.md`
2. Seguí el frontmatter existente:

```yaml
---
name: sdet-{nombre}
description: >
  Descripción del skill.
  Trigger: Cuándo cargar este skill.
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: general | sqem
---
```

3. Incluí keywords de trigger en la descripción
4. Ejecutá `.\scripts\generate-registry.ps1` para regenerar los 3 artefactos derivados (`.atl/skill-registry.md`, `config.yaml` skills block, `system.md` §8 table)
5. Mandá un PR

> **Importante**: No edités `.atl/skill-registry.md`, el bloque `skills:` de `config.yaml`, ni la tabla de `system.md` §8 manualmente — se regeneran desde los frontmatter con markers automáticos.

### Mejorar el conocimiento

- **ISTQB**: Editá `skills/sdet-istqb/SKILL.md`
- **SQEM**: Editá el skill SQEM correspondiente (`sdet-sqem-classification`, `sdet-sqem-gates`, `sdet-sqem-controls`, `sdet-sqem-ia`)
- **Automatización**: Editá el skill del framework correspondiente
- Mantené cada skill bajo 4K tokens para eficiencia de contexto

### Regenerar artefactos derivados

```bash
# Regenerar skill registry (desde frontmatter de SKILL.md)
.\scripts\generate-registry.ps1

# Regenerar adaptador de Copilot (desde agent.md + system.md)
.\adapters\copilot\scripts\build-copilot-adapter.ps1
```

---

## Licencia

Apache License 2.0 — ver [LICENSE](LICENSE) para detalles.

## Agradecimientos

- [ISTQB](https://www.istqb.org/) por la metodología de testing
- [opencode](https://opencode.ai) por la plataforma de agentes de IA
- [Playwright](https://playwright.dev/) por el framework de testing
- La comunidad open-source por compartir skills de agentes de IA

## Recursos

- [Syllabi ISTQB](https://www.istqb.org/certifications/) — Syllabi oficiales de certificación
- [Documentación de Playwright](https://playwright.dev/docs/intro) — Docs del framework de testing
- [GitHub Actions](https://docs.github.com/en/actions) — Documentación de CI/CD

---

Built with ❤️ by [ArgTincho89](https://github.com/ArgTincho89)
