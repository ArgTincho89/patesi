---
name: sdet-sqem-classification
description: >
  Clasificación de proyectos SQEM: cálculo de NAQ, selección de tipología, derivación del delivery target, núcleo común y roles de gobernanza.
  Trigger: clasificación de proyecto Seidor, cálculo NAQ, tipología, delivery target
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: sqem
---

# SQEM — Clasificación de proyectos

Clasifica proyectos Seidor usando el framework SQEM (Seidor Quality Engineering Model). Es el punto de entrada para todo trabajo de calidad Seidor.

---

## Los dos ejes de decisión

```
Axis 1: NAQ (Quality Assurance Level) → Bajo / Medio / Alto
Axis 2: Project Tipologia (15 types, composable)
              ↓  combined automatically
OUTPUT: Delivery Target → Basico / Integrado / Continuo
```

---

## Eje 1 — NAQ (sección 5.1)

### Fórmula de NAQ

Promedio ponderado, con cada factor puntuado de 0 a 4:

| Factor | Peso |
|--------|--------|
| Business Criticality | 8 |
| Visibilidad / uso | 4 |
| Interoperability | 4 |
| Data Sensitivity | 4 |
| Technical Maturity | 2 (suspended until data available) |
| Complexity | 2 |

`NAQ = Sum(score_i x weight_i) / Sum(active_weights)`

### Bandas de NAQ

| Valor | Nivel | Intención | Esfuerzo de QA |
|-------|-------|--------|-----------|
| >=0 y <1.5 | **Bajo** | Velocidad: no ralentizar la entrega | Bajo |
| >=1.5 y <3 | **Medio** | Equilibrio: costo frente a riesgo | Medio |
| >=3 | **Alto** | Minimizar el riesgo de negocio | Alto (muy alto para misión crítica) |

### Reglas de override (no negociables)

- Business Criticality=4 **OR** Data Sensitivity=4 → **NAQ Alto** forced
- Business Criticality>=3 **AND** Data Sensitivity>=3 → minimum **NAQ Medio**
- Impacts on person safety / serious legal breach / critical ops continuity → **NAQ Alto**
- AI system classified as "high risk" under EU AI Act → **NAQ Alto** + Annex IA (Section 16)

### Sub-banda de misión crítica (dentro de Alto)

Activates when override rules trigger:

| Control | Alto ordinario | Alto — mision critica |
|---------|---------------|----------------------|
| Code coverage | New >=80% / Overall >=70% | **New >=90% / Overall >=80%** |
| Code review | >=1 senior reviewer | **>=2 senior reviewers, one independent** |
| Mutation testing | Recommended | **Mandatory** |
| Security | SAST/DAST/SCA | + **formal pentest**, 0 Critical/High open |
| DR/rollback | SLO defined | + **validated in rehearsal + MTTR verified** |
| Deliverables | NAQ Alto minimums | + **formal risk report + Go/No-Go with Direction** |

### Triggers de reevaluación de NAQ

- >=3 Sev1/Sev2 incidents in production within 3 months on same application
- DER above band threshold for 2 consecutive releases
- Cambio sustancial en el alcance, las integraciones o los requisitos de cumplimiento

---

## Eje 2 — Tipologías (sección 5.2)

15 tipos componibles (uno primario + componentes secundarios):

| # | Tipología | Tests / controles clave |
|---|-----------|---------------------|
| 1 | **New Development** | Unit, static analysis, code review, integration, E2E, UAT, smoke, NF by NAQ |
| 2 | **Evolutionary Maintenance (AMS)** | Impact analysis, selective regression, defect confirmation, smoke |
| 3 | **Corrective Maintenance (AMS)** | Defect reproduction, confirmation test, selective regression, smoke |
| 4 | **Hotfix / Emergency** | QG-Express: peer review + directed smoke + rollback + ex-post closure 24-48h |
| 5 | **Transformation / Migration** | Baseline, migration/reconciliation, regression, NF, formal UAT, rollback |
| 6 | **Integrations / APIs / Data** | Contract testing, integration, negative tests, data validation, resilience, perf, security |
| 7 | **Digital Product / User Channel** | E2E, usability, accessibility (WCAG), compatibility, performance, security |
| 8 | **Packaged (SAP/Salesforce/...)** | Functional config, integration, E2E regression, UAT, role security, batch perf |
| 9 | **Producto de mercado (COTS/SaaS)** | Requisitos frente al estándar del producto, revisión de configuración, integración, UAT funcional, NF según NAQ |
| 10 | **AI / ML / GenAI** | Data/model quality, LLM/RAG, agents, Responsible AI, continuous evaluation — Annex IA Section 16 |
| 11 | **Data & Analytics / BI** | Data quality (completeness, accuracy, uniqueness, lineage), reconciliation, rules, perf |
| 12 | **Infrastructure / DevOps / Cloud** | IaC linting/policy-as-code, deploy/idempotency, hardening/CIS, DR, observability |
| 13 | **RPA / Automation** | E2E process, exception/retry handling, UI robustness, process regression, monitoring |
| 14 | **Cybersecurity** | SAST/DAST/SCA, pentest, threat modeling, hardening verification, compliance evidence |
| 15 | **Consulting** | Peer review, document QC, client validation — build/production gates N/A |

> **Composable:** declare one primary tipologia + secondary components. Controls = union of all, modulated by the same NAQ.

---

## Salida — Delivery Target (sección 5.3.4)

| Target | Minimum capabilities |
|--------|---------------------|
| **Basico** | Checklist, documented manual tests, smoke, defects logged, manual gates and evidence |
| **Integrado** | CI, SonarQube in pipeline, critical regression automated, req-test traceability, partial auto-gates, KPI dashboard |
| **Continuo** | Automatic quality gates in CI/CD, high automation (E2E), recurring NF, executive dashboards, controlled deploys with rehearsed rollback |

**Recommendation rule:** Continuo when high deploy frequency OR NAQ Alto. Basico is the minimum. Integrado is the portfolio target.

---

## Núcleo común NO NEGOCIABLE (sección 5.4)

Estos 9 ítems aplican a TODOS los proyectos Seidor, sin importar NAQ, tipología o delivery target:

1. NAQ assigned + project/application sheet completed
2. Criterios de aceptación definidos para el alcance del entregable
3. Defect management with standard severity in ALM tool
4. **Smoke test pre and post-deploy**
5. **Zero blocking/critical defects open** to pass to production
6. **Go/No-Go decision recorded** (even lightweight) before production
7. Deploy and rollback plan (proportional to risk)
8. Standard nomenclature and traceability
9. **GDPR compliance in test data** (never unmasked real data)

---

## Roles de gobernanza (sección 3.2)

| Role | Responsibility |
|------|---------------|
| **QA Manager** | Model owner. Portfolio KPIs, audits, training, NAQ Alto exception arbitration. |
| **QA Lead** | Adapts model to project, defines Test Strategy, controls gates, reports quality and risks. |
| **QA Engineer** | Designs/executes tests, automates, manages defects and evidence. |
| **Tech Lead / Architect** | Technical quality, code and design review, NFRs, technical debt, ADRs. |
| **PM / Delivery Manager** | Integra la calidad en la planificación, asegura recursos y evidencias, y gestiona dependencias. |
| **Product Owner / Client** | Defines acceptance criteria, prioritizes defects, approves UAT and Go-Live. |
| **DevOps / Release Manager** | CI/CD, automatic quality gates, deployment, rollback, smoke, observability. |

---
