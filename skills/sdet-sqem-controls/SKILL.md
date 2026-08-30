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
| **Code review** | QG3 | 1 reviewer (recomendado) | 1 reviewer obligatorio | >=2 reviewers senior |
| **Tests unitarios (cobertura)** | QG3 | Ver umbrales | Ver umbrales | Ver umbrales |
| **Análisis estático / QG** | QG3 | Perfil Bajo | Perfil Medio | Perfil Alto + revisión manual |
| **Testing funcional / API-UI** | QG4-5 | Smoke | Obligatorio (API/UI) | Completo + flujos E2E críticos automatizados |
| **Tests de integración** | QG4 | Parcial según alcance | Obligatorio | Cobertura completa |
| **Regresión** | QG4-5 | Smoke | Parcial | Completa (100% automatizada en áreas críticas) |
| **Mutation testing** | QG3 | — | Recomendado | Obligatorio en áreas críticas |
| **Performance** | QG4 | No obligatorio | Prueba básica | Carga + estrés + soak + escalabilidad |
| **Seguridad** | QG3+6 | SCA de dependencias | SAST + dependencias | SAST+DAST+secretos (+pentest en misión crítica) |
| **Accesibilidad WCAG** | QG4-5 | Recomendada si es web | Obligatoria en canal público | WCAG auditada (obligatoria en público/ENS) |
| **Documentación** | QG6-7 | Básica | Actualizada | Completa y auditada |
| **UAT** | QG5 | Opcional | Recomendado | Obligatorio (aprobación formal) |
| **Rollback** | QG6 | Plan recomendado/básico | Plan obligatorio | Plan obligatorio + **ensayado** |
| **Observabilidad** | QG6 | Básica (logs) | Estándar (métricas+logs) | Dashboards + alertas + trazas |
| **Disaster recovery** | QG6 | — | Según riesgo | **Validado** (ensayo de recuperación) |
| **Revisión de Go-Live** | QG6 | Autoservicio/ligera | QA Lead | QA + negocio (Comité/CAB en misión crítica) |

---

## Umbrales de cobertura de código (sección 10.3)

| NAQ | Código nuevo (nuevo/modificado) | Overall (base de código completa) |
|-----|--------------------------------|-----------------------------------|
| Alto — misión crítica | >=90% | >=80% |
| Alto | >=80% | >=70% |
| Medio | >=70% | >=50% |
| Bajo | >=60% | >=35% |

---

## Quality Gate de SonarQube por NAQ (sección 10.2)

| NAQ + alcance | Bloqueante | Crítico | Confiabilidad | Seguridad | Mantenibilidad | Duplicado |
|-------------|---------|----------|-------------|----------|-----------------|------------|
| Bajo — Nuevo (Overall) | 0 | <=10 | >=C | >=C | >=C (<=20%) | — |
| Bajo — Legacy (código nuevo) | 0 | — | >=C | >=C | — | — |
| Medio — Nuevo (Overall) | 0 | <=5 | >=B | >=B | >=B (<=10%) | <=10% |
| Medio — Legacy (código nuevo) | 0 | <=10 | >=B | >=B | >=C (<=20%) | <=10% |
| Alto — Nuevo (Overall) | 0 | 0 | A | A | A (<=5%) | <=5% |
| Alto — Legacy (código nuevo) | 0 | 0 | A | A | A (<=5%) | <=5% |

**Regla de alcance de SonarQube (sección 7.2):**
- **Proyectos nuevos** (desarrollo nuevo, transformación): evaluar sobre la base de código **Overall**
- **Proyectos legacy/AMS** (evolutivo, correctivo, hotfix): evaluar solo sobre **código nuevo**

---

## Indicadores clave y umbrales por NAQ (sección 7.1.1)

