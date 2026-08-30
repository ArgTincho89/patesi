---
name: sdet-client-onboarding
description: >
  Arranque con un cliente nuevo en Modo C: qué documentación pedir, cómo extraer sus reglas de calidad y cómo poblar el perfil sin convertir interpretaciones en normas del cliente.
  Trigger: onboarding de cliente, cliente nuevo, documentación de calidad del cliente, poblar perfil de cliente
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-core
---

# Onboarding de cliente (Modo C)

Convierte la documentación que entrega un cliente en un perfil inicial poblado, en vez de construirlo solo por conversación.

Usalo **una sola vez por cliente**, al arranque. El mantenimiento posterior lo lleva `sdet-client-profile`, que es la fuente de verdad del formato y de las reglas de actualización.

---

## Regla central

> **Un documento del cliente no es lo mismo que una regla confirmada del cliente.**

La documentación suele estar desactualizada, ser genérica o describir cómo *debería* trabajarse en lugar de cómo se trabaja. Por eso el onboarding produce un **borrador de perfil**, no un perfil final.

Todo ítem extraído nace en uno de dos estados, y nunca en otro:

- **`cliente`** — el documento lo dice de forma **explícita y literal**, sin necesidad de interpretación.
- **`fallback`** — todo lo demás: lo que dedujiste, lo que el documento sugiere pero no afirma, y lo que directamente no está.

Un ítem `fallback` solo pasa a `cliente` cuando el usuario lo confirma en la sesión de cierre (paso 5). **Nunca lo promuevas por tu cuenta**, aunque la deducción sea razonable.

---

## Paso 1 — Pedir la documentación

Pedí solo lo que exista. Si el cliente no tiene nada de esto, no pasa nada: el perfil se construye por conversación con `sdet-client-profile`.

| Prioridad | Documento | Qué aporta al perfil |
|-----------|-----------|----------------------|
| Alta | Normativa, manual o política de calidad | Marco general, etapas, roles |
| Alta | Definition of Done / Definition of Ready | Criterios de aceptación y de entrada |
| Alta | Plan o estrategia de pruebas de referencia | Niveles, tipos y alcance exigidos |
| Media | Procedimiento de release o despliegue | Gates, aprobaciones, rollback |
| Media | Política de gestión de defectos | Severidades, SLA, herramienta |
| Media | Contrato o SLA con cláusulas de calidad | Umbrales exigibles y penalizaciones |
| Baja | Plantillas de reportes que usan | Formato y frecuencia esperados |
| Baja | Diagramas de arquitectura y entornos | Contexto técnico y quién controla qué |

**Preguntá también qué NO existe.** Que el cliente diga "no tenemos política de datos de prueba" es información valiosa: define un hueco conocido en lugar de un supuesto silencioso.

---

## Paso 2 — Extraer

Recorré cada documento buscando **reglas verificables**, no descripciones generales.

| Buscá | Ejemplo de regla extraíble |
|-------|----------------------------|
| Números y umbrales | "cobertura mínima del 70% en código nuevo" |
| Obligaciones explícitas | "toda historia requiere aprobación del Product Owner" |
| Prohibiciones | "no se permite usar datos productivos en QA" |
| Roles con poder de decisión | "el Release Manager autoriza el pase a producción" |
| Herramientas nombradas | "la gestión de defectos se realiza en Jira" |
| Plazos y frecuencias | "reporte semanal de calidad los viernes" |

**Descartá** declaraciones de intención sin criterio verificable ("buscamos la excelencia", "la calidad es responsabilidad de todos"). No son reglas y no entran al perfil.

**Ante ambigüedad, marcá `fallback` y anotá la pregunta.** Es mejor un hueco declarado que una regla inventada.

---

## Paso 3 — Mapear al perfil

Cada regla extraída va a su sección en el perfil que define `sdet-client-profile`:

| Lo que encontraste | Sección destino |
|--------------------|-----------------|
| Marco, normativa, definición de terminado | 1. Marco de calidad |
| Etapas, gates, aprobaciones, evidencia exigida | 2. Proceso y etapas |
| Niveles, tipos, umbrales, automatización, defectos | 3. Testing exigido |
| ALM, CI/CD, stack, entornos, datos de prueba | 4. Herramientas y entorno |
| Reportes, interlocutores, excepciones | 5. Reporting y gobernanza |

Toda fila lleva su columna `Origen` con el estado que corresponda según la regla central.

Agregá siempre la referencia al documento de donde salió cada regla: cuando dentro de seis meses aparezca una contradicción, hay que poder rastrear el origen.

---

## Paso 4 — Detectar los huecos

Comparar lo extraído contra las áreas que un proyecto necesita cubrir. Todo lo que no esté en la documentación es un hueco.

Checklist de áreas a verificar:

- [ ] Definición de terminado
- [ ] Criterios de aceptación y quién los valida
- [ ] Niveles de testing exigidos
- [ ] Umbrales de cobertura o de defectos
- [ ] Gestión de defectos: herramienta, severidades, SLA
- [ ] Criterios de pase a producción y quién aprueba
- [ ] Plan de rollback
- [ ] Restricciones sobre datos de prueba
- [ ] Entornos disponibles y quién los controla
- [ ] Alcance de la automatización
- [ ] Formato y frecuencia de reporting
- [ ] Gestión de excepciones y desviaciones

Cada casilla sin marcar va a la sección **6. Huecos abiertos** del perfil, con la práctica de fallback que vas a aplicar mientras tanto (tomada de `sdet-industry-practices` o `sdet-istqb`).

---

## Paso 5 — Sesión de confirmación

**Este paso no es opcional.** Sin él, el perfil es un borrador basado en interpretación de documentos.

Presentale al usuario un resumen en tres bloques:

```markdown
## Onboarding de {cliente} — borrador de perfil

### Reglas explícitas encontradas ({N})
Salen literales de la documentación. Las aplico tal cual.
- {regla} — fuente: {documento, sección}

### Necesito que confirmes ({N})
Lo deduje de la documentación pero no está dicho de forma explícita.
Hasta que lo confirmes, queda marcado como fallback nuestro.
- {interpretación} — mi lectura de: {documento, sección}

### Huecos sin cubrir ({N})
El cliente no lo define. Aplico buenas prácticas y lo declaro cada vez.
- {área}: aplico {práctica} por defecto
```

Con las respuestas del usuario:

1. Promové a `cliente` únicamente lo confirmado.
2. Lo que el usuario no pueda confirmar **queda como `fallback`** y va a huecos abiertos. No insistas.
3. Guardá el perfil bajo `qa-patterns/{project}/client-profile`.
4. Registrá en el historial de aprendizaje que el perfil se originó en un onboarding documental, con la fecha y los documentos usados.

A partir de acá, el mantenimiento continuo pasa a `sdet-client-profile`.

---

## Cliente sin documentación

Es el caso más frecuente, y no es un problema.

1. Decilo sin dramatismo: no hay documentación, así que el perfil se construye conversando.
2. Cargá `sdet-client-profile` y elicitá solo su Bloque 1 (tres preguntas).
3. Marcá **todas** las áreas como huecos abiertos con fallback declarado.
4. Trabajá normalmente. El perfil se va a llenar solo, a medida que el usuario mencione cómo trabaja el cliente.

Un perfil vacío pero honesto es mejor que un perfil completo lleno de supuestos.
