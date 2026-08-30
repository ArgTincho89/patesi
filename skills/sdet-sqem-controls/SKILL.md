---
name: sdet-sqem-controls
description: >
  Indicadores y umbrales SQEM: catálogo de controles por gate x NAQ, Quality Gate de análisis estático, cobertura, indicadores de gate frente a resultado, equivalencia funcional por tecnología y ficha de métrica.
  Trigger: controles operativos Seidor, umbrales de cobertura, perfiles SonarQube, indicadores, KPIs, ficha de métrica, equivalencia de quality gate
license: Apache-2.0
metadata:
  author: patesi
  version: "2.0"
  category: sqem
---

# SQEM — Indicadores, umbrales y controles

Fuente: SQEM v1.2 §7 (indicadores) y §10 (toolchain, umbrales y catálogo consolidado).

> Todos los umbrales son **valores por defecto provisionales (v0)**, pendientes de re-baseline en pilotaje (§14).

---

## Distinción crítica: indicador de gate frente a indicador de resultado (§7)

**No todo indicador puede ser un gate de promoción.**

| Uso | Qué significa | Efecto |
|-----|---------------|--------|
| **Gate de promoción (leading)** | Medible **en el momento** de decidir el paso a producción | Condiciona el Go/No-Go |
| **Resultado / salud (lagging)** | Solo medible **después** del despliegue; requiere datos de producción | Alimenta mejora continua y reevaluación de NAQ. **NUNCA bloquea el gate del release que lo genera** |

**DDE y DER son indicadores de resultado.** Exigirlos como condición de promoción del release que los produce es un error de aplicación de la norma: todavía no existen datos para calcularlos.

---

## Catálogo operativo consolidado — control x puerta x NAQ (§10.6)

La columna Puerta usa la vista de 5 puertas con el gate operativo entre paréntesis.

| Control | Puerta / gate | NAQ Bajo | NAQ Medio | NAQ Alto |
|---------|---------------|----------|-----------|----------|
| **Code review** | Integración (QG3) | 1 revisor (recomendado) | 1 revisor obligatorio | >=2 revisores (senior en misión crítica) |
| **Unit tests (cobertura)** | Integración (QG3) | Según §10.3 | Según §10.3 | Según §10.3 |
| **Análisis estático (Quality Gate)** | Integración (QG3) | Perfil Bajo §10.2 | Perfil Medio §10.2 | Perfil Alto §10.2 + revisión manual |
| **Functional / API-UI** | Preprod.–UAT (QG4–QG5) | Smoke | Obligatorio (API/UI) | Completo + E2E de flujos críticos automatizado |
| **Integration tests** | Preprod. (QG4) | Parcial según alcance | Obligatorios | Cobertura completa |
| **Regresión** | Preprod.–UAT (QG4–QG5) | Smoke | Parcial | Completa (100% automatizada en áreas críticas) |
| **Mutation testing** | Integración (QG3) | — | Recomendado (opcional) | Recomendado (obligatorio en áreas críticas de misión crítica) |
| **Performance** | Preprod. (QG4); cierre en QG6 | No obligatorio | Prueba básica | Carga + estrés + soak + escalabilidad |
| **Seguridad** | Integración·Producción (QG3·QG6) | Dependencias (SCA) | SAST + dependencias | SAST + DAST + secrets (+ pentest y modelado de amenazas en misión crítica) |
| **Accesibilidad (WCAG/EN 301 549)** | Preprod.–UAT (QG4–QG5); cierre en QG6 | Recomendado si web interna | WCAG si canal público | WCAG auditada (obligatorio en canal público/ENS) |
| **Documentación** | Producción–Cierre (QG6–QG7) | Básica | Actualizada | Completa y auditada |
| **UAT** | UAT (QG5) | Opcional | Recomendado | Obligatorio (aprobación formal) |
| **Rollback** | Producción (QG6) | Recomendado / plan básico | Plan obligatorio | Plan obligatorio y **ensayado** |
| **Observabilidad** | Producción (QG6) | Básica (logs) | Estándar (métricas + logs) | Dashboards + alertas + trazas |
| **Disaster Recovery** | Producción (QG6) | — | Según riesgo | **Validado** (ensayo de recuperación) |
| **Go-Live Review** | Producción (QG6) | Autoservicio / ligero | QA Lead | QA + Negocio (Comité/CAB en misión crítica) |

---

## Quality Gate de análisis estático por NAQ (§10.2)

Debe pasar **SUCCESS** para promocionar. **New code** = código nuevo/modificado (*Clean as You Code*); **Overall** = base total del componente.

