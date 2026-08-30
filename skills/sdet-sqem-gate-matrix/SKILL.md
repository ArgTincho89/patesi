---
name: sdet-sqem-gate-matrix
description: >
  Matriz resuelta de quality gates SQEM: las 60 combinaciones de tipología x NAQ con el estado de cada gate QG0-QG7 y su nota justificativa, más la regla de precedencia y los alias de comunicación.
  Trigger: qué gates aplican, matriz de gates, tipología por NAQ, formalidad de gates, fusionar gates, 5 puertas
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: sqem
---

# SQEM — Matriz resuelta de quality gates

Responde a la pregunta operativa del Modo A: **dado un NAQ y una tipología, ¿qué gates recorro y con qué formalidad?**

Fuente: SQEM v1.2 §6.4 (aplicación por tipología) y §6.5 (ajuste por NAQ), con las combinaciones ya resueltas según el modelo de gobernanza de quality gates de la Oficina de Calidad.

> **Verificación:** las filas base están validadas contra la tabla §6.4 del Modelo extendido —fuente distinta del configurador— y las filas con NAQ contra las reglas de §6.5. Ejecutar `python scripts/check-sqem-matrix.py` tras cualquier cambio en esta tabla o cuando Seidor publique una versión nueva de la normativa.

---

## Regla de precedencia (§6.5) — leer antes de usar la matriz

1. **La tipología (§6.4) define qué gates existen** y su intensidad base.
2. **El NAQ (§6.5) modula la formalidad** y resuelve los condicionales.
3. **En conflicto prevalece el NAQ.**
4. **Límite infranqueable: nunca por debajo del núcleo común no negociable (§5.4).** Ninguna combinación puede dejar un proyecto por debajo de ese suelo, ni siquiera las celdas marcadas como ligeras o no aplicables.

**No re-derives la matriz.** Las reglas de §6.5 tienen excepciones documentadas —los AMS conservan QG0 ligero incluso en NAQ Alto, y el Hotfix es inmune a la elevación por NAQ— y el coste de equivocarse es exigir o saltarse un control obligatorio. Leé la fila.

---

## Leyenda

| Símbolo | Significado |
|---------|-------------|
| **F** | Formal — evidencias + aprobación |
| **L** | Ligero — checklist |
| **C** | Condicional — aplica según alcance/NAQ |
| **Fc** | Formal condicional — obligatorio *si hay código/desarrollo/configuración/pipeline*. **El NAQ no resuelve esta condición** |
| **—** | No aplica |

**Notas:**

- **①** Fusionable con el gate adyacente si el alcance es pequeño (§6.5, NAQ Bajo). QG3↔QG4 y QG5↔QG6.
- **②** Puede simplificarse si la UAT es ligera (§6.5, NAQ Medio).
- **③** Condicional resuelto por el NAQ (§6.5).
- **④** Elevado por NAQ Alto (§6.5).
- **⑤** AMS sin arranque de proyecto: QG0 permanece ligero aunque el NAQ sea Medio o Alto (§6.4).
- **⑥** §6.4.2 — el NAQ modula *dentro* del QG-Exprés; no reimpone gates.
- **⑦** La validación antes de producción se mantiene siempre, aunque QG5 y QG6 se fusionen.
- **⑧** Condicional que **se formaliza si el NAQ es Alto** (§6.4). Anotación de la fila base: indica hacia dónde resuelve, no que ya esté resuelto.

---

## Matriz resuelta — tipología x NAQ

`—` en la columna NAQ significa banda todavía sin definir: la formalidad mostrada es la base de §6.4, sin resolver los condicionales.

