---
name: sdet-sqem-classification
description: >
  Clasificación de proyectos SQEM: cálculo del NAQ con escalas por factor, las 15 tipologías canónicas, derivación del delivery target, núcleo común no negociable y reevaluación del NAQ.
  Trigger: clasificación de proyecto Seidor, cálculo NAQ, tipología, delivery target, ficha NAQ
license: Apache-2.0
metadata:
  author: patesi
  version: "2.0"
  category: sqem
---

# SQEM — Clasificación de proyectos

Punto de entrada de todo trabajo de calidad Seidor. Fuente: SQEM v1.2 §5.

**Regla de fidelidad:** este skill es una derivación literal de la normativa. Nada de lo que contiene es interpretación propia. Si la norma no define algo, se declara como hueco y se resuelve por fallback declarado, nunca inventando la regla.

---

## Los dos ejes de decisión (§5)

```
Eje 1: NAQ (§5.1)         → Bajo / Medio / Alto
Eje 2: Tipología (§5.2)   → 15 tipos, componibles
              ↓  el modelo deriva automáticamente
SALIDA: Delivery target (§5.3.4) → Básico / Integrado / Continuo
```

La madurez de entrega **no es un eje de entrada**: es una recomendación derivada.

---

## Eje 1 — NAQ (§5.1)

### Fórmula

`Valor NAQ = Σ (Valor_asignado_i × Peso_i) / Σ Pesos_activos` → resultado normalizado entre 0 y 4.

| Factor | Peso | Qué mide |
|--------|------|----------|
| **Criticidad de negocio** | 8 | Impacto si falla: desde misión crítica a soporte menor |
| **Visibilidad / uso** | 4 | Nº de usuarios y frecuencia de uso; exposición pública |
| **Interoperabilidad** | 4 | Grado de acoplamiento/reutilización con otras soluciones |
| **Sensibilidad de los datos** | 4 | Desde datos públicos a datos críticos/regulados (GDPR, PCI, salud) |
| **Madurez tecnológica** | 2 | Tecnología estándar y soportada frente a obsoleta/incipiente |
| **Complejidad** | 2 | Volumen y complejidad funcional/técnica |

> **Factor Madurez tecnológica — deprecado (§5.1).** Mientras no disponga de dato fiable y esté fijada a un valor neutro, **se excluye del denominador**: `Σ Pesos_activos` no la incluye, para no distorsionar el resultado. Se reincorporará cuando el factor se alimente con datos reales. Con la exclusión, el denominador es **22**.

### Escalas de referencia por factor (§5.1)

Recorré estos valores con el usuario, uno por uno. **No le pidas que estime el NAQ: pedile los factores y calculá vos.**

| Factor | 0 | 1 | 2 | 3 | 4 |
|--------|---|---|---|---|---|
| **Criticidad de negocio** | Investigación / PoC | Soporte menor | Core con alternativa | Esencial sin alternativa temporal | Misión crítica / impacto mediático |
| **Visibilidad / uso** | <10 usuarios internos, uso esporádico | — | — | — | >100 usuarios diarios o público general |
| **Interoperabilidad** | Aislada | — | — | — | Transversal / producto comercializado / >8 integraciones |
| **Sensibilidad de datos** | Público | — | — | — | Crítico / regulado (financiero, salud, legal) |
| **Complejidad** | Muy baja: pocos objetos/flujos; <4 KLOC en desarrollo a medida | — | — | — | Muy alta: gran nº de objetos/flujos/RICEFW/pipelines o >120 KLOC |

**Complejidad — proxy agnóstico al stack:** en entornos config-heavy o no-code se cuenta **objetos, flujos o integraciones**, no KLOC.

Los valores intermedios se interpolan sobre estas anclas. Las escalas completas por factor viven en el anexo de la ficha de aplicación; si necesitás un grado de detalle que la norma no publica, declaralo como hueco.

### Bandas de NAQ (§5.1)

| Valor | Nivel | Interpretación |
|-------|-------|----------------|
| `>=0 y <1,5` | **Bajo** | Impacto reducido, datos no sensibles, uso limitado |
| `>=1,5 y <3` | **Medio** | Impacto relevante con alternativas, uso significativo |
| `>=3` | **Alto** | Crítico para el negocio/cliente, datos sensibles, alta exposición o baja tolerancia a fallo |

