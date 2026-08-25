---
name: sdet-sqem-classification
description: >
  SQEM project classification: NAQ calculation, tipologia selection, delivery target derivation, nucleo comun, and governance roles.
  Trigger: clasificación de proyecto Seidor, cálculo NAQ, tipología, delivery target
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: sqem
---

# SQEM — Project Classification

Classifies Seidor projects using the SQEM (Seidor Quality Engineering Model) framework. This is the entry point for all Seidor quality work.

---

## The Two Decision Axes

```
Axis 1: NAQ (Quality Assurance Level) → Bajo / Medio / Alto
Axis 2: Project Tipologia (15 types, composable)
              ↓  combined automatically
OUTPUT: Delivery Target → Basico / Integrado / Continuo
```

---

## Axis 1 — NAQ (Section 5.1)

### NAQ Formula

Weighted average, each factor scored 0-4:

| Factor | Weight |
|--------|--------|
| Business Criticality | 8 |
| Visibility / Usage | 4 |
| Interoperability | 4 |
| Data Sensitivity | 4 |
| Technical Maturity | 2 (suspended until data available) |
| Complexity | 2 |

`NAQ = Sum(score_i x weight_i) / Sum(active_weights)`

### NAQ Bands

| Value | Level | Intent | QA Effort |
|-------|-------|--------|-----------|
| >=0 and <1.5 | **Bajo** | Speed — do not slow delivery | Low |
| >=1.5 and <3 | **Medio** | Balance — cost vs risk | Medium |
| >=3 | **Alto** | Minimize business risk | High (very high for mision critica) |

### Override Rules (Non-Negotiable)

- Business Criticality=4 **OR** Data Sensitivity=4 → **NAQ Alto** forced
- Business Criticality>=3 **AND** Data Sensitivity>=3 → minimum **NAQ Medio**
- Impacts on person safety / serious legal breach / critical ops continuity → **NAQ Alto**
- AI system classified as "high risk" under EU AI Act → **NAQ Alto** + Annex IA (Section 16)

### Mision Critica Sub-Band (within Alto)

Activates when override rules trigger:

| Control | Alto ordinario | Alto — mision critica |
|---------|---------------|----------------------|
| Code coverage | New >=80% / Overall >=70% | **New >=90% / Overall >=80%** |
| Code review | >=1 senior reviewer | **>=2 senior reviewers, one independent** |
| Mutation testing | Recommended | **Mandatory** |
| Security | SAST/DAST/SCA | + **formal pentest**, 0 Critical/High open |
| DR/rollback | SLO defined | + **validated in rehearsal + MTTR verified** |
| Deliverables | NAQ Alto minimums | + **formal risk report + Go/No-Go with Direction** |

### NAQ Re-Evaluation Triggers

- >=3 Sev1/Sev2 incidents in production within 3 months on same application
- DER above band threshold for 2 consecutive releases
- Material change in scope, integrations, or compliance requirements

---

## Axis 2 — Tipologias (Section 5.2)

15 types, composable (one primary + secondary components):

| # | Tipologia | Key tests / controls |
|---|-----------|---------------------|
| 1 | **New Development** | Unit, static analysis, code review, integration, E2E, UAT, smoke, NF by NAQ |
| 2 | **Evolutionary Maintenance (AMS)** | Impact analysis, selective regression, defect confirmation, smoke |
| 3 | **Corrective Maintenance (AMS)** | Defect reproduction, confirmation test, selective regression, smoke |
| 4 | **Hotfix / Emergency** | QG-Express: peer review + directed smoke + rollback + ex-post closure 24-48h |
| 5 | **Transformation / Migration** | Baseline, migration/reconciliation, regression, NF, formal UAT, rollback |
| 6 | **Integrations / APIs / Data** | Contract testing, integration, negative tests, data validation, resilience, perf, security |
| 7 | **Digital Product / User Channel** | E2E, usability, accessibility (WCAG), compatibility, performance, security |
| 8 | **Packaged (SAP/Salesforce/...)** | Functional config, integration, E2E regression, UAT, role security, batch perf |
| 9 | **Market Product (COTS/SaaS)** | Requirements vs product standard, config review, integration, functional UAT, NF by NAQ |
| 10 | **AI / ML / GenAI** | Data/model quality, LLM/RAG, agents, Responsible AI, continuous evaluation — Annex IA Section 16 |
| 11 | **Data & Analytics / BI** | Data quality (completeness, accuracy, uniqueness, lineage), reconciliation, rules, perf |
| 12 | **Infrastructure / DevOps / Cloud** | IaC linting/policy-as-code, deploy/idempotency, hardening/CIS, DR, observability |
| 13 | **RPA / Automation** | E2E process, exception/retry handling, UI robustness, process regression, monitoring |
| 14 | **Cybersecurity** | SAST/DAST/SCA, pentest, threat modeling, hardening verification, compliance evidence |
| 15 | **Consulting** | Peer review, document QC, client validation — build/production gates N/A |

> **Composable:** declare one primary tipologia + secondary components. Controls = union of all, modulated by the same NAQ.

---

## Output — Delivery Target (Section 5.3.4)

| Target | Minimum capabilities |
|--------|---------------------|
| **Basico** | Checklist, documented manual tests, smoke, defects logged, manual gates and evidence |
| **Integrado** | CI, SonarQube in pipeline, critical regression automated, req-test traceability, partial auto-gates, KPI dashboard |
| **Continuo** | Automatic quality gates in CI/CD, high automation (E2E), recurring NF, executive dashboards, controlled deploys with rehearsed rollback |

**Recommendation rule:** Continuo when high deploy frequency OR NAQ Alto. Basico is the minimum. Integrado is the portfolio target.

---

## Nucleo Comun NO NEGOCIABLE (Section 5.4)

These 9 items apply to EVERY Seidor project regardless of NAQ, tipologia, or delivery target:

1. NAQ assigned + project/application sheet completed
2. Acceptance criteria defined for deliverable scope
3. Defect management with standard severity in ALM tool
4. **Smoke test pre and post-deploy**
5. **Zero blocking/critical defects open** to pass to production
6. **Go/No-Go decision recorded** (even lightweight) before production
7. Deploy and rollback plan (proportional to risk)
8. Standard nomenclature and traceability
9. **GDPR compliance in test data** (never unmasked real data)

---

## Governance Roles (Section 3.2)

| Role | Responsibility |
|------|---------------|
| **QA Manager** | Model owner. Portfolio KPIs, audits, training, NAQ Alto exception arbitration. |
| **QA Lead** | Adapts model to project, defines Test Strategy, controls gates, reports quality and risks. |
| **QA Engineer** | Designs/executes tests, automates, manages defects and evidence. |
| **Tech Lead / Architect** | Technical quality, code and design review, NFRs, technical debt, ADRs. |
| **PM / Delivery Manager** | Integrates quality in planning, ensures resources and evidence, manages dependencies. |
| **Product Owner / Client** | Defines acceptance criteria, prioritizes defects, approves UAT and Go-Live. |
| **DevOps / Release Manager** | CI/CD, automatic quality gates, deployment, rollback, smoke, observability. |

---


