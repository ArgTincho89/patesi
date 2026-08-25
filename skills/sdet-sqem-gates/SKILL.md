---
name: sdet-sqem-gates
description: >
  SQEM quality gates: QG0-QG7 criteria, F/L/C/N/A matrix by tipologia, QG-Express for hotfixes, gate merge rules, exception management.
  Trigger: When user asks about quality gates, gate evaluation, QG criteria, F/L/C/N/A matrix, or gate exceptions in a Seidor project.
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: sqem
---

# SQEM — Quality Gates

Defines the 8 operational quality gates, their criteria, the F/L/C/N/A matrix by tipologia, and exception management.

---

## 8 Operational Gates (Section 6.3)

```
QG0 → QG1 → QG2 → QG3 → QG4 → QG5 → QG6 → QG7
```

| Gate | What | Key criteria | Approves |
|------|------|-------------|----------|
| **QG0** Inicio/Viabilidad | Start with scope, risks, NAQ, quality plan | NAQ assigned, plan approved, risks mapped, toolchain defined | QA Mgr + Delivery |
| **QG1** Requisitos (DoR) | Requirements complete, testable, traceable | AC defined, req<->test traceability, NFRs identified | QA Lead + PO |
| **QG2** Diseno/Arquitectura | Robust design covering F and NF | Design reviewed, ADRs, NFRs sized, Test Strategy approved | Architect + QA Lead |
| **QG3** Construccion (DoD) | Code meets standards before testing | Code review OK, static no blockers, coverage in threshold, **QG Sonar SUCCESS** | Tech Lead + QA |
| **QG4** Pruebas de sistema | Integrated system meets F and NF | Cases executed on target, **0 blocking/critical open**, regression passed, NF passed | QA Lead |
| **QG5** UAT/Aceptacion | Formal business/client acceptance | UAT cases accepted, residual defects agreed, **client sign-off** | Client/PO |
| **QG6** Go-Live/Readiness | Solution and org ready for production | Readiness checklist, **rollback tested** (NAQ Alto), smoke pre-prod OK, monitoring | Delivery + Client/Ops |
| **QG7** Cierre/Garantia | Stabilize, transfer, capitalize | Hypercare without criticals, docs, handoff to AMS/RUN, lessons, KPIs | QA Mgr + Delivery |

---

## QG-Express (Hotfix/Emergency)

- **Ex-ante** (before deploy): peer review + directed smoke + rollback tested + Go/No-Go recorded
- **Ex-post** (24-48h after): complete omitted gate criteria + root cause analysis

---

## 4 Gate Outcomes

| Decision | Condition | Consequence |
|----------|-----------|-------------|
| **PASS** | Complete, current, traceable evidence within NAQ threshold | Advances |
| **WARNING** | Partial evidence, incomplete control, minor deviation | Conditional advance — requires owner, closure date |
| **FAIL** | Absent/unverifiable evidence, out-of-threshold, blocker | Does NOT advance — formal exception required |
| **N/A** | Not applicable by tipologia/NAQ/scope | Excluded from scoring |

### Non-Excepable Criteria (Hard Blocks)

- Open blocking/critical defect
- Serious security/data/compliance breach
- Minimum test evidence unavailable
- Mandatory rollback not defined
- High risk without mitigation

---

## Deliverables Per Gate

| Gate | Mandatory deliverables |
|------|----------------------|
| **QG0** | Ficha NAQ, Plan de Calidad, Matriz de riesgos, RACI, Toolchain y entornos |
| **QG1** | Backlog/ERS, Criterios de aceptacion, NFRs, Trazabilidad req<->prueba |
| **QG2** | Documento de arquitectura, ADRs, Riesgos tecnicos, Estrategia de pruebas, Criterios NF, Acta revision |
| **QG3** | Pipeline CI, Analisis estatico (SonarQube), Informe de cobertura, PR/code review |
| **QG4** | Informe de ejecucion, Defect report, Regresion+integracion, NF, Evidencias entorno |
| **QG5** | Casos UAT y resultados, Defectos residuales aceptados, Sign-off cliente/PO |
| **QG6** | Acta Go/No-Go, Runbook, Plan rollback, Smoke pre/post, Seguridad/ops+observabilidad |
| **QG7** | Informe final, KPIs finales, Lecciones aprendidas, Transferencia RUN/AMS, Plan acciones |

---

## Gates by Tipologia — F/L/C/N/A Matrix

| Tipologia | QG0 | QG1 | QG2 | QG3 | QG4 | QG5 | QG6 | QG7 |
|-----------|-----|-----|-----|-----|-----|-----|-----|-----|
| New Development | F | F | F | F | F | F | F | F |
| Mant. evolutivo | L | L | C | F if code | C | C | F | L |
| Mant. correctivo | L | L | N/A | F if code | C | C (half) | F | L |
| Hotfix/Emergency | N/A | L | N/A | L(peer) | L(smoke) | N/A | F | L(ex-post) |
| Transformation | F | F | F | F | F | F | F | F |
| Integrations/APIs | F | F | F | F | F | C | F | F |
| Digital Product | F | F | F | F | F | F | F | F |
| Packaged (SAP/SF) | F | F | C | F if dev | F | F | F | F |
| Market Product | F | F | F | F | F | F | F | F |
| AI/ML/GenAI | F | F | F | F if code/pipeline | F | F | F | F |
| Data & Analytics | F | F | F | F | F | F | F | F |
| Infra/DevOps | F | F | F | F | F | C | F | F |
| RPA | F | F | C | F | F | F | F | F |
| Cybersecurity | F | F | F | F if code/config | F | C | F | F |
| Consulting | F | F | L | N/A | N/A | F | N/A | L |

**Legend:** F = Formal, C = Conditional, L = Lightweight, N/A = Not applicable

---

## Exception Management (Section 8)

| Exception severity | NAQ | Minimum approver |
|-------------------|-----|-----------------|
| Minor (deferred) | Any | PM + QA Lead |
| Medium (Major deferred) | Bajo/Medio | PM + Client/PO |
| Medium | Alto | QA Manager + Delivery |
| High (blocking/critical, security, data, compliance) | Any | **Direction/Sponsor + QA Manager** |

---

## Trigger Keywords

- "quality gates", "QG0" through "QG7"
- "gate evaluation", "gate assessment"
- "F/L/C/N/A", "formal/lightweight/conditional"
- "QG-Express", "hotfix gate"
- "gate exception", "formal exception"
- "puertas de calidad", "evaluar gate"