**Los umbrales de cobertura no se repiten aquí**: son los de §10.3.

| NAQ | Ámbito | Blocker | Critical | Reliability | Security | Maintainability (deuda) | Duplicated | Security Review | Unit Test Success |
|-----|--------|---------|----------|-------------|----------|-------------------------|------------|-----------------|-------------------|
| **Bajo — Nuevo** | Overall | 0 | <=10 | >=C | >=C | >=C (<=20%) | — | — | 100% |
| **Bajo — Legacy** | New code | 0 | — | >=C | >=C | — | — | — | — |
| **Medio — Nuevo** | Overall | 0 | <=5 | >=B | >=B | >=B (<=10%) | <=10% | >=C (>=50%) | 100% |
| **Medio — Legacy** | New code | 0 | <=10 | >=B | >=B | >=C (<=20%) | <=10% | >=C (>=50%) | — |
| **Medio — Legacy** | Overall | 0 | — | >=C | >=C | — | — | — | 100% |
| **Alto — Nuevo** | Overall | 0 | 0 | A | A | A (<=5%) | <=5% | >=B (>=75%) | 100% |
| **Alto — Legacy** | New code | 0 | 0 | A | A | A (<=5%) | <=5% | >=B (>=70%) | — |
| **Alto — Legacy** | Overall | 0 | <=10 | >=B | >=B | >=C (<=20%) | <=10% | — | 100% |

**Legacy exige las dos filas a la vez**: la fila *New code* y la fila *Overall* de su banda. No basta con cumplir una.

> Rating: A es el mejor. ">=B" significa "no peor que B".

**Regla de ámbito (§7.2 del modelo de gobernanza / §10.2):** el ámbito lo fija **la tipología, no el NAQ**.
- **Proyectos nuevos** (nuevo desarrollo, transformación): se evalúa sobre **Overall**.
- **Proyectos legacy/AMS** (evolutivo, correctivo, hotfix): se evalúa sobre **New code**, con la fila Overall de refuerzo donde la tabla la exige.

---

## Umbrales de cobertura de código (§10.3) — tabla única

| NAQ | New code (nuevo/modificado) | Overall (conjunto) |
|-----|-----------------------------|--------------------|
| **Alto — misión crítica** (override §5.1) | >= 90% | >= 80% |
| **Alto** | >= 80% | >= 70% |
| **Medio** | >= 70% | >= 50% |
| **Bajo** | >= 60% | >= 35% |

- Aplica por igual a componentes nuevos y legacy. En legacy la exigencia fuerte recae sobre **New code**; el umbral **Overall** se alcanza de forma progresiva.
- En todos los casos, la cobertura debe ser **> la cobertura inicial** registrada en la foto de PLAN. **No se admite regresión de cobertura.**

---

## Equivalencia funcional del Quality Gate por tecnología (§10.5)

SonarQube es la referencia para desarrollo a medida, pero **no cubre todo el portfolio**. El indicador primario es "Quality Gate de análisis estático **o su equivalente funcional**".

| Stack / tipo | Análisis estático (gate) | Proxy de complejidad | Equivalente de "cobertura" |
|--------------|--------------------------|----------------------|----------------------------|
| Java/.NET/JS a medida | SonarQube | KLOC | Cobertura unitaria (§10.3) |
| **SAP / ABAP** | Code Inspector / ATC | Nº de objetos/RICEFW | Cobertura de casos funcionales por objeto/proceso + ABAP Unit donde aplique |
| **Salesforce / Apex** | PMD Apex / Salesforce Code Analyzer; validación de metadatos | Nº de objetos/flows/Apex classes | Cobertura Apex (mín. plataforma 75%) + cobertura de flujos declarativos por casos |
| **Data / ETL / analytics** | Linting de pipelines + reglas de calidad de datos | Nº de pipelines/transformaciones | Tests de reconciliación (conteos, integridad, reglas) y cobertura de reglas |
| **Low-code / no-code** | Reglas de la plataforma + revisión de configuración | Nº de flujos/pantallas/reglas | Cobertura de casos funcionales sobre flujos configurados |

> **Regla de prevalencia:** cuando el mínimo impuesto por la plataforma sea **superior** al umbral de la banda NAQ, **prevalece el mínimo de plataforma**. Ejemplo: el 75% de cobertura Apex de Salesforce gana sobre el 60% de NAQ Bajo de §10.3.

La **validación de la equivalencia** para un stack concreto es responsabilidad del QA CoE (RACI §3.3).

---

## Catálogo de indicadores (§7.1)

