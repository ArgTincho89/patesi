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

| Gate | Qué | Criterios clave | Aprueba |
|------|-----|-----------------|---------|
| **QG0** Inicio/Viabilidad | Arranque con alcance, riesgos, NAQ y plan de calidad | NAQ asignado, plan aprobado, riesgos mapeados, toolchain definido | QA Manager + Delivery Manager |
| **QG1** Requisitos (DoR) | Requisitos completos, testeables y trazables | Criterios de aceptación definidos, trazabilidad requisito<->prueba, NFRs identificados | QA Lead + Product Owner |
| **QG2** Diseño/Arquitectura | Diseño robusto que cubre lo funcional y lo no funcional | Diseño revisado, ADRs, NFRs dimensionados, estrategia de testing aprobada | Arquitecto + QA Lead |
| **QG3** Construcción (DoD) | El código cumple los estándares antes de pasar a pruebas | Code review OK, análisis estático sin bloqueantes, cobertura dentro del umbral, **QG de Sonar SUCCESS** | Tech Lead + QA |
| **QG4** Pruebas de sistema | El sistema integrado cumple lo funcional y lo no funcional | Casos ejecutados sobre el objetivo, **0 bloqueantes/críticos abiertos**, regresión superada, no funcionales superados | QA Lead |
| **QG5** UAT/Aceptación | Aceptación formal de negocio o del cliente | Casos UAT aceptados, defectos residuales acordados, **sign-off del cliente** | Cliente / Product Owner |
| **QG6** Go-Live/Readiness | Solución y organización listas para producción | Checklist de readiness, **rollback probado** (NAQ Alto), smoke pre-producción OK, monitoreo | Delivery Manager + Cliente/Ops |
| **QG7** Cierre/Garantía | Estabilizar, transferir y capitalizar | Hypercare sin críticos, documentación, traspaso a AMS/RUN, lecciones aprendidas, KPIs | QA Manager + Delivery Manager |

---

## QG-Express (hotfix/emergencia)

- **Ex-ante** (antes del deploy): revisión por pares + smoke dirigido + rollback probado + Go/No-Go registrado
- **Ex-post** (24-48 h después): completar los criterios de gate omitidos + análisis de causa raíz

---

## 4 resultados de gate

| Decisión | Condición | Consecuencia |
|----------|-----------|--------------|
| **PASS** | Evidencia completa, vigente y trazable dentro del umbral del NAQ | Avanza |
| **WARNING** | Evidencia parcial, control incompleto, desviación menor | Avance condicionado — requiere responsable y fecha de cierre |
| **FAIL** | Evidencia ausente o no verificable, fuera de umbral, bloqueante | NO avanza — requiere excepción formal |
| **N/A** | No aplica por tipología, NAQ o alcance | Excluido del scoring |

### Criterios no exceptuables (bloqueos estrictos)

- Defecto bloqueante/crítico abierto
- Brecha grave de seguridad, datos o cumplimiento
- Evidencia mínima de pruebas no disponible
- Rollback obligatorio no definido
- Riesgo alto sin mitigación

---

## Entregables por gate

| Gate | Entregables obligatorios |
|------|--------------------------|
| **QG0** | Ficha NAQ, Plan de Calidad, Matriz de riesgos, RACI, Toolchain y entornos |
| **QG1** | Backlog/ERS, Criterios de aceptación, NFRs, Trazabilidad requisito<->prueba |
| **QG2** | Documento de arquitectura, ADRs, Riesgos técnicos, Estrategia de pruebas, Criterios no funcionales, Acta de revisión |
| **QG3** | Pipeline CI, Análisis estático (SonarQube), Informe de cobertura, PR/code review |
| **QG4** | Informe de ejecución, Informe de defectos, Regresión+integración, No funcionales, Evidencias de entorno |
| **QG5** | Casos UAT y resultados, Defectos residuales aceptados, Sign-off de cliente/Product Owner |
| **QG6** | Acta Go/No-Go, Runbook, Plan de rollback, Smoke pre/post, Seguridad/ops+observabilidad |
| **QG7** | Informe final, KPIs finales, Lecciones aprendidas, Transferencia RUN/AMS, Plan de acciones |

---

## Gates por tipología — matriz F/L/C/N/A

Los nombres de tipología son exactamente los definidos en `sdet-sqem-classification`.

| Tipología | QG0 | QG1 | QG2 | QG3 | QG4 | QG5 | QG6 | QG7 |
|-----------|-----|-----|-----|-----|-----|-----|-----|-----|
| Desarrollo nuevo | F | F | F | F | F | F | F | F |
| Mantenimiento evolutivo (AMS) | L | L | C | F si hay código | C | C | F | L |
| Mantenimiento correctivo (AMS) | L | L | N/A | F si hay código | C | C (mitad) | F | L |
| Hotfix / Emergencia | N/A | L | N/A | L (revisión por pares) | L (smoke) | N/A | F | L (ex-post) |
| Transformación / Migración | F | F | F | F | F | F | F | F |
| Integraciones / APIs / Datos | F | F | F | F | F | C | F | F |
| Producto digital / Canal de usuario | F | F | F | F | F | F | F | F |
| Empaquetado (SAP/Salesforce/...) | F | F | C | F si hay desarrollo | F | F | F | F |
| Producto de mercado (COTS/SaaS) | F | F | F | F | F | F | F | F |
| IA / ML / GenAI | F | F | F | F si hay código/pipeline | F | F | F | F |
| Datos y analítica / BI | F | F | F | F | F | F | F | F |
| Infraestructura / DevOps / Cloud | F | F | F | F | F | C | F | F |
| RPA / Automatización | F | F | C | F | F | F | F | F |
| Ciberseguridad | F | F | F | F si hay código/configuración | F | C | F | F |
| Consultoría | F | F | L | N/A | N/A | F | N/A | L |

**Leyenda:** F = Formal, C = Condicional, L = Ligero, N/A = No aplica

---

## Gestión de excepciones (sección 8)

| Severidad de la excepción | NAQ | Aprobador mínimo |
|---------------------------|-----|------------------|
| Menor (diferida) | Cualquiera | PM + QA Lead |
| Media (Mayor diferida) | Bajo/Medio | PM + Cliente/Product Owner |
| Media | Alto | QA Manager + Delivery Manager |
| Alta (bloqueante/crítica, seguridad, datos, cumplimiento) | Cualquiera | **Dirección/Sponsor + QA Manager** |

---
