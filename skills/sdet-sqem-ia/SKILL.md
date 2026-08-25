---
name: sdet-sqem-ia
description: >
  SQEM Annex IA: AI/ML/GenAI project controls including data quality, golden dataset, groundedness, hallucination rate, red-teaming, fairness, drift, and EU AI Act compliance.
  Trigger: When user asks about AI/ML/GenAI testing, data quality, LLM evaluation, Responsible AI, EU AI Act, or AI-specific quality controls in a Seidor project.
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: sqem
---

# SQEM — Annex IA: AI/ML/GenAI Controls

Controls specific to AI/ML/GenAI projects. Applies when the project's primary or secondary tipologia is "IA / ML / GenAI" (tipologia #10).

---

## Controls by Gate x NAQ

| Control | Gate | NAQ Bajo | NAQ Medio | NAQ Alto |
|---------|------|----------|-----------|----------|
| **Data quality** (dataset/pipeline) | QG1/QG2 | Basic validation (schema, nulls, duplicates) | Data quality gate in critical dimensions + train/test leak control | Data quality gate >=98% + audited labeling + 0 train/test leak |
| **Golden dataset + offline eval** | QG2/QG4 | Recommended (>=50 cases) | Mandatory (>=200 cases, baseline recorded) | Mandatory (>=500 cases, champion vs challenger) |
| **Groundedness/Faithfulness** (RAG) | QG4 | — | >=0.80 (RAGAS or equivalent) | >=0.90 + human sample review |
| **Hallucination rate** | QG4 | Measured and reported | <=threshold agreed with business | <=strict threshold + source traceability mandatory |
| **Red-teaming** (prompt injection + jailbreak) | QG5/QG6 | Basic battery | Standard battery, 0 critical findings | Formal red-teaming + AI pentest, 0 Critical/High open |
| **Fairness/bias** (decisions affecting people) | QG4 | — | Disaggregated metrics documented | Delta between subgroups <=threshold agreed with legal |
| **Task completion** (agents/GenAI) | QG5 | — | >=90% E2E scenarios | >=95% + loop limits and permissions tested |
| **Drift** (data/model) | QG7 | — | Monitoring configured | Thresholds + runbook + AMS owner |
| **EU AI Act classification** | QG0 | Registered in NAQ sheet | Registered in NAQ sheet | If high risk: technical dossier + human oversight + logging (mandatory) |

---

## AI-Specific Test Types

### Data Quality Testing
- Schema validation (fields, types, constraints)
- Null/missing value handling
- Duplicate detection
- Data lineage verification
- Train/test separation validation (no leakage)
- Label quality audit (for supervised learning)

### Model Evaluation
- Offline metrics (accuracy, F1, precision, recall, AUC)
- Baseline recording and comparison
- Champion vs challenger evaluation
- Slice analysis (performance across subgroups)

### LLM/RAG Evaluation
- Groundedness/Faithfulness (RAGAS or equivalent)
- Hallucination rate measurement
- Answer relevance scoring
- Context precision and recall
- Source attribution verification

### Agent Evaluation
- Task completion rate (E2E scenarios)
- Loop limit testing (prevent infinite agent loops)
- Permission boundary testing
- Tool usage correctness
- Multi-step reasoning validation

### Red-Teaming
- Prompt injection attacks
- Jailbreak attempts
- Data extraction attempts
- Adversarial input robustness
- Boundary condition behavior

### Fairness/Bias
- Disaggregated metrics by subgroup
- Statistical parity analysis
- Equal opportunity assessment
- Impact assessment for decisions affecting people

### Drift Monitoring
- Data drift detection (distribution changes)
- Model performance drift
- Concept drift identification
- Alert thresholds and runbook

---

## EU AI Act Compliance (Section 16)

### Classification at QG0

Register the AI system's EU AI Act risk classification in the NAQ sheet:
- **Unacceptable risk** — Prohibited
- **High risk** — Requires technical dossier, human oversight, logging
- **Limited risk** — Transparency obligations
- **Minimal risk** — No specific obligations

### High-Risk AI System Requirements

At QG0, if classified as high risk:
- Technical dossier preparation
- Human oversight mechanisms design
- Logging and audit trail requirements
- Registration in EU AI database

---

## Tooling Reference

| Function | Recommended Tools |
|----------|------------------|
| Data quality | Great Expectations, Pandera, Deequ |
| LLM evaluation | RAGAS, DeepEval, promptfoo |
| Red-teaming | Garak, AI-exploits, custom batteries |
| Fairness | Fairlearn, AIF360, AI Fairness 360 |
| Drift monitoring | Evidently, NannyML, Alibi Detect |
| Observability | Langfuse, LangSmith, Phoenix |

---

## Trigger Keywords

Load this skill when the user says any of:
- "AI testing", "ML testing", "GenAI testing", "LLM testing"
- "data quality", "golden dataset", "train test leak"
- "groundedness", "faithfulness", "hallucination"
- "red-teaming", "prompt injection", "jailbreak"
- "fairness", "bias", "AI bias"
- "drift", "model drift", "data drift"
- "EU AI Act", "AI regulation", "responsible AI"
- "agente IA", "testing IA", "calidad IA"
