# Patesi — Referencia Rápida SQEM

## Estructura del Documento SQEM

| Sección | Título | Contenido clave |
|---------|--------|-----------------|
| 1 | Introducción | Contexto, alcance, alineación con ISO/IEC 25010 |
| 2 | Modelo de Calidad | 8 características ISO/IEC 25010 |
| 3 | Roles y Organización | Governance: QA Mgr, QA Lead, QA Eng, Tech Lead, PM, PO, DevOps |
| 4 | Principios Generales | Context-aware, proporcional, basado en evidencia, risk-based |
| 5 | Clasificación y Diseño | NAQ (5.1), Tipologías (5.2), Delivery Target (5.3), Núcleo Común (5.4) |
| 6 | Puertas de Calidad | 8 puertas operativas (6.3), Por tipología (6.4), Ajuste NAQ (6.5) |
| 7 | Reportes e Indicadores | Umbrales (7.1.1), Dashboards (7.3) |
| 8 | Excepciones y Resoluciones | Gestión de excepciones, escalamiento |
| 9 | Entregables Mínimos por NAQ | Tabla de entregables por nivel NAQ |
| 10 | Controles Operativos | Catálogo (10.6), Cobertura (10.3), SonarQube (10.2) |
| 11 | Compliance y Mejora | Auditorías, capacitación, toolchain |
| 12 | Despliegue en CI/CD | Integración pipelines, quality gates |
| 13 | Agilidad y SQEM | Gates ligeros para Agile/Scrum |
| 14 | Herramientas y Automatización | Recomendaciones de tooling |
| 15 | Escalamiento y Madurez | Modelo de madurez organizacional |
| 16 | Anexo IA | Controles específicos IA/ML/GenAI |
| 17 | Anexo IB | Referencias |
| 18 | Glosario | Definiciones |

## Referencia Rápida NAQ

```
NAQ = (Criticidad×8 + Visibilidad×4 + Interop×4 + Sensibilidad×4 + Complejidad×2) / pesos activos

  NAQ < 1.5  → Bajo (Velocidad)
1.5 ≤ NAQ < 3 → Medio (Balance)
    NAQ ≥ 3  → Alto (Minimizar Riesgo)
```

**Overrides:**
- Criticidad=4 O Sensibilidad=4 → Alto (forzado)
- Criticidad≥3 Y Sensibilidad≥3 → mínimo Medio

## 15 Tipologías (Referencia Rápida)

| # | Nombre | Preocupación principal |
|---|--------|----------------------|
| 1 | Desarrollo Nuevo | Testing F + NF completo |
| 2 | Mant. Evolutivo | Análisis de impacto, regresión selectiva |
| 3 | Mant. Correctivo | Confirmación de defecto, regresión selectiva |
| 4 | Hotfix/Emergencia | QG-Express: peer review + smoke + rollback |
| 5 | Transformación/Migración | Baseline, validación de migración, rollback |
| 6 | Integraciones/APIs | Contract testing, resiliencia, seguridad |
| 7 | Producto Digital | E2E, usabilidad, accesibilidad, compatibilidad |
| 8 | Embalado (SAP/SF) | Config vs estándar, UAT, seguridad por roles |
| 9 | Producto Mercado (COTS) | Requisitos vs producto, revisión de config |
| 10 | IA/ML/GenAI | Calidad de datos, eval LLM, Responsible AI |
| 11 | Data & Analytics/BI | Calidad de datos, reconciliación, lineage |
| 12 | Infra/DevOps/Cloud | IaC, hardening, DR, observabilidad |
| 13 | RPA | E2E process, exception handling |
| 14 | Ciberseguridad | SAST/DAST/SCA, pentest, threat modeling |
| 15 | Consultoría | Peer review, document QC |

## Delivery Targets

| Target | Capacidades Mínimas |
|--------|---------------------|
| **Básico** | Checklist, tests manuales, smoke, gates manuales |
| **Integrado** | CI, SonarQube, regresión crítica automatizada, gates parciales |
| **Continuo** | Auto quality gates, alta automatización, dashboards, rollback rehearsed |

## Núcleo Común (NO Negociable — Siempre Aplica)

1. NAQ asignado + ficha de proyecto
2. Criterios de aceptación definidos
3. Gestión de defectos en ALM
4. **Smoke pre + post deploy**
5. **0 bloqueantes/críticos abiertos**
6. **Go/No-Go registrado**
7. Plan de deploy + rollback
8. Nomenclatura estándar + trazabilidad
9. **GDPR en datos de test**

## 8 Gates (Resumen)

| Gate | Qué |
|------|-----|
| QG0 | Inicio/Viabilidad — Alcance, riesgos, NAQ, plan |
| QG1 | Requisitos — AC definidos, trazabilidad, NFRs |
| QG2 | Diseño — Diseño revisado, ADRs, Estrategia de Pruebas |
| QG3 | Construcción — Code review, estático, cobertura, SonarQube |
| QG4 | Pruebas de sistema — Ejecutados en target, 0 bloqueantes |
| QG5 | UAT — Aceptación del cliente, sign-off formal |
| QG6 | Go-Live — Readiness, rollback, smoke, monitoreo |
| QG7 | Cierre — Estabilizar, transferir, capitalizar |

## Resultados de Gate

| Resultado | Condición |
|-----------|-----------|
| **PASS** | Evidencia completa, actual, trazable |
| **WARNING** | Evidencia parcial, desviación menor |
| **FAIL** | Evidencia ausente, fuera de umbral, bloqueador |
| **N/A** | No aplica por tipología/NAQ |

## Umbrales de Cobertura por NAQ

| NAQ | Código Nuevo | Global |
|-----|-------------|--------|
| Alto misión crítica | >=90% | >=80% |
| Alto | >=80% | >=70% |
| Medio | >=70% | >=50% |
| Bajo | >=60% | >=35% |

## Modelo de Calidad ISO/IEC 25010 (Base del SQEM)

| Característica | Qué mide |
|---------------|----------|
| **Idoneidad Funcional** | Corrección, completitud, adecuación |
| **Eficiencia de Desempeño** | Tiempo, utilización de recursos, capacidad |
| **Compatibilidad** | Coexistencia, interoperabilidad |
| **Usabilidad** | Reconocibilidad, aprendizaje, operabilidad |
| **Fiabilidad** | Madurez, disponibilidad, tolerancia a fallos |
| **Seguridad** | Confidencialidad, integridar, no repudio |
| **Mantenibilidad** | Modularidad, reusabilidad, analizabilidad |
| **Portabilidad** | Adaptabilidad, instalabilidad, reemplazabilidad |

## Gestión de Excepciones

| Severidad | NAQ | Aprobador |
|-----------|-----|-----------|
| Menor (deferred) | Cualquiera | PM + QA Lead |
| Medio | Bajo/Medio | PM + Cliente/PO |
| Medio | Alto | QA Manager + Delivery |
| Alto (bloqueador, seguridad, datos, compliance) | Cualquiera | **Direction/Sponsor + QA Manager** |