| Tipología | NAQ | QG0 | QG1 | QG2 | QG3 | QG4 | QG5 | QG6 | QG7 |
|-----------|-----|-----|-----|-----|-----|-----|-----|-----|-----|
| Nuevo desarrollo | — | F | F | F | F | F | F | F | F |
| Nuevo desarrollo | Bajo | F | F | F | F① | F① | F① | F①⑦ | F |
| Nuevo desarrollo | Medio | F | F | F | F | F | F② | F | F |
| Nuevo desarrollo | Alto | F | F | F | F | F | F | F | F |
| Mantenimiento evolutivo | — | L | L | C | Fc | C | C | F | L |
| Mantenimiento evolutivo | Bajo | L | L | C | Fc⑤ | C① | C① | F①⑦ | L |
| Mantenimiento evolutivo | Medio | L⑤ | L | C | Fc⑤ | F③ | L③ | F | L |
| Mantenimiento evolutivo | Alto | L⑤ | F④ | F③ | Fc⑤ | F③ | F③ | F | F④ |
| Mantenimiento correctivo | — | L | L | — | Fc | C | C⑧ | F | L |
| Mantenimiento correctivo | Bajo | L | L | — | Fc⑤ | C① | C① | F①⑦ | L |
| Mantenimiento correctivo | Medio | L⑤ | L | — | Fc⑤ | F③ | L③ | F | L |
| Mantenimiento correctivo | Alto | L⑤ | F④ | — | Fc⑤ | F③ | F③ | F | F④ |
| Hotfix / Emergencia | — | — | L | — | L (par) | L (smoke) | — | F | L (ex-post) |
| Hotfix / Emergencia | Bajo | — | L | — | L① | L① | — | F①⑦ | L (ex-post) |
| Hotfix / Emergencia | Medio | — | L | — | L⑥ | L⑥ | — | F⑥ | L⑥ |
| Hotfix / Emergencia | Alto | — | L⑥ | — | L⑥ | L⑥ | — | F⑥ | L⑥ |
| Transformación / migración | — | F | F | F | F | F | F | F | F |
| Transformación / migración | Bajo | F | F | F | F① | F① | F① | F①⑦ | F |
| Transformación / migración | Medio | F | F | F | F | F | F② | F | F |
| Transformación / migración | Alto | F | F | F | F | F | F | F | F |
| Integraciones / APIs / datos | — | F | F | F | F | F | C | F | F |
| Integraciones / APIs / datos | Bajo | F | F | F | F① | F① | C① | F①⑦ | F |
| Integraciones / APIs / datos | Medio | F | F | F | F | F | L③ | F | F |
| Integraciones / APIs / datos | Alto | F | F | F | F | F | F③ | F | F |
| Producto digital / canal usuario | — | F | F | F | F | F | F | F | F |
| Producto digital / canal usuario | Bajo | F | F | F | F① | F① | F① | F①⑦ | F |
| Producto digital / canal usuario | Medio | F | F | F | F | F | F② | F | F |
| Producto digital / canal usuario | Alto | F | F | F | F | F | F | F | F |
| Paquetizado (SAP/Salesforce) | — | F | F | C | Fc | F | F | F | F |
| Paquetizado (SAP/Salesforce) | Bajo | F | F | C | Fc⑤ | F① | F① | F①⑦ | F |
| Paquetizado (SAP/Salesforce) | Medio | F | F | C | Fc⑤ | F | F② | F | F |
| Paquetizado (SAP/Salesforce) | Alto | F | F | F③ | Fc⑤ | F | F | F | F |
| Producto de mercado | — | F | F | F | F | F | F | F | F |
| Producto de mercado | Bajo | F | F | F | F① | F① | F① | F①⑦ | F |
| Producto de mercado | Medio | F | F | F | F | F | F② | F | F |
| Producto de mercado | Alto | F | F | F | F | F | F | F | F |
| IA / ML / GenAI | — | F | F | F | Fc | F | F | F | F |
| IA / ML / GenAI | Bajo | F | F | F | Fc⑤ | F① | F① | F①⑦ | F |
| IA / ML / GenAI | Medio | F | F | F | Fc⑤ | F | F② | F | F |
| IA / ML / GenAI | Alto | F | F | F | Fc⑤ | F | F | F | F |
| Data & Analytics / BI | — | F | F | F | F | F | F | F | F |
| Data & Analytics / BI | Bajo | F | F | F | F① | F① | F① | F①⑦ | F |
| Data & Analytics / BI | Medio | F | F | F | F | F | F② | F | F |
| Data & Analytics / BI | Alto | F | F | F | F | F | F | F | F |
| Infraestructura / DevOps / Cloud | — | F | F | F | F | F | C | F | F |
| Infraestructura / DevOps / Cloud | Bajo | F | F | F | F① | F① | C① | F①⑦ | F |
| Infraestructura / DevOps / Cloud | Medio | F | F | F | F | F | L③ | F | F |
| Infraestructura / DevOps / Cloud | Alto | F | F | F | F | F | F③ | F | F |
| RPA / Automatización | — | F | F | C | F | F | F | F | F |
| RPA / Automatización | Bajo | F | F | C | F① | F① | F① | F①⑦ | F |
| RPA / Automatización | Medio | F | F | C | F | F | F② | F | F |
| RPA / Automatización | Alto | F | F | F③ | F | F | F | F | F |
| Ciberseguridad | — | F | F | F | Fc | F | C | F | F |
| Ciberseguridad | Bajo | F | F | F | Fc⑤ | F① | C① | F①⑦ | F |
| Ciberseguridad | Medio | F | F | F | Fc⑤ | F | L③ | F | F |
| Ciberseguridad | Alto | F | F | F | Fc⑤ | F | F③ | F | F |
| Consultoría | — | F | F | L | — | — | F | — | L |
| Consultoría | Bajo | F | F | L | — | — | F① | — | L |
| Consultoría | Medio | F | F | L | — | — | F② | — | L |
| Consultoría | Alto | F | F | F④ | — | — | F | — | F④ |

