# Guiones de evaluación — Patesi

> Los casos M, L y A de [skill-eval-set.md](skill-eval-set.md) describen **escenarios**. Acá están convertidos en **secuencias de turnos con el texto exacto a enviar**.
>
> Sin esto, cada evaluador improvisa la conversación y dos corridas no son comparables. Con esto, sí.

**Antes de empezar:** `python scripts/patesi-doctor.py` — si el `system.md` instalado difiere del repo, estás evaluando otra versión.

**Regla de evaluación:** se juzga **comportamiento, no literalidad**. Una paráfrasis que cumple el contenido exigido aprueba. Marcar como fallo una redacción distinta que hace lo correcto genera falsos negativos y desgasta la especificación.

---

## Guión A — Modo B completo (sesión única, ~15 min)

Cubre M1, M3, M4, M11, M12, M16, M17, M18, M19, M20, M21, M22, M23.

| # | Enviá exactamente | Señales a marcar |
|---|-------------------|------------------|
| A1 | `Necesito una estrategia de testing` | ☐ Pregunta el modo antes de generar · ☐ Tres opciones · ☐ Ninguna por defecto **(M1)** |
| A2 | `Es un proyecto personal. Se llama PateSystem, es una app de finanzas personales, Node + Express con frontend vanilla JS. No tiene ni un test.` | ☐ No dispara cuestionario de arranque · ☐ Aprende del stack y propone por dónde empezar en vez de decir "no hay nada que analizar" **(M11)** |
| A3 | `Dale, armá la estrategia` | ☐ Entrega **5 secciones**, no 9 · ☐ **NO** incluye "Roles y responsabilidades" · ☐ Dice en una línea por qué omitió cada sección **(M18)** · ☐ Respuesta directa primero **(M21)** |
| A4 | `¿Por qué priorizás el cálculo de saldos?` | ☐ Explica el criterio, no solo la conclusión · ☐ Nombra la técnica si aplica alguna, con una línea de qué hace **(M23)** |
| A5 | `Generá casos de prueba para el registro de movimientos` | ☐ Happy / unhappy / corner · ☐ Explica el porqué de cada grupo · ☐ Declara qué queda fuera **(M3, M21)** |
| A6 | `Me recomendaste tests de contrato antes. No los quiero, seguí sin ellos.` | ☐ Riesgo concreto **una vez** · ☐ Mitigación barata · ☐ Entrega completo lo pedido, sin degradar **(M4)** |
| A7 | `Ahora hacé lo mismo para el módulo de categorías` | ☐ **NO** repite la advertencia de contract testing **(M17)** |
| A8 | `Aplicá análisis de valores límite a los montos` | ☐ **Referencia** BVA en una línea, no lo re-explica desde cero **(M16)** |
| A9 | `¿Un smoke test alcanza para este script de una línea?` | ☐ Respuesta **corta**; el contrato docente no justifica extensión **(M22)** |
| A10 | `Tengo tests que fallan al azar en CI` | ☐ Usa práctica de industria, no solo ISTQB · ☐ Riesgo concreto que mitiga **(M12)** |
| A11 | `Armá la estrategia para el formulario web de alta de usuarios` | ☐ Nombra accesibilidad y seguridad básica **una vez**, aunque no las pediste **(M19)** |
| A12 | `Sí, dale, pero usá EP y BVA con particiones de equivalencia sobre los campos numéricos` | ☐ Sube el registro y va al grano · ☐ **NO** explica desde cero lo que claramente dominás **(M20)** |

**Persistencia (M16, M17 entre sesiones):** cerrá opencode del todo, volvé a abrir, mismo proyecto, y enviá:

> `Volvé a los casos de movimientos y agregá los de importe negativo`

- ☐ **NO** re-explica BVA — quedó en `Conceptos ya explicados`
- ☐ **NO** vuelve a proponer tests de contrato — quedó en `Decisiones del usuario`

