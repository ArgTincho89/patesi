---
name: sdet-client-profile
description: >
  Elicitación, registro y actualización continua de la forma de trabajar de un cliente en Modo C, con fallback declarado a ISTQB para todo hueco no definido.
  Trigger: proyecto de cliente, metodología del cliente, perfil de cliente, forma de trabajar del cliente, Modo C
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-core
---

# Perfil de cliente (Modo C)

Construye y mantiene el documento vivo que describe cómo trabaja un cliente concreto. Usalo siempre que el modo activo sea **Modo C — Proyecto de un Cliente**.

El objetivo es que la iteración número 10 con ese cliente sea mucho mejor que la número 1, porque Patesi ya no vuelve a preguntar lo que ya aprendió.

---

## Principios

1. **El cliente manda.** Todo lo registrado en el perfil tiene precedencia sobre ISTQB y sobre cualquier práctica de industria.
2. **Lo que no está en el perfil, no es del cliente.** Nunca presentes una suposición como norma del cliente.
3. **Todo hueco se cubre con ISTQB y se declara.** El fallback es legítimo, pero siempre visible y etiquetado.
4. **El perfil se actualiza durante la conversación**, no al final ni cuando el usuario lo pide.
5. **Elicitación progresiva.** Nunca dispares el cuestionario completo de una vez. Preguntá lo que la tarea actual necesita y dejá que el resto se llene con el tiempo.

---

## Elicitación inicial

Cuando abrís un perfil nuevo, preguntá **solo el Bloque 1**. Es lo mínimo para empezar a trabajar sin inventar nada.

### Bloque 1 — Arranque (preguntar al abrir el perfil)

1. ¿El cliente tiene una metodología o normativa de calidad propia? ¿Cómo se llama?
2. ¿Cómo se define "terminado" en este proyecto? ¿Hay criterios de aceptación formales?
3. ¿Quién aprueba que algo pueda pasar a producción?

Con estas tres respuestas ya podés trabajar. El resto se elicita cuando la tarea lo requiera.

### Bloque 2 — Proceso (cuando definís estrategia o gates)

4. ¿Hay etapas o puertas formales que un cambio tiene que atravesar?
5. ¿Qué evidencia hay que dejar en cada etapa y dónde se guarda?
6. ¿Qué metodología de desarrollo usan (Scrum, Kanban, cascada, híbrido) y cuál es la cadencia de release?

### Bloque 3 — Testing (cuando diseñás o ejecutás tests)

7. ¿Qué niveles y tipos de testing exige el cliente?
8. ¿Hay umbrales obligatorios (cobertura, defectos abiertos, performance)?
9. ¿Qué se automatiza y qué queda manual por decisión del cliente?
10. ¿Cómo se gestionan los defectos: herramienta, severidades, SLA?

### Bloque 4 — Herramientas y entorno (cuando tocás código, pipeline o datos)

11. ¿Qué herramientas usa el cliente (ALM, CI/CD, análisis estático, gestión de tests)?
12. ¿Qué stack y qué frameworks de testing están aprobados?
13. ¿Qué entornos existen y quién los controla?
14. ¿Hay restricciones sobre datos de prueba (anonimización, datos productivos, normativa aplicable)?

### Bloque 5 — Reporting y gobernanza (cuando informás calidad)

15. ¿Qué reportes espera el cliente, con qué formato y frecuencia?
16. ¿Quiénes son los interlocutores y qué decide cada uno?
17. ¿Cómo se gestiona una excepción o una desviación de la norma del cliente?

---

## Estructura del perfil

Guardalo bajo la clave `qa-patterns/{project}/client-profile`.

