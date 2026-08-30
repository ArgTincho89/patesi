---
name: sdet-sqem-gates
description: >
  Definición operativa de los 8 quality gates SQEM: objetivo, criterios de salida, entregables con responsable y validez, rol aprobador, reglas de decisión PASS/WARNING/FAIL/N-A y QG-Exprés para hotfix.
  Trigger: puertas de calidad Seidor, QG0-QG7, criterios de salida, evidencias por gate, QG-Exprés, PASS WARNING FAIL
license: Apache-2.0
metadata:
  author: patesi
  version: "2.0"
  category: sqem
---

# SQEM — Los 8 quality gates

Define **qué es** cada gate, qué hay que cumplir y quién aprueba. Fuente: SQEM v1.2 §6.

**Qué gates aplican a tu proyecto y con qué formalidad lo resuelve `sdet-sqem-gate-matrix`.** Este skill define el contenido de cada uno.

Los quality gates son **decisiones Go/No-Go basadas en evidencias**, no trámites documentales.

```
QG0 → QG1 → QG2 → QG3 → QG4 → QG5 → QG6 → QG7
```

---

## Catálogo de gates (§6.3)

### QG0 — Inicio / Viabilidad

**Objetivo:** arrancar con alcance, riesgos, plan de calidad y NAQ.

- **Pruebas:** ninguna. Es un gate de planificación previo a la construcción.
- **Criterios de salida:** NAQ asignado · Plan de calidad aprobado · Mapa de riesgos + RACI · Toolchain y entornos definidos
- **Entregables:** Ficha NAQ · Plan de Calidad · Matriz de riesgos · RACI · Definición de toolchain y entornos
- **Responsable de la evidencia:** QA Lead + PM · **Formato mínimo:** documento o registro ALM · **Validez:** aprobado antes de iniciar construcción
- **Aprueba:** QA Manager + Delivery
- **Umbrales:** §7.6 no define umbrales numéricos por NAQ. La exigencia se modula por formalidad según tipología y NAQ.

### QG1 — Requisitos (DoR)

**Objetivo:** requisitos completos, testables y trazables.

- **Pruebas:** ninguna. Se prepara la base testable.
- **Criterios de salida:** Criterios de aceptación definidos · Trazabilidad requisito↔caso · NFRs identificados
- **Entregables:** Backlog/ERS · Criterios de aceptación · NFRs · Matriz de trazabilidad requisito↔prueba inicial
- **Responsable:** PO/BA + QA Lead · **Formato:** ALM, matriz o plantilla oficial · **Validez:** versionado contra alcance candidato
- **Aprueba:** QA Lead + PO
- **Umbrales:** no aplican; los controles con umbral empiezan en QG3.

### QG2 — Diseño / Arquitectura

**Objetivo:** diseño robusto que cubre lo funcional y lo no funcional.

- **Pruebas:** ninguna de ejecución.
- **Criterios de salida:** Diseño revisado · ADRs registrados · NFRs dimensionados · Estrategia de Pruebas aprobada
- **Entregables:** Documento de arquitectura · ADRs · Riesgos técnicos · Estrategia de pruebas · Criterios NF · Acta de revisión
- **Responsable:** Arquitecto + QA Lead · **Formato:** documento de arquitectura, ADR o acta · **Validez:** revisado antes de implementación material
- **Aprueba:** Arquitecto + QA Lead
- **Umbrales:** no aplican.

### QG3 — Construcción (DoD)

**Objetivo:** el código cumple estándares antes de pruebas.

- **Pruebas:** Unitarias · Componentes · Contract testing · Seguridad (SAST/SCA) · **Mutation testing si NAQ Alto**
- **Criterios de salida:** Code review OK · Estático sin blockers · Unitarias verdes + cobertura en umbral · Build en CI · **Quality Gate SonarQube = SUCCESS**
- **Entregables:** Pipeline CI · Análisis estático · Informe de cobertura · PR/code review
- **Responsable:** Tech Lead + DevOps + QA · **Formato:** URL de pipeline/informe y PR · **Validez:** ejecución sobre commit o versión candidata
- **Aprueba:** Tech Lead + QA
- **Umbrales:** ver `sdet-sqem-controls` — estático §10.2, cobertura §10.3.

### QG4 — Pruebas de sistema

**Objetivo:** el sistema integrado cumple lo funcional y lo no funcional.

