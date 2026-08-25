# 🧪 Patesi

**Agente SDET de IA** — Ingeniero QA con conocimiento ISTQB y SQEM, estrategia de testing, automatización, análisis de riesgos y aprendizaje por proyecto.

Compatible con **GitHub Copilot** y **opencode**.

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

Patesi detecta automáticamente qué framework usar según el tipo de proyecto:

### Modo A — Proyecto Seidor

El **SQEM es la referencia absoluta**. ISTQB complementa pero nunca override.

```
Usuario: "Creame una estrategia de testing para el módulo de pagos"
Patesi: "Primero necesito clasificar el proyecto. ¿Cuál es la criticidad de negocio?"
         → Clasifica NAQ → Deriva delivery target → Genera estrategia validada contra SQEM
```

Cada recomendación cita la sección SQEM aplicable. Si el usuario propone algo que viola SQEM, Patesi lo señala y pide excepción formal.

### Modo B — Proyecto Personal / No-Seidor

**ISTQB es la referencia primaria.** SQEM no aplica.

```
Usuario: "Analizá los riesgos de mi app de recetas"
Patesi: → Matriz de riesgos ponderada → Priorización ISTQB → Estrategia risk-based
```

### Modo C — Proyecto Client-Governed

El framework del cliente tiene prioridad. SQEM funciona como checklist de suficiencia e ISTQB como complemento.

---

## Flujo de Sesión

Al iniciar una sesión, Patesi ejecuta este protocolo:

```
1. ¿Existe contexto del proyecto?
   ├── SÍ → Lo cargo, confirmo: "Trabajando en {proyecto}. ¿Continuamos?"
   └ NO → Pregunto:

2. ¿Qué tipo de proyecto es?
   ├── Seidor → Clasificación NAQ (5 factores, 0-4 cada uno)
   ├── Personal → ISTQB como framework primario
   └── Client-governed → Framework del cliente + SQEM como suficiencia

3. Guardo el contexto en memoria

4. READY — Listo para trabajar
```

### Clasificación NAQ (Proyectos Seidor)

Patesi calcula el nivel de aseguramiento de calidad con la fórmula:

```
NAQ = (Criticidad×8 + Visibilidad×4 + Interop×4 + Sensibilidad×4 + Complejidad×2) / pesos activos

  NAQ < 1.5  → Bajo  (Velocidad — no frenar la entrega)
1.5 ≤ NAQ < 3 → Medio (Balance — costo vs riesgo)
    NAQ ≥ 3  → Alto  (Minimizar riesgo de negocio)
```

**Overrides obligatorios:**
- Criticidad=4 O Sensibilidad=4 → **NAQ Alto forzado**
- Criticidad≥3 Y Sensibilidad≥3 → mínimo **NAQ Medio**

De NAQ se deriva automáticamente:
- Delivery Target (Básico / Integrado / Continuo)
- Puertas de calidad aplicables (QG0-QG7)
- Controles operativos y umbrales
- Entregables mínimos

---

## Arquitectura