### Reglas de override (§5.1) — prevalecen sobre la media ponderada

- Criticidad de negocio = 4 **O** Sensibilidad de datos = 4 → **NAQ Alto**, con independencia de la media. Evita infravalorar sistemas de alto impacto pero baja exposición.
- Criticidad de negocio >= 3 **Y** Sensibilidad de datos >= 3 → el NAQ **no baja de Medio**.
- Impacto en **seguridad de personas, cumplimiento legal grave o continuidad operativa crítica** → **NAQ Alto**.
- Sistema de IA clasificado como **alto riesgo según el EU AI Act** (§11.2) → **NAQ Alto** + activación del Anexo IA (§16).

### Objetivo y esfuerzo por banda (§5.1.1)

| NAQ | Objetivo dominante | Esfuerzo de QA |
|-----|--------------------|----------------|
| **Bajo** | Velocidad — no frenar la entrega | Bajo |
| **Medio** | Equilibrio — coste/riesgo balanceados | Medio |
| **Alto** | Minimizar el riesgo de negocio; en misión crítica, tolerancia mínima al fallo | Alto (muy alto en misión crítica) |

**El salto entre Medio y Alto no es lineal**: dentro de Alto conviven proyectos core de negocio y proyectos de misión crítica.

### Sub-banda de misión crítica (§5.1.1)

Se activa cuando se dispara alguna regla de override. Los criterios se aplican en su **lectura más estricta**:

| Control | Alto ordinario | Alto — misión crítica |
|---------|----------------|-----------------------|
| Cobertura de código (§10.3) | New >=80% / Overall >=70% | **New >=90% / Overall >=80%** |
| Code review | >=1 revisor senior | **>=2 revisores senior**, uno independiente del equipo |
| Mutation / pruebas de robustez | Recomendado | **Obligatorio** (mutation testing y pruebas negativas/límite) |
| Seguridad | SAST/DAST/SCA en gate | + **pentest formal** y 0 hallazgos Críticos/Altos abiertos |
| Fiabilidad operativa (§11.4) | SLO definidos | + **DR/rollback validado** y MTTR objetivo verificado en simulacro |
| Entregables (§9) | Mínimos de NAQ Alto | + **informe de riesgos formal y acta Go/No-Go con Dirección** |

### NAQ vivo — reevaluación obligatoria (§5.1)

Se reevalúa el NAQ cuando concurra cualquiera de estos disparadores, además de por cambios de criticidad, tecnología o uso:

- **>=3 incidencias Sev1/Sev2 en producción en 3 meses** sobre la misma aplicación, **o**
- **Defect Escape Rate por encima del umbral de su banda durante 2 releases consecutivas**, **o**
- Cambio material de alcance, integración o marco de cumplimiento aplicable.

**La reevaluación la dispara el QA Lead y la ratifica el QA Manager** (RACI §3.3).

> Los umbrales por factor y de corte de NAQ son **valores por defecto provisionales (v0)**, pendientes de re-baseline en pilotaje (§14).

---

## Eje 2 — Tipologías (§5.2)

15 tipos. **Los nombres son los canónicos de §5.2**; usalos literalmente al comunicar y al leer la matriz de gates.

| # | Tipología | Rasgos |
|---|-----------|--------|
| 1 | **Nuevo desarrollo** | Construcción desde cero |
| 2 | **Mantenimiento evolutivo (AMS)** | Nuevas funcionalidades sobre sistema en producción |
| 3 | **Mantenimiento correctivo (AMS)** | Corrección de defectos sin construcción ni diseño nuevos |
| 4 | **Hotfix / Emergencia** | Corrección urgente con ventana mínima; sigue el QG-Exprés (§6.4.2) |
| 5 | **Transformación / migración** | Cambio de plataforma, cloud o datos |
| 6 | **Integraciones / APIs / datos** | Sistemas distribuidos, contratos |
| 7 | **Producto digital / canal usuario** | Portales, apps, front intensivo |
| 8 | **Paquetizado (SAP/Salesforce/…)** | Parametrización + desarrollo (RICEFW/Apex/config) |
| 9 | **Producto de mercado** | Implantación de COTS/SaaS existente, sin desarrollo custom: configuración estándar, fit-gap e integración |
| 10 | **IA / ML / GenAI** | Modelos de aprendizaje automático o IA generativa; comportamiento probabilístico |
| 11 | **Data & Analytics / BI** | Pipelines, ETL/ELT, modelos analíticos, cuadros de mando |
| 12 | **Infraestructura / DevOps / Cloud** | Aprovisionamiento, IaC, plataformas, CI/CD, landing zones |
| 13 | **RPA / Automatización** | Bots que operan sobre aplicaciones existentes |
| 14 | **Ciberseguridad** | Bastionado, SOC, IAM, cumplimiento |
| 15 | **Consultoría** | Entregables documentales/analíticos sin construcción de software |

