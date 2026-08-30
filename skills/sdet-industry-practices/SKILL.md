---
name: sdet-industry-practices
description: >
  Buenas prácticas modernas de ingeniería de calidad: forma de la suite, shift-left, tests flaky, datos de prueba, contract testing, feature flags, observabilidad y criterios de release.
  Trigger: buenas prácticas de la industria, pirámide de tests, shift-left, tests flaky, datos de prueba, contract testing, feature flags, criterios de release
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-core
---

# Buenas prácticas de la industria

Complementa a `sdet-istqb`. ISTQB aporta el vocabulario y las técnicas de diseño de tests; este skill aporta la práctica de ingeniería con la que esas técnicas se aplican hoy en equipos reales.

Usalo como referencia primaria en **Modo B** y como fallback en **Modo C** cuando el cliente no define una práctica.

**Regla de uso:** cada recomendación que salga de acá se entrega explicando el porqué y el riesgo concreto que mitiga. Este skill existe para enseñar criterio, no para imponer un catálogo.

---

## 1. Forma de la suite de tests

No existe una única forma correcta. La forma se elige según dónde vive el riesgo del sistema.

| Forma | Cuándo conviene | Distribución típica |
|-------|-----------------|---------------------|
| **Pirámide** | Lógica de negocio rica, muchas reglas y cálculos | Muchos unitarios, algunos de integración, pocos E2E |
| **Trofeo** | Aplicaciones web donde el valor está en la integración de piezas | Peso en integración, unitarios para lógica pura, E2E acotados |
| **Panal** | Arquitecturas de microservicios | Peso en integración y contratos, unitarios solo en dominio |

**Criterio de decisión:** poné el test en el nivel más bajo que pueda detectar el fallo que te preocupa. Un test que sube de nivel sin necesidad cuesta más, tarda más y falla por razones ajenas al defecto.

**Antipatrón — cono de helado:** muchos E2E, pocos unitarios. Se detecta cuando la suite tarda horas, falla seguido por motivos no reproducibles y nadie confía en el rojo. La salida es empujar cobertura hacia abajo, no agregar reintentos.

---

## 2. Shift-left

Mover la detección de defectos lo más temprano posible, porque el costo de corrección crece con la distancia al momento en que se introdujo el defecto.

Prácticas concretas, de más barata a más cara:

1. **Criterios de aceptación testeables antes de codificar.** Si no se puede escribir el test desde el criterio, el criterio está mal escrito.
2. **Revisión de requisitos con mirada de testing.** Preguntar "¿qué pasa si...?" antes de que exista código.
3. **Análisis estático y linters en el editor**, no solo en CI.
4. **Tests unitarios escritos junto al código**, no después.
5. **Tests de integración en el pipeline de PR**, no en el nocturno.

**Shift-right complementario:** monitoreo, alertas y validación en producción. No reemplaza al shift-left; cubre lo que ningún entorno previo puede reproducir (carga real, datos reales, comportamiento de usuarios reales).

---

## 3. Tests flaky

Un test flaky es aquel que pasa y falla sin cambios en el código. **Es más dañino que un test ausente**, porque destruye la confianza en toda la suite: cuando el rojo deja de significar algo, el equipo empieza a ignorar fallos reales.

### Causas frecuentes

| Causa | Síntoma | Corrección |
|-------|---------|------------|
| Esperas por tiempo fijo | Falla en máquinas lentas o CI cargado | Esperar por condición, nunca por `sleep` |
| Dependencia de orden | Falla al cambiar el orden o al paralelizar | Cada test crea y limpia su propio estado |
| Estado compartido | Falla al correr en paralelo | Aislar datos por test (IDs únicos, esquemas separados) |
| Fecha y hora reales | Falla a fin de mes, fin de año o en otro huso | Inyectar el reloj; usar tiempo determinista |
| Dependencia de red externa | Falla cuando el tercero está lento o caído | Mockear en unitarios; contract testing en integración |
| Aleatoriedad sin semilla | Falla de forma irreproducible | Fijar la semilla y registrarla en el reporte |

### Política de gestión

1. **Detectar**: registrar tasa de fallo por test a lo largo del tiempo. Un test que falla y luego pasa sin cambios es flaky por definición.
2. **Cuarentena**: sacarlo del bloqueo de merge y etiquetarlo, con dueño y fecha límite. **La cuarentena es temporal, no un cementerio.**
3. **Presupuesto de flakiness**: definir un umbral aceptable (por ejemplo, menos del 1% de la suite). Superarlo detiene el trabajo de features hasta bajarlo.
4. **Nunca "arreglar" con reintentos.** El reintento esconde el síntoma y deja el defecto real —de test o de producto— dentro del sistema.

---

