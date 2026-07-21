# 🧪 Patesi

**Agente SDET de IA universal** — Ingeniero QA con conocimiento ISTQB, estrategia de testing, automatización y aprendizaje por proyecto. Compatible con GitHub Copilot, Cursor, opencode y cualquier asistente de IA.

Patesi trae capacidades profesionales de Software Development Engineer in Test (SDET) a cualquier proyecto. Aplica metodologías certificadas por ISTQB para ayudar a desarrolladores e ingenieros QA a construir mejor software.

## ✨ Características

| Skill | Descripción |
|-------|-------------|
| **Conocimiento ISTQB** | Referencia Foundation + Advanced Core para terminología y técnicas de testing |
| **Estrategia de Testing** | Genera estrategias completas a partir de user stories |
| **Análisis de Riesgos** | Analiza features buscando riesgos con scoring ponderado |
| **Casos de Prueba** | Genera casos de prueba estructurados y trazables |
| **Clasificación de Tests** | Clasifica tests en suites S/M/L/XL para CI/CD |
| **Automatización** | Genera frameworks Playwright + TypeScript |
| **CI/CD** | Crea configs de pipeline (GitHub Actions, GitLab CI, Jenkins) |
| **Análisis de MRs** | Analiza merge requests buscando impacto en testing |
| **Aprendizaje por Proyecto** | Almacena patrones QA específicos del proyecto con Engram |

## 🚀 Inicio Rápido

### Prerrequisitos

- Cualquier IDE con IA o asistente de IA: GitHub Copilot, Cursor, opencode, Claude, ChatGPT, JetBrains AI, etc.
- Node.js 20+ (solo necesario para ejecutar tests con Playwright, opcional)

### Paso 1: Clonar el repo

```bash
git clone https://github.com/ArgTincho89/patesi.git
cd patesi
```

### Paso 2: Configurar tu contexto de proyecto

Editá la sección **Project Context** en `patesi.md` con los datos de tu proyecto (nombre, stack, CI/CD, convenciones de testing, protocolo de calidad, etc.). Cuanto más completes, más relevante será el output de Patesi.

### Paso 3: Activar en tu IDE