| Indicador | Tipo | Uso | Umbral normativo |
|-----------|------|-----|------------------|
| **Quality Gate (estático)** | Primario | Gate | **SUCCESS** para promocionar |
| **Nº de defectos por severidad** | Primario | Gate | 0 bloqueantes/críticos abiertos para producción |
| **Vulnerabilidades** (SAST/DAST/SCA) | Primario | Gate | **0 Críticas/Altas abiertas en todas las bandas.** Medias/Bajas: 0 en Alto; plan de remediación con fecha en Medio (<=30 días) y Bajo (<=90 días) |
| **Rating de seguridad** | Primario | Gate | A/B promocionan; C/D/E no (Medio/Alto) |
| **Cobertura de historias de usuario** | Primario | Gate | 100% en HU crítica/normal · 80% en HU de necesidad baja |
| **Tasa de regresión** | Primario | Gate | 100% ejecutado; sin fallos críticos para producción |
| **Tasa de UAT** | Primario | Gate | 100% ejecutado o conformidad escrita del usuario |
| **Cobertura de código** | Primario | Gate | Según §10.3 y > cobertura inicial |
| **Tiempo de respuesta** | Primario si aplica NF | Gate | Umbral de la Estrategia de Pruebas (p. ej. <2 s en p95) |
| **Cumplimiento accesibilidad AA** | **Condicional** | Gate | Obligatorio en canales públicos y sujetos a ENS/EN 301 549; recomendado en web interna de NAQ Bajo |
| **Compatibilidad navegadores/SO** | **Condicional** | Gate | 100% de la matriz objetivo; obligatorio en producto digital |
| **Interoperabilidad / contratos** | **Condicional** | Gate | 100% de interfaces críticas con contrato versionado y test en verde (§11.5) |
| **Instalación / despliegue** | **Condicional** | Gate | 100% en los entornos objetivo definidos |
| **Migración / rollback verificado** | **Condicional** | Gate | Migración sin pérdida y rollback verificado antes de Go-Live; obligatorio en Transformación/migración |
| **Data quality score** | Primario | Gate | Alto >=98% (+ 0 fuga train/test en IA) · Medio >= umbral pactado · Bajo validación básica |
| **Code smells** | Secundario | Gate | Según Quality Gate |
| **Nº de bugs en código** | Secundario | Gate | Según Quality Gate |
| **Deuda técnica** | Secundario | **Salud** | Ratio según Maintainability Rating por NAQ |
| **DDE** (eficacia de detección) | Secundario | **Resultado** | Alto >=95% · Medio >=92% · Bajo >=88%. **No es gate del propio release** |

> **DDE y DER son complementarios y comparten ventana de 30 días post-release: `DER = 100% − DDE`.** Sus umbrales se fijan de forma coherente para que un mismo proyecto no pueda aprobar uno y suspender el otro.

### Umbrales por NAQ — vista rápida (§7.1.1)

| Indicador | Bajo | Medio | Alto |
|-----------|------|-------|------|
| Vulnerabilidades | 0 Blocker/Critical (Major tolerado con plan de cierre) | 0 Blocker/Critical/Major | 0 en cualquier severidad |
| Rating de seguridad | >= C | >= B | A |
| Deuda técnica | >= C (<=20% ratio) | >= B (<=10% ratio) | A (<=5% ratio) |
| DDE | >= 88% | >= 92% | >= 95% |

En caso de discrepancia entre esta vista y §10.2/§10.3/§10.6, **prevalecen §10.2/§10.3/§10.6**: esta tabla es capa de lectura, no fuente alternativa.

---

## KPIs de proceso y de negocio — nivel portfolio (§7.2)

| KPI | Objetivo recomendado |
|-----|----------------------|
| **Defect Escape Rate (DER)** | Alto <=5% · Medio <=8% · Bajo <=12% (ventana 30 días post-release) |
| **Cumplimiento de Quality Gates** | >=90%. **Leer siempre junto a DER**: un alto % de gates con DER creciente indica gates laxos o presión indebida |
| **Gates superados a la primera** | >=85% |
| **Automatización de regresión crítica** | Alto >=80% · Medio >=50% |
| **Lead time de defectos críticos (MTTR)** | Alto <2 días · Medio <5 días |
| **Reapertura de defectos** | <5% |
| **Éxito de pipeline CI/CD** | >=90% |
| **Change Failure Rate (DORA)** | <15% |
| **Incidencias post-release** | Tendencia decreciente |
| **CSAT/NPS** | >=8/10 |
| **Coste de la no calidad (CoNQ)** | Tendencia decreciente. Fórmula: horas de retrabajo × coste/hora + coste de incidencias en producción + penalizaciones SLA |

