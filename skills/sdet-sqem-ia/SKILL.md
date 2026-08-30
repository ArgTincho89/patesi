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
| **Data quality** (dataset/pipeline) | QG1/QG2 | Validación básica (schema, nulos, duplicados) | Quality gate de datos en dimensiones críticas + control de filtración train/test | Quality gate de datos >=98% + etiquetado auditado + 0 filtraciones train/test |
| **Golden dataset + offline eval** | QG2/QG4 | Recomendado (>=50 casos) | Obligatorio (>=200 casos, baseline registrado) | Obligatorio (>=500 casos, champion frente a challenger) |
| **Groundedness/Faithfulness** (RAG) | QG4 | — | >=0.80 (RAGAS or equivalent) | >=0.90 + human sample review |
| **Hallucination rate** | QG4 | Medida e informada | <=umbral acordado con negocio | <=umbral estricto + trazabilidad de fuentes obligatoria |
| **Red-teaming** (prompt injection + jailbreak) | QG5/QG6 | Basic battery | Standard battery, 0 critical findings | Formal red-teaming + AI pentest, 0 Critical/High open |
| **Fairness/bias** (decisions affecting people) | QG4 | — | Disaggregated metrics documented | Delta between subgroups <=threshold agreed with legal |
| **Task completion** (agents/GenAI) | QG5 | — | >=90% de escenarios E2E | >=95% + límites de loop y permisos testeados |
| **Drift** (datos/modelo) | QG7 | — | Monitoreo configurado | Umbrales + runbook + responsable de AMS |
| **EU AI Act classification** | QG0 | Registrada en la ficha NAQ | Registrada en la ficha NAQ | Si es de alto riesgo: dossier técnico + supervisión humana + logging (obligatorio) |

---

## Tipos de tests específicos de IA

### Testing de calidad de datos
- Schema validation (fields, types, constraints)
- Null/missing value handling
- Duplicate detection
- Data lineage verification
- Train/test separation validation (no leakage)
- Label quality audit (for supervised learning)

### Evaluación de modelos
- Offline metrics (accuracy, F1, precision, recall, AUC)
- Baseline recording and comparison
- Champion vs challenger evaluation
- Slice analysis (performance across subgroups)

### Evaluación de LLM/RAG
- Groundedness/Faithfulness (RAGAS or equivalent)
- Hallucination rate measurement
- Answer relevance scoring
- Context precision and recall
- Source attribution verification

### Evaluación de agentes
- Task completion rate (E2E scenarios)
- Loop limit testing (prevent infinite agent loops)
- Permission boundary testing
- Tool usage correctness
- Multi-step reasoning validation

### Red-teaming
- Prompt injection attacks
- Jailbreak attempts
- Data extraction attempts
- Adversarial input robustness
- Boundary condition behavior

### Equidad/sesgo
- Disaggregated metrics by subgroup
- Statistical parity analysis
- Equal opportunity assessment
- Impact assessment for decisions affecting people

### Monitoreo de drift
- Data drift detection (distribution changes)
- Model performance drift
- Concept drift identification
- Alert thresholds and runbook

---

## Cumplimiento del EU AI Act (sección 16)

### Clasificación en QG0

Registrá la clasificación de riesgo del sistema de IA según EU AI Act en la ficha NAQ:
- **Riesgo inaceptable** — Prohibido
- **Alto riesgo** — Requiere dossier técnico, supervisión humana y logging
- **Riesgo limitado** — Obligaciones de transparencia
- **Riesgo mínimo** — Sin obligaciones específicas

### Requisitos para sistemas de IA de alto riesgo

At QG0, if classified as high risk:
- Technical dossier preparation
- Human oversight mechanisms design
- Requisitos de logging y trazabilidad de auditoría
- Registration in EU AI database

---

## Referencia de herramientas

| Function | Recommended Tools |
|----------|------------------|
| Data quality | Great Expectations, Pandera, Deequ |
| LLM evaluation | RAGAS, DeepEval, promptfoo |
| Red-teaming | Garak, AI-exploits, custom batteries |
| Fairness | Fairlearn, AIF360, AI Fairness 360 |
| Drift monitoring | Evidently, NannyML, Alibi Detect |
| Observability | Langfuse, LangSmith, Phoenix |

---
