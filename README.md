# 🧪 Patesi

**Agente SDET de IA para [opencode](https://opencode.ai)** — Ingeniero QA con conocimiento ISTQB, estrategia de testing, automatización y aprendizaje por proyecto.

Patesi es un agente modular basado en skills que trae capacidades profesionales de Software Development Engineer in Test (SDET) a cualquier proyecto a través de [opencode](https://opencode.ai). Aplica metodologías certificadas por ISTQB para ayudar a desarrolladores e ingenieros QA a construir mejor software.

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

- [opencode](https://opencode.ai) instalado y configurado
- Node.js 20+ (para ejecución de tests con Playwright)

### Instalación

#### Opción 1: Script de Instalación (Recomendado)

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

#### Opción 2: Instalación Manual

1. Copiá `agents/sdet.md` a `~/.config/opencode/agents/`
2. Copiá todos los directorios `skills/sdet-*/` a `~/.config/opencode/skills/`
3. Agregá la configuración del agente a tu `opencode.json`:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "agent": {
    "patesi": {
      "description": "Patesi — SDET AI Agent for test strategy, ISTQB knowledge, case generation, automation, and quality analysis",
      "mode": "primary",
      "prompt": "{file:./agents/sdet.md}",
      "tools": {
        "edit": true,
        "write": true
      }
    }
  }
}
```

4. Reiniciá opencode

#### Opción 3: Usando `skills.paths` (Sin Copiar)

Agregá el repo clonado a tu config de opencode:

```json
{
  "skills": {
    "paths": ["/ruta/a/patesi/skills"]
  }
}
```

### Uso

1. Iniciá opencode en tu proyecto
2. Cambiá al agente **Patesi** usando la tecla **Tab** (o escribí `@patesi`)
3. Hacé preguntas sobre QA:

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

## 📁 Estructura del Proyecto

```
patesi/
├── agents/
│   └── sdet.md                    # Prompt principal del agente
├── skills/
│   ├── sdet-istqb/
│   │   └── SKILL.md               # Referencia de conocimiento ISTQB
│   ├── sdet-test-strategy/
│   │   └── SKILL.md               # Generador de estrategia de testing
│   ├── sdet-risk-analysis/
│   │   └── SKILL.md               # Motor de análisis de riesgos
│   ├── sdet-test-cases/
│   │   └── SKILL.md               # Generador de casos de prueba
│   ├── sdet-test-classification/
│   │   └── SKILL.md               # Clasificador de suites de testing
│   ├── sdet-automation/
│   │   └── SKILL.md               # Framework Playwright+TS
│   ├── sdet-cicd/
│   │   └── SKILL.md               # Generador de pipelines CI/CD
│   ├── sdet-mr-analysis/
│   │   └── SKILL.md               # Analizador de MRs
│   └── sdet-project-learning/
│       └── SKILL.md               # Aprendizaje de patrones del proyecto
├── scripts/
│   ├── install.sh                 # Instalador Linux/macOS
│   └── install.ps1                # Instalador Windows
├── examples/
│   └── opencode.json              # Configuración de ejemplo
├── istqb-syllabi/
│   └── README.md                  # Links de descarga de syllabi ISTQB
├── README.md
├── LICENSE
└── .gitignore
```

## 🔧 Configuración

### Permisos del Agente

Patesi requiere estos permisos:

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

## 🧠 Engram Integration (Opcional)

Patesi puede aprender patrones QA específicos del proyecto usando [Engram](https://github.com/nicholasgriffintn/engram) de memoria persistente.

### Configuración

1. Agregá Engram MCP a tu `opencode.json`:

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

2. Usá la skill de aprendizaje del proyecto:

```
"Aprendé de la suite de tests de este proyecto"
"Recordá que usamos fixtures, no page objects"
"Qué patrones usa este proyecto?"
```

### Sin Engram

Patesi funciona perfectamente sin Engram. Todas las skills son independientes y no requieren memoria. Simplemente no tenés recall de patrones entre sesiones.

## 🌍 Soporte Multi-Proyecto

### Instalación Global (Por Defecto)

Instalado en `~/.config/opencode/` — disponible en todos los proyectos.

### Overrides por Proyecto

Especificá skills para proyectos específicos creando `.opencode/skills/sdet-{name}/SKILL.md` en la raíz de tu proyecto. Los skills del proyecto tienen prioridad sobre los globales.

### Configuración entre Máquinas

Patesi son solo archivos markdown — portátil entre máquinas:

1. Cloná este repo en cada máquina
2. Ejecutá el script de instalación, o
3. Usá `skills.paths` para apuntar a la ubicación del repo

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