```
patesi/
│
├── agent.md                         WHO soy (identidad, personalidad, principios)
├── system.md                        CÓMO me comporto (reglas, protocolos, planning,
│                                    generación, auto-revisión, workflow QA)
├── config.yaml                      CONFIGURACIÓN (permisos, skills, defaults)
│
├── skills/                          23 SKILLS (auto-descubiertos, bajo demanda)
│   │
│   │  ── Core QA ──
│   ├── sdet-istqb/                  Referencia ISTQB Foundation + Advanced
│   ├── sdet-test-strategy/          Generador de estrategias (9 secciones)
│   ├── sdet-risk-analysis/          Matriz ponderada de riesgos (5 factores)
│   ├── sdet-test-cases/             Generador TC-XXX con happy/unhappy/corner
│   ├── sdet-test-classification/    Clasificador S/M/L/XL para CI/CD
│   ├── sdet-mr-analysis/            Análisis de impacto en MRs/PRs (4 factores)
│   ├── sdet-project-learning/       Aprendizaje de patrones (persistencia según entorno)
│   │
│   │  ── Automation Frameworks ──
│   ├── sdet-automation/             Playwright + TypeScript + POM
│   ├── sdet-automation-cypress/     Cypress E2E
│   ├── sdet-automation-selenium/    Selenium (Java + Python)
│   ├── sdet-automation-appium/      Appium (Android + iOS)
│   ├── sdet-automation-robot/       Robot Framework (kw-driven)
│   │
│   │  ── Languages ──
│   ├── sdet-lang-python/            pytest + fixtures + parametrize
│   ├── sdet-lang-java/              JUnit + Mockito + TestNG
│   ├── sdet-lang-javascript/        Jest + Vitest + Testing Library
│   │
│   │  ── Methodologies & Build ──
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
│   └── README.md                    Documentación de herramientas disponibles
│
├── adapters/                        INTEGRACIÓN POR IDE
│   ├── opencode/patesi.md           Configuración para opencode
│   └── copilot/copilot-instructions.md  Instrucciones para Copilot
│
├── examples/
│   └── opencode.json                Ejemplo de configuración
│
├── scripts/
│   ├── install.sh / install.ps1     Instalador para opencode
│   ├── update.sh / update.ps1       Actualizador
│   ├── generate-registry.sh / .ps1  Generador de skill registry (single source)
│   └── build-copilot-adapter.sh/.ps1 Regenerador de adaptador Copilot
│
├── tests/
│   └── skill-eval-set.md            Eval set para validar triggers de skills
│
└── .atl/
    └── skill-registry.md            Registry auto-generado (no editar manualmente)
```

### Cómo se compone el System Prompt

En opencode, el system prompt se arma combinando dos archivos con `{file:...}`:

```json
{
  "agent": {
    "patesi": {
      "prompt": "{file:./agent.md}\n\n---\n\n{file:./system.md}"
    }
  }
}
```

- **`agent.md`** define QUIÉN es Patesi: nombre, rol, personalidad, tono, principios, awareness de happy/unhappy/corner
- **`system.md`** define CÓMO funciona: protocolo de sesión, jerarquía de frameworks, reglas de riesgo, flujo de planificación, estándares de formato, reglas de generación, auto-revisión, protocolo de skills, memoria de proyecto, workflow QA

Los **skills** se cargan bajo demanda — nunca todos juntos. Cuando tu solicitud coincide con el trigger de un skill, Patesi lo carga y lo aplica.

### Cómo Funcionan los Skills

Cada skill es un directorio con un `SKILL.md` que tiene:
- **Frontmatter**: nombre, descripción con triggers, licencia, metadata
- **Contenido**: conocimiento especializado, templates, reglas, ejemplos

Patesi carga skills cuando tu solicitud coincide con los triggers:

| Tu pregunta | Skill que se carga |
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
| "Clasificá este proyecto Seidor" | `sdet-sqem-classification` |
| "¿Estamos listos para QG4?" | `sdet-sqem-gates` |
| "¿Qué controles necesito para NAQ Alto?" | `sdet-sqem-controls` |
| "Testeá este modelo de IA" | `sdet-sqem-ia` |

\* Requiere persistencia de memoria. Si el entorno no la soporta, degradará gracefully.

**Skills simultáneos**: Puede cargar varios skills a la vez cuando la situación lo requiere (ej: `sdet-automation-selenium` + `sdet-lang-java` + `sdet-methodology-cucumber` para un proyecto Selenium/Java/Cucumber).

---

## SQEM — Protocolo de Calidad Seidor

El SQEM es el protocolo de quality engineering de Seidor. Patesi lo ejecuta como referencia absoluta en proyectos Seidor.

### Las 15 Tipologías de Proyecto

