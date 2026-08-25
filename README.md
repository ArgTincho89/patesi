# 🧪 Patesi

**Agente SDET de IA** — Ingeniero QA con conocimiento ISTQB, SQEM (para proyectos Seidor), estrategia de testing, automatización y aprendizaje por proyecto.

Compatible con **GitHub Copilot · opencode** (Cursor support removed).

Patesi trae capacidades profesionales de Software Development Engineer in Test (SDET) a cualquier proyecto. Aplica metodologías certificadas por ISTQB y se adapta a las convenciones y protocolo de calidad de tu equipo.

---

## ✨ Capacidades

| Capacidad | Qué hace |
|-----------|----------|
| **Conocimiento ISTQB** | Referencia Foundation v4.0 + Advanced Core: terminología, niveles, tipos y técnicas de testing |
| **SQEM (Seidor)** | Protocolo de calidad empresarial: clasificación NAQ, puertas de calidad, controles operativos, IA |
| **Estrategia de Testing** | Genera estrategias completas (9 secciones) a partir de user stories o requisitos |
| **Análisis de Riesgos** | Calcula riesgo con matriz ponderada (5 factores) y prioriza el esfuerzo de testing |
| **Casos de Prueba** | Genera casos TC-XXX estructurados, clasificados por happy/unhappy/corner |
| **Clasificación de Tests** | Organiza tests en suites S/M/L/XL con estrategia de ejecución para CI/CD |
| **Automatización** | Genera frameworks Playwright + TypeScript con Page Object Model |
| **CI/CD** | Crea configs de pipeline para GitHub Actions, GitLab CI y Jenkins |
| **Análisis de MRs** | Analiza merge requests buscando impacto en testing y riesgos de rotura |
| **Aprendizaje por Proyecto** | Aprende y aplica convenciones específicas del proyecto en cada respuesta |

---

## 🧠 Arquitectura (v2.0)

Patesi se estructura en capas separadas para máxima mantenibilidad:

```
patesi/
├── agent.md                    ← Identidad, personalidad, principios core
├── system.md                   ← Reglas de comportamiento, protocolo de sesión
├── config.yaml                 ← Configuración del agente, permisos, registro de skills
├── prompts/
│   ├── planning.md             ← Reglas para planificación de output
│   ├── execution.md            ← Reglas de generación por tipo de output
│   └── review.md               ← Auto-revisión antes de responder
├── tools/
│   └── README.md               ← Documentación de herramientas disponibles
├── skills/                     ← 13 skills auto-descubiertos
│   ├── sdet-istqb/             ← Conocimiento ISTQB
│   ├── sdet-test-strategy/     ← Generador de estrategias
│   ├── sdet-risk-analysis/     ← Motor de análisis de riesgos
│   ├── sdet-test-cases/        ← Generador de casos de prueba
│   ├── sdet-test-classification/ ← Clasificador S/M/L/XL
│   ├── sdet-automation/        ← Framework Playwright + TS
│   ├── sdet-cicd/              ← Generador de pipelines CI/CD
│   ├── sdet-mr-analysis/       ← Analizador de MRs
│   ├── sdet-project-learning/  ← Aprendizaje de patrones
│   ├── sdet-sqem-classification/ ← Clasificación NAQ + tipología
│   ├── sdet-sqem-gates/        ← Puertas de calidad QG0-QG7
│   ├── sdet-sqem-controls/     ← Controles operativos y umbrales
│   └── sdet-sqem-ia/           ← Controles IA/ML/GenAI
├── memory/                     ← Plantillas de memoria por proyecto
│   └── _template/
│       ├── context.yaml        ← Contexto del proyecto
│       ├── patterns.md         ← Patrones aprendidos
│       └── decisions.md        ← Decisiones de arquitectura
├── knowledge/                  ← Referencias ISTQB y SQEM
│   ├── istqb-references.md
│   └── sqem-quick-reference.md
├── workflows/                  ← Flujos de trabajo
│   ├── session-start.md        ← Protocolo de inicio de sesión
│   ├── new-project.md          ← Flujo para nuevos proyectos
│   └── quality-gate.md         ← Flujo de evaluación de gates
├── adapters/                   ← Adaptadores por IDE
│   ├── opencode/
│   │   └── patesi.md           ← Config de ejemplo para opencode
│   └── copilot/
│       └── copilot-instructions.md ← Instrucciones para Copilot
├── .github/
│   └── copilot-instructions.md ← (deprecated, use adapters/copilot/)
├── examples/
│   └── opencode.json
├── scripts/
│   ├── install.sh / install.ps1
│   └── update.sh / update.ps1
├── patesi.md                   ← Agente universal legacy (deprecated, see adapters/)
├── CHANGELOG.md
├── LICENSE
└── README.md
```

