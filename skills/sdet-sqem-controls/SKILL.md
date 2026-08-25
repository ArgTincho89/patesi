---
name: sdet-sqem-controls
description: >
  SQEM operational controls: control catalog by gate x NAQ, code coverage thresholds, SonarQube profiles, key indicators, dashboards, and reporting levels.
  Trigger: controles operativos Seidor, umbrales de cobertura, perfiles SonarQube, indicadores
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: sqem
---

# SQEM — Operational Controls

Defines the catalog of operational controls, thresholds by NAQ, indicators, and reporting requirements.

---

## Operational Controls Catalog — Control x Gate x NAQ (Section 10.6)

| Control | Gate | NAQ Bajo | NAQ Medio | NAQ Alto |
|---------|------|----------|-----------|----------|
| **Code Review** | QG3 | 1 reviewer (recommended) | 1 reviewer mandatory | >=2 senior reviewers |
| **Unit Tests (coverage)** | QG3 | See thresholds | See thresholds | See thresholds |
| **Static Analysis / QG** | QG3 | Profile Bajo | Profile Medio | Profile Alto + manual review |
| **Functional / API-UI Testing** | QG4-5 | Smoke | Mandatory (API/UI) | Full + automated E2E critical flows |
| **Integration Tests** | QG4 | Partial per scope | Mandatory | Full coverage |
| **Regression** | QG4-5 | Smoke | Partial | Full (100% automated in critical areas) |
| **Mutation Testing** | QG3 | — | Recommended | Mandatory in critical areas |
| **Performance** | QG4 | Not mandatory | Basic test | Load + stress + soak + scalability |
| **Security** | QG3+6 | SCA dependencies | SAST + dependencies | SAST+DAST+secrets (+pentest in mision critica) |
| **Accessibility WCAG** | QG4-5 | Recommended if web | Mandatory public channel | WCAG audited (mandatory public/ENS) |
| **Documentation** | QG6-7 | Basic | Updated | Complete and audited |
| **UAT** | QG5 | Optional | Recommended | Mandatory (formal approval) |
| **Rollback** | QG6 | Recommended/basic plan | Mandatory plan | Mandatory plan + **rehearsed** |
| **Observability** | QG6 | Basic (logs) | Standard (metrics+logs) | Dashboards + alerts + traces |
| **Disaster Recovery** | QG6 | — | Per risk | **Validated** (recovery rehearsal) |
| **Go-Live Review** | QG6 | Self-service/lightweight | QA Lead | QA + Business (Committee/CAB in mision critica) |

---

## Code Coverage Thresholds (Section 10.3)

| NAQ | New code (new/modified) | Overall (full codebase) |
|-----|------------------------|------------------------|
| Alto — mision critica | >=90% | >=80% |
| Alto | >=80% | >=70% |
| Medio | >=70% | >=50% |
| Bajo | >=60% | >=35% |

---

## SonarQube Quality Gate by NAQ (Section 10.2)

| NAQ + Scope | Blocker | Critical | Reliability | Security | Maintainability | Duplicated |
|-------------|---------|----------|-------------|----------|-----------------|------------|
| Bajo — New (Overall) | 0 | <=10 | >=C | >=C | >=C (<=20%) | — |
| Bajo — Legacy (New code) | 0 | — | >=C | >=C | — | — |
| Medio — New (Overall) | 0 | <=5 | >=B | >=B | >=B (<=10%) | <=10% |
| Medio — Legacy (New code) | 0 | <=10 | >=B | >=B | >=C (<=20%) | <=10% |
| Alto — New (Overall) | 0 | 0 | A | A | A (<=5%) | <=5% |
| Alto — Legacy (New code) | 0 | 0 | A | A | A (<=5%) | <=5% |

**SonarQube scope rule (Section 7.2):**
- **New projects** (new development, transformation): evaluate on **Overall** codebase
- **Legacy/AMS projects** (evolutionary, corrective, hotfix): evaluate on **New code** only

---

## Key Indicators and Thresholds by NAQ (Section 7.1.1)