**Las pruebas que "tienen sentido" en cada tipología, gate por gate, están en `sdet-sqem-typology-tests`.**

### Tipologías componibles (§5.2)

Las tipologías **no son excluyentes**. Un proyecto declara una **tipología primaria** y los **componentes secundarios** que apliquen; su conjunto de pruebas y controles es la **unión de todos ellos**, modulada por un mismo NAQ.

Caso típico: un proyecto **IA/ML/GenAI** casi siempre combina IA (Anexo IA §16) con **Data & Analytics** (calidad de datos del dataset/pipeline) y, con frecuencia, Integraciones/APIs y Producto digital.

La ficha de proyecto registra la tipología primaria y los componentes activados.

> **Agile no es una tipología**, sino un modo de entrega aplicable a cualquiera de las anteriores. Su efecto sobre los gates se trata en la variante gate-as-code (§6.5.1).

---

## Salida — Delivery target (§5.3.4)

| Delivery target | Objetivo | Capacidades mínimas |
|-----------------|----------|---------------------|
| **Básico** | Control básico común (mínimo corporativo) | Checklist de calidad, pruebas mayoritariamente manuales documentadas, smoke, defectos registrados, gates y evidencias manuales |
| **Integrado** | Calidad gestionada y repetible (estándar objetivo) | CI, análisis estático en pipeline, regresión crítica automatizada, trazabilidad requisito-prueba, gates parcialmente automáticos, dashboard y KPIs por release |
| **Continuo** | Calidad continua | Quality gates automáticos en CI/CD, alta automatización incluido E2E, no funcionales recurrentes, dashboards ejecutivos, despliegues controlados con rollback ensayado |

**Regla de recomendación:** Básico es el **mínimo exigible** a todo proyecto. Integrado es el **estándar objetivo** del portfolio. Continuo se **recomienda** cuando concurra alta frecuencia de despliegue **O** NAQ Alto.

Al ser una recomendación derivada y no una imposición mecánica: un sistema NAQ Alto de baja frecuencia puede operar en Integrado con gates formales, y un producto NAQ Medio de despliegue continuo puede beneficiarse de Continuo.

---

## Núcleo común NO NEGOCIABLE (§5.4)

Aplica a **todo proyecto con entrega a producción**, con independencia del NAQ, de la tipología, del delivery target y de los gates que la matriz marque como ligeros o no aplicables.

1. **NAQ asignado** y ficha de proyecto/aplicación cumplimentada
2. **Criterios de aceptación** definidos para el alcance entregable
3. **Gestión de defectos** con severidad estándar en herramienta ALM
4. **Smoke test** pre y post-despliegue
5. **Cero defectos bloqueantes/críticos** abiertos para pasar a producción
6. **Decisión Go/No-Go** registrada, aunque sea ligera, antes de producción
7. **Plan de despliegue y de rollback** proporcional al riesgo
8. **Nomenclatura y trazabilidad** estándar (proyecto, repos, casos de prueba)
9. **Cumplimiento GDPR** en datos de prueba: nunca datos reales sin anonimizar

**Ninguna combinación de NAQ y tipología puede dejar el proyecto por debajo de este suelo.**

---

## Ficha de clasificación — qué registrar

Al terminar la clasificación, dejá registrado:

- Valor asignado a cada factor **con su justificación**
- Denominador usado y la exclusión de Madurez tecnológica
- Valor NAQ calculado y banda resultante
- Override aplicado, si lo hubo, y cuál
- Si activa la sub-banda de misión crítica
- Tipología primaria y componentes secundarios
- Delivery target recomendado
- Clasificación EU AI Act si la tipología IA está activa (§11.2)
