---
name: sdet-self-review
description: >
  Auditoría del propio agente Patesi: detectar contradicciones internas entre agent.md, system.md, config.yaml y los skills. Es lo que los scripts NO pueden verificar, porque las contradicciones son semánticas y no estructurales.
  Trigger: auditá a Patesi, revisá tu propia definición, contradicciones internas, auto-QA del agente, ¿te contradecís?, revisar system.md y skills
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-core
---

# Auditoría interna del agente

> **No confundir con la §9 de `system.md`.** Esa es la autorrevisión del **output** antes de entregarlo, y corre siempre. Esto es la auditoría de la **definición del agente** —`agent.md`, `system.md`, `config.yaml`, los 35 skills— y corre bajo pedido.

## Por qué existe

Patesi tiene tres capas de verificación y cada una atrapa una clase distinta de fallo:

| Capa | Qué atrapa | Cuándo corre |
|------|------------|--------------|
| `scripts/check-consistency.py` | Fallos **estructurales**: conteos desalineados, marcadores faltantes, referencias rotas, texto sin traducir | Automático (CI y a mano) |
| `tests/smoke-comportamiento.md` y `tests/guiones-evaluacion.md` | Fallos de **comportamiento**: el agente no hace lo que la spec dice | Manual |
| **Este skill** | Fallos de **coherencia**: dos partes de la spec se contradicen, y el agente cumple una u otra según el día | Bajo pedido |

Un script no puede detectar que la §2 dice "los tres modos tienen la misma jerarquía" y la §7 le da nueve secciones al Modo A y cinco al Modo B sin explicar por qué eso no es una jerarquía. Eso hay que **leerlo**.

Y es el fallo más caro de todos: una contradicción no rompe nada visible. Produce un agente que responde distinto ante la misma pregunta y nadie sabe cuál de las dos respuestas era la correcta.

---

## Alcance

Solo estos archivos del repo de Patesi:

```
agent.md          system.md          config.yaml
skills/*/SKILL.md
adapters/opencode/    adapters/copilot/
```

**No** entra el código de los scripts —eso lo cubren sus propias verificaciones— ni el contenido normativo de SQEM.

> **Límite sobre SQEM:** el contenido sustantivo de SQEM (umbrales, roles, reglas de negocio) es **fuente de verdad externa**. Si hay una incoherencia dentro de la propia normativa, **se reporta como hallazgo y no se toca**. Lo único que se corrige acá es la incoherencia entre lo que dice la fuente y lo que Patesi transcribió.

---

## Las siete clases de contradicción

Buscá estas. Están ordenadas por cuánto daño hacen.

### 1. Regla contra regla

Dos afirmaciones normativas que no pueden ser ciertas a la vez.

*Ejemplo real de este repo:* la regla fundamental dice que Patesi nunca escribe en el proyecto bajo prueba; una regla posterior de autonomía dice que ejecuta lo que el usuario pida tras advertir el riesgo. ¿Cuál gana si el usuario insiste en que corrija el bug?

**Está resuelto** —la autonomía gana, con registro— pero *tuvo que estar escrito explícitamente*. La contradicción sin resolución declarada es el hallazgo.

**Cómo buscarla:** listá las reglas absolutas (las que dicen *nunca*, *siempre*, *no debe*) y por cada una preguntá qué otra regla podría exigir lo opuesto.

### 2. Alcance declarado contra alcance real

Una sección declara que algo aplica en los tres modos, y solo está desarrollado en uno.

**Cómo buscarla:** por cada "aplica en los tres modos" / "en cualquier modo", verificá que exista tratamiento real en A, B y C. Una mención de pasada no es tratamiento.

### 3. Deriva entre el núcleo y los skills

`system.md` define una regla, un skill la reformula distinto. El agente carga el skill y pierde la del núcleo.

**Cómo buscarla:** por cada tema tratado en `system.md` y en algún skill (límite de escritura, contrato docente, fallback declarado, cálculo del NAQ), leé las dos versiones en paralelo. Deben decir lo mismo o el skill debe **ampliar** sin cambiar la regla.

### 4. Deriva entre el núcleo y los adaptadores

Lo que ve el usuario de Copilot difiere de lo que ve el usuario de OpenCode.

**Los bloques `COPILOT-EXTRACT` ya cubren esto mecánicamente** y `check-consistency.py` verifica la paridad. Lo que queda para revisión humana es lo que está **fuera** de esos marcadores: texto propio del adaptador que reformula algo del núcleo.

**Cómo buscarla:** leé los adaptadores ignorando lo extraído. Todo lo que queda es texto original, y todo texto original es sospechoso de deriva.

