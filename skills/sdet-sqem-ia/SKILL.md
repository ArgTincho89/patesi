---
name: sdet-sqem-ia
description: >
  Anexo IA de SQEM (§16): los 13 controles gate-ables para IA/ML/GenAI con criterio de aceptación por NAQ, mapeo de obligaciones del EU AI Act y tipos de prueba específicos.
  Trigger: proyectos IA/ML/GenAI, groundedness, alucinaciones, red-teaming, golden dataset, drift, EU AI Act
license: Apache-2.0
metadata:
  author: patesi
  version: "2.0"
  category: sqem
---

# SQEM — Anexo IA (§16)

Convierte el catálogo de pruebas IA/ML/GenAI de la Oficina de Calidad en **controles verificables en puerta**, con criterio de aceptación por NAQ.

Aplica a la tipología **IA / ML / GenAI** (§5.2) y a **cualquier componente de IA embebido en otra tipología**.

> **Herencia obligatoria:** al ser proyectos compuestos, IA/ML/GenAI **hereda la calidad de datos de Data & Analytics** (data quality gate por NAQ) sobre el dataset/pipeline de entrenamiento, RAG y features.

> Criterios de aceptación: valores por defecto provisionales (v0), pendientes de re-baseline en pilotaje (§14).

---

## Los 13 controles IA x puerta x NAQ (§16.1)

| Control | Puerta / gate | NAQ Bajo | NAQ Medio | NAQ Alto |
|---------|---------------|----------|-----------|----------|
| **Calidad de datos** (dataset/pipeline) | Datos–Diseño (QG1/QG2) | Validación básica: esquema, nulos, duplicados | Data quality gate en dimensiones críticas (completitud, exactitud, unicidad, linaje) + control de fuga train/test | Data quality gate **>=98%** + etiquetado auditado, representatividad/balance verificados, linaje completo y **0 fuga train/test** |
| **Golden dataset y evaluación offline** | Preprod. (QG2/QG4) | Recomendado (>=50 casos) | Obligatorio (>=200 casos, baseline registrado) | Obligatorio (>=500 casos, *champion vs challenger*) |
| **Groundedness / Faithfulness** (RAG) | Preprod.–UAT (QG4) | — | >= 0,80 (RAGAS o equivalente) | >= 0,90 + revisión humana muestral |
| **Tasa de alucinación** | Preprod.–UAT (QG4) | Medida y reportada | <= umbral pactado con negocio | <= umbral estricto + trazabilidad de fuentes obligatoria |
| **Red-teaming** (prompt injection + jailbreak) | UAT–Prod. (QG5/QG6) | Batería básica | Batería estándar, 0 hallazgos críticos | Red-teaming formal + pentest IA, 0 críticos/altos abiertos |
| **Fairness / sesgo** (decisiones sobre personas) | Preprod. (QG4) | — | Métricas desagregadas documentadas | Delta entre subgrupos <= umbral pactado con negocio/legal, **auditable** |
| **Precisión de recuperación** (precision@k / recall) | Preprod. (QG4) | Reportada | >= umbral por caso de uso | >= umbral estricto + análisis de fallos |
| **Task completion** (agentes/GenAI) | UAT (QG5) | — | >= 90% en escenarios E2E | >= 95% + límites de bucle y permisos probados |
| **Coste por interacción / token budget** | Prod. (QG6) | Estimado | Presupuesto definido | Presupuesto + alerta de desviación en producción |
| **Latencia (p95)** | Preprod. (QG4) | Medida | <= umbral de la Estrategia de Pruebas | <= umbral estricto bajo carga representativa |
| **Drift** (data / model) | Cierre–RUN (QG7) | — | Monitorización configurada | Umbrales + runbook + responsable en AMS |
| **Evaluación humana muestral** | UAT (QG5) | — | Muestra revisada por experto | Muestra ampliada + criterio de aceptación documentado |
| **Clasificación EU AI Act** (§11.2) | Idea/Kickoff (QG0) | Registrada en ficha NAQ | Registrada en ficha NAQ | Si alto riesgo: **expediente técnico + supervisión humana + logging** (obligatorio) |

> Un sistema de IA de **alto riesgo (EU AI Act)** es **NAQ Alto por override (§5.1)** y **no promociona en QG6** sin los controles obligatorios de la columna Alto.