## 4. Estrategia de datos de prueba

La mayoría de los tests frágiles lo son por los datos, no por la lógica.

| Enfoque | Ventaja | Costo | Cuándo usarlo |
|---------|---------|-------|---------------|
| **Fixtures estáticas** | Simple y legible | Se desactualiza con el esquema | Casos pocos y estables |
| **Factories / builders** | Cada test declara solo lo que le importa | Requiere mantener las factories | Enfoque por defecto en la mayoría de los proyectos |
| **Datos generados** | Encuentra casos que nadie pensó | Fallos difíciles de reproducir | Complemento, con semilla fija |
| **Copia de producción** | Realismo máximo | Riesgo legal y de privacidad alto | Solo anonimizada y con autorización explícita |

**Reglas no negociables:**

- Nunca uses datos personales reales sin anonimizar, en ningún entorno de prueba.
- Cada test crea el estado que necesita y lo deja limpio. Un test que depende de datos preexistentes es un test que va a fallar.
- Los datos hablan: `usuarioSinMetodoDePago` explica el caso; `usuario3` no explica nada.

---

## 5. Contract testing

Cuando dos servicios se comunican, los tests E2E que levantan ambos son lentos, frágiles y difíciles de diagnosticar. El contract testing verifica que ambos lados cumplen el mismo acuerdo, sin levantarlos juntos.

- **Consumidor**: declara qué espera recibir y prueba contra un doble que cumple el contrato.
- **Proveedor**: verifica que su implementación real satisface todos los contratos declarados por sus consumidores.

**Cuándo aplica:** integraciones entre servicios propios, o con terceros cuya API puede cambiar sin aviso.
**Cuándo no aplica:** una única aplicación monolítica sin fronteras de servicio.

El riesgo que mitiga es concreto: enterarse en producción de que el otro lado cambió el formato de una respuesta.

---

## 6. Feature flags y validación en producción

Los feature flags separan el despliegue de la liberación: el código llega a producción apagado y se enciende cuando corresponde.

**Implicancias para testing:**

- Cada flag duplica los caminos posibles. Testeá las combinaciones que importan, no todas.
- Un flag sin fecha de retiro se vuelve deuda técnica permanente.
- La ruta de apagado es la ruta de rollback más barata que existe: hay que probarla, no suponerla.

**Prácticas de validación en producción:** despliegue canario, comparación en paralelo contra la implementación anterior, y smoke tests post-deploy automatizados.

---

## 7. Observabilidad como instrumento de QA

Si un fallo ocurre en producción y nadie puede explicar por qué, el problema no es solo el defecto: es la falta de instrumentación.

Preguntas de QA sobre observabilidad, en orden:

1. Si esta funcionalidad falla, **¿nos enteramos?** (alertas)
2. Si nos enteramos, **¿podemos reconstruir qué pasó?** (logs y trazas correlacionadas)
3. **¿Podemos saber a cuántos usuarios afectó?** (métricas de negocio, no solo técnicas)
4. **¿Cuánto tardamos en detectarlo y en recuperarnos?** (MTTD y MTTR)

Estas preguntas pertenecen al diseño de la feature, no al post mortem.

---

## 8. Criterios de "listo para liberar"

Un criterio de release sirve si se puede verificar objetivamente. "El equipo se siente cómodo" no es un criterio.

Base mínima, ajustable por riesgo:

- [ ] Los tests planificados se ejecutaron y el resultado está registrado
- [ ] Cero defectos bloqueantes o críticos abiertos
- [ ] Los defectos conocidos que quedan están documentados y aceptados por quien decide
- [ ] Smoke test posterior al despliegue, definido y automatizado
- [ ] Plan de rollback existente y probado, no solo escrito
- [ ] Monitoreo y alertas activos para lo que se libera

**Proporcionalidad:** en un proyecto personal, esta lista puede resolverse en diez minutos. En un sistema con dinero o datos sensibles de por medio, cada punto exige evidencia. La lista es la misma; el rigor de la evidencia cambia con el riesgo.

---

## Antipatrones frecuentes

| Antipatrón | Por qué falla |
|------------|---------------|
| Cobertura como objetivo | Se alcanza el número con tests que no verifican nada. La cobertura mide qué se ejecutó, no qué se comprobó |
| Tests que repiten la implementación | Rompen en cada refactor sin detectar ningún defecto. Testeá comportamiento observable, no estructura interna |
| Un solo `assert` gigante al final | Cuando falla no se sabe qué falló. Afirmá de forma específica |
| Suite que nadie puede correr localmente | Si solo corre en CI, deja de usarse durante el desarrollo |
| Automatizar todo lo automatizable | Automatizá lo que se repite y tiene riesgo. Lo demás cuesta más de lo que aporta |
