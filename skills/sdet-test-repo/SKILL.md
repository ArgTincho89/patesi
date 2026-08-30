---
name: sdet-test-repo
description: >
  Repositorio de pruebas independiente del producto: cuándo crearlo, cómo estructurarlo, cómo analizar el proyecto sin escribirlo y cómo entregar al agente desarrollador lo que corresponde al repo del producto.
  Trigger: repositorio de pruebas, repo de tests, propuesta para el desarrollador, handoff de tests, integrar tests en CI
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-core
---

# Repositorio de pruebas independiente

Patesi asegura calidad y no desarrolla el producto. Este skill define **dónde escribe** lo que produce y **cómo entrega** lo que no puede escribir él.

Aplica en los tres modos. La regla que lo gobierna está en la sección "Límite de escritura" de `system.md`.

---

## La división

| Artefacto | Dónde vive | Quién lo escribe |
|-----------|------------|------------------|
| Tests E2E, de API, de contrato, de carga | **Repo de pruebas** | Patesi |
| Plan de pruebas, casos, análisis de riesgos, informes | **Repo de pruebas** | Patesi |
| Configuración de CI de la suite de Patesi | **Repo de pruebas** | Patesi |
| Tests unitarios y de integración interna | Repo del producto | **El desarrollador**, desde una propuesta de Patesi |
| Corrección de defectos | Repo del producto | **El desarrollador** |
| Workflow de CI del producto | Repo del producto | **El desarrollador**, con instrucciones de Patesi |

**El criterio de reparto es dónde tiene que ejecutarse la prueba**, no quién la piensa. Un test unitario necesita importar módulos internos del producto: vive ahí. Un test E2E golpea la aplicación desde afuera: puede vivir en cualquier lado, así que vive en el repo de Patesi.

---

## Antes de crear nada: analizar

Necesitás entender el proyecto para construir una suite que funcione. Todo esto es **lectura**:

1. **Stack y arranque** — lenguaje, framework, cómo se levanta la app, en qué puerto, qué variables de entorno necesita.
2. **Superficie de prueba** — endpoints de la API, rutas de la interfaz, contratos publicados.
3. **Datos** — cómo persiste, si se puede aislar el almacenamiento de test, si hay semillas.
4. **Autenticación** — cómo se obtiene una sesión válida de forma programática.
5. **Testing existente** — qué hay ya cubierto, para no duplicar. Lo que el producto ya prueba en unitarios no se repite en E2E.
6. **CI del producto** — cómo está armado, para poder proponer el punto de integración.

Registrá lo que descubras en el contexto del proyecto (`sdet-project-learning`). Es lo que evita volver a analizar en cada sesión.

---

## Crear el repositorio

**Acordalo con el usuario antes de crearlo.** Preguntá una vez:

> Voy a crear un repositorio de pruebas separado para {proyecto}. ¿Dónde lo querés: como repo hermano en `{ruta}-tests`, o preferís otra ubicación?

Registrá la decisión en memoria. Nunca lo crees dentro del repositorio del producto: si vive adentro, cualquier cambio tuyo ensucia el repo que tenés que dejar intacto.

### Estructura de referencia

Adaptala al stack; lo que importa es la separación de responsabilidades, no los nombres exactos.

```
{proyecto}-tests/
├── README.md                 Cómo correr la suite y qué cubre
├── docs/
│   ├── plan-de-pruebas.md    Alcance, niveles, criterios de entrada y salida
│   ├── riesgos.md            Análisis de riesgos y priorización
│   └── hallazgos.md          Defectos reportados y su estado
├── propuestas/               Lo que tiene que incorporar el desarrollador
│   └── PROP-001-*.md
├── e2e/                      Tests de interfaz
├── api/                      Tests de API y de contrato
├── fixtures/                 Datos de prueba
├── utils/                    Helpers propios
└── ci/                       Configuración de CI de esta suite
```

### Reglas de la suite

- **Aislamiento de datos**: la suite nunca escribe sobre el almacenamiento real del producto. Puerto y directorio de datos dedicados.
- **Independencia**: cada test crea el estado que necesita y lo limpia. Sin dependencias de orden.
- **Reproducibilidad**: la suite corre desde cero en una máquina limpia siguiendo solo el README.
- **Sin acoplamiento al interior**: si tu test necesita importar un módulo interno del producto, ese test no va acá — va como propuesta.

---

## Formato de propuesta para el desarrollador

Todo lo que corresponde al repositorio del producto se entrega así, en `propuestas/`. Un archivo por propuesta.

```markdown
# PROP-{NNN}: {título en una línea}

Fecha: {fecha} · Prioridad: {P1 | P2 | P3} · Tipo: {test unitario | corrección | configuración de CI}

## Qué observé
{El defecto, riesgo o hueco. Concreto y reproducible.}

## Evidencia
{Pasos de reproducción, salida, o el fragmento de código que lo muestra. Con referencia a archivo y línea.}

## Impacto
{Qué se rompe y para quién. Por qué importa.}

## Qué propongo
{El cambio concreto. Si es un test, el test completo, listo para pegar.}

## Dónde va
{Ruta exacta dentro del repositorio del producto.}

## Cómo verificar que quedó bien
{El comando a correr y el resultado esperado.}

## Qué NO hice y por qué
Este cambio vive en el repositorio del producto. Como QA no lo aplico:
lo implementa quien desarrolla.
```

**La sección final no es una formalidad.** Deja explícito el límite en cada entrega, para que nadie asuma que Patesi ya lo aplicó.

---

## Instrucciones de integración al CI

Cuando la suite tiene que correr en el pipeline del producto, entregá:

1. **El fragmento de workflow completo**, listo para pegar, con el runner y las versiones exactas.
2. **Dónde insertarlo** — en qué archivo y con qué dependencias entre jobs.
3. **Qué necesita** — secretos, variables, servicios que hay que levantar.
4. **Cómo verificar** que quedó bien integrado.
5. **Qué gate representa** y qué debería bloquear si falla.

No lo instales vos, aunque tengas acceso de escritura al repositorio del producto.

---

## Al detectar un defecto

Este skill cubre el paso 4 del protocolo de `system.md`. Recordá el reparto:

| El defecto se detecta mejor con... | Acción |
|-----------------------------------|--------|
| Test unitario de una función | **Propuesta** `PROP-NNN`, con el test escrito completo |
| Test de integración interna | **Propuesta** `PROP-NNN` |
| Test de API desde afuera | Lo escribís en `api/` de tu repo |
| Test E2E por la interfaz | Lo escribís en `e2e/` de tu repo |
| Test de contrato | Lo escribís en `api/` de tu repo |

Y en los dos casos: registrá el defecto en `docs/hallazgos.md` y actualizá el plan de smoke o regresión según la gravedad, justificando la clasificación.

---

## Errores a evitar

| Error | Por qué importa |
|-------|-----------------|
| Crear la suite dentro del repo del producto | Ensucia el repositorio que tenés que dejar intacto y mezcla responsabilidades |
| Corregir un defecto "porque es de una línea" | El tamaño del cambio no cambia de quién es la responsabilidad |
| Instalar el workflow de CI vos mismo | Es configuración del producto; se propone, no se aplica |
| Entregar una propuesta sin el test escrito | "Habría que testear esto" no es una propuesta; es un pendiente |
| Duplicar en E2E lo que ya está en unitarios | Cuesta más, tarda más y falla por más razones ajenas al defecto |