### Cómo se compone el system prompt (opencode)

En `opencode.json`, el system prompt se compone usando la sustitución `{file:...}`:

```json
{
  "agent": {
    "patesi": {
      "prompt": "{file:./agent.md}\n\n---\n\n{file:./system.md}"
    }
  }
}
```

Los **skills** se cargan bajo demanda cuando la solicitud del usuario coincide con un trigger.

---

## 🚀 Inicio Rápido

### 1. Clonar el repo

```bash
git clone https://github.com/ArgTincho89/patesi.git
cd patesi
```

### 2. Configurar tu proyecto

Editá el `context.yaml` en `memory/_template/` con los datos de tu proyecto, o simplemente dejá que Patesi pregunte al inicio de la sesión.

### 3. Activar en tu IDE

Seguí la guía de instalación de tu entorno en la sección siguiente.

---

## 🛠️ Instalación por entorno

### GitHub Copilot

**Opción A — Archivo de instrucciones (recomendado):**

1. Copiá `adapters/copilot/copilot-instructions.md` a `.github/copilot-instructions.md`
2. Para el conocimiento completo, adjuntá `patesi.md` o `agent.md` en cada sesión de chat

**Opción B — Directo:**

1. Abrí Copilot Chat (`Ctrl+Alt+I`)
2. Escribí `#` y buscá `agent.md`
3. Seleccionalo y empezá a preguntar

---

### opencode

**Opción A — Script (recomendado):**

```bash
# Linux/macOS
bash scripts/install.sh

# Windows
.\scripts\install.ps1
```

Esto copia el agente y los 13 skills a `~/.config/opencode/`. Después reiniciá opencode y cambiá al agente con **Tab** o `@patesi`.

**Opción B — Manual:**

1. Copiá `agent.md` a `~/.config/opencode/agents/patesi.md`
2. Copiá `system.md` al mismo directorio
3. Copiá los directorios `skills/sdet-*/` a `~/.config/opencode/skills/`
4. Agregá la siguiente configuración a tu `opencode.json`:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "anthropic/claude-sonnet-4-6",
  "agent": {
    "patesi": {
      "description": "Patesi — SDET AI Agent",
      "mode": "primary",
      "prompt": "{file:./agents/patesi.md}\n\n---\n\n{file:./agents/system.md}",
      "tools": { "edit": true, "write": true }
    }
  }
}
```

5. Reiniciá opencode.

---

## 💬 Ejemplos de uso

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
"Clasificá este proyecto según SQEM" → activa sdet-sqem-classification
"Evaluá si estamos listos para QG4" → activa sdet-sqem-gates
```

---

## 🧠 Memoria de Proyecto

Patesi aprende y aplica las convenciones de tu proyecto:

**Sesión actual** — Al inicio, Patesi detecta si hay contexto previo o hace preguntas de elicitation.

**Entre sesiones (opencode + Engram MCP)** — Si configurás Engram, Patesi guarda patrones entre sesiones automáticamente:

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

---

## 🤝 Contribuciones

¡Contribuciones bienvenidas!

### Agregar un nuevo skill

1. Creá `skills/sdet-{name}/SKILL.md` con el conocimiento especializado
2. Seguí el frontmatter existente (name, description con triggers, license, metadata)
3. Incluí keywords de trigger en la descripción y ejemplos de input/output
4. Actualizá `.atl/skill-registry.md` y `config.yaml`
5. Mandá un PR

### Mejorar el conocimiento ISTQB

1. Editá `skills/sdet-istqb/SKILL.md` y `knowledge/istqb-references.md`
2. Mantené cada sección de skill bajo 4K tokens para eficiencia de contexto
3. Referenciá la versión del syllabus ISTQB

---

## 📄 Licencia

Apache License 2.0 — ver [LICENSE](LICENSE) para detalles.

## 🙏 Agradecimientos

- [ISTQB](https://www.istqb.org/) por la metodología de testing
- [opencode](https://opencode.ai) por la plataforma de agentes de IA
- [Playwright](https://playwright.dev/) por el framework de testing
- La comunidad open-source por compartir skills de agentes de IA

## 📚 Recursos

- [Syllabi ISTQB](https://www.istqb.org/certifications/) — Syllabi oficiales de certificación
- [Documentación de Playwright](https://playwright.dev/docs/intro) — Docs del framework de testing
- [GitHub Actions](https://docs.github.com/en/actions) — Documentación de CI/CD

---

Built with ❤️ by [ArgTincho89](https://github.com/ArgTincho89)