```markdown
# Perfil de cliente: {Nombre del cliente}

Proyecto: {proyecto}
Última actualización: {fecha}

## 1. Marco de calidad
- Metodología o normativa propia: {nombre | "no tiene"}
- Documentos de referencia: {dónde viven}
- Definición de terminado: {criterio}

## 2. Proceso y etapas
| Etapa | Qué exige | Evidencia | Quién aprueba | Origen |
|-------|-----------|-----------|---------------|--------|
| {etapa} | {criterio} | {artefacto} | {rol} | cliente / fallback |

## 3. Testing exigido
| Aspecto | Regla del cliente | Origen |
|---------|-------------------|--------|
| Niveles | {...} | cliente / fallback |
| Tipos | {...} | cliente / fallback |
| Umbrales | {...} | cliente / fallback |
| Automatización | {...} | cliente / fallback |
| Gestión de defectos | {...} | cliente / fallback |

## 4. Herramientas y entorno
| Función | Herramienta | Origen |
|---------|-------------|--------|
| {ALM / CI / etc.} | {herramienta} | cliente / fallback |

Restricciones de datos de prueba: {...}

## 5. Reporting y gobernanza
| Reporte | Formato | Frecuencia | Destinatario | Origen |
|---------|---------|------------|--------------|--------|

Interlocutores: {rol → qué decide}
Gestión de excepciones: {...}

## 6. Huecos abiertos
Áreas donde el cliente no definió nada y estamos operando con fallback:
- {área}: aplicamos {práctica}. Pendiente de confirmar con el cliente.

## 7. Historial de aprendizaje
| Fecha | Qué aprendimos | Reemplaza a |
|-------|----------------|-------------|
| {fecha} | {dato} | {dato anterior o "—"} |
```

**La columna `Origen` es obligatoria en toda fila.** Solo admite dos valores:

- `cliente` — el usuario lo informó explícitamente como regla del cliente
- `fallback` — lo pusimos nosotros por buena práctica, a falta de definición del cliente

---

## Regla de fallback

Para todo hueco del framework del cliente, aplicá buenas prácticas de ISTQB y de la industria (cargá `sdet-istqb` cuando necesites la técnica exacta) y **declaralo en la respuesta**:

> El cliente no define {X}. Aplico {práctica} por defecto; confirmame si el cliente tiene una regla propia.

Registrá ese ítem en la sección **6. Huecos abiertos** con `Origen: fallback`. Cuando el usuario confirme la regla real del cliente, movelo a su sección correspondiente, cambiá el origen a `cliente` y sacalo de huecos abiertos.

Nunca conviertas un fallback en regla del cliente por inercia ni porque se repitió varias veces.

---

## Actualización continua

Durante cualquier conversación en Modo C, disparás una actualización del perfil cuando el usuario menciona:

- una herramienta, un entorno o una restricción de datos
- un criterio de aceptación, un umbral o una definición de terminado
- una etapa, un gate, una aprobación o un responsable
- un formato o una cadencia de reporte
- una preferencia o una prohibición explícita del cliente

**Qué hacer:** actualizá el perfil en ese momento y confirmá en una línea, sin cortar el hilo de la tarea:

> Registrado en el perfil de {cliente}: {dato}.

### Conflictos

Si el dato nuevo contradice algo ya registrado, **no lo sobrescribas en silencio**. Mostrá el conflicto y preguntá:

> Tenía registrado que {A}. Ahora mencionaste {B}. ¿Cuál vale, o cambió?

Recién con la respuesta, actualizá y dejá el cambio anotado en **7. Historial de aprendizaje**.

---

## Recuperación al inicio de sesión

Si el perfil existe, cargalo y presentá un resumen breve antes de trabajar:

> Cliente {nombre}. Marco: {metodología}. Sé cómo maneja {áreas cubiertas}. Tengo {N} huecos abiertos operando con fallback: {lista corta}. ¿Sigue vigente?

Esto le da al usuario la chance de corregir el perfil antes de que se use, y le muestra exactamente qué parte del trabajo se apoya en supuestos nuestros.

---

## Degradación controlada

Si el entorno no tiene memoria persistente:

1. Avisá: "No tengo memoria persistente disponible; el perfil del cliente no se va a conservar entre sesiones."
2. Mantené el perfil en la conversación actual y aplicá las mismas reglas.
3. Ofrecé al usuario exportar el perfil como archivo markdown en el repositorio para que no se pierda.
