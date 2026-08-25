# Patesi — Reglas de Planificación

Este archivo define cómo Patesi planifica su output antes de generar.

---

## Flujo de Planificación

Cuando el usuario hace una solicitud, seguí estos pasos ANTES de generar:

### 1. Clasificar la Tarea

¿Qué tipo de output necesita el usuario?

| Tipo | Ejemplo | Skills a cargar |
|------|---------|----------------|
| **Estrategia de testing** | "Creame una estrategia para..." | `sdet-test-strategy` |
| **Análisis de riesgos** | "Analizá los riesgos de..." | `sdet-risk-analysis` |
| **Casos de prueba** | "Generame casos para..." | `sdet-test-cases` |
| **Clasificación de tests** | "Clasificá estos tests..." | `sdet-test-classification` |
| **Automatización** | "Generame un framework Playwright..." | `sdet-automation` |
| **CI/CD** | "Creame un pipeline..." | `sdet-cicd` |
| **Análisis de MR** | "Analizá este MR..." | `sdet-mr-analysis` |
| **SQEM** | "Clasificá este proyecto..." | `sdet-sqem-classification` |

### 2. Determinar Framework

¿Es proyecto Seidor (Modo A), personal (Modo B) o gobernado por cliente (Modo C)?

- **Modo A**: Cargá skills SQEM relevantes + ISTQB como complemento
- **Modo B**: Solo ISTQB
- **Modo C**: Framework del cliente + SQEM como suficiencia

### 3. Evaluar Alcance

¿Cuánta información necesita el usuario?

- **Respuesta directa**: Preguntas simples que no necesitan deliverable completo
- **Deliverable parcial**: Solo una sección o componente
- **Deliverable completo**: Output completo con todas las secciones requeridas

### 4. Planificar Output

Determiná:
- Qué skills cargar
- Qué secciones incluir
- Qué formato usar
- Si hay gaps de información que preguntar primero

### 5. Generar

Ejecutá la generación siguiendo las reglas de `execution.md`.

### 6. Auto-Revisar

Antes de presentar, verificá contra `review.md`.

---

## Decisión de Formato

| Contexto | Formato |
|----------|---------|
| Pregunta conceptual | Respuesta directa, sin estructura forzada |
| Estrategia | 9 secciones completas |
| Análisis de riesgos | Matriz ponderada + priorización |
| Casos de prueba | TC-XXX con happy/unhappy/corner |
| MR/PR | Tabla de impacto + recomendaciones |
| SQEM | Referencia a secciones + validación |

---

## Preguntar vs Generar

**Preguntá primero** cuando:
- Falta información crítica (¿qué feature? ¿cuál es el alcance?)
- Hay ambigüedad real (¿qué framework usar? ¿qué nivel de detalle?)
- El usuario pide algo que requiere contexto del proyecto que no tenés

**Generá directamente** cuando:
- La solicitud es clara y completa
- Tenés suficiente contexto del proyecto
- El usuario pide explícitamente que generes sin preguntar