| Indicador | NAQ Bajo | NAQ Medio | NAQ Alto |
|-----------|----------|-----------|----------|
| Vulnerabilidades | 0 Bloqueantes/Críticas | 0 Bloqueantes/Críticas/Mayores | 0 de cualquier severidad |
| Security Rating (Sonar) | >=C | >=B | A |
| Cobertura de tests de HU | 100% críticas/normales | Igual | Igual |
| Tasa de regresión | Smoke obligatorio | Parcial, 100% planificada | Completa, críticos automatizados |
| Tasa de UAT | Opcional | Recomendada, 100% | Aprobación formal obligatoria |
| Pruebas de performance | No obligatorias | Prueba básica | Carga+estrés+soak+escalabilidad |
| Accesibilidad WCAG AA | Recomendada si es web | Obligatoria en público | Auditada, obligatoria en ENS/público |
| Deuda técnica (Sonar) | >=C (ratio <=20%) | >=B (ratio <=10%) | A (ratio <=5%) |
| DDE (Defect Detection Effectiveness) | >=88% | >=92% | >=95% |
| DER (Defect Escape Rate) | <=12% | <=8% | <=5% |

---

## Dashboards y reporting — 4 niveles (sección 7.3)

| Nivel | Tipo | Audiencia | Frecuencia | Contenido |
|-------|------|-----------|------------|-----------|
| **Semáforo de Calidad** | Cuantitativo | Equipo de desarrollo / QA / Product Owner | Diaria / Semanal | Semáforo por característica ISO/IEC 25010 |
| **Barómetro de Calidad** | Cualitativo | QA Lead / Arquitecto / Ops / Product Owner | Semanal / Quincenal | Salud en 7 dimensiones puntuadas de 0 a 100 |
| **Cuadro de mando de portfolio** | Ejecutivo | Comité de Calidad | Mensual | KPIs consolidados: IQ agregado, distribución de NAQ, defectos críticos, % de automatización |
| **Reporting de proyecto** | De proyecto | PM + QA Lead + Tech Lead | Semanal / Quincenal | Avance de calidad, defectos abiertos, hitos de gates |

### Barómetro de Calidad — 7 dimensiones

| Dimensión | Significado |
|-----------|-------------|
| Estrategia de testing | Cobertura y robustez de la estrategia de testing |
| Riesgos de calidad | Riesgos de calidad identificados y estado de mitigación |
| No conformidades | Fallos de gate, excepciones y tendencia de desviaciones |
| Observabilidad | Monitoreo, alertas y trazabilidad en producción |
| Readiness de release | Completitud de la preparación de la release |
| OPS y operación | Salud operativa y patrones de incidentes |
| Costes de no calidad | Coste de defectos, retrabajo y escapes a producción |

### Escala de puntuación

| Puntuación | Estado | Acción |
|-------|--------|--------|
| 80-100 | Óptimo | Mantener |
| 60-79 | Aceptable | Monitorear y mejorar |
| 40-59 | En riesgo | Requiere acción correctiva |
| 0-39 | Crítico | Escalar de inmediato |

---

## Entregables mínimos por NAQ (sección 9)

| Entregable | NAQ Bajo | NAQ Medio | NAQ Alto |
|-------------|----------|-----------|----------|
| Ficha/clasificación NAQ | Obligatoria | Obligatoria | Obligatoria |
| Plan/checklist de calidad | Checklist mínimo | Plan simplificado | Plan completo |
| Estrategia de pruebas | Breve (en el checklist) | Simplificada | Completa, basada en riesgo |
| Análisis de riesgos | Básico | Recomendado | Obligatorio |
| Matriz requisito-prueba | Solo críticos | Requisitos principales | 100% de los relevantes |
| Casos/escenarios | Flujos mínimos | Flujos principales | Principales + alternativos + críticos |
| Informe de ejecución | Checklist de resultados | Por ciclo/release | Formal por ciclo/gate |
| Informe de defectos | Registro básico | Con severidad | Con severidad, tendencia y riesgo |
| Informe de calidad de código | Si hay riesgo técnico | Obligatorio si hay código | Obligatorio, sin críticos |
| Evidencia UAT | Aprobación simple | Evidencia funcional | UAT formal con resultados |
| Acta Go/No-Go | Ligera | Obligatoria | Comité formal |
| Plan de despliegue y rollback | Básico | Obligatorio | Obligatorio y validado |
| Informe post-producción | Smoke post-deploy | Breve | Informe formal de estabilización |
| Lecciones aprendidas | Recomendadas | Obligatorias | Obligatorias |

---