Estos controles son la materialización IA del catálogo consolidado §10.6, y sus resultados alimentan §7.1 como indicadores de la tipología, con su ficha §7.4.

---

## Cumplimiento del EU AI Act (§11.2)

### Clasificación en QG0 — obligatoria

Registrá la clasificación de riesgo en la ficha NAQ:

- **Riesgo inaceptable** → Prohibido
- **Alto riesgo** → NAQ Alto por override; activa los controles del Anexo IA
- **Riesgo limitado** → Obligaciones de transparencia
- **Riesgo mínimo** → Sin obligaciones específicas

**Sistemas de alto riesgo (Anexo III):** RRHH y selección, scoring crediticio, educación, servicios esenciales, biometría, salud, justicia.

Los modelos GenAI de propósito general añaden obligaciones de transparencia y de gestión de riesgo sistémico.

**La ausencia de clasificación y sus evidencias en un sistema de alto riesgo es una no conformidad.**

### Mapeo de obligaciones a controles del modelo (§16.2)

| Obligación (sistemas de alto riesgo) | Control equivalente en el modelo |
|---|---|
| Sistema de gestión de riesgos | Gestión de riesgos §11.1 + NAQ Alto por override (§5.1) |
| Gobernanza y calidad de datos | Golden dataset, calidad de datos (ISO/IEC 5259), reglas de datos §6.9 |
| Documentación técnica y registros | Entregables §9 + expediente técnico del sistema |
| Registro de eventos (logging) | Observabilidad §10.6 / §11.4 (logs, métricas, trazas) |
| Transparencia e información al usuario | Documentación §10.6 + explicabilidad |
| Supervisión humana | Evaluación humana muestral (§16.1) + Go-Live Review con negocio |
| Robustez, precisión y ciberseguridad | Red-teaming, fairness, groundedness, pentest IA (§16.1) + Security §10.6 |

Varias obligaciones ya existen como control en el modelo; el anexo las declara y las hace **exigibles en puerta**.

---

## Tipos de prueba específicos de IA

### Calidad de datos
Validación de esquema · Manejo de nulos y valores faltantes · Detección de duplicados · Verificación del linaje · Validación de separación train/test sin filtración · Auditoría de la calidad del etiquetado

### Evaluación de modelos
Métricas offline (accuracy, F1, precisión, recall, AUC) · Registro y comparación de baseline · Champion frente a challenger · Análisis por slices entre subgrupos

### Evaluación de LLM/RAG
Groundedness/Faithfulness · Tasa de alucinaciones · Relevancia de respuestas · Precisión y recall del contexto · Verificación de atribución de fuentes

### Evaluación de agentes
Task completion en escenarios E2E · Límites de bucle · Límites de permisos · Corrección en el uso de herramientas · Razonamiento multi-paso

### Red-teaming
Prompt injection · Jailbreak · Extracción de datos · Robustez ante entradas adversarias · Condiciones de borde

### Equidad y sesgo
Métricas desagregadas por subgrupo · Paridad estadística · Igualdad de oportunidades · Evaluación de impacto en decisiones sobre personas

### Monitoreo de drift
Data drift · Drift de rendimiento del modelo · Concept drift · Umbrales de alerta y runbook

---

## Referencia de herramientas (§10.1)

| Función | Referencia | Equivalentes |
|---------|------------|--------------|
| Evaluación de LLM | promptfoo, RAGAS, DeepEval | Giskard, TruLens, Azure AI Evaluation |
| Observabilidad y drift | Langfuse, Evidently | Arize, LangSmith |
| Calidad de datos | Great Expectations, Pandera, Deequ | — |
| Red-teaming | Garak, baterías propias | AI-exploits |
| Equidad | Fairlearn, AIF360 | — |

---

## Nota de gobierno: código asistido por IA (§11.3)

Aplica a **cualquier** proyecto, no solo a los de tipología IA:

El código generado o completado por IA **no exime de revisión humana**. Pasa por code review humano, análisis estático y las mismas pruebas. Atención específica a **alucinaciones de API, licencias y propiedad intelectual de dependencias sugeridas, y fugas de datos sensibles en prompts**.

**En NAQ Alto, la revisión humana de código asistido por IA es obligatoria y trazable.**
