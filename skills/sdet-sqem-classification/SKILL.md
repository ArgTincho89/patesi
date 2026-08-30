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
Eje 1: NAQ (nivel de aseguramiento de la calidad) → Bajo / Medio / Alto
Eje 2: Tipología de proyecto (15 tipos, componible)
              ↓  combinación automática
SALIDA: Delivery Target → Básico / Integrado / Continuo
```

---

## Eje 1 — NAQ (sección 5.1)

### Fórmula de NAQ

Promedio ponderado, con cada factor puntuado de 0 a 4:

| Factor | Peso |
|--------|--------|
| Criticidad de negocio | 8 |
| Visibilidad / uso | 4 |
| Interoperabilidad | 4 |
| Sensibilidad de datos | 4 |
| Madurez técnica | 2 (suspendido hasta disponer de datos) |
| Complejidad | 2 |

`NAQ = Sum(score_i x weight_i) / Sum(active_weights)`

`active_weights` incluye el peso 2 de **Madurez técnica** únicamente cuando se
cumple la regla objetiva siguiente. En caso contrario, el factor queda excluido
del numerador y del denominador, y la ficha de clasificación debe registrar la
razón de suspensión.

### Rúbrica de Madurez técnica

La puntuación se asigna usando evidencia fechada y verificable de la aplicación
evaluada, no por opinión del evaluador:

| Puntuación | Criterios observables |
|---|---|
| 0 | No existe release productiva documentada, o no hay inventario/diagrama técnico vigente ni historial de operación verificable. |
| 1 | Existe al menos una release productiva documentada, pero faltan evidencias de operación repetible, monitoreo o gestión de defectos. |
| 2 | Existe al menos una release productiva documentada, runbook o procedimiento operativo vigente, monitoreo básico y registro de defectos de producción. |
| 3 | Existen al menos dos releases productivas documentadas, historial verificable de defectos/DER por release, observabilidad operativa, rollback probado y deuda técnica registrada. |
| 4 | Cumple el nivel 3 y, además, evidencia de al menos cuatro releases productivas en los últimos 12 meses, rollback ensayado en los últimos 6 meses, revisión periódica de deuda técnica y ausencia de Sev1/Sev2 abiertos. |

### Activación objetiva del peso

El peso 2 de Madurez técnica está **activo** solo si se verifican
simultáneamente estas tres condiciones:

1. Hay al menos dos releases productivas documentadas.
2. Existe un historial verificable de defectos o DER de esas releases.
3. No hay ningún Sev1/Sev2 abierto al momento de la clasificación.

Si falta una condición, el peso queda **suspendido**. La ficha debe registrar
cada evidencia consultada y la razón concreta, por ejemplo: `suspendido: solo
una release documentada` o `suspendido: Sev2 abierto INC-123`. El evaluador no
puede activar ni desactivar este peso por preferencia.

### Bandas de NAQ

| Valor | Nivel | Intención | Esfuerzo de QA |
|-------|-------|--------|-----------|
| >=0 y <1.5 | **Bajo** | Velocidad: no ralentizar la entrega | Bajo |
| >=1.5 y <3 | **Medio** | Equilibrio: costo frente a riesgo | Medio |
| >=3 | **Alto** | Minimizar el riesgo de negocio | Alto (muy alto para misión crítica) |

### Reglas de override (no negociables)

- Criticidad de negocio=4 **OR** Sensibilidad de datos=4 → **NAQ Alto** obligatorio
- Criticidad de negocio>=3 **AND** Sensibilidad de datos>=3 → mínimo **NAQ Medio**
- Impacto en seguridad de personas / violación legal grave / continuidad operativa crítica → **NAQ Alto**
- Sistema de IA clasificado como "high risk" según EU AI Act → **NAQ Alto** + Anexo IA (sección 16)

### Sub-banda de misión crítica (dentro de Alto)

Se activa cuando se dispara alguna regla de override:

| Control | Alto ordinario | Alto — misión crítica |
|---------|---------------|----------------------|
| Code coverage | New >=80% / Overall >=70% | **New >=90% / Overall >=80%** |
| Code review | >=1 senior reviewer | **>=2 senior reviewers, one independent** |
| Mutation testing | Recommended | **Mandatory** |
| Security | SAST/DAST/SCA | + **formal pentest**, 0 Critical/High open |
| DR/rollback | SLO defined | + **validated in rehearsal + MTTR verified** |
| Entregables | Mínimos de NAQ Alto | + **informe formal de riesgos + Go/No-Go con Dirección** |

### Triggers de reevaluación de NAQ

- >=3 Sev1/Sev2 incidents in production within 3 months on same application
- DER above band threshold for 2 consecutive releases
- Cambio sustancial en el alcance, las integraciones o los requisitos de cumplimiento

---

## Eje 2 — Tipologías (sección 5.2)

15 tipos componibles (uno primario + componentes secundarios):

| # | Tipología | Tests / controles clave |
|---|-----------|---------------------|
| 1 | **Desarrollo nuevo** | Unit, análisis estático, code review, integración, E2E, UAT, smoke, NF según NAQ |
| 2 | **Mantenimiento evolutivo (AMS)** | Análisis de impacto, regresión selectiva, confirmación de defectos, smoke |
| 3 | **Mantenimiento correctivo (AMS)** | Reproducción de defectos, test de confirmación, regresión selectiva, smoke |
| 4 | **Hotfix / Emergencia** | QG-Express: revisión por pares + smoke dirigido + rollback + cierre ex-post en 24-48 h |
| 5 | **Transformación / Migración** | Baseline, migración/reconciliación, regresión, NF, UAT formal, rollback |
| 6 | **Integraciones / APIs / Datos** | Contract testing, integración, tests negativos, validación de datos, resiliencia, perf, seguridad |
| 7 | **Producto digital / Canal de usuario** | E2E, usabilidad, accesibilidad (WCAG), compatibilidad, performance, seguridad |
| 8 | **Empaquetado (SAP/Salesforce/...)** | Configuración funcional, integración, regresión E2E, UAT, seguridad de roles, perf de batch |
| 9 | **Producto de mercado (COTS/SaaS)** | Requisitos frente al estándar del producto, revisión de configuración, integración, UAT funcional, NF según NAQ |
| 10 | **IA / ML / GenAI** | Calidad de datos/modelo, LLM/RAG, agents, Responsible AI, evaluación continua — Anexo IA, sección 16 |
| 11 | **Datos y analítica / BI** | Calidad de datos (completitud, exactitud, unicidad, linaje), reconciliación, reglas, perf |
| 12 | **Infraestructura / DevOps / Cloud** | Linting de IaC/policy-as-code, deploy/idempotencia, hardening/CIS, DR, observabilidad |
| 13 | **RPA / Automatización** | Proceso E2E, gestión de excepciones/reintentos, robustez de UI, regresión del proceso, monitoreo |
| 14 | **Ciberseguridad** | SAST/DAST/SCA, pentest, modelado de amenazas, verificación de hardening, evidencia de cumplimiento |
| 15 | **Consultoría** | Revisión por pares, QC documental, validación del cliente — gates de build/producción N/A |

> **Componible:** declaré una tipología primaria + componentes secundarios. Los controles son la unión de todos, modulada por el mismo NAQ.

---

## Salida — Delivery Target (sección 5.3.4)

| Delivery Target | Capacidades mínimas |
|--------|---------------------|
| **Básico** | Checklist, tests manuales documentados, smoke, defectos registrados, gates manuales y evidencias |
| **Integrado** | CI, SonarQube en pipeline, regresión crítica automatizada, trazabilidad requisito-test, auto-gates parciales, dashboard de KPI |
| **Continuo** | Quality gates automáticos en CI/CD, alta automatización (E2E), NF recurrentes, dashboards ejecutivos, deploys controlados con rollback ensayado |

**Regla de recomendación:** Continuo cuando hay alta frecuencia de despliegue OR NAQ Alto. Básico es el mínimo. Integrado es el objetivo de portfolio.

---

## Núcleo común NO NEGOCIABLE (sección 5.4)

Estos 9 ítems aplican a TODOS los proyectos Seidor, sin importar NAQ, tipología o Delivery Target:

1. NAQ asignado + ficha de proyecto/aplicación completada
2. Criterios de aceptación definidos para el alcance del entregable
3. Gestión de defectos con severidad estándar en herramienta ALM
4. **Smoke test pre y post-deploy**
5. **Cero defectos bloqueantes/críticos abiertos** para pasar a producción
6. **Decisión Go/No-Go registrada** (aunque sea ligera) antes de producción
7. Plan de deploy y rollback (proporcional al riesgo)
8. Nomenclatura estándar y trazabilidad
9. **Cumplimiento GDPR en datos de test** (nunca datos reales sin enmascarar)

---

## Roles de gobernanza (sección 3.2)

| Rol | Responsabilidad |
|------|---------------|
| **QA Manager** | Responsable del modelo. KPIs de portfolio, auditorías, formación y arbitraje de excepciones de NAQ Alto. |
| **QA Lead** | Adapta el modelo al proyecto, define la Test Strategy, controla gates e informa calidad y riesgos. |
| **QA Engineer** | Diseña y ejecuta tests, automatiza y gestiona defectos y evidencias. |
| **Tech Lead / Architect** | Calidad técnica, revisión de código y diseño, NFRs, deuda técnica y ADRs. |
| **PM / Delivery Manager** | Integra la calidad en la planificación, asegura recursos y evidencias, y gestiona dependencias. |
| **Product Owner / Client** | Define criterios de aceptación, prioriza defectos y aprueba UAT y Go-Live. |
| **DevOps / Release Manager** | CI/CD, quality gates automáticos, deployment, rollback, smoke y observabilidad. |

---