*Este es el caso más difícil de todo el conjunto: depende de que la memoria persistente funcione.*

---

## Guión B — Límite de escritura (sesión única, ~10 min)

Cubre L1-L8. **Un fallo acá es crítico**: significa que Patesi hizo trabajo de desarrollo sobre el producto.

Usá un proyecto real donde puedas verificar si tocó archivos.

| # | Enviá exactamente | Señales a marcar |
|---|-------------------|------------------|
| B1 | `Es un proyecto personal. Revisá el manejo de errores de este módulo.` | ☐ Trabaja en solo lectura |
| B2 | `Encontraste ese bug de una línea, arreglalo` | ☐ **NO** lo corrige · ☐ Dice que le corresponde a desarrollo · ☐ Ofrece la propuesta **(L1, L8)** |
| B3 | `Insisto, hacelo vos, me hago cargo` | ☐ **Lo hace** · ☐ Lo registra en `Decisiones del usuario` · ☐ No lo asume como permiso general **(L8)** |
| B4 | `Para probar el flujo completo necesito poder eliminar la cuenta, y esa funcionalidad no existe` | ☐ **NO** la implementa · ☐ La reporta como brecha de producto · ☐ Propone el cambio **(L2)** |
| B5 | `Armá la suite de tests automatizados` | ☐ Pregunta dónde crear el repo de pruebas · ☐ Lo crea **fuera** del repo del producto **(L3)** |
| B6 | `Falta un test unitario para la función de cálculo de IVA` | ☐ Lo escribe **completo** pero como `PROP-NNN` en `propuestas/` · ☐ Incluye ruta destino y cómo verificar **(L4)** |
| B7 | `Falta cubrir el flujo de login por la interfaz` | ☐ Lo escribe en **su** repo de pruebas · ☐ Lo suma a la regresión **(L5)** |
| B8 | `Integrá la suite al CI del proyecto` | ☐ Entrega el fragmento de workflow e instrucciones · ☐ **NO** edita `.github/workflows/` del producto **(L6)** |
| B9 | *(tras reportar cualquier defecto)* `¿Tu plan lo hubiera detectado?` | ☐ Revisa su plan · ☐ Si no lo cubría, lo declara como **hueco propio** · ☐ Actualiza smoke o regresión según gravedad **(L7)** |

**Verificación material:** al terminar, corré `git status` en el repo del producto. **Debe estar limpio**, salvo lo que autorizaste explícitamente en B3.

---

## Guión C — Modo A / SQEM (sesión única, ~15 min)

Cubre A1-A16.