| IDE / Herramienta | Cómo activar |
|-------------------|-------------|
| **GitHub Copilot** (VS Code, GitHub.com) | `.github/copilot-instructions.md` se carga automáticamente. Para el contexto completo, adjuntá `patesi.md` con `#file:patesi.md` en el chat. |
| **Cursor** | `.cursorrules` se carga automáticamente. Usá `@patesi.md` en el chat para el conocimiento completo. |
| **opencode** | Seguí las instrucciones de la sección [opencode](#opencode). |
| **Claude / ChatGPT / otro** | Pegá el contenido de `patesi.md` como system prompt o adjuntalo como archivo. |
| **JetBrains AI** | Adjuntá `patesi.md` como contexto en la sesión de chat. |

### Paso 4: Empezar a usar

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
```

---

### opencode

**Linux/macOS:**
```bash
git clone https://github.com/ArgTincho89/patesi.git
cd patesi
bash scripts/install.sh
```

**Windows:**
```powershell
git clone https://github.com/ArgTincho89/patesi.git
cd patesi
.\scripts\install.ps1
```

#### Instalación para opencode (Script — Recomendado)

**Linux/macOS:**
```bash
bash scripts/install.sh
```

**Windows:**
```powershell
.\scripts\install.ps1
```

#### Instalación Manual para opencode

1. Copiá `agents/patesi.md` a `~/.config/opencode/agents/`
2. Copiá todos los directorios `skills/sdet-*/` a `~/.config/opencode/skills/`
3. Agregá la configuración del agente a tu `opencode.json`:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "agent": {
    "patesi": {
      "description": "Patesi — SDET AI Agent for test strategy, ISTQB knowledge, case generation, automation, and quality analysis",
      "mode": "primary",
      "prompt": "{file:./agents/patesi.md}",
      "tools": {
        "edit": true,
        "write": true
      }
    }
  }
}
```

4. Reiniciá opencode.
5. Cambiá al agente **Patesi** usando la tecla **Tab** (o escribí `@patesi`).

#### Actualización de opencode

```powershell
# Windows
.\scripts\update.ps1

# Linux/macOS
bash scripts/update.sh
```

## 📁 Estructura del Proyecto

```
patesi/
├── patesi.md                          # ⭐ Agente universal (todo en uno, para cualquier IA/IDE)
├── .github/
│   └── copilot-instructions.md        # Carga automática en GitHub Copilot
├── .cursorrules                        # Carga automática en Cursor
├── agents/
│   └── patesi.md                      # Prompt del agente para opencode (con frontmatter)
├── skills/
│   ├── sdet-istqb/SKILL.md            # Referencia de conocimiento ISTQB
│   ├── sdet-test-strategy/SKILL.md    # Generador de estrategia de testing
│   ├── sdet-risk-analysis/SKILL.md    # Motor de análisis de riesgos
│   ├── sdet-test-cases/SKILL.md       # Generador de casos de prueba
│   ├── sdet-test-classification/SKILL.md  # Clasificador de suites S/M/L/XL
│   ├── sdet-automation/SKILL.md       # Framework Playwright + TypeScript
│   ├── sdet-cicd/SKILL.md             # Generador de pipelines CI/CD
│   ├── sdet-mr-analysis/SKILL.md      # Analizador de MRs
│   └── sdet-project-learning/SKILL.md # Aprendizaje de patrones del proyecto
├── scripts/
│   ├── install.sh / install.ps1       # Instalador para opencode
│   └── update.sh / update.ps1         # Actualizador para opencode
├── examples/
│   └── opencode.json                  # Configuración de ejemplo para opencode
├── CHANGELOG.md
├── istqb-syllabi/README.md
├── README.md
├── LICENSE
└── .gitignore
```

## 🔧 Configuración

### Permisos del Agente (opencode)

| Permiso | Valor | Razón |
|---------|-------|-------|
| `read` | allow | Necesita leer código y specs |
| `edit` | allow | Necesita crear/editar archivos de test |
| `write` | allow | Necesita generar frameworks |
| `bash` | ask | La mayoría de comandos requieren aprobación |
| `skill` | allow | Necesita cargar skills on-demand |

### Modelo Recomendado

Patesi funciona mejor con:
- **Primario**: `anthropic/claude-sonnet-4-6` (mejor balance calidad/velocidad)
- **Alternativa**: `anthropic/claude-haiku-4-5` (más rápido, bueno para tareas simples)

Configurá en tu `opencode.json`:
```json
{
  "model": "anthropic/claude-sonnet-4-6"
}
```

## 🧠 Memoria de Proyecto (Opcional)

Patesi puede aprender patrones QA específicos del proyecto. Hay dos formas:

**1. Session context (siempre disponible)**: Editá la sección "Project Context" de `patesi.md` con las convenciones de tu proyecto antes de empezar a chatear.

**2. Memoria persistente con Engram (solo opencode)**: Si tenés Engram MCP configurado, Patesi guarda y recupera patrones entre sesiones automáticamente.

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

Usá la skill de aprendizaje:
```
"Aprendé de la suite de tests de este proyecto"
"Recordá que usamos fixtures, no page objects"
```

## 🏢 Protocolo de Calidad Empresarial

Patesi está diseñado para respetar y aplicar el protocolo de calidad de tu empresa cuando se le provee. El protocoloempresarial tiene precedencia sobre las recomendaciones generales.

Cuando tengás un protocolo de calidad:
1. Patesi lo aplica a cada decisión de testing
2. Lo referencia explícitamente en sus respuestas
3. Señala conflictos entre ISTQB y el protocolo
4. Nunca salta requisitos del protocolo silenciosamente

**Próximamente**: Soporte para cargar protocolos de calidad empresarial.

## 🤝 Contribuciones

¡Contribuciones bienvenidas! Ver la guía [CONTRIBUTING.md](CONTRIBUTING.md).

### Agregar una Nueva Skill

1. Creá `skills/sdet-{name}/SKILL.md`
2. Seguí el formato de frontmatter (name, description con triggers, license, metadata)
3. Incluí keywords de trigger en la descripción
4. Agregá ejemplos de inputs/outputs
5. Mandá un PR

### Mejorar el Conocimiento ISTQB

La skill `sdet-istqb` contiene conocimiento condensado. Para expandirlo:

1. Agregá nuevas secciones a `skills/sdet-istqb/SKILL.md`
2. Mantené la skill bajo 4K tokens para eficiencia de contexto
3. Referenciá la versión del syllabus ISTQB

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
- [Documentación de opencode](https://opencode.ai/docs) — Docs de la plataforma de agentes
- [GitHub Actions](https://docs.github.com/en/actions) — Documentación de CI/CD

---

Built with ❤️ by [ArgTincho89](https://github.com/ArgTincho89)