- **Pruebas:** Integración · Sistema/E2E · Regresión · **No funcionales si aplican**: rendimiento, seguridad (DAST/pentest), usabilidad, accesibilidad y compatibilidad
- **Criterios de salida:** Casos ejecutados sobre objetivo · **0 defectos bloqueantes/críticos abiertos** · Regresión pasada · NF superadas si aplican
- **Entregables:** Informe de ejecución · Informe de defectos · Resultados de regresión e integración · Resultados NF · Evidencias de entorno
- **Responsable:** QA Lead · **Formato:** informe de ciclo y export ALM · **Validez:** sin bloqueantes/críticos abiertos
- **Aprueba:** QA Lead
- **Umbrales:** ver `sdet-sqem-controls`.

### QG5 — UAT / Aceptación

**Objetivo:** aceptación formal de negocio o cliente.

- **Pruebas:** UAT / Aceptación por negocio o cliente
- **Criterios de salida:** Casos UAT aceptados · Defectos residuales acordados · **Sign-off del cliente**
- **Entregables:** Casos UAT y resultados · Defectos residuales aceptados (lista de diferidos) · Sign-off del cliente/PO
- **Responsable:** Cliente/PO + QA Lead · **Formato:** acta, workflow ALM o aprobación formal · **Validez:** aprobación explícita antes de Go-Live
- **Aprueba:** Cliente + PO
- **Umbrales:** UAT opcional (Bajo) / recomendado (Medio) / obligatorio con aprobación formal (Alto). Además, Functional/API-UI, Regresión y Accesibilidad verificados en QG4 deben **permanecer en verde**.

### QG6 — Go-Live / Readiness

**Objetivo:** solución y organización listas para producción.

- **Pruebas:** Smoke pre y post-despliegue · **DR/resiliencia y rollback si NAQ Alto** · Migración/reconciliación de datos si aplica
- **Criterios de salida:** Checklist de readiness · **Rollback probado (NAQ Alto)** · Smoke pre-prod OK · Monitorización/hypercare · Aprobación seguridad/ops
- **Entregables:** Acta Go/No-Go · Plan de despliegue y runbook · Plan de rollback · Smoke pre/post · Aprobación seguridad/ops y observabilidad
- **Responsable:** Delivery + DevOps + Cliente/Ops · **Formato:** acta, checklist y enlaces a evidencias · **Validez:** versión candidata y ventana de despliegue identificadas
- **Aprueba:** Delivery + Cliente + Ops
- **Umbrales:** ver `sdet-sqem-controls`.

> **QG6 es barrera dura en todas las tipologías**, incluida IA/ML/GenAI: no se promociona sin decisión Go/No-Go formal.

### QG7 — Cierre / Garantía

**Objetivo:** estabilizar, transferir y capitalizar.

- **Pruebas:** ninguna. Se estabiliza (hypercare), se transfiere y se capitaliza.
- **Criterios de salida:** Hypercare sin críticos · Documentación y traspaso a AMS/RUN · Lecciones y KPIs finales
- **Entregables:** Informe final · KPIs finales · Lecciones aprendidas · Transferencia a RUN/AMS · Plan/backlog de acciones
- **Responsable:** QA Manager + Delivery · **Formato:** informe final y backlog de acciones · **Validez:** cierre posterior a hypercare o garantía
- **Aprueba:** QA Manager + Delivery
- **Umbrales:** documentación básica (Bajo) / actualizada (Medio) / completa y auditada (Alto).

---

## Reglas de decisión (§6.10)

Todo control evaluado en un gate se traduce a una de estas cuatro decisiones homogéneas, para que la estrategia sea auditable y comparable entre proyectos.

| Resultado | Condición | Decisión de gate |
|-----------|-----------|------------------|
| **PASS** | Evidencia completa, actual, trazable y dentro del umbral aplicable por NAQ | Permite avanzar si el resto de criterios críticos también son PASS |
| **WARNING** | Evidencia parcial, control incompleto, desviación menor o criterio cumplido con riesgo residual documentado | Avance condicionado con **responsable, fecha de cierre y aceptación de riesgo** |
| **FAIL** | Evidencia ausente, no verificable, fuera de umbral, o incumplimiento de criterio bloqueante | No avanza salvo excepción formal (§8); si el criterio es no excepcionable, bloquea |
| **N/A** | Criterio no aplicable por tipología, NAQ o alcance, **con justificación explícita** | Se excluye del scoring y queda registrado |

### Criterios no excepcionables

