---
name: sdet-sqem-ia
description: >
  Anexo IA de SQEM: controles para proyectos AI/ML/GenAI, incluyendo calidad de datos, golden dataset, groundedness, tasa de alucinaciones, red-teaming, equidad, drift y cumplimiento del EU AI Act.
  Trigger: proyectos IA/ML/GenAI, calidad de datos, golden dataset, red-teaming, EU AI Act
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: sqem
---

# SQEM — Anexo IA: controles AI/ML/GenAI

Controles específicos para proyectos AI/ML/GenAI. Aplica cuando la tipología primaria o secundaria del proyecto es "IA / ML / GenAI" (tipología #10).

---

## Controles por gate x NAQ

| Control | Gate | NAQ Bajo | NAQ Medio | NAQ Alto |
|---------|------|----------|-----------|----------|
| **Calidad de datos** (dataset/pipeline) | QG1/QG2 | Validación básica (schema, nulos, duplicados) | Quality gate de datos en dimensiones críticas + control de filtración train/test | Quality gate de datos >=98% + etiquetado auditado + 0 filtraciones train/test |
| **Golden dataset + evaluación offline** | QG2/QG4 | Recomendado (>=50 casos) | Obligatorio (>=200 casos, baseline registrado) | Obligatorio (>=500 casos, champion frente a challenger) |
| **Groundedness/Faithfulness** (RAG) | QG4 | — | >=0.80 (RAGAS o equivalente) | >=0.90 + revisión humana por muestreo |
| **Tasa de alucinaciones** | QG4 | Medida e informada | <=umbral acordado con negocio | <=umbral estricto + trazabilidad de fuentes obligatoria |
| **Red-teaming** (prompt injection + jailbreak) | QG5/QG6 | Batería básica | Batería estándar, 0 hallazgos críticos | Red-teaming formal + pentest de IA, 0 Critical/High abiertos |
| **Equidad/sesgo** (decisiones que afectan a personas) | QG4 | — | Métricas desagregadas documentadas | Delta entre subgrupos <=umbral acordado con legal |
| **Task completion** (agentes/GenAI) | QG5 | — | >=90% de escenarios E2E | >=95% + límites de loop y permisos testeados |
| **Drift** (datos/modelo) | QG7 | — | Monitoreo configurado | Umbrales + runbook + responsable de AMS |
| **Clasificación EU AI Act** | QG0 | Registrada en la ficha NAQ | Registrada en la ficha NAQ | Si es de alto riesgo: dossier técnico + supervisión humana + logging (obligatorio) |

---

## Tipos de tests específicos de IA

### Testing de calidad de datos
- Validación de schema (campos, tipos, restricciones)
- Manejo de nulos y valores faltantes
- Detección de duplicados
- Verificación del linaje de datos
- Validación de la separación train/test (sin filtración)
- Auditoría de la calidad del etiquetado (en aprendizaje supervisado)

### Evaluación de modelos
- Métricas offline (accuracy, F1, precisión, recall, AUC)
- Registro y comparación de baseline
- Evaluación champion frente a challenger
- Análisis por slices (rendimiento entre subgrupos)

### Evaluación de LLM/RAG
- Groundedness/Faithfulness (RAGAS o equivalente)
- Medición de la tasa de alucinaciones
- Puntuación de relevancia de respuestas
- Precisión y recall del contexto
- Verificación de la atribución de fuentes

### Evaluación de agentes
- Tasa de task completion (escenarios E2E)
- Testing de límites de loop (evitar loops infinitos del agente)
- Testing de los límites de permisos
- Corrección en el uso de herramientas
- Validación del razonamiento multi-paso

### Red-teaming
- Ataques de prompt injection
- Intentos de jailbreak
- Intentos de extracción de datos
- Robustez ante entradas adversarias
- Comportamiento en condiciones de borde

### Equidad/sesgo
- Métricas desagregadas por subgrupo
- Análisis de paridad estadística
- Evaluación de igualdad de oportunidades
- Evaluación de impacto en decisiones que afectan a personas

### Monitoreo de drift
- Detección de data drift (cambios de distribución)
- Drift de rendimiento del modelo
- Identificación de concept drift
- Umbrales de alerta y runbook

---

## Cumplimiento del EU AI Act (sección 16)

### Clasificación en QG0

Registrá la clasificación de riesgo del sistema de IA según EU AI Act en la ficha NAQ:
- **Riesgo inaceptable** — Prohibido
- **Alto riesgo** — Requiere dossier técnico, supervisión humana y logging
- **Riesgo limitado** — Obligaciones de transparencia
- **Riesgo mínimo** — Sin obligaciones específicas

### Requisitos para sistemas de IA de alto riesgo

En QG0, si se clasifica como de alto riesgo:
- Preparación del dossier técnico
- Diseño de los mecanismos de supervisión humana
- Requisitos de logging y trazabilidad de auditoría
- Registro en la base de datos de IA de la UE

---

## Referencia de herramientas

| Función | Herramientas recomendadas |
|----------|------------------|
| Calidad de datos | Great Expectations, Pandera, Deequ |
| Evaluación de LLM | RAGAS, DeepEval, promptfoo |
| Red-teaming | Garak, AI-exploits, baterías propias |
| Equidad | Fairlearn, AIF360, AI Fairness 360 |
| Monitoreo de drift | Evidently, NannyML, Alibi Detect |
| Observabilidad | Langfuse, LangSmith, Phoenix |

---
