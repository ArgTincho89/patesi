---
name: sdet-sqem-gates
description: >
  Quality gates SQEM: criterios QG0-QG7, matriz F/L/C/N/A por tipología, QG-Express para hotfixes, reglas de merge de gates y gestión de excepciones.
  Trigger: puertas de calidad Seidor, QG0-QG7, matriz F/L/C/N/A, evaluación de gates
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: sqem
---

# SQEM — Quality gates

Define los 8 quality gates operativos, sus criterios, la matriz F/L/C/N/A por tipología y la gestión de excepciones.

---

## 8 gates operativos (sección 6.3)

```
QG0 → QG1 → QG2 → QG3 → QG4 → QG5 → QG6 → QG7
```

| Gate | What | Key criteria | Approves |
|------|------|-------------|----------|
| **QG0** Inicio/Viabilidad | Start with scope, risks, NAQ, quality plan | NAQ assigned, plan approved, risks mapped, toolchain defined | QA Mgr + Delivery |
| **QG1** Requisitos (DoR) | Requisitos completos, testeables y trazables | AC defined, req<->test traceability, NFRs identified | QA Lead + PO |
| **QG2** Diseño/Arquitectura | Diseño robusto que cubre F y NF | Diseño revisado, ADRs, NFRs dimensionados, estrategia de testing aprobada | Architect + QA Lead |
| **QG3** Construccion (DoD) | Code meets standards before testing | Code review OK, static no blockers, coverage in threshold, **QG Sonar SUCCESS** | Tech Lead + QA |
| **QG4** Pruebas de sistema | Integrated system meets F and NF | Cases executed on target, **0 blocking/critical open**, regression passed, NF passed | QA Lead |
| **QG5** UAT/Aceptacion | Formal business/client acceptance | UAT cases accepted, residual defects agreed, **client sign-off** | Client/PO |
| **QG6** Go-Live/Readiness | Solution and org ready for production | Readiness checklist, **rollback tested** (NAQ Alto), smoke pre-prod OK, monitoring | Delivery + Client/Ops |
| **QG7** Cierre/Garantia | Stabilize, transfer, capitalize | Hypercare without criticals, docs, handoff to AMS/RUN, lessons, KPIs | QA Mgr + Delivery |

---

## QG-Express (hotfix/emergencia)

- **Ex-ante** (before deploy): peer review + directed smoke + rollback tested + Go/No-Go recorded
- **Ex-post** (24-48h after): complete omitted gate criteria + root cause analysis

---

## 4 resultados de gate

| Decision | Condition | Consequence |
|----------|-----------|-------------|
| **PASS** | Complete, current, traceable evidence within NAQ threshold | Advances |
| **WARNING** | Partial evidence, incomplete control, minor deviation | Conditional advance — requires owner, closure date |
| **FAIL** | Absent/unverifiable evidence, out-of-threshold, blocker | Does NOT advance — formal exception required |
| **N/A** | Not applicable by tipologia/NAQ/scope | Excluded from scoring |

### Criterios no exceptuables (bloqueos estrictos)

- Open blocking/critical defect
- Serious security/data/compliance breach
- Minimum test evidence unavailable
- Mandatory rollback not defined
- High risk without mitigation

---

## Entregables por gate

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

## Gates por tipología — matriz F/L/C/N/A

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
| Producto de mercado | F | F | F | F | F | F | F | F |
| AI/ML/GenAI | F | F | F | F if code/pipeline | F | F | F | F |
| Data & Analytics | F | F | F | F | F | F | F | F |
| Infra/DevOps | F | F | F | F | F | C | F | F |
| RPA | F | F | C | F | F | F | F | F |
| Cybersecurity | F | F | F | F if code/config | F | C | F | F |
| Consulting | F | F | L | N/A | N/A | F | N/A | L |

**Legend:** F = Formal, C = Conditional, L = Lightweight, N/A = Not applicable

---

## Gestión de excepciones (sección 8)

| Exception severity | NAQ | Minimum approver |
|-------------------|-----|-----------------|
| Minor (deferred) | Any | PM + QA Lead |
| Medium (Major deferred) | Bajo/Medio | PM + Client/PO |
| Medium | Alto | QA Manager + Delivery |
| High (blocking/critical, security, data, compliance) | Any | **Direction/Sponsor + QA Manager** |

---
