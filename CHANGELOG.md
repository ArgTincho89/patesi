# Registro de cambios

Todos los cambios relevantes de Patesi se documentarán en este archivo.

Formato basado en [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

### Cambiado
- Consolidada la arquitectura en un núcleo agnóstico y exactamente dos adapters: `adapters/opencode/` y `adapters/copilot/`.
- Movidos la instalación, actualización, configuración de entorno, herramientas concretas de opencode y builder de Copilot dentro de sus adapters correspondientes.
- README simplificado para describir el núcleo sin mecanismos de runtime; la documentación concreta queda en cada adapter.
- §8 de `system.md` reducido al contrato de disponibilidad de conocimiento especializado; su tabla continúa generándose desde los frontmatter.
- La clasificación SQEM documenta la sub-banda de NAQ Alto para misión crítica como derivación del skill, con entregables y controles diferenciados.

## [2.2.0] - 2026-08-25

### Cambiado
- Núcleo independiente del entorno: `agent.md`, `system.md` y `config.yaml` ahora son independientes de las herramientas y compartidos por los adaptadores de opencode/Copilot
- Estandarización del idioma de los triggers en todos los skills (descripciones de frontmatter consistentes)
- Reescritura del generador de registry: `scripts/generate-registry.ps1` / `.sh` ahora escribe directamente en `config.yaml` y `system.md` entre markers (sin archivo intermedio `skills-block.yaml`)
- Reescritura del constructor del adaptador Copilot: concatenación línea por línea en lugar de here-strings (corrige la corrupción Unicode de PS5.1); se agregó la fecha de generación

### Corregido
- Codificación del adaptador Copilot: se reemplazó el here-string (`@"..."`) por construcción línea por línea para evitar la corrupción Unicode de PS5.1; se agregó BOM UTF-8 a todos los scripts PS1
- Sintaxis YAML de la plantilla de memoria: `fixture preferredStyle` → `fixture_preferred_style`
- El generador ahora escribe directamente en `config.yaml` (entre los markers `# SKILLS_BLOCK_START/END`) y en §8 de `system.md` (entre los markers `<!-- SKILL_TABLE_START/END -->`); ya no hace falta copiar y pegar manualmente
- El modo `--check` ahora valida 3 salidas: `.atl/skill-registry.md`, el bloque de skills de `config.yaml` y la tabla §8 de `system.md`

### Agregado
- Script de validación de tokens: `scripts/check-skill-tokens.ps1` / `.sh` — estima la cantidad de tokens por skill y marca los que superan el presupuesto de 4K
- BOM UTF-8 en todos los scripts PS1 (necesario para que PS5.1 lea correctamente literales con tildes)

## [2.1.0] - 2026-08-25

### Agregado
- **10 skills nuevos**: frameworks de automatización (Cypress, Selenium, Appium, Robot Framework), lenguajes (Python, Java, JavaScript/TypeScript), metodologías (Gherkin/BDD, Cucumber) y herramientas de build (Maven/Gradle)
- **Generador del skill registry**: `scripts/generate-registry.ps1` / `.sh` — lee el frontmatter de SKILL.md y genera `.atl/skill-registry.md` (fuente única de verdad)
- **Constructor del adaptador Copilot**: `adapters/copilot/scripts/build-copilot-adapter.ps1` / `.sh` — regenera `adapters/copilot/copilot-instructions.md` desde `agent.md` + `system.md`
- **Conjunto de evaluación de skills**: `tests/skill-eval-set.md` — 18 prompts de tests con triggers esperados para validación
- **Total de skills**: 23 (antes 13)

### Corregido
- **Modelo de permisos**: `adapters/opencode/tools.md` documenta la resolución concreta; `config.yaml` mantiene la autoridad del núcleo
- **Referencia cruzada de la matriz de riesgos**: `sdet-risk-analysis` y `sdet-mr-analysis` ahora se referencian mutuamente e indican cuándo usar cada uno
- **Alcance de Engram**: la integración de memoria de opencode se documenta en `adapters/opencode/tools.md`
- **Eliminación de duplicados de triggers**: la fuente única de verdad ahora es `config.yaml` + `system.md`; el script genera `.atl/skill-registry.md`

### Cambiado
- Configuración actualizada a v2.1.0
- La tabla de skills del README se amplió de 13 a 23 entradas
- La sección de carga de skills de system.md se amplió con ejemplos de skills combinados

## [2.0.0] - 2026-08-25

### Agregado

#### Arquitectura
- **Reestructuración del agente**: se separó el monolito `patesi.md` en una arquitectura modular
  - `agent.md` — identidad, personalidad y principios del agente
  - `system.md` — especificación completa de comportamiento: protocolo de sesión, jerarquía de frameworks, orientación a riesgos, flujo de planificación, reglas de generación, checklist de auto-revisión y workflow de QA
  - `config.yaml` — configuración del agente, permisos y registry de skills
- **Documentación de herramientas**: `adapters/opencode/tools.md` con la referencia específica de opencode
- **Plantillas de memoria**: estructura de memoria del proyecto
  - `memory/_template/context.yaml` — plantilla de contexto del proyecto
  - `memory/_template/patterns.md` — plantilla de almacenamiento de patrones
  - `memory/_template/decisions.md` — plantilla de registro de decisiones
- **Adaptadores**: archivos de integración específicos para IDE
  - `adapters/opencode/patesi.md` — adaptador de opencode con composición `{file:}`
  - `adapters/copilot/copilot-instructions.md` — adaptador de GitHub Copilot

#### Skills SQEM (4 nuevos)
- **sdet-sqem-classification**: cálculo de NAQ, selección de tipología, derivación del delivery target, núcleo común y roles de gobernanza
- **sdet-sqem-gates**: criterios QG0-QG7, matriz F/L/C/N/A por tipología, QG-Express y gestión de excepciones
- **sdet-sqem-controls**: catálogo de controles por gate x NAQ, umbrales de cobertura, perfiles de SonarQube, indicadores y dashboards
- **sdet-sqem-ia**: controles del Anexo IA para AI/ML/GenAI: calidad de datos, golden dataset, tasa de alucinaciones, red-teaming y EU AI Act

#### Compatibilidad con múltiples proyectos
- Flujo de elicitación: al iniciar la sesión se detecta el tipo de proyecto (Seidor/Personal/Gobernado por cliente)
- Clasificación NAQ con reglas de override
- Aislamiento de memoria por proyecto mediante la persistencia definida por el adapter activo
- Jerarquía de frameworks: Modo A (SQEM), Modo B (ISTQB), Modo C (Gobernado por cliente)

### Cambiado
- Skills autodetectados desde el directorio `skills/` (13 en total: 9 originales + 4 SQEM)
- system prompt de opencode compuesto mediante `{file:agent.md}\n\n---\n\n{file:system.md}`
- README actualizado con la nueva arquitectura e instrucciones de instalación
- Skill registry actualizado con los skills SQEM

### Eliminado
- **Soporte de Cursor** (`.cursorrules` eliminado)
- `agents/patesi.md` (reemplazado por `agent.md` + `system.md` en la raíz del repo)
- Monolito `patesi.md` (reemplazado por `agent.md` + `system.md`)
- Directorio `prompts/` (integrado en `system.md`)
- Directorio `workflows/` (integrado en `system.md`)
- Directorio `knowledge/` (redundante con los skills)
- Antiguo `.github/copilot-instructions.md` (reemplazado por `adapters/copilot/copilot-instructions.md`)
- Todas las referencias a Shagaluf (proyecto personal eliminado del alcance del agente)

---

## [1.0.0] - 2026-07-14

### Agregado

#### Agente
- Agente SDET `patesi` con metodología de QA alineada con ISTQB
- Estilo de escritura directo y sin rodeos, sin groserías
- Awareness de casos: cobertura obligatoria de casos happy/unhappy/corner
- Orientación a riesgos y cobertura: métricas explícitas en cada propuesta
- Respaldo de buenas prácticas: ISTQB/industria/justificación requeridos para cada recomendación
- Soporte para protocolo de calidad empresarial (placeholder para integración futura)
- Soporte para múltiples proyectos mediante skills globales + overrides por proyecto

#### Skills (9 en total)
- **sdet-istqb**: referencia condensada de ISTQB Foundation v4.0 + Advanced Core
- **sdet-test-strategy**: generador de estrategias de testing desde user stories con plantilla de 9 secciones
- **sdet-risk-analysis**: matriz de riesgos ponderada (Business 30%, Complexity 25%, Change 20%, Gap 15%, Dependency 10%)
- **sdet-test-cases**: generador estructurado de casos de prueba con formato TC-XXX y prioridad P1-P4
- **sdet-test-classification**: clasificador de suites S/M/L/XL para integración CI/CD
- **sdet-automation**: generador de frameworks Playwright + TypeScript con Page Object Model
- **sdet-cicd**: generador de pipelines CI/CD (GitHub Actions, GitLab CI, Jenkins)
- **sdet-mr-analysis**: analizador de merge requests para impacto y potencial de roturas en tests
- **sdet-project-learning**: aprendizaje de patrones de QA por proyecto mediante memoria persistente de Engram

#### Scripts
- `install.ps1`: instalador para Windows
- `install.sh`: instalador para Linux/macOS
- `update.ps1`: actualizador para Windows (git pull + copy)
- `update.sh`: actualizador para Linux/macOS (git pull + copy)

#### Documentación
- README en castellano con guía completa de instalación y uso
- Configuración de ejemplo del entorno opencode
- Enlaces de descarga de los syllabi ISTQB
- Licencia Apache 2.0

### Decisiones
- El agente se llama "Patesi" (no "sdet") para evitar confusión con el auto-descubrimiento basado en archivos
- El archivo del agente se llama `patesi.md` (no `sdet.md`) para mantener limpia la lista de agentes de opencode
- Los skills usan el prefijo `sdet-` para mantener consistencia en el namespace
- El conocimiento ISTQB está condensado inline (menos de 4K tokens) para optimizar el contexto
- Agente basado en archivos (en el directorio `agents/`) para facilitar el mantenimiento frente a una configuración inline

---

## Cómo actualizar

**Windows:**
```powershell
.\scripts\update.ps1
```

**Linux/macOS:**
```bash
bash adapters/opencode/scripts/update.sh
```

Después reiniciá opencode.