| # | Tipología | Preocupación principal |
|---|-----------|----------------------|
| 1 | **Desarrollo Nuevo** | Testing F + NF completo |
| 2 | **Mantenimiento Evolutivo** | Análisis de impacto, regresión selectiva |
| 3 | **Mantenimiento Correctivo** | Confirmación de defecto, regresión selectiva |
| 4 | **Hotfix / Emergencia** | QG-Express: peer review + smoke + rollback |
| 5 | **Transformación / Migración** | Baseline, validación de migración, rollback |
| 6 | **Integraciones / APIs / Datos** | Contract testing, resiliencia, seguridad |
| 7 | **Producto Digital / Canal Usuario** | E2E, usabilidad, accesibilidad, compatibilidad |
| 8 | **Embalado (SAP/Salesforce/...)** | Config vs estándar, UAT, seguridad por roles |
| 9 | **Producto Mercado (COTS/SaaS)** | Requisitos vs producto, revisión de config |
| 10 | **IA / ML / GenAI** | Calidad de datos, eval LLM, Responsible AI |
| 11 | **Data & Analytics / BI** | Calidad de datos, reconciliación, lineage |
| 12 | **Infra / DevOps / Cloud** | IaC, hardening, DR, observabilidad |
| 13 | **RPA / Automatización** | E2E process, exception handling |
| 14 | **Ciberseguridad** | SAST/DAST/SCA, pentest, threat modeling |
| 15 | **Consultoría** | Peer review, document QC |

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

## Instalación

### GitHub Copilot

**Opción A — Archivo de instrucciones (recomendado):**

1. Cloná el repo
2. Copiá `adapters/copilot/copilot-instructions.md` a `.github/copilot-instructions.md`
3. Para el conocimiento completo, adjuntá `agent.md` en cada sesión de chat

**Opción B — Directo:**

1. Abrí Copilot Chat (`Ctrl+Alt+I`)
2. Escribí `#` y buscá `agent.md`
3. Empezá a preguntar

---

### opencode

**Opción A — Script (recomendado):**

```bash
# Linux/macOS
bash scripts/install.sh

# Windows
.\scripts\install.ps1
```

Copia el agente y los 23 skills a `~/.config/opencode/`. Reiniciá opencode y cambiá al agente con **Tab** o `@patesi`.

**Opción B — Manual:**

1. Copiá `agent.md` y `system.md` a `~/.config/opencode/agents/`
2. Copiá los directorios `skills/sdet-*/` a `~/.config/opencode/skills/`
3. Agregá a tu `opencode.json`:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "agent": {
    "patesi": {
      "description": "Patesi — Agente SDET de IA",
      "mode": "primary",
      "prompt": "{file:./agents/patesi.md}\n\n---\n\n{file:./agents/system.md}",
      "tools": { "edit": true, "write": true }
    }
  }
}
```

4. Reiniciá opencode.

**Actualización:**

```bash
# Linux/macOS
bash scripts/update.sh

# Windows
.\scripts\update.ps1
```

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

### Entre Sesiones (opencode + Engram)

Si configurás Engram MCP, Patesi guarda patrones automáticamente:

```json
{
  "mcp": {
    "engram": {
      "command": ["engram", "mcp"],
      "enabled": true,
      "type": "local"
    }
  }
}
```

```
"Aprendé de la suite de tests de este proyecto"
"Recordá que usamos fixtures, no page objects"
```

La memoria se almacena fuera del repo en `~/.config/opencode/patesi-memory/{project}/`.

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
4. Ejecutá `.\scripts\generate-registry.ps1` para regenerar `.atl/skill-registry.md`
5. Actualizá `config.yaml` con el nuevo skill (o copiá la sección que genera el script)
6. Mandá un PR

> **Importante**: No edités `.atl/skill-registry.md` manualmente — se regenera desde los frontmatter.

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
.\scripts\build-copilot-adapter.ps1
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
