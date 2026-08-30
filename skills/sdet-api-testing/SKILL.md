---
name: sdet-api-testing
description: >
  Testing de APIs REST y GraphQL: qué verificar más allá del status code, contrato y esquema, códigos de estado, idempotencia, paginación, autenticación y datos de prueba.
  Trigger: testing de API, REST, GraphQL, endpoints, status code, contrato de API, Postman, esquema JSON
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-core
---

# Testing de APIs

Las APIs son la capa donde más barato sale encontrar defectos: más rápida que la interfaz, más cercana al negocio que los tests unitarios, y estable frente a cambios visuales.

---

## Qué verificar en cada respuesta

**Verificar solo el status code es el error más común del testing de APIs.** Un `200 OK` con el cuerpo equivocado es un fallo que pasa desapercibido.

Por cada respuesta, comprobá cinco cosas:

| # | Qué | Por qué |
|---|-----|---------|
| 1 | **Status code** | Correcto para la operación y el resultado |
| 2 | **Estructura del cuerpo** | Campos presentes, tipos correctos, nada extra ni faltante |
| 3 | **Valores de negocio** | Los datos son los esperados, no solo tienen la forma esperada |
| 4 | **Cabeceras** | Content-Type, cache, cabeceras de seguridad, paginación |
| 5 | **Efecto lateral** | Si la operación modifica estado, verificá que el estado cambió de verdad |

El punto 5 es el que más se omite: un `POST` que devuelve `201` pero no persiste nada pasa el test si solo mirás el código.

---

## Códigos de estado que importan

| Código | Cuándo corresponde | Confusión frecuente |
|--------|--------------------|---------------------|
| **200** | Operación exitosa con cuerpo | Se devuelve también en errores, con un `"error"` adentro. Antipatrón |
| **201** | Recurso creado | Debe incluir la ubicación o el recurso creado |
| **204** | Éxito sin cuerpo | Devolver cuerpo con 204 es incorrecto |
| **400** | La petición está mal formada | Se usa para errores de negocio que merecen 422 |
| **401** | No autenticado — no sabemos quién sos | Se confunde con 403 |
| **403** | Autenticado pero sin permiso | Se confunde con 401 |
| **404** | No existe — o no querés revelar que existe | Ver la nota de seguridad más abajo |
| **409** | Conflicto de estado | Se devuelve 400 genérico y se pierde información |
| **422** | Bien formada pero semánticamente inválida | Se mezcla con 400 |
| **429** | Demasiadas peticiones | Rara vez se testea que exista rate limiting |
| **500** | Error del servidor | **Nunca** debería aparecer en un caso de prueba de entrada inválida |

**Nota de seguridad:** devolver 403 para un recurso ajeno confirma que ese recurso existe. En recursos sensibles, 404 es preferible. Ver `sdet-security-testing`.

---

## Casos por operación

### GET

- [ ] Recurso existente devuelve los datos correctos
- [ ] Recurso inexistente devuelve 404, no 500 ni 200 con cuerpo vacío
- [ ] ID con formato inválido devuelve 400
- [ ] Sin autenticación devuelve 401
- [ ] Recurso de otro usuario devuelve 403 o 404
- [ ] Colección vacía devuelve `[]` con 200, **no** 404

### POST

- [ ] Datos válidos crean el recurso y lo persisten de verdad
- [ ] Campo obligatorio faltante devuelve 400 o 422 indicando **cuál** falta
- [ ] Tipo incorrecto en un campo devuelve error, no 500
- [ ] Duplicado devuelve 409 si corresponde
- [ ] Cuerpo vacío o JSON malformado devuelve 400
- [ ] Campos extra no reconocidos: se ignoran o se rechazan, pero de forma **consistente**

### PUT y PATCH

- [ ] `PUT` es idempotente: repetirlo deja el mismo estado
- [ ] `PATCH` modifica solo los campos enviados y no borra el resto
- [ ] Actualizar un recurso inexistente devuelve 404
- [ ] Actualización concurrente se resuelve de forma definida

### DELETE

- [ ] Borrado exitoso devuelve 204 o 200
- [ ] Borrar dos veces: la segunda devuelve 404 o 204 según el contrato, pero de forma consistente
- [ ] Borrar algo referenciado por otro recurso devuelve 409 o borra en cascada, según lo definido

---

## Contrato y esquema

Verificar la forma de la respuesta contra un esquema declarado detecta cambios accidentales que ningún test de valores encuentra.

- Validá contra **JSON Schema** o el esquema de OpenAPI del proyecto.
- Comprobá **tipos**, no solo presencia: un `id` que pasa de número a string rompe consumidores.
- Comprobá **nulabilidad**: un campo que empieza a llegar `null` es un cambio de contrato.
- Un campo **nuevo** suele ser compatible; uno **eliminado o renombrado** nunca lo es.

Para integraciones entre servicios, esto se profundiza con contract testing — ver `sdet-industry-practices`.

---

## Puntos que se olvidan

| Aspecto | Qué probar |
|---------|------------|
| **Paginación** | Primera página, última, página fuera de rango, límite en cero, límite enorme |
| **Ordenamiento** | Campo válido, campo inexistente, dirección inválida |
| **Filtros** | Filtro sin resultados, combinación de filtros, valores con caracteres especiales |
| **Idempotencia** | Repetir la misma petición no debe duplicar efectos |
| **Rate limiting** | Superar el límite devuelve 429 con información de reintento |
| **Timeouts** | Qué pasa cuando una dependencia tarda demasiado |
| **Concurrencia** | Dos peticiones simultáneas sobre el mismo recurso |
| **Versionado** | La versión anterior sigue funcionando tras publicar una nueva |

---

## GraphQL: diferencias

- El status suele ser **200 incluso con errores**: hay que inspeccionar el array `errors`.
- Probá **consultas profundas o anidadas**: sin límite de profundidad hay riesgo de denegación de servicio.
- Verificá que la autorización se aplique **por campo**, no solo por operación.
- Probá el problema **N+1**: una consulta que dispara cientos de accesos a base de datos.
- Comprobá que la introspección esté deshabilitada en producción si el esquema no es público.

---

## Datos de prueba

- Cada test **crea el estado que necesita** y lo limpia al terminar.
- No dependas de datos preexistentes en el entorno: es la causa número uno de tests de API frágiles.
- Usá identificadores únicos por ejecución para poder correr en paralelo.
- Preparar el estado vía API es más rápido y estable que hacerlo por interfaz.

---

## Herramientas

| Uso | Herramientas |
|-----|--------------|
| Exploración manual | Postman, Insomnia, Bruno, `curl`, HTTPie |
| Automatización | REST Assured (Java), Supertest (JS), `requests` + pytest (Python), Playwright API |
| Validación de esquema | Ajv, jsonschema, Pydantic |
| Contract testing | Pact, Spring Cloud Contract |
| Simulación | WireMock, MSW, Prism |

**Recomendación:** explorá con una herramienta interactiva y automatizá con la del lenguaje del proyecto. Mantener suites grandes dentro de una herramienta gráfica se vuelve difícil de versionar y revisar.