Salvo aprobación de **Dirección/Sponsor + QA Manager**:

- Defecto bloqueante o crítico abierto
- Incumplimiento grave de seguridad, datos o compliance
- Ausencia de evidencias mínimas de pruebas
- Rollback obligatorio no definido
- Riesgo alto sin mitigación

Corresponden a la **severidad Alta** de la matriz de aprobadores de §8 y, con independencia del NAQ, requieren ese nivel de aprobación.

---

## QG-Exprés — Hotfix / Emergencia (§6.4.2)

Las correcciones urgentes en producción no pueden recorrer la secuencia completa sin agravar el impacto de negocio. El QG-Exprés **no renuncia al control**: reparte el aseguramiento en dos tiempos.

### Mínimos ex-ante (obligatorios antes de promocionar)

1. **Revisión por par** del cambio. En NAQ Alto, revisor senior.
2. **Smoke test dirigido** sobre la funcionalidad afectada y sus dependencias inmediatas.
3. **Rollback probado** — mecanismo verificado antes del despliegue.
4. **Decisión Go/No-Go registrada**, aunque sea ligera, con aprobador acorde a severidad × NAQ (§8).

### Cierre ex-post (24-48 h tras el despliegue)

- Completar los criterios de gate omitidos que apliquen: caso de regresión de la zona afectada, actualización de la matriz de trazabilidad, análisis estático sobre el código del hotfix, evidencia documental y, si procede, incorporación del caso a la suite de regresión automatizada.
- **Análisis de causa raíz** del incidente y, si el patrón lo justifica, disparador de reevaluación de NAQ (§5.1).

### Reglas

- **No exime del núcleo común (§5.4).** Cero bloqueantes/críticos, smoke pre y post, plan de rollback y trazabilidad mínima siguen siendo infranqueables.
- Es un **mecanismo excepcional**, no una vía para saltarse el proceso. Todo uso se registra, y un **patrón recurrente de hotfix sobre la misma aplicación es en sí una no conformidad** y un disparador de reevaluación de NAQ.
- La deuda ex-post tiene **seguimiento operativo diario a cargo del QA Lead** dentro de la ventana de 24-48 h, con **escalado automático a las 72 h** según §8. El Comité de Calidad revisa el **patrón**, no la ventana individual.

---

## Criterios de entrada, salida, suspensión y reinicio de pruebas (§6.8)

- **Entrada:** plan de pruebas consensuado con desarrollo · recursos asignados · entorno y datos disponibles · casos creados y asignados · smoke previo OK
- **Suspensión:** software no disponible en plazo · entorno inestable · defectos críticos tras smoke que impiden progresar
- **Reinicio:** resueltos los problemas causantes; si fue un crítico, verificada su corrección antes de reanudar
- **Salida:** 100% de casos planificados ejecutados con independencia del resultado · 0 casos bloqueantes en estado *failed* · defectos residuales que no comprometen el negocio y con plan de solución · desviaciones comunicadas y registradas

---

## Gestión de defectos (§6.7)

| Severidad | Definición | Efecto en Go-Live |
|-----------|------------|-------------------|
| **Blocker** | Bloquea completamente una funcionalidad; no hay acceso | **Impide paso a producción** |
| **Critical** | Bloquea parcialmente; problema grave de uso | **Impide paso a producción** |
| **Major** | Defecto grave que no bloquea | Requiere workaround acordado o corrección |
| **Normal** | Criticidad media | Puede diferirse con acuerdo |
| **Minor** | Criticidad baja | Diferible |
| **Trivial** | Estético/ortográfico | Diferible |

**Ciclo de vida:** registro (con contexto, evidencia y componente) → priorización → asignación → corrección → **confirmación (re-test)** → cierre; regresión asociada si el fix toca áreas sensibles.

**Regla de aceptación a producción:** no se promociona software con defectos **bloqueantes o críticos abiertos**. Los de menor prioridad pueden diferirse si no comprometen el proceso de negocio y existe plan de solución acordado.

---

## Datos y entornos de prueba (§6.9)

- **GDPR:** prohibido usar datos reales sin anonimizar. Preferir datos sintéticos, anonimización o enmascaramiento.
- **Test Data Management:** detección temprana de la necesidad de datos, generación, autoservicio y datos de referencia versionados.
- **Entornos:** definir hardware/software/datos y ventanas de despliegue. Entorno de pruebas estable y representativo. **Para NAQ Alto, preproducción equivalente a producción.**
