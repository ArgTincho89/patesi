# Patesi — Adaptador para opencode

Usá este adaptador para componer el system prompt en opencode.

```json
{
  "agent": {
    "patesi": {
      "description": "Patesi — Agente SDET de IA",
      "mode": "primary",
      "prompt": "{file:./agent.md}\n\n---\n\n{file:./system.md}",
      "tools": { "edit": true, "write": true }
    }
  }
}
```

> **Sobre `edit` y `write`:** opencode concede estas herramientas al agente, pero **no distingue entre el repositorio del producto y el repositorio de pruebas**. El límite de escritura de Patesi es de comportamiento, no de sandbox: está definido en la Regla fundamental de `system.md` y Patesi lo respeta por instrucción.
>
> Si querés respaldo del entorno, corré Patesi con el directorio de trabajo apuntando a su repositorio de pruebas y montá el proyecto bajo prueba como fuente de solo lectura.

## Qué hace este adaptador

1. Carga `agent.md` (identidad, personalidad, principios core)
2. Carga `system.md` (reglas de comportamiento, protocolo de sesión, jerarquía de frameworks)
3. El contenido de los skills se resuelve bajo demanda desde el catálogo del proyecto.

## Resolución en opencode

opencode carga el contenido del skill relevante bajo demanda antes de generar una respuesta. Cuando este adapter delega trabajo mediante `task`, transmite el modo del proyecto, el NAQ, las tipologías y los datos de clasificación disponibles, la memoria o contexto del proyecto y los skills disponibles con sus paths relevantes.

## Instalación

### Opción A — Script (recomendado)

```bash
# Linux/macOS
bash adapters/opencode/scripts/install.sh

# Windows
.\adapters\opencode\scripts\install.ps1
```

Esto copia el agente y los 35 skills a `~/.config/opencode/`. Después reiniciá opencode y cambiá al agente con **Tab** o `@patesi`.

### Opción B — Manual

1. Copiá `agent.md` a `~/.config/opencode/agents/patesi.md`
2. Copiá `system.md` al mismo directorio (`~/.config/opencode/agents/system.md`)
3. Copiá los directorios `skills/sdet-*/` a `~/.config/opencode/skills/`
4. Agregá a tu `opencode.json`:

```json
{
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

5. Reiniciá opencode.

## Skills

Los skills se cargan bajo demanda cuando la solicitud del usuario coincide con un trigger. Ver `config.yaml` para el registro completo.

### Cuándo cargar skills

- Usuario pregunta sobre ISTQB → `sdet-istqb`
- Usuario pide estrategia de testing → `sdet-test-strategy`
- Usuario pide análisis de riesgos → `sdet-risk-analysis`
- Usuario pide generar casos de prueba → `sdet-test-cases`
- Usuario pide clasificar tests → `sdet-test-classification`
- Usuario pide Playwright → `sdet-automation`
- Usuario pide Cypress → `sdet-automation-cypress`
- Usuario pide Selenium → `sdet-automation-selenium`
- Usuario pide Appium/móvil → `sdet-automation-appium`
- Usuario pide Robot Framework → `sdet-automation-robot`
- Usuario pide Python/pytest → `sdet-lang-python`
- Usuario pide Java/JUnit → `sdet-lang-java`
- Usuario pide JavaScript/Jest → `sdet-lang-javascript`
- Usuario pide Gherkin/BDD → `sdet-methodology-gherkin`
- Usuario pide Cucumber → `sdet-methodology-cucumber`
- Usuario pide Maven/Gradle → `sdet-build-maven`
- Usuario pide pipelines CI/CD → `sdet-cicd`
- Usuario pide analizar un MR/PR → `sdet-mr-analysis`
- Usuario pide aprender de proyecto → `sdet-project-learning` *
- Hay que escribir tests o entregar algo al desarrollador → `sdet-test-repo`
- Usuario pide buenas prácticas, pirámide de tests, flaky, contract testing → `sdet-industry-practices`
- Usuario pide testing exploratorio o charters → `sdet-exploratory-testing`
- Usuario pide testear una API / REST / GraphQL → `sdet-api-testing`
- Usuario pide accesibilidad, WCAG o a11y → `sdet-accessibility`
- Usuario pide performance, carga o estrés → `sdet-performance`
- Usuario pide seguridad, OWASP, SAST/DAST/SCA → `sdet-security-testing`
- **Modo C (proyecto de cliente) — siempre** → `sdet-client-profile` *
- Modo C + cliente nuevo con documentación → `sdet-client-onboarding`
- Proyecto Seidor + necesita NAQ → `sdet-sqem-classification`
- **Proyecto Seidor + qué gates aplican → `sdet-sqem-gate-matrix`** (siempre tras clasificar)
- Proyecto Seidor + qué probar en cada gate → `sdet-sqem-typology-tests`
- Proyecto Seidor + criterios/evidencias de un gate → `sdet-sqem-gates`
- Proyecto Seidor + umbrales e indicadores → `sdet-sqem-controls`
- Proyecto Seidor + quién aprueba / excepciones → `sdet-sqem-governance`
- Proyecto Seidor + IA/ML/GenAI → `sdet-sqem-ia`

### Resolución por modo

El modo se resuelve en el Paso 2 del protocolo de `system.md` y determina qué se puede cargar:

| Modo | Skills habilitados |
|------|--------------------|
| **A — Seidor** | Todos, incluidos los **siete** skills SQEM. Tras clasificar, `sdet-sqem-gate-matrix` es obligatorio |
| **B — Personal** | Todos **menos** los SQEM. Base: `sdet-industry-practices` + `sdet-istqb`. Cargar un skill SQEM en Modo B es un error |
| **C — Cliente** | `sdet-client-profile` siempre, `sdet-client-onboarding` al arrancar con documentación, y el resto según la tarea. SQEM solo si el usuario lo pide explícitamente |

\* Requiere persistencia configurada en opencode; si no está disponible, se informa la limitación.
