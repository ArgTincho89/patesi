---
name: sdet-sqem-governance
description: >
  Gobierno de calidad SQEM: roles y RACI, comités y escalado, gestión de excepciones con matriz de aprobadores, fiabilidad operativa SRE, compatibilidad contractual y código de terceros o asistido por IA.
  Trigger: quién aprueba, RACI, roles Seidor, escalado, excepción formal, SLO RPO RTO, contratos versionados, subcontrata
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: sqem
---

# SQEM — Gobierno, excepciones y controles transversales

Fuente: SQEM v1.2 §3 (gobierno), §8 (excepciones), §11 (riesgos y cumplimiento).

Este skill responde a **quién decide, quién aprueba y qué pasa cuando algo no se cumple**.

---

## Estructura organizativa (§3.1)

Modelo híbrido **hub & spoke**:

- **QA CoE (hub)** — Oficina de Calidad central. Define y mantiene el modelo, plantillas, catálogo de gates e indicadores, toolchain de referencia, formación y auditorías. No sustituye al QA de proyecto: lo habilita y lo supervisa.
- **QA embebido (spokes)** — QA Lead y QA Engineers integrados en el equipo de entrega.
- **Regla de proporcionalidad:** el grado de involucración del CoE escala con el NAQ.

> **En NAQ Alto, la independencia del QA respecto del equipo de desarrollo es OBLIGATORIA** — rol de aseguramiento separado del de construcción, salvo excepción formal aprobada por el QA Manager.

---

## Roles (§3.2)

| Rol | Foco de calidad |
|-----|-----------------|
| **Dirección / Sponsor de entrega** | Aprueba el modelo, arbitra escalados críticos, prioriza inversión en calidad |
| **QA Manager (Oficina de Calidad)** | Dueño del modelo. Estándares, KPIs de portfolio, auditorías, capacitación, arbitraje de excepciones NAQ alto |
| **QA CoE Engineers** | Mantienen activos reutilizables, dan soporte a proyectos, ejecutan auditorías |
| **QA Lead de proyecto** | Adapta el modelo al proyecto, define la Estrategia de Pruebas, controla los gates, reporta calidad y riesgos |
| **QA Engineer** | Diseña y ejecuta pruebas, automatiza, gestiona defectos y evidencias |
| **Delivery Manager / PM / Scrum Master** | Integra la calidad en la planificación, garantiza recursos y evidencias, gestiona dependencias |
| **Product Owner / Cliente** | Define criterios de aceptación, prioriza defectos, aprueba UAT y Go-Live |
| **Business Analyst / Functional** | Requisitos claros, completos, trazables y testables (DoR) |
| **Tech Lead / Arquitecto** | Calidad técnica, revisión de código y diseño, NFRs, deuda técnica, ADRs |
| **Developers** | Construcción con calidad, pruebas unitarias, *clean as you code*, corrección de defectos |
| **DevOps / Release Manager** | CI/CD, quality gates automáticos, despliegue, rollback, smoke, observabilidad |

---

## RACI de actividades clave (§3.3)

**R** ejecuta · **A** aprueba/rinde cuentas · **C** consultado · **I** informado

| Actividad | QA Mgr/CoE | QA Lead | QA Eng | PM/Delivery | Tech Lead/Arq | Dev | DevOps | PO/Cliente |
|-----------|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| Clasificación NAQ | **A** | R | C | C | C | I | I | C |
| Validación de equivalencia de toolchain (§10.5) | **A** | R | C | I | C | I | C | I |
| Estrategia / Plan de Pruebas | C | **R/A** | C | C | C | I | I | C |
| Definition of Ready | I | C | I | **A** | C | I | — | **R** |
| Revisión de diseño / arquitectura | I | C | I | I | **R/A** | C | C | I |
| Code review + análisis estático (DoD) | I | C | C | I | **A** | **R** | C | — |
| Diseño y ejecución de pruebas | C | **A** | **R** | I | C | C | — | I |
| Gestión de defectos | I | **A** | **R** | C | C | R | — | **A** (prioriz.) |
| Quality Gate Go/No-Go a producción | C | R | C | **A** | C | I | R | **A** |
| Decisión y ejecución de QG-Exprés (§6.4.2) | I | **A** | R | C | C | R | R | C |
| Cierre de deuda ex-post del QG-Exprés | C | **R/A** | R | C | I | C | C | I |
| Aprobación de excepción (§8) | **A\*** | R | C | C | I | I | C | I |
| Aceptación UAT | I | C | C | C | I | I | — | **R/A** |
| Auditoría de calidad y cierre | **R/A** | R | C | C | C | I | I | I |