### 5. Trigger que se solapa

Dos skills declaran triggers que compiten y ninguna regla decide cuál gana.

*Ejemplo:* "testing de APIs" está en `sdet-api-testing`; "tests de contrato" podría razonablemente caer en ese o en `sdet-test-strategy`.

**Cómo buscarla:** juntá los `Trigger:` de los 35 skills en una lista y buscá frases que un mismo pedido dispararía. Si dos compiten, o se desambigua el trigger o se declara la precedencia.

*Los casos de ruteo de `tests/skill-eval-set.md` prueban esto en la práctica; esta revisión lo detecta antes de gastar una corrida de evaluación.*

### 6. Ejemplo que contradice a su regla

La regla dice una cosa, el ejemplo de abajo hace otra. **El ejemplo gana siempre**: un modelo imita lo que ve antes que lo que se le dice.

**Cómo buscarla:** por cada plantilla y cada ejemplo, verificá que cumpla la regla que ilustra. Prestá atención a los conteos de secciones, al orden de las partes, y a si el ejemplo cita las secciones cuando la regla exige citarlas.

### 7. Regla huérfana

Una regla que ninguna evaluación prueba. No es una contradicción, es un hueco: si se rompe, nadie se entera.

**Cómo buscarla:** por cada regla bloqueante, buscá qué caso de `smoke-comportamiento.md` o `guiones-evaluacion.md` fallaría si la regla desapareciera. Si no hay ninguno, el hallazgo es la ausencia del caso.

---

## Procedimiento

1. **Correr los scripts primero.** `python scripts/patesi-doctor.py`. Si la verificación estructural falla, arreglá eso antes: no tiene sentido buscar contradicciones semánticas sobre un archivo truncado.
2. **Leer completos** `agent.md` y `system.md`. Completos, no por búsqueda: las contradicciones viven entre secciones distantes, y una búsqueda por palabra clave devuelve una de las dos puntas.
3. **Recorrer las siete clases**, en orden, sobre el material leído.
4. **Leer los `Trigger:` de los 35 skills** de corrido para la clase 5.
5. **Emitir el informe.**

---

## Formato del informe

Un hallazgo se reporta así:

```markdown
### H-01 · [Clase 1: regla contra regla] Autonomía vs. límite de escritura

**Dónde:** system.md §"Regla fundamental" ↔ system.md §3.2

**Qué dice cada parte:**
- §Regla fundamental: «nunca modificás el código del proyecto bajo prueba»
- §3.2: «tras advertir el riesgo una vez, ejecutás exactamente lo pedido»

**Por qué importa:** ante «arreglalo vos, me hago cargo», las dos reglas
exigen conductas opuestas. El agente resuelve según cuál pesó más en el
contexto, y el usuario no puede predecir la respuesta.

**Propuesta:** declarar la precedencia en la regla fundamental.

**Cómo se verificaría:** caso B3 de guiones-evaluacion.md.
```

**Severidad:**

| Nivel | Criterio |
|-------|----------|
| **Bloqueante** | Afecta el límite de escritura, la pregunta de modo o el fallback declarado |
| **Alta** | Puede producir dos comportamientos distintos ante el mismo pedido |
| **Media** | Genera output inconsistente sin cambiar la conducta |
| **Baja** | Redacción confusa, sin efecto observable |

---

## Reglas de la auditoría

**No propongas cambios en la misma pasada en que buscás.** Buscar y arreglar al mismo tiempo hace que dejes de buscar en cuanto encontrás algo. Primero el informe completo, después las correcciones.

**No inventes contradicciones para llenar el informe.** Cero hallazgos es un resultado válido y hay que decirlo así. Un hallazgo forzado hace que el próximo informe se lea en diagonal, y ahí es donde se pierde el que importaba.

**Una contradicción resuelta explícitamente no es un hallazgo.** Si el texto dice cuál regla gana, está bien. Lo que se reporta es la contradicción *sin arbitraje*.

**Toda corrección exige volver a correr `check-consistency.py`.** Tocar `system.md` mueve conteos, marcadores y derivados. Ya pasó que una edición manual borrara los seis marcadores `COPILOT-EXTRACT` sin que nadie lo notara durante un commit entero.

---

## Cuándo correrla

- Antes de un commit que toque `agent.md` o `system.md`
- Después de agregar o reescribir un skill
- Cuando la evaluación de comportamiento falla y el motivo no es evidente — muchas veces el agente no está fallando, está cumpliendo la otra mitad de una contradicción
- Cada tanto, sin motivo. Las contradicciones se acumulan por sedimentación, no por un cambio puntual.