**Mínimo viable de medición:** se instrumentan desde el día 1 los tres KPIs primarios — **DER, Cumplimiento de Quality Gates y MTTR**. El resto es fase 2 y requiere ficha cumplimentada antes de exigirse como objetivo.

---

## Ficha obligatoria de métrica (§7.4, ISO/IEC 25023)

Todo indicador usado como gate, salud o resultado **debe** tener esta ficha, para que otra persona pueda reproducir la medición y entender la decisión.

| Campo | Contenido obligatorio |
|-------|-----------------------|
| **Nombre** | Único y estable |
| **Característica ISO** | Característica ISO/IEC 25010 controlada |
| **Riesgo controlado** | Riesgo que ayuda a prevenir, detectar o aceptar |
| **Fórmula** | Cálculo exacto: numerador, denominador, ventana temporal y exclusiones |
| **Fuente** | ALM, CI/CD, SonarQube, APM, dashboard, test manager… |
| **Periodicidad** | Por commit, por gate, por release, mensual o post-producción |
| **Umbrales** | PASS / WARNING / FAIL, diferenciados por NAQ cuando aplique |
| **Responsable** | Rol que mantiene la métrica y responde ante desviaciones |
| **Acción si incumple** | Bloqueo, excepción, plan de remediación, escalado o revisión de NAQ |
| **Evidencia** | Ruta/URL del informe, fecha, versión evaluada y periodo cubierto |

---

## Dashboards y reporting (§7.3)

| Nivel | Tipo | Audiencia | Contenido |
|-------|------|-----------|-----------|
| **Semáforo de Calidad** | Cuantitativo | Equipo / QA / PO | Semáforo por característica ISO/IEC 25010, alimentado por indicadores y Quality Gate |
| **Barómetro de Calidad** | Cualitativo | QA Lead / Arquitecto / Ops / PO | Salud por dimensiones: características, testing, riesgos, no conformidades, observabilidad, release, OPS, costes |
| **Cuadro de mando de portfolio** | Ejecutivo | Comité de Calidad | Consolidado mensual: KPIs de §7.2, excepciones, auditorías |
| **Reporting de proyecto** | De proyecto | PM + QA Lead + Tech Lead | Informe diario de ejecución e informe final con recomendación Go/No-Go |

---

## Entregables mínimos por NAQ (§9)

| Entregable | Bajo | Medio | Alto | Responsable |
|------------|------|-------|------|-------------|
| Ficha/clasificación NAQ | Obligatoria | Obligatoria | Obligatoria | PM + QA Lead |
| Plan / checklist de calidad | Checklist mínimo | Plan simplificado | Plan completo | QA Lead |
| Estrategia de Pruebas | Breve (en checklist) | Simplificada | Completa, basada en riesgos | QA Lead |
| Análisis de riesgos | Básico | Recomendado | Obligatorio | PM + QA + Tech Lead |
| Matriz requisito-prueba | Solo críticos | Requisitos principales | 100% de los relevantes | QA + BA |
| Casos / escenarios | Flujos mínimos | Flujos principales | Principales + alternativos + críticos | QA |
| Informe de ejecución | Checklist de resultado | Por ciclo/release | Formal por ciclo/gate | QA |
| Informe de defectos | Registro básico | Con severidad | Con severidad, tendencia y riesgo | QA |
| Informe de calidad de código | Si hay riesgo técnico | Obligatorio si hay código | Obligatorio, sin críticos | Tech Lead |
| Evidencia UAT | Aprobación simple | Evidencia funcional | UAT formal con resultados | Cliente/PO |
| Acta Go/No-Go | Ligera | Obligatoria | Comité formal | PM + QA + Cliente |
| Plan de despliegue y rollback | Básico | Obligatorio | Obligatorio y validado/ensayado | DevOps/Tech Lead |
| Informe post-producción | Smoke post | Breve | Formal de estabilización | PM + QA |
| Lecciones aprendidas | Recomendadas | Obligatorias | Obligatorias | PM |

### Plantillas oficiales (§9.1)

Ficha NAQ · Plan de calidad / Estrategia de Pruebas · Matriz requisito-prueba · Registro de evidencias · Acta Go/No-Go · Registro de excepciones · Informe de ejecución · Informe de defectos · Informe de calidad de código · Informe final de calidad · Plan de acción.

El QA CoE mantiene la versión oficial y valida equivalencias cuando el cliente impone su propio formato.