---

## Cómo comunicar el resultado

Al presentar los gates de un proyecto, indicá siempre **la fila aplicada y la justificación de las celdas que no son formales**. Ejemplo:

> Proyecto de **Mantenimiento evolutivo**, **NAQ Medio**. Los gates quedan así:
> QG0 Ligero (§6.4 — AMS, sin arranque de proyecto) · QG1 Ligero · QG2 Condicional · QG3 Formal si hay código (el NAQ no resuelve esta condición) · QG4 Formal (condicional resuelto por NAQ Medio, §6.5) · QG5 Ligero (condicional resuelto por NAQ Medio) · QG6 Formal · QG7 Ligero.
> Por encima de todo esto aplica el núcleo común de §5.4, que ningún gate ligero puede rebajar.

Una celda ligera o no aplicable **nunca** significa "no hay control": significa que la formalidad exigida es menor. El núcleo común sigue vigente.

---

## Alias de comunicación — vista de 5 puertas (§6.3)

Para diálogo con negocio. La vista de 8 gates es la que gobierna; esta es solo un alias, y **no debe intercambiarse su numeración**.

| Puerta (momento de despliegue) | Equivale a | Pregunta que responde |
|---|---|---|
| **1 · Construcción** | QG0 + QG1 + QG2 | ¿Sabemos qué construir, con qué riesgo y cómo probarlo? |
| **2 · Integración** | QG3 (DoD) | ¿El código está limpio, revisado y con estático/cobertura en verde? |
| **3 · Preproducción** | QG4 | ¿El sistema integrado pasa integración y regresión sin críticos? |
| **4 · UAT** | QG5 | ¿Negocio puede aceptarlo? |
| **5 · Producción** | QG6 | ¿Sign-off, no funcionales, rollback y observabilidad listos? |

**QG7 (cierre/garantía) no tiene puerta equivalente** en la vista simplificada: se conserva siempre desde la vista operativa.

### Alias de proyectos de transformación (§6.3)

Algunas migraciones usan numeración propia: **0T** (arranque; equivale a QG0+QG2) · **1** (QG3) · **2** (QG4) · **3** (QG5) · **4T** (QG6, con rollback y reconciliación). La equivalencia con QG0-QG7 es la que gobierna.

**Si no existe entorno de integración independiente**, los criterios del gate de integración se validan obligatoriamente en el de preproducción.

---

## Variante gate-as-code (§6.5.1)

En equipos con delivery target **Integrado/Continuo** y alta frecuencia de despliegue, los gates se ejecutan **como código** en el pipeline:

- **QG3 y QG4** se embeben en cada merge: estático + Quality Gate, unitarias, integración/E2E y regresión crítica automatizadas. El pipeline aprueba o bloquea.
- **QG5** pasa a aceptación continua: validación del Product Owner en la Sprint Review + verificación en producción controlada (feature flags, canary, despliegue progresivo).
- **QG6** se convierte en release gate ligero y automatizado: promociona por defecto si se cumplen las condiciones codificadas; la intervención humana ocurre **solo por excepción**.
- **NAQ Alto sigue siendo compatible**: un cambio de alto riesgo puede exigir aprobación humana explícita, como excepción codificada y no como norma.

**KPIs propios de la variante (DORA):** Change Failure Rate <15%, lead time de despliegue, frecuencia de despliegue, MTTR; historias que cumplen DoD = 100%.

> La variante **no elimina** los criterios de cada gate: los **automatiza**. El núcleo común (§5.4) sigue siendo infranqueable.
