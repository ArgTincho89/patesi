# Registro de cambios

Todos los cambios relevantes de Patesi se documentarán en este archivo.

Formato basado en [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

_Sin cambios pendientes._

## [3.0.0] - 2026-08-31

Versión mayor: cambia el contrato de comportamiento del agente. Patesi ya no
asume un único marco de calidad ni puede escribir en el proyecto que evalúa.

### Agregado

#### Los tres modos de operación
- Toda sesión abre preguntando si se trabaja sobre un proyecto **de Seidor**, **personal** o **de un cliente**. Ninguno es el modo por defecto.
- **Modo A (Seidor)** — SQEM como fuente de verdad, con fallback declarado cuando la normativa no cubre el caso.
- **Modo B (personal)** — buenas prácticas de la industria + ISTQB, con contrato docente: explicar el porqué, nombrar la técnica, calibrar la dosis. El usuario decide; Patesi informa el riesgo una vez y después ejecuta lo pedido, completo.
- **Modo C (cliente)** — interroga la metodología del cliente, la persiste y la actualiza de forma continua; ISTQB como fallback declarado para los huecos.
- Los tres modos tienen la misma profundidad. La paridad entre opencode y Copilot se garantiza por extracción literal (marcadores `COPILOT-EXTRACT`), no por disciplina.

#### Límite de escritura
- Patesi asegura calidad, **no desarrolla**: solo lectura sobre el proyecto bajo prueba.
- Escribe únicamente en su **repositorio de pruebas propio** y en sus artefactos.
- Ante un defecto: informa → confirma → revisa si su plan lo cubría → crea la prueba faltante (unitaria o de integración interna como **propuesta** para el agente desarrollador; E2E, API o contrato en su propio repo) → actualiza los planes de smoke y regresión.
- Aplica en los tres modos. `sdet-test-repo` documenta el reparto y el handoff.

#### Modo A sobre la normativa SQEM v1.2
- NAQ calculado desde los 6 factores con sus escalas 0-4, con `Madurez tecnológica` excluida del denominador (22) y el override por criticidad.
- Las 15 tipologías con sus nombres canónicos.
- `sdet-sqem-gate-matrix`: las **60 combinaciones** tipología × banda de NAQ resueltas (480 celdas), con nota justificativa por gate y las excepciones documentadas de §6.5 — AMS conserva QG0 Ligero en NAQ Alto, Hotfix es inmune a la elevación.
- Anexo IA con sus 13 controles y la clasificación EU AI Act en QG0.
- Toda afirmación normativa cita su sección; todo lo que no viene de SQEM se declara como fallback.

#### Auto-QA del agente
- `scripts/check-consistency.py` — 13 verificaciones de consistencia interna, con el principio de **cero falsos positivos**.
- `scripts/check-sqem-matrix.py` — valida las 480 celdas contra §6.4 y contra su propia coherencia estructural.
- `scripts/patesi-doctor.py` — compara el repo contra lo realmente instalado en `~/.config/opencode/`. `git pull` no actualiza al agente.
- `SOURCES.yaml` — qué versión de cada fuente normativa alimenta cada skill, incluidas las cuatro que la normativa referencia y todavía no tenemos.
- `.github/workflows/consistencia.yml` — corre los checks en push y PR, y avisa cuando cambia el núcleo o los skills SQEM.
- `tests/smoke-comportamiento.md` — 8 casos con prompts literales, ~5 min.
- `tests/guiones-evaluacion.md` — guiones ejecutables de los tres modos y del límite de escritura.
- `skills/sdet-self-review` — las siete clases de contradicción interna que ningún script puede detectar.
- Verificación de que la versión coincide en `agent.md`, `config.yaml` y el CHANGELOG, y de que la entrada más nueva del changelog es la versión actual.

#### Skills nuevos
`sdet-industry-practices`, `sdet-exploratory-testing`, `sdet-api-testing`, `sdet-accessibility`, `sdet-performance`, `sdet-security-testing`, `sdet-client-profile`, `sdet-client-onboarding`, `sdet-test-repo`, `sdet-self-review`, `sdet-sqem-gate-matrix`, `sdet-sqem-typology-tests`, `sdet-sqem-governance`. **Total: 36** (antes 23).

### Cambiado
- Contenido de Patesi íntegramente en castellano, incluido el que se escondía dentro de fences ` ```markdown `.
- Formato de respuesta con cantidad de secciones dependiente del modo, y la razón de cada omisión declarada en una línea.
- Consolidada la arquitectura en un núcleo agnóstico y exactamente dos adapters: `adapters/opencode/` y `adapters/copilot/`.
- Instalación, actualización, configuración de entorno, herramientas concretas de opencode y builder de Copilot movidos dentro de sus adapters.
- §8 de `system.md` reducido al contrato de disponibilidad de conocimiento especializado; su tabla se sigue generando desde los frontmatter.
- La clasificación SQEM documenta la sub-banda de NAQ Alto para misión crítica, con entregables y controles diferenciados.
- README con el estado actual: los tres modos, la regla fundamental, el catálogo de 36 skills y la sección de Auto-QA.

### Corregido
- **`system.md` había perdido 297 líneas** —los 6 marcadores `COPILOT-EXTRACT` completos— en un commit ya publicado. Causa raíz: `update_marked_section` de `generate-registry.sh` usaba `>>` sin truncar y sin limpieza ante interrupción; una corrida interrumpida dejaba un temporal parcial que la siguiente movía sobre el archivo real. Se agregó `mktemp` + `trap` + una guarda que aborta si el resultado pierde más de la mitad de las líneas.
- `generate-registry.ps1` agregaba una línea en blanco por corrida: no era idempotente.
- La ruptura de paridad entre builders era **line endings mezclados**, no divergencia real. Resuelto con `.gitattributes`.
- `build-copilot-adapter.sh` borraba la última línea de `agent.md` cuando el archivo no tenía separador `---`.
- `config.yaml` había perdido sus marcadores `SKILLS_BLOCK`, lo que rompía toda regeneración en silencio. Restaurados, con guardas de código de salida para que los generadores fallen fuerte.
- Etiquetas sin tilde: se corrigieron en los mapas de los generadores, no en el archivo de salida, que se regeneraba.
- La nota de QG5 en mantenimiento correctivo decía `C (mitad)`, corrupción de `C (→ NAQ Alto)`.
- Se eliminó contenido normativo inventado que no existía en la fuente SQEM (rúbrica de madurez técnica de 5 niveles y activación objetiva del peso).
- **`generate-registry.sh` borraba los marcadores `SKILLS_BLOCK` de `config.yaml` en cada corrida**, dejando el archivo irregenerable, y salía con código 0. `update_marked_section` no conserva las líneas de marcador —las reemplaza por el contenido—, y el contenido de `config.yaml` no las incluía; el de `system.md` sí, por eso solo fallaba uno de los dos. En Windows nunca se notó porque solo se corría el `.ps1`.
- Los generadores no tenían verificación de paridad entre sí; los builders del adapter sí. Ahí se escondió el bug anterior. Agregada `paridad de generadores`.
- Los artefactos generados llevaban sello de fecha, así que cambiaban solos todos los días: ensuciaban el diff y disparaban el check de idempotencia sin motivo. Cuándo cambió es dato de git; qué contiene es dato del archivo.
- El check de paridad se auto-saltaba en CI porque invocaba `powershell`, inexistente en Linux. Usa `pwsh` fuera de Windows y el workflow exige ambos shells.
- `.atl/.skill-registry.cache.json` estaba versionado pese a figurar en `.gitignore`.

### Notas de migración
- Reinstalá con `adapters/opencode/scripts/install.ps1` (o `.sh`) y reiniciá opencode. `git pull` **no** alcanza.
- Verificá con `python scripts/patesi-doctor.py` antes de evaluar nada.

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
