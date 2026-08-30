---
name: sdet-sqem-typology-tests
description: >
  Pruebas específicas de cada una de las 15 tipologías SQEM, ubicadas en el gate donde se ejecutan, más la base común de pruebas por gate y la tipología de pruebas de referencia.
  Trigger: qué pruebas hago en este gate, pruebas por tipología, qué testear en QG3 QG4 QG6, pruebas específicas Seidor
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: sqem
---

# SQEM — Pruebas por tipología y gate

Responde a la segunda mitad de la pregunta del Modo A: ya sé **qué gates** recorro (`sdet-sqem-gate-matrix`); acá sé **qué pruebo** en cada uno.

Fuente: SQEM v1.2 §5.2 y §6.6, más los bloques específicos por tipología del modelo de gobernanza de quality gates.

**Regla de composición:** con tipologías componibles, el conjunto de pruebas es la **unión** de la primaria y las secundarias, modulada por un mismo NAQ (§5.2).

---

## Base común por gate

Aplica a toda tipología, antes de sumar lo específico.

| Gate | Pruebas base |
|------|--------------|
| **QG0** | Ninguna — gate de planificación |
| **QG1** | Ninguna — se prepara la base testable |
| **QG2** | Ninguna de ejecución — gate de diseño |
| **QG3** | Unitarias · Componentes · Contract testing · Seguridad (SAST/SCA) · **Mutation testing si NAQ Alto** |
| **QG4** | Integración · Sistema/E2E · Regresión · **No funcionales si aplican**: rendimiento, seguridad (DAST/pentest), usabilidad, accesibilidad, compatibilidad |
| **QG5** | UAT / Aceptación por negocio o cliente |
| **QG6** | Smoke pre y post-despliegue · **DR/resiliencia y rollback si NAQ Alto** · Migración/reconciliación de datos si aplica |
| **QG7** | Ninguna — estabilización, transferencia y capitalización |

---

## Específico por tipología

### 1. Nuevo desarrollo
Sin bloques adicionales: aplica íntegra la base común, con las no funcionales moduladas por NAQ.

### 2. Mantenimiento evolutivo (AMS)
- **QG2:** Análisis de impacto del cambio
- **QG4:** Regresión selectiva de la zona afectada · Confirmación de defectos · Regresión no funcional si el cambio afecta a rendimiento/seguridad
- **QG5:** UAT ligera

### 3. Mantenimiento correctivo (AMS)
- **QG4:** Reproducción del defecto + test de confirmación · Regresión selectiva de la zona afectada · Verificación no funcional de la zona afectada si el defecto tenía impacto en rendimiento/seguridad

### 4. Hotfix / Emergencia (QG-Exprés)
- **QG3:** Revisión por par
- **QG4:** Smoke test dirigido · Validación no funcional mínima si afecta a rendimiento/seguridad
- **QG6:** Rollback probado
- **QG7:** Cierre de criterios restantes ex-post (24-48 h)

### 5. Transformación / migración
- **QG2:** Definir la estrategia de línea base y **capturar el baseline del sistema actual mientras el legado es representativo** · Arquitectura destino y estrategia de migración
- **QG4:** Comparación contra baseline (*parallel run* / golden master) · Baseline de rendimiento · No funcionales: rendimiento, seguridad, fiabilidad/DR
- **QG5:** UAT formal
- **QG6:** Migración/reconciliación de datos · Reconciliación final y validación de rendimiento vs baseline **antes del cutover** · Rollback probado (obligatorio)

### 6. Integraciones / APIs / datos
- **QG3:** Contract testing en CI
- **QG4:** Pruebas de integración · Pruebas negativas · Validación de datos · Resiliencia · Rendimiento/carga · Seguridad · Observabilidad

### 7. Producto digital / canal usuario
- **QG4:** E2E · Usabilidad · Accesibilidad (WCAG / EN 301 549) · Compatibilidad · Rendimiento · Seguridad · Analítica

### 8. Paquetizado (SAP/Salesforce/…)
- **QG3:** Análisis estático de plataforma (SAP ATC · Salesforce Code Analyzer / PMD Apex)
- **QG4:** Pruebas funcionales de configuración · Regresión de proceso end-to-end · Seguridad de roles/perfiles · Rendimiento de procesos críticos/batch según NAQ

### 9. Producto de mercado
- **QG1:** Especificación de requisitos frente al estándar del producto (**fit-gap**)
- **QG2:** Revisión de la configuración
- **QG4:** Integración con otros sistemas · Cualificación funcional con datos · Seguridad y no funcionales según NAQ
- **QG5:** UAT

### 10. IA / ML / GenAI
- **QG0:** Clasificación EU AI Act (§11.2) registrada en la ficha NAQ
- **QG2:** Calidad de datos del dataset/pipeline: data quality gate >=98% en dimensiones críticas + control de fuga train/test
- **QG3:** Versionado de modelo/prompt/dataset · Evaluación offline superada sobre golden set (DoD)
- **QG4:** Groundedness/faithfulness (RAG) · Tasa de alucinación · Precisión de recuperación (precision@k / recall) · Fairness/sesgo en decisiones sobre personas · Responsible AI: toxicidad y privacidad · Latencia p95 · Explicabilidad y métricas de modelo
- **QG5:** Red-teaming (prompt injection + jailbreak) · Task completion (agentes/GenAI) · Evaluación humana muestral
- **QG6:** Coste por interacción / token budget
- **QG7:** Monitorización de drift (data/model) en producción/AMS

> Controles gate-ables y criterios de aceptación por NAQ en `sdet-sqem-ia` (Anexo IA §16.1).

