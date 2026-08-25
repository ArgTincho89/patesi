# Patesi — Knowledge: SQEM Quick Reference

## SQEM Document Structure

| Section | Title | Key Content |
|---------|-------|-------------|
| 1 | Introduction | Context, scope, alignment with ISO/IEC 25010 |
| 2 | Quality Model | 8 ISO/IEC 25010 characteristics |
| 3 | Roles and Organization | Governance: QA Mgr, QA Lead, QA Eng, Tech Lead, PM, PO, DevOps |
| 4 | General Principles | Context-aware, proportional, evidence-based, risk-based, continuous improvement |
| 5 | Classification and Design | NAQ (5.1), Tipologias (5.2), Delivery Target (5.3), Nucleo Comun (5.4) |
| 6 | Quality Gates | 8 operational gates (6.3), Gates by tipologia (6.4), NAQ adjustment (6.5) |
| 7 | Reports and Indicators | Thresholds (7.1.1), Dashboards (7.3) |
| 8 | Exceptions and Resolutions | Exception management, approver escalation |
| 9 | Minimum Deliverables by NAQ | Table of deliverables per NAQ level |
| 10 | Operational Controls | Catalog (10.6), Coverage thresholds (10.3), SonarQube profiles (10.2) |
| 11 | Compliance and Improvement | Audits, training, toolchain, adoption phases |
| 12 | Deployment in CI/CD | Pipeline integration, quality gates in CI |
| 13 | Agility and SQEM | Lightweight gates for Agile/Scrum |
| 14 | Tools and Automation | Tooling recommendations |
| 15 | Scaling and Maturity | Organizational maturity model |
| 16 | Annex IA | AI/ML/GenAI specific controls |
| 17 | Annex IB | References |
| 18 | Glossary | Definitions |

## NAQ Quick Reference

```
NAQ = (Criticidad x 8 + Visibilidad x 4 + Interop x 4 + Sensibilidad x 4 + Complejidad x 2) / active_weights

  NAQ < 1.5  → Bajo (Speed)
1.5 <= NAQ < 3 → Medio (Balance)
    NAQ >= 3  → Alto (Minimize Risk)
```

**Overrides:**
- Criticidad=4 OR Sensibilidad=4 → Alto (forced)
- Criticidad>=3 AND Sensibilidad>=3 → minimum Medio

## 15 Tipologias (Quick Reference)

| # | Name | Primary Concern |
|---|------|----------------|
| 1 | New Development | Full F + NF testing |
| 2 | Mant. Evolutivo | Impact analysis, selective regression |
| 3 | Mant. Correctivo | Defect confirmation, selective regression |
| 4 | Hotfix/Emergency | QG-Express: peer review + smoke + rollback |
| 5 | Transformation/Migration | Baseline, migration validation, rollback |
| 6 | Integrations/APIs | Contract testing, resilience, security |
| 7 | Digital Product | E2E, usability, accessibility, compatibility |
| 8 | Packaged (SAP/SF) | Config vs standard, UAT, role security |
| 9 | Market Product (COTS) | Requirements vs product, config review |
| 10 | AI/ML/GenAI | Data quality, LLM eval, Responsible AI |
| 11 | Data & Analytics/BI | Data quality, reconciliation, lineage |
| 12 | Infra/DevOps/Cloud | IaC, hardening, DR, observability |
| 13 | RPA | E2E process, exception handling, UI robustness |
| 14 | Cybersecurity | SAST/DAST/SCA, pentest, threat modeling |
| 15 | Consulting | Peer review, document QC |

## Delivery Targets

| Target | Minimum Capabilities |
|--------|---------------------|
| **Basico** | Checklist, manual tests, smoke, manual gates |
| **Integrado** | CI, SonarQube, critical regression automated, partial auto-gates |
| **Continuo** | Auto quality gates, high automation, executive dashboards, rehearsed rollback |

## Nucleo Comun (Non-Negotiable — Always Applies)

1. NAQ assigned + project sheet
2. Acceptance criteria defined
3. Defect management in ALM
4. **Smoke pre + post deploy**
5. **0 blocking/critical open**
6. **Go/No-Go recorded**
7. Deploy + rollback plan
8. Standard nomenclature + traceability
9. **GDPR compliance in test data**

## 8 Gates Quick

| Gate | What |
|------|------|
| QG0 | Inicio/Viabilidad — Scope, risks, NAQ, plan |
| QG1 | Requisitos — AC defined, traceability, NFRs |
| QG2 | Diseno — Design reviewed, ADRs, Test Strategy |
| QG3 | Construccion — Code review, static, coverage, SonarQube |
| QG4 | Pruebas de sistema — Executed on target, 0 blockers |
| QG5 | UAT — Client acceptance, formal sign-off |
| QG6 | Go-Live — Readiness, rollback, smoke, monitoring |
| QG7 | Cierre — Stabilize, transfer, capitalize |

## Gate Outcomes

| Outcome | Condition |
|---------|-----------|
| **PASS** | Complete, current, traceable evidence |
| **WARNING** | Partial evidence, minor deviation |
| **FAIL** | Absent evidence, out-of-threshold, blocker |
| **N/A** | Not applicable by tipologia/NAQ |

## Coverage Thresholds by NAQ

| NAQ | New Code | Overall |
|-----|----------|---------|
| Alto mision critica | >=90% | >=80% |
| Alto | >=80% | >=70% |
| Medio | >=70% | >=50% |
| Bajo | >=60% | >=35% |

## ISO/IEC 25010 Quality Model (SQEM Foundation)

| Characteristic | What it Measures |
|---------------|-----------------|
| **Functional Suitability** | Correctness, completeness, appropriateness |
| **Performance Efficiency** | Time, resource utilization, capacity |
| **Compatibility** | Co-existence, interoperability |
| **Usability** | Recognizability, learnability, operability, protection from errors |
| **Reliability** | Maturity, availability, fault tolerance, recoverability |
| **Security** | Confidentiality, integrity, non-repudiation, accountability, authenticity |
| **Maintainability** | Modularity, reusability, analyzability, modifiability, testability |
| **Portability** | Adaptability, installability, replaceability |

## Exception Management

| Severity | NAQ | Approver |
|----------|-----|----------|
| Minor (deferred) | Any | PM + QA Lead |
| Medium | Bajo/Medio | PM + Client/PO |
| Medium | Alto | QA Manager + Delivery |
| High (blocking/critical) | Any | Direction/Sponsor + QA Manager |