**Notas normativas:**
- Los **Go/No-Go a producción tienen doble aprobación** (Delivery + Cliente/PO) porque el riesgo es compartido. **Regla de desempate:** si no coinciden, la decisión escala al **QA Manager** y, si persiste, se trata como excepción según §8.
- **(\*)** En "Aprobación de excepción" el aprobador final **no es siempre el QA Manager**: escala con la severidad y el NAQ según la matriz de §8. El QA Manager es responsable del gobierno del proceso; el QA Lead documenta la excepción.

---

## Comités, cadencias y escalado (§3.4)

| Foro | Frecuencia | Propósito |
|------|------------|-----------|
| **Quality Gate del proyecto** | En cada hito/gate | Decisión Go/No-Go basada en evidencias |
| **Comité de Calidad de proyecto** | Quincenal/mensual según NAQ | Salud de calidad, defectos, riesgos, indicadores |
| **Comité de Calidad de portfolio** | Mensual | Consolidado de KPIs, no conformidades, excepciones, auditorías |
| **Escalado a Dirección** | Bajo demanda | Riesgo crítico de negocio/producción, excepciones recurrentes |

| Nivel | Situación | Decisor |
|-------|-----------|---------|
| **Equipo** | Defectos menores, dudas operativas | PM + QA Lead + Tech Lead |
| **Proyecto** | Incumplimiento de gate, retraso relevante, excepción puntual | PM + Cliente/PO |
| **Portfolio** | Riesgo alto, excepción en NAQ alto, patrón de no conformidad | QA Manager + Delivery |
| **Dirección** | Riesgo crítico de negocio o producción | Sponsor / Dirección |

---

## Gestión de excepciones (§8)

Un proyecto **no pasa a producción** si concurre alguna de estas condiciones sin excepción formal aprobada:

- Defecto bloqueante o crítico abierto
- UAT no aprobada
- Riesgo alto sin mitigación ni aceptación formal
- Ausencia de plan de rollback donde el NAQ lo exige
- Incumplimiento grave de seguridad, datos o compliance
- Evidencias mínimas de pruebas no disponibles

Toda excepción documenta: **criterio incumplido, riesgo asumido, impacto, mitigación, responsable, fecha límite y aprobador formal.**

### Matriz de aprobadores

| Severidad del riesgo de la excepción | NAQ | Aprobador mínimo |
|---|---|---|
| **Menor** (Minor/Trivial diferido, gate ligero relajado) | Cualquiera | PM + QA Lead |
| **Media** (Major diferido con workaround, gate condicional omitido) | Bajo/Medio | PM + Cliente/PO |
| **Media** | Alto | QA Manager + Delivery |
| **Alta** (bloqueante/crítico, seguridad, datos, compliance, sin rollback) | Cualquiera | **Dirección / Sponsor + QA Manager** |

> Las excepciones se registran, se siguen hasta su cierre y se revisan en el Comité de portfolio. **Un patrón de excepciones recurrentes es en sí mismo una no conformidad.** El QG-Exprés (§6.4.2) es un caso particular de excepción reglada.

---

## Calidad de código de terceros y asistido por IA (§11.3)

- **Subcontrata / nearshore / offshore:** el código de proveedores está sujeto **exactamente a los mismos gates e indicadores** que el propio — mismo Quality Gate por NAQ, misma cobertura, misma revisión. **El QA Lead de Seidor mantiene la responsabilidad de aseguramiento aunque la construcción se externalice.**
- **Código asistido por IA:** se acepta como acelerador pero **no exime de revisión humana**. Pasa por code review humano, análisis estático y las mismas pruebas. Atención a alucinaciones de API, licencias y propiedad intelectual de dependencias sugeridas, y fugas de datos sensibles en prompts. **En NAQ Alto la revisión humana es obligatoria y trazable.**