### 11. Data & Analytics / BI
- **QG4:** Calidad de datos (completitud, exactitud, unicidad, linaje) · **Data quality gate: score >=98% en dimensiones críticas** · Pruebas de reconciliación (conteos e integridad origen↔destino) · Validación de reglas de negocio · Regresión de informes/KPIs · Rendimiento de cargas

### 12. Infraestructura / DevOps / Cloud
- **QG3:** Validación de IaC (linting / policy-as-code)
- **QG4:** Pruebas de despliegue e idempotencia · Hardening y cumplimiento (CIS/benchmark) · Resiliencia/DR · Observabilidad
- **QG6:** Pruebas de rollback

### 13. RPA / Automatización
- **QG4:** Proceso end-to-end · Manejo de excepciones y reintentos · Robustez ante cambios de UI/entorno · Datos de prueba representativos · Regresión del proceso
- **QG6:** Monitorización de ejecución

### 14. Ciberseguridad
- **QG2:** Modelado de amenazas
- **QG3:** SAST / SCA / gestión de secretos
- **QG4:** DAST · Pentest y análisis de vulnerabilidades · Verificación de controles y hardening · Evidencias de cumplimiento (ENS / PCI / ISO 27001)

### 15. Consultoría
- **QG1:** Control de calidad documental (completitud, coherencia, trazabilidad de recomendaciones)
- **QG2:** Revisión por pares
- **QG5:** Validación con cliente

> Los gates de construcción y producción **no aplican (N/A justificado)**.

---

## Tipología de pruebas de referencia (§6.6)

**Funcionales** (qué hace el sistema, caja negra) frente a **no funcionales** (rendimiento, seguridad, usabilidad, accesibilidad, compatibilidad). Ambos grupos se cruzan con las categorías transversales **Smoke / Regresión / UAT / Automatizadas**.

| Nivel / tipo | Objetivo | Referencia técnica |
|--------------|----------|--------------------|
| **Unitarias** | Lógica aislada | Principio FIRST, patrón AAA, base de la pirámide |
| **Componentes** | Componente en pequeño (CTIS) o en grande (CTIL) | — |
| **Integración** | Interacción entre componentes/sistemas | Big-bang, top-down, bottom-up, sandwich, incremental |
| **Contract testing** | Contrato consumidor↔proveedor de API/eventos | Microservicios, integraciones |
| **Sistema / E2E** | Proceso de negocio completo | BDD/Gherkin, user journey |
| **Regresión** | El cambio no rompe lo existente | Selección de casos + automatización |
| **Smoke** | Verificación mínima pre/post despliegue | Núcleo común |
| **UAT / Aceptación** | Aceptación de negocio/usuario | Modelo INVEST, caja negra |
| **Mutation testing** | Calidad real de la batería de pruebas | Recomendado en NAQ Alto sobre áreas críticas |
| **Rendimiento** | Tiempos, carga, estrés, soak, escalabilidad | JMeter / BlazeMeter / k6 |
| **Seguridad** | Vulnerabilidades, control de acceso, exposición | SAST / DAST / pentest / secrets |
| **Usabilidad** | Facilidad de uso | 10 heurísticas de Nielsen |
| **Accesibilidad** | Inclusión en canales digitales | WCAG 2.x nivel AA / EN 301 549 |
| **Compatibilidad** | Navegadores/dispositivos/SO/versiones | Matriz de soporte |
| **Migración / reconciliación** | Integridad, conteos, reglas, consistencia | Transformaciones y datos |
| **Línea base / comparación** | Capturar el comportamiento y rendimiento actuales como referencia y verificar que la nueva versión los reproduce o mejora | Golden master / characterization, *parallel run*, baseline de rendimiento |
| **Disaster Recovery / resiliencia** | Recuperabilidad ante fallo mayor | Ensayo de recuperación; NAQ Alto |

---

## Intensidad de pruebas por NAQ (§6.6)

Recordatorio de intención: **Bajo → velocidad** · **Medio → equilibrio** · **Alto → minimizar riesgo de negocio**.

| Práctica | NAQ Bajo | NAQ Medio | NAQ Alto |
|----------|----------|-----------|----------|
| **Supervisión de calidad** | Opcional/ligera | Por hitos | Continua por QA Lead/CoE; **QA independiente del desarrollo**; grupo QA separado en misión crítica |
| **Estrategia de pruebas** | Análisis mínimo | Riesgos principales documentados | Análisis de riesgos formal y exhaustivo + plan formal |
| **Trazabilidad requisito-prueba** | >=80% de los críticos o checklist | >=95% de los principales | 100% de requisitos relevantes, auditable |
| **Guiones de prueba** | No siempre | Sí, en flujos clave | Sí, detallados |
| **Regresión** | Smoke mínimo obligatorio; una vez antes de PRE | Versiones mayores y evolutivos | Cada versión y cada sprint; automatizada en áreas críticas |
| **Pruebas de confirmación (re-test)** | Revisión manual de la corrección | Registro recomendable en herramienta | Registro obligatorio en herramienta |
| **Automatización** | Solo si el ROI es claro | Selectiva sobre lo repetitivo y estable | Prioritaria, alta cobertura con análisis coste/beneficio |
| **Soporte a UAT** | No, salvo petición | Opcional | Recomendado/activo; obligatorio en misión crítica |
| **Análisis / revisión de código** | Recomendada (1 revisor, opcional) | En nuevas apps y evolutivos | Continuas: al 20% de construcción y antes de la 1.ª PRE; auditoría externa en misión crítica |
| **Mutation testing** | No | Opcional | Recomendado (obligatorio en áreas críticas de misión crítica) |

**Estrategia de automatización y ROI (§10.4):** automatizar donde hay repetición, estabilidad y criticidad. Prioridad: **smoke → regresión crítica → APIs/contract → E2E de flujos clave**. **No automatizar** lo inestable, lo de un solo uso, o lo de coste de mantenimiento superior al beneficio.
