# 🧪 Patesi

**Agente SDET de IA universal** — Ingeniero QA con conocimiento ISTQB, estrategia de testing, automatización y aprendizaje por proyecto.

Compatible con **GitHub Copilot · Cursor · opencode · Claude · ChatGPT · JetBrains AI · cualquier asistente de IA**.

Patesi trae capacidades profesionales de Software Development Engineer in Test (SDET) a cualquier proyecto. Aplica metodologías certificadas por ISTQB y se adapta a las convenciones y protocolo de calidad de tu equipo.

---

## ✨ Capacidades

| Capacidad | Qué hace |
|-----------|----------|
| **Conocimiento ISTQB** | Referencia Foundation + Advanced Core: terminología, niveles, tipos y técnicas de testing |
| **Estrategia de Testing** | Genera estrategias completas (9 secciones) a partir de user stories o requisitos |
| **Análisis de Riesgos** | Calcula riesgo con matriz ponderada (5 factores) y prioriza el esfuerzo de testing |
| **Casos de Prueba** | Genera casos TC-XXX estructurados, clasificados por happy/unhappy/corner |
| **Clasificación de Tests** | Organiza tests en suites S/M/L/XL con estrategia de ejecución para CI/CD |
| **Automatización** | Genera frameworks Playwright + TypeScript con Page Object Model |
| **CI/CD** | Crea configs de pipeline para GitHub Actions, GitLab CI y Jenkins |
| **Análisis de MRs** | Analiza merge requests buscando impacto en testing y riesgos de rotura |
| **Aprendizaje por Proyecto** | Aprende y aplica convenciones específicas del proyecto en cada respuesta |

---

## 🧠 Cómo funciona

Patesi tiene dos capas:

1. **`patesi.md` (cerebro)** — Archivo markdown autocontenido con las instrucciones del agente y todo el conocimiento de las 9 capacidades inlineado. Sin dependencias de IDE. Funciona en cualquier IA que acepte un system prompt o archivo de contexto.

2. **Integraciones por IDE (adaptadores finos)** — Archivos que cargan el agente automáticamente en cada herramienta. Apuntan a `patesi.md` o contienen un resumen para carga inmediata.

```
patesi.md           ←  El agente completo. Editá "Project Context" con tu proyecto.
    ↓ cargado por
.github/copilot-instructions.md   ←  GitHub Copilot (auto)
.cursorrules                       ←  Cursor (auto)
agents/patesi.md                   ←  opencode (auto, con frontmatter)
```

---

## 🚀 Inicio Rápido (3 pasos)

### 1. Clonar el repo

```bash
git clone https://github.com/ArgTincho89/patesi.git
cd patesi
```

### 2. Configurar tu proyecto

Abrí `patesi.md` y completá la tabla de **Project Context** al principio del archivo:

```markdown
| Field                  | Your Value                              |
|------------------------|-----------------------------------------|
| Project name           | Mi App                                  |
| Tech stack             | React + Node.js + PostgreSQL            |
| Test frameworks in use | Jest (unit), Playwright (E2E)           |
| CI/CD platform         | GitHub Actions                          |
| Testing maturity       | Tenemos unit tests, sin E2E             |
| Known risk areas       | Módulo de pagos, autenticación          |
```

Cuanto más completes, más alineadas estarán las respuestas de Patesi a tu contexto.

### 3. Activar en tu IDE

Seguí la guía de instalación de tu entorno en la sección siguiente.

---

## 🛠️ Instalación por entorno

### GitHub Copilot en VS Code

**Sin instalación adicional.** Al clonar el repo, `.github/copilot-instructions.md` se carga automáticamente cuando abrís la carpeta en VS Code con Copilot activo.

Para el conocimiento completo (ISTQB, casos de prueba, automatización, etc.), adjuntá `patesi.md` en cada sesión de chat:

1. Abrí Copilot Chat (`Ctrl+Alt+I`)
2. Escribí `#` y buscá `patesi.md`
3. Seleccionalo y empezá a preguntar

> **Tip**: Creá un `.vscode/settings.json` con `"github.copilot.chat.contextFiles": ["patesi.md"]` para que se adjunte automáticamente.

---

### GitHub Copilot en GitHub.com

1. Navegá a la pestaña **Copilot** en el repositorio
2. Hacé clic en el ícono de adjuntar archivo y seleccioná `patesi.md`
3. Patesi está activo con todo el conocimiento disponible

---

### Cursor

**Sin instalación adicional.** Al abrir la carpeta del repo en Cursor, `.cursorrules` se carga automáticamente.