---

## Fiabilidad operativa y criterios SRE mínimos (§11.4)

| Control | NAQ Bajo | NAQ Medio | NAQ Alto |
|---------|----------|-----------|----------|
| **SLO/SLA** | Objetivo básico si hay servicio productivo | SLO/SLA por operación crítica | SLO/SLA formal con presupuesto de error y seguimiento periódico |
| **RPO/RTO** | Definido si hay datos persistentes relevantes | Definido y aceptado por negocio | Definido, medido y **probado en ensayo de recuperación** |
| **Backups y restauración** | Backup configurado si aplica | Backup con prueba de restauración planificada | **Restauración probada y evidenciada** antes de Go-Live |
| **Health checks y alertas** | Health check o smoke operacional básico | Alertas sobre disponibilidad, errores y saturación | Dashboards, alertas, trazas y criterios de escalado |
| **Runbooks y postmortems** | Procedimiento básico de soporte | Runbook para incidentes principales | Runbooks críticos, **postmortem obligatorio en Sev1/Sev2** y acciones preventivas |

---

## Compatibilidad contractual y versionado (§11.5)

Para integraciones, APIs, eventos y datos compartidos:

- **Contratos versionados:** OpenAPI, AsyncAPI, esquema de eventos o especificación equivalente para interfaces críticas.
- **Cambios incompatibles:** requieren análisis de impacto, aviso a consumidores, ventana de transición y aprobación del gate correspondiente.
- **Matriz de consumidores:** cada API/evento crítico identifica consumidores, versiones soportadas y propietario.
- **Compatibilidad hacia atrás: obligatoria en NAQ Medio/Alto**, salvo excepción formal aceptada por los consumidores afectados.
- **Pruebas:** contract testing o validación equivalente en CI/CD; si el stack no lo permite, evidencia manual trazable.

---

## Cumplimiento normativo (§11.2)

- **GDPR:** anonimización/enmascaramiento de datos de prueba; trazabilidad del tratamiento.
- **Sectorial:** financiero (PCI-DSS, DORA), salud, sector público (ENS, accesibilidad WCAG obligatoria). **El cumplimiento aplicable eleva el NAQ** y añade gates y evidencias específicos.
- **EU AI Act:** ver `sdet-sqem-ia`.
- **No conformidades:** el incumplimiento de un indicador normativo primario genera una no conformidad que se registra, se asigna y se sigue hasta su cierre.

---

## Riesgos de calidad (§11.1)

Categorías de referencia: documentación funcional incompleta · casos de prueba obsoletos · planificación insuficiente · falta de recursos o conocimiento · tecnologías nuevas · inestabilidad del software o del entorno · retrasos · exceso de defectos · cambios de alcance · datos de prueba · cobertura unitaria insuficiente · dependencias externas.

Cada riesgo se evalúa por **probabilidad × impacto** y lleva plan de mitigación y contingencia. La intensidad del análisis escala con el NAQ: **formal en Alto, principal en Medio, mínimo en Bajo**.

---

## Auditoría interna del modelo (§12.1)

| Elemento | Regla mínima |
|----------|--------------|
| **Quién audita** | QA CoE o auditor independiente del equipo auditado; en NAQ Alto, revisión formal por QA Manager o delegado senior |
| **Frecuencia** | Muestreo trimestral en portfolio; **obligatoria al menos una vez en NAQ Alto o misión crítica** |
| **Muestra** | Proyectos de distinta tipología, NAQ, cliente, tecnología y madurez |
| **Checklist** | Núcleo común, gates aplicables, evidencias, métricas, excepciones, trazabilidad y cierre de acciones |
| **Resultado** | PASS/WARNING/FAIL por control, severidad, responsable y fecha objetivo |
| **Cierre** | Una no conformidad solo se cierra con **evidencia verificable** y revisión del auditor |

---

## Restricción de uso del mapeo TMMi (§12.3)

La equivalencia entre delivery target y niveles TMMi es **conceptual, de referencia interna**. Automatización de pipeline no equivale a madurez de proceso de prueba certificada.

**No debe presentarse en propuestas comerciales como "nivel TMMi X"** de Seidor ni del cliente.
