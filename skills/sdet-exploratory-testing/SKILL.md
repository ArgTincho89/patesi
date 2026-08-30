---
name: sdet-exploratory-testing
description: >
  Testing exploratorio con gestión por sesiones: charters, time-boxing, heurísticas de exploración y documentación ligera de hallazgos.
  Trigger: testing exploratorio, session-based test management, charter de exploración, heurísticas de testing, SFDIPOT, FEW HICCUPPS
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-core
---

# Testing exploratorio

Aprendizaje, diseño y ejecución de tests en simultáneo. No es "probar sin plan": es un enfoque disciplinado donde el plan se construye mientras se ejecuta y queda registrado.

Es la técnica con mejor retorno por hora invertida cuando el producto es nuevo, cambió mucho, o nadie sabe todavía qué hay que testear.

---

## Cuándo usarlo

| Situación | Exploratorio | Scripted |
|-----------|--------------|----------|
| Feature nueva sin especificación detallada | ✅ Primero | Después, para lo que valga automatizar |
| Verificar que una corrección no rompió nada | | ✅ Regresión automatizada |
| Producto que nunca se testeó | ✅ Empezá acá | — |
| Requisito regulatorio con evidencia formal | Complemento | ✅ Casos trazables |
| Poco tiempo, mucho territorio desconocido | ✅ | — |
| Verificación repetible en cada build | — | ✅ Automatizado |

**No son excluyentes.** El exploratorio descubre qué importa; el scripted fija lo descubierto para que no se vuelva a romper. Un hallazgo exploratorio valioso termina convertido en caso de prueba automatizado.

---

## Session-Based Test Management (SBTM)

Estructura mínima que convierte la exploración en trabajo medible y comunicable.

### Sesión

Bloque de tiempo **ininterrumpido y acotado** dedicado a explorar un objetivo concreto.

- **Duración**: 45, 60 o 90 minutos. Más de 90 pierde foco; menos de 45 no alcanza a entrar en profundidad.
- **Sin interrupciones**: una sesión cortada por reuniones deja de ser una sesión.
- **Un objetivo por sesión**: si aparecen dos, anotá el segundo como charter pendiente y seguí con el primero.

### Charter

La declaración de qué se va a explorar. Es lo que convierte "voy a probar un rato" en trabajo dirigido.

```
Explorar   {área o funcionalidad}
Con        {recursos, datos, herramientas o configuración}
Para       {qué información se busca descubrir}
```

**Ejemplos:**

```
Explorar  el flujo de recuperación de contraseña
Con       cuentas en distintos estados: activa, bloqueada, sin verificar
Para      descubrir cómo se comporta ante estados inesperados

Explorar  la carga de archivos del perfil
Con       archivos en el límite de tamaño, formatos no soportados y nombres con Unicode
Para      descubrir fallos de validación y mensajes de error poco claros
```

**Un buen charter es específico pero no prescriptivo:** dice dónde mirar, no qué apretar.

### Reparto del tiempo

Al cerrar la sesión, estimá aproximadamente cómo se repartió:

- **Exploración**: el trabajo de la sesión
- **Investigación de bugs**: reproducir y acotar lo encontrado
- **Preparación**: montar datos, entorno o configuración

Si la preparación se come más de la mitad del tiempo de forma sistemática, el problema no es el testing: es el entorno.

---

## Heurísticas de exploración

Una heurística es un disparador de ideas, no una regla. Sirven para no quedarse mirando la pantalla sin saber qué probar.

### SFDIPOT — recorrer el producto por dimensiones