Para el conocimiento completo:

```
@patesi.md creame una estrategia de testing para el módulo de pagos
```

---

### opencode

**Opción A — Script (recomendado):**

```bash
# Linux/macOS
bash scripts/install.sh

# Windows
.\scripts\install.ps1
```

Esto copia el agente y los 9 skills a `~/.config/opencode/`. Después reiniciá opencode y cambiá al agente con **Tab** o `@patesi`.

**Opción B — Manual:**

1. Copiá `agents/patesi.md` a `~/.config/opencode/agents/patesi.md`
2. Copiá los directorios `skills/sdet-*/` a `~/.config/opencode/skills/`
3. Agregá la siguiente configuración a tu `opencode.json`:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "anthropic/claude-sonnet-4-6",
  "agent": {
    "patesi": {
      "description": "Patesi — SDET AI Agent",
      "mode": "primary",
      "prompt": "{file:./agents/patesi.md}",
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

### Claude / ChatGPT / cualquier IA

1. Abrí `patesi.md` y copiá todo el contenido
2. Pegalo como **system prompt** o **custom instructions** en tu herramienta
3. O adjuntá `patesi.md` directamente si la herramienta soporta archivos

---

### JetBrains AI Assistant

1. Abrí **AI Assistant** → **Editor Context** → **Add file**
2. Seleccioná `patesi.md`
3. Patesi está activo en la sesión

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

# Protocolo de Calidad
"Qué cobertura necesito según nuestro protocolo de calidad?"
```

---

## 🏢 Protocolo de Calidad Empresarial

Patesi aplica el protocolo de calidad de tu empresa cuando lo proveés. Agregalo en la sección **Project Context** de `patesi.md`:

```markdown
| Company quality protocol | Todos los P1 bloquean el release. Cobertura mínima 80% en branch. |
```

Cuando hay un protocolo cargado, Patesi:
- Lo aplica a cada decisión de testing
- Lo referencia explícitamente en sus respuestas
- Señala conflictos entre ISTQB y el protocolo
- Nunca salta requisitos del protocolo silenciosamente

---

## 🧠 Memoria de Proyecto

Patesi aprende y aplica las convenciones de tu proyecto de dos formas:

**Sesión actual** — Completá "Project Context" en `patesi.md`. Patesi usa esos datos en toda la conversación.

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

---

## 📁 Estructura del Proyecto

```
patesi/
├── patesi.md                              # ⭐ Agente universal (todo en uno)
│                                          #    Editá "Project Context" aquí
├── .github/
│   └── copilot-instructions.md            # Integración GitHub Copilot (auto)
├── .cursorrules                            # Integración Cursor (auto)
├── agents/
│   └── patesi.md                          # Agente para opencode (con frontmatter)
├── skills/
│   ├── sdet-istqb/SKILL.md                # Conocimiento ISTQB
│   ├── sdet-test-strategy/SKILL.md        # Generador de estrategias
│   ├── sdet-risk-analysis/SKILL.md        # Motor de análisis de riesgos
│   ├── sdet-test-cases/SKILL.md           # Generador de casos de prueba
│   ├── sdet-test-classification/SKILL.md  # Clasificador S/M/L/XL
│   ├── sdet-automation/SKILL.md           # Framework Playwright + TS
│   ├── sdet-cicd/SKILL.md                 # Generador de pipelines CI/CD
│   ├── sdet-mr-analysis/SKILL.md          # Analizador de MRs
│   └── sdet-project-learning/SKILL.md     # Aprendizaje de patrones
├── scripts/
│   ├── install.sh / install.ps1           # Instalador para opencode
│   └── update.sh / update.ps1             # Actualizador para opencode
├── examples/
│   └── opencode.json                      # Config de ejemplo para opencode
├── istqb-syllabi/README.md                # Links a syllabi ISTQB oficiales
├── CHANGELOG.md
├── LICENSE
└── README.md
```

---

## 🤝 Contribuciones

¡Contribuciones bienvenidas!

### Agregar una nueva capacidad

1. Creá `skills/sdet-{name}/SKILL.md` con el conocimiento especializado
2. Seguí el frontmatter existente (name, description con triggers, license, metadata)
3. Incluí keywords de trigger en la descripción y ejemplos de input/output
4. Añadí la sección correspondiente en `patesi.md` bajo `## Knowledge Base`
5. Mandá un PR

### Mejorar el conocimiento ISTQB

1. Editá `skills/sdet-istqb/SKILL.md` y la sección `## ISTQB Reference` en `patesi.md`
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
