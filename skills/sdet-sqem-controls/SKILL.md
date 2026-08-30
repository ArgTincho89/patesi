---
name: sdet-sqem-controls
description: >
  Controles operativos SQEM: catálogo de controles por gate x NAQ, umbrales de cobertura de código, perfiles de SonarQube, indicadores clave, dashboards y niveles de reporting.
  Trigger: controles operativos Seidor, umbrales de cobertura, perfiles SonarQube, indicadores
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: sqem
---

# SQEM — Controles operativos

Define el catálogo de controles operativos, umbrales por NAQ, indicadores y requisitos de reporting.

---

## Catálogo de controles operativos — Control x Gate x NAQ (sección 10.6)

| Control | Gate | NAQ Bajo | NAQ Medio | NAQ Alto |
|---------|------|----------|-----------|----------|
| **Code Review** | QG3 | 1 reviewer (recomendado) | 1 reviewer obligatorio | >=2 reviewers senior |
| **Unit Tests (coverage)** | QG3 | See thresholds | See thresholds | See thresholds |
| **Static Analysis / QG** | QG3 | Perfil Bajo | Perfil Medio | Perfil Alto + revisión manual |
| **Functional / API-UI Testing** | QG4-5 | Smoke | Obligatorio (API/UI) | Completo + flujos E2E críticos automatizados |
| **Integration Tests** | QG4 | Partial per scope | Mandatory | Full coverage |
| **Regression** | QG4-5 | Smoke | Partial | Full (100% automated in critical areas) |
| **Mutation Testing** | QG3 | — | Recommended | Mandatory in critical areas |
| **Performance** | QG4 | Not mandatory | Basic test | Load + stress + soak + scalability |
| **Security** | QG3+6 | SCA dependencies | SAST + dependencies | SAST+DAST+secrets (+pentest in mision critica) |
| **Accessibility WCAG** | QG4-5 | Recommended if web | Mandatory public channel | WCAG audited (mandatory public/ENS) |
| **Documentation** | QG6-7 | Básica | Actualizada | Completa y auditada |
| **UAT** | QG5 | Opcional | Recomendado | Obligatorio (aprobación formal) |
| **Rollback** | QG6 | Recommended/basic plan | Mandatory plan | Mandatory plan + **rehearsed** |
| **Observability** | QG6 | Básica (logs) | Estándar (métricas+logs) | Dashboards + alertas + trazas |
| **Disaster Recovery** | QG6 | — | Per risk | **Validated** (recovery rehearsal) |
| **Go-Live Review** | QG6 | Autoservicio/ligera | QA Lead | QA + negocio (Comité/CAB en misión crítica) |

---

## Umbrales de cobertura de código (sección 10.3)

| NAQ | New code (new/modified) | Overall (full codebase) |
|-----|------------------------|------------------------|
| Alto — mision critica | >=90% | >=80% |
| Alto | >=80% | >=70% |
| Medio | >=70% | >=50% |
| Bajo | >=60% | >=35% |

---

## Quality Gate de SonarQube por NAQ (sección 10.2)

| NAQ + alcance | Bloqueante | Crítico | Confiabilidad | Seguridad | Mantenibilidad | Duplicado |
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

## Indicadores clave y umbrales por NAQ (sección 7.1.1)

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

## Dashboards y reporting — 4 niveles (sección 7.3)

| Level | Type | Audience | Frequency | Content |
|-------|------|----------|-----------|---------|
| **Semaforo de Calidad** | Quantitative | Dev team / QA / PO | Daily / Weekly | Traffic-light per ISO/IEC 25010 characteristic |
| **Barometro de Calidad** | Qualitative | QA Lead / Architect / Ops / PO | Weekly / Biweekly | Health across 7 dimensions scored 0-100 |
| **Cuadro de mando portfolio** | Executive | Comite de Calidad | Monthly | Consolidated KPIs: IQ aggregate, NAQ distribution, critical defects, automation % |
| **Reporting de proyecto** | Project-level | PM + QA Lead + Tech Lead | Weekly / Biweekly | Quality progress, open defects, gate milestones |

### Barómetro de Calidad — 7 dimensiones

| Dimension | Meaning |
|-----------|---------|
| Estrategia de testing | Coverage and robustness of the test strategy |
| Riesgos de calidad | Identified quality risks and mitigation status |
| No conformidades | Gate failures, exceptions, and deviation trends |
| Observabilidad | Monitoreo, alertas y trazabilidad en producción |
| Readiness de release | Release preparation completeness |
| OPS & Operacion | Operational health and incident patterns |
| Costes de no calidad | Cost of defects, rework, escapes to production |

### Escala de puntuación

| Score | Status | Action |
|-------|--------|--------|
| 80-100 | Optimal | Maintain |
| 60-79 | Acceptable | Monitor and improve |
| 40-59 | En riesgo | Corrective action required |
| 0-39 | Critico | Escalate immediately |

---

## Entregables mínimos por NAQ (sección 9)

| Deliverable | NAQ Bajo | NAQ Medio | NAQ Alto |
|-------------|----------|-----------|----------|
| Ficha/clasificacion NAQ | Mandatory | Mandatory | Mandatory |
| Plan/checklist de calidad | Minimum checklist | Simplified plan | Complete plan |
| Estrategia de Pruebas | Brief (in checklist) | Simplified | Full, risk-based |
| Analisis de riesgos | Basic | Recommended | Mandatory |
| Matriz requisito-prueba | Solo críticos | Requisitos principales | 100% relevantes |
| Casos/escenarios | Minimum flows | Main flows | Main + alternatives + critical |
| Informe de ejecución | Checklist de resultados | Por ciclo/release | Formal por ciclo/gate |
| Informe de defectos | Basic log | With severity | With severity, trend, risk |
| Informe calidad de codigo | If technical risk | Mandatory if code | Mandatory, no criticals |
| Evidencia UAT | Simple approval | Functional evidence | Formal UAT with results |
| Acta Go/No-Go | Lightweight | Mandatory | Formal committee |
| Plan despliegue y rollback | Basic | Mandatory | Mandatory and validated |
| Informe post-produccion | Post-deploy smoke | Brief | Formal stabilization report |
| Lecciones aprendidas | Recommended | Mandatory | Mandatory |

---