| Dimensión | Qué preguntarse |
|-----------|-----------------|
| **S**tructure (estructura) | ¿De qué partes está hecho? ¿Qué pasa si falta una? |
| **F**unction (función) | ¿Qué hace? ¿Qué debería hacer y no hace? |
| **D**ata (datos) | ¿Qué datos consume y produce? ¿Cuáles son los extremos? |
| **I**nterfaces | ¿Con qué se comunica: usuario, API, archivos, otros sistemas? |
| **P**latform (plataforma) | ¿De qué depende: navegador, sistema operativo, red, servicios? |
| **O**perations (operaciones) | ¿Cómo lo usa la gente de verdad? ¿Qué haría un usuario apurado? |
| **T**ime (tiempo) | ¿Qué cambia con el paso del tiempo, la concurrencia o el orden? |

### FEW HICCUPPS — contra qué comparar para decidir si algo es un fallo

Un comportamiento es sospechoso cuando es **inconsistente** con:

| Referencia | Pregunta |
|------------|----------|
| **F**amiliar | ¿Se parece a un problema conocido en otros productos? |
| **E**xplainable | ¿Puedo explicarle este comportamiento a un usuario sin que suene absurdo? |
| **W**orld | ¿Coincide con cómo funcionan las cosas en el mundo real? |
| **H**istory | ¿Se comportaba así antes? |
| **I**mage | ¿Daña la imagen que el producto quiere proyectar? |
| **C**omparable | ¿Otros productos equivalentes lo hacen distinto? |
| **C**laims | ¿Contradice lo que promete la documentación o el marketing? |
| **U**ser expectations | ¿Es lo que un usuario razonable esperaría? |
| **P**roduct | ¿Es coherente con el resto del propio producto? |
| **P**urpose | ¿Sirve al propósito para el que existe la funcionalidad? |
| **S**tandards | ¿Cumple normas, convenciones o requisitos legales aplicables? |

**Uso práctico:** cuando encontrás algo raro pero no sabés si es un bug, recorré esta lista. Si es inconsistente con alguna de estas referencias, tenés un argumento concreto para reportarlo.

### Heurísticas rápidas de datos

- **Cero, uno, muchos, demasiados**: lista vacía, un elemento, varios, más de los que caben
- **CRUD**: crear, leer, actualizar, borrar — y borrar algo que otra cosa está usando
- **Interrumpir**: cerrar la pestaña, cortar la red, volver atrás a mitad de un flujo
- **Repetir**: doble clic, enviar dos veces, refrescar durante el procesamiento
- **Extremos**: el valor mínimo, el máximo, uno menos, uno más, el vacío, el nulo

---

## Documentación de hallazgos

El exploratorio pierde valor si no queda registro. Pero el registro tiene que costar minutos, no horas.

### Nota de sesión

```markdown
# Sesión: {charter en una línea}

Fecha: {fecha} · Duración: {min} · Build: {versión o commit}

## Charter
Explorar {área} con {recursos} para {objetivo}

## Reparto
Exploración {X}% · Investigación de bugs {Y}% · Preparación {Z}%

## Hallazgos
| # | Qué observé | Por qué es sospechoso | Severidad |
|---|-------------|-----------------------|-----------|
| 1 | {observación} | {referencia FEW HICCUPPS} | Alta/Media/Baja |

## Preguntas abiertas
- {duda que no se pudo resolver en la sesión}

## Zonas no cubiertas
- {qué quedó sin explorar y por qué}

## Charters que surgieron
- {nueva exploración que vale la pena hacer}
```

**Las tres últimas secciones son las más valiosas y las que más se omiten.** "Qué no miré" es información de calidad tanto como "qué encontré": es el gap de cobertura declarado.

---

## Errores frecuentes

| Error | Por qué falla |
|-------|---------------|
| Llamar exploratorio a probar sin rumbo | Sin charter no hay foco, y sin nota no hay resultado comunicable |
| Sesiones de cuatro horas | La atención cae y la calidad de observación se desploma |
| Documentar cada clic | El costo supera al valor; registrá hallazgos y decisiones, no pasos |
| Explorar solo el happy path | Ahí justamente no está la información nueva |
| No convertir hallazgos en tests | El mismo defecto vuelve en tres meses |
| Reportar "no funciona" | Sin la referencia contra la que es inconsistente, el reporte es discutible |