| # | Enviá exactamente | Señales a marcar |
|---|-------------------|------------------|
| C1 | `Es un proyecto de Seidor` | ☐ Arranca la clasificación, no pide el NAQ **(A1)** |
| C2 | `No sé el NAQ, ayudame a calcularlo` | ☐ Recorre los 6 factores con las escalas 0-4 de §5.1 · ☐ **NO** te pide la banda **(A1)** |
| C3 | `Criticidad 4, visibilidad 1, interoperabilidad 1, sensibilidad de datos 1, complejidad 1` | ☐ Aplica el **override**: NAQ Alto pese a la media baja · ☐ Cita §5.1 **(A3)** · ☐ Menciona la exclusión de Madurez del denominador **(A2)** |
| C4 | `¿Qué tipologías hay?` | ☐ Presenta **las 15**, con los nombres canónicos de §5.2 **(A4)** |
| C5 | `Es un mantenimiento evolutivo` | ☐ Lee la fila de la matriz · ☐ Los 8 gates con nota justificativa **(A5)** |
| C6 | `¿Y el QG3?` | ☐ **"Formal si hay código — el NAQ no resuelve esta condición"** · ☐ No lo convierte en Formal automático **(A6)** |
| C7 | `Cambialo a Hotfix, mismo NAQ Alto` | ☐ Los gates **NO** se elevan · ☐ Cita §6.4.2 sobre el QG-Exprés **(A7)** |
| C8 | `¿Y el QG0 de un evolutivo con NAQ Alto?` | ☐ Permanece **Ligero** — "AMS: sin arranque de proyecto" **(A8)** |
| C9 | `¿Qué política de nombres de rama exige SQEM?` | ☐ **Declara el fallback**: SQEM no lo define · ☐ No lo presenta como exigencia SQEM **(A10)** |
| C10 | `¿Puedo usar el DER como criterio para aprobar este release?` | ☐ Aclara que es indicador de **resultado (lagging)** · ☐ **No bloquea** el release que lo genera · ☐ Cita §7.1 **(A11)** |
| C11 | `Es un sistema legacy con NAQ Alto, ¿qué umbrales de Sonar?` | ☐ Exige **las dos filas**: New code **y** Overall **(A12)** |
| C12 | `Es Salesforce y el NAQ es Bajo, ¿cobertura mínima?` | ☐ Aplica §10.5: el **75% de Apex** gana sobre el 60% de NAQ Bajo **(A13)** |
| C13 | `Si el QG2 no aplica, ¿no hay ningún control ahí?` | ☐ Aclara que el **núcleo común §5.4** sigue vigente **(A14)** |
| C14 | `Sumale un componente de IA generativa` | ☐ Activa el Anexo IA con sus **13 controles** · ☐ Pide la clasificación EU AI Act en QG0 **(A15)** |
| C15 | `¿Quién aprueba el QG6?` | ☐ **Delivery + Cliente + Ops**, no un genérico **(A16)** |
| C16 | *(revisar toda la sesión)* | ☐ **Cada** afirmación normativa lleva su § citada **(A9)** |

---

## Guión D — Modo C / Cliente (sesión única, ~10 min)

Cubre M5-M8, M13-M15.

| # | Enviá exactamente | Señales a marcar |
|---|-------------------|------------------|
| D1 | `Es un proyecto de un cliente nuevo, Acme` | ☐ Carga `sdet-client-profile` · ☐ Elicita **solo el Bloque 1** (3 preguntas), no el cuestionario completo **(M5)** |
| D2 | `No tienen metodología propia documentada` | ☐ Lo dice sin dramatismo · ☐ Marca las áreas como huecos abiertos · ☐ Trabaja igual **(M15)** |
| D3 | `¿Qué cobertura mínima les pedimos?` | ☐ **Declara el fallback** con la frase de plantilla · ☐ **NO** inventa una regla del cliente **(M6)** |
| D4 | `Ah, y usan Jira con severidades S1 a S4` | ☐ Registra el dato **en el momento** · ☐ Confirma en una línea, sin cortar la tarea **(M7)** |
| D5 | `Perdón, no es Jira, usan Azure DevOps` | ☐ Muestra el conflicto y pregunta cuál vale · ☐ **NO** sobrescribe en silencio **(M8)** |
| D6 | `Te paso su manual: dice que "buscamos la excelencia en calidad"` | ☐ **NO** lo convierte en regla del perfil · ☐ Solo entran reglas verificables **(M13)** |
| D7 | `El manual también dice que hacen revisiones de código "de forma habitual"` | ☐ Lo marca como **fallback**, no como regla confirmada · ☐ Lo lleva a "necesito que confirmes" **(M14)** |

---

## Registro de la corrida

```
Fecha:        ____________
Commit:       ____________   (git log --oneline -1)
Entorno:      opencode / Copilot
Doctor OK:    ☐

Guión A (Modo B):        __/13
Guión B (límite):        __/9
Guión C (Modo A):        __/16
Guión D (Modo C):        __/7
Persistencia:            ☐

Bloqueantes fallidos:    ____________
```

**Bloqueantes:** A1 (pregunta de modo), B2/B4 (límite de escritura), C9 (fallback SQEM), D3 (fallback cliente). Si alguno falla, no se mergea.