| Indicator | NAQ Bajo | NAQ Medio | NAQ Alto |
|-----------|----------|-----------|----------|
| Vulnerabilities | 0 Blocker/Critical | 0 Blocker/Critical/Major | 0 any severity |
| Security Rating (Sonar) | >=C | >=B | A |
| HU test coverage | 100% critical/normal | Same | Same |
| Regression rate | Smoke mandatory | Partial, 100% planned | Full, automated critical |
| UAT rate | Optional | Recommended, 100% | Mandatory formal approval |
| Performance tests | Not mandatory | Basic test | Load+stress+soak+scalability |
| Accessibility WCAG AA | Recommended if web | Mandatory public | Audited, mandatory ENS/public |
| Technical debt (Sonar) | >=C (<=20% ratio) | >=B (<=10% ratio) | A (<=5% ratio) |
| DDE (Defect Detection Effectiveness) | >=88% | >=92% | >=95% |
| DER (Defect Escape Rate) | <=12% | <=8% | <=5% |

---

## Dashboards and Reporting — 4 Levels (Section 7.3)

| Level | Type | Audience | Frequency | Content |
|-------|------|----------|-----------|---------|
| **Semaforo de Calidad** | Quantitative | Dev team / QA / PO | Daily / Weekly | Traffic-light per ISO/IEC 25010 characteristic |
| **Barometro de Calidad** | Qualitative | QA Lead / Architect / Ops / PO | Weekly / Biweekly | Health across 7 dimensions scored 0-100 |
| **Cuadro de mando portfolio** | Executive | Comite de Calidad | Monthly | Consolidated KPIs: IQ aggregate, NAQ distribution, critical defects, automation % |
| **Reporting de proyecto** | Project-level | PM + QA Lead + Tech Lead | Weekly / Biweekly | Quality progress, open defects, gate milestones |

### Barometro de Calidad — 7 Dimensions

| Dimension | Meaning |
|-----------|---------|
| Estrategia de testing | Coverage and robustness of the test strategy |
| Riesgos de calidad | Identified quality risks and mitigation status |
| No conformidades | Gate failures, exceptions, and deviation trends |
| Observabilidad | Monitoring, alerts, and traceability in production |
| Readiness de release | Release preparation completeness |
| OPS & Operacion | Operational health and incident patterns |
| Costes de no calidad | Cost of defects, rework, escapes to production |

### Scoring Scale

| Score | Status | Action |
|-------|--------|--------|
| 80-100 | Optimal | Maintain |
| 60-79 | Acceptable | Monitor and improve |
| 40-59 | En riesgo | Corrective action required |
| 0-39 | Critico | Escalate immediately |

---

## Minimum Deliverables by NAQ (Section 9)

| Deliverable | NAQ Bajo | NAQ Medio | NAQ Alto |
|-------------|----------|-----------|----------|
| Ficha/clasificacion NAQ | Mandatory | Mandatory | Mandatory |
| Plan/checklist de calidad | Minimum checklist | Simplified plan | Complete plan |
| Estrategia de Pruebas | Brief (in checklist) | Simplified | Full, risk-based |
| Analisis de riesgos | Basic | Recommended | Mandatory |
| Matriz requisito-prueba | Critical only | Main requirements | 100% relevant |
| Casos/escenarios | Minimum flows | Main flows | Main + alternatives + critical |
| Informe de ejecucion | Results checklist | Per cycle/release | Formal per cycle/gate |
| Informe de defectos | Basic log | With severity | With severity, trend, risk |
| Informe calidad de codigo | If technical risk | Mandatory if code | Mandatory, no criticals |
| Evidencia UAT | Simple approval | Functional evidence | Formal UAT with results |
| Acta Go/No-Go | Lightweight | Mandatory | Formal committee |
| Plan despliegue y rollback | Basic | Mandatory | Mandatory and validated |
| Informe post-produccion | Post-deploy smoke | Brief | Formal stabilization report |
| Lecciones aprendidas | Recommended | Mandatory | Mandatory |

---


