---
name: sdet-performance
description: >
  Testing de performance: tipos de prueba, definición de objetivos medibles, percentiles frente a promedios, diseño de carga realista e interpretación de resultados.
  Trigger: performance, pruebas de carga, estrés, soak, latencia, throughput, k6, JMeter, percentiles
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-core
---

# Testing de performance

Mide cómo se comporta el sistema bajo carga, no si funciona. Un sistema correcto que tarda ocho segundos está roto para el usuario.

---

## Antes de escribir un solo test

**Un test de performance sin objetivo definido no puede fallar, y por lo tanto no sirve.** "Ver cómo anda" no es un criterio.

Definí primero, en este orden:

1. **Qué operación** — el flujo concreto, no "la aplicación"
2. **Cuántos usuarios** — concurrentes o peticiones por segundo, con un número que salga de datos reales o de una expectativa declarada
3. **Qué latencia es aceptable** — expresada en percentil, no en promedio
4. **Durante cuánto tiempo** — un pico de cinco minutos y una jornada de ocho horas revelan problemas distintos

Ejemplo de objetivo utilizable:

> El endpoint de búsqueda responde en **p95 < 500 ms** con **200 peticiones por segundo** sostenidas durante **15 minutos**, con menos de 0,1% de errores.

Ese objetivo se puede aprobar o rechazar. "Que sea rápido" no.

---

## Percentiles, no promedios

**El promedio miente y es el error más común en performance.**

Con 100 peticiones: 99 responden en 100 ms y una en 10 segundos. El promedio da 199 ms — parece excelente. Pero hay un usuario que esperó diez segundos.

| Métrica | Qué dice | Uso |
|---------|----------|-----|
| Promedio | Nada útil por sí solo | Evitarlo como criterio |
| **p50 (mediana)** | La experiencia típica | Referencia general |
| **p95** | La experiencia del 5% peor | **Criterio principal de aceptación** |
| **p99** | Los casos extremos | Sistemas críticos o de alto volumen |
| Máximo | El peor caso observado | Detectar outliers e investigarlos |

**Regla:** fijá los criterios en p95 como mínimo. Si el sistema es crítico, agregá p99.

---

## Tipos de prueba

| Tipo | Qué responde | Cómo se diseña |
|------|--------------|----------------|
| **Carga** | ¿Aguanta la carga esperada? | Carga normal prevista, sostenida |
| **Estrés** | ¿Dónde se rompe y cómo? | Subir la carga hasta que falle |
| **Pico (spike)** | ¿Sobrevive a una subida repentina? | Salto brusco y vuelta a la normalidad |
| **Soak / resistencia** | ¿Se degrada con el tiempo? | Carga normal durante horas |
| **Escalabilidad** | ¿Mejora al agregar recursos? | Medir con distinta capacidad |
| **Volumen** | ¿Aguanta muchos datos? | Base de datos con volumen realista |

**Qué encuentra cada uno, en la práctica:**

- **Estrés** revela el modo de fallo. Un sistema que se degrada suave es sano; uno que colapsa de golpe es frágil.
- **Soak** revela fugas de memoria y conexiones sin liberar. Nada más las encuentra.
- **Pico** revela si el autoescalado reacciona a tiempo o llega tarde.

---

## Diseñar carga realista

Una prueba con carga irreal produce conclusiones irreales.

| Aspecto | Error frecuente | Qué hacer |
|---------|-----------------|-----------|
| **Datos** | Todos los usuarios virtuales piden el mismo registro | Variar los datos; la caché tapa el problema real |
| **Pausas** | Peticiones sin pausa entre sí | Agregar think time: la gente lee antes de hacer clic |
| **Distribución** | Todos hacen la misma operación | Mezclar operaciones según proporciones reales |
| **Arranque** | Toda la carga de golpe | Rampa gradual, salvo que estés probando picos |
| **Caché** | Medir con caché caliente | Decidir explícitamente si medís con caché fría o caliente |
| **Entorno** | Medir en un entorno mucho más chico | Documentar la diferencia; los números no extrapolan linealmente |

---

## Interpretar resultados

Mirá siempre estas cuatro señales juntas:

1. **Latencia por percentil** a lo largo del tiempo, no un único número final
2. **Throughput** — si la carga sube y el throughput se estanca, encontraste el techo
3. **Tasa de errores** — latencia buena con 20% de errores no es un buen resultado
4. **Recursos** — CPU, memoria, conexiones. Sin esto sabés *que* es lento, no *por qué*

**Patrones reconocibles:**

| Patrón | Diagnóstico probable |
|--------|----------------------|
| Latencia sube y throughput se estanca | Se saturó un recurso: pool de conexiones, CPU, I/O |
| Latencia crece sostenida durante un soak | Fuga de memoria o de conexiones |
| p50 estable y p99 disparado | Contención puntual: locks, garbage collection, consultas lentas ocasionales |
| Todo bien y de golpe colapsa | Falta de degradación gradual; revisar timeouts y circuit breakers |

---

## Herramientas

| Herramienta | Cuándo conviene |
|-------------|-----------------|
| **k6** | Scripts en JavaScript, buena integración con CI. Punto de partida recomendado |
| **JMeter** | Interfaz gráfica, protocolos variados, ecosistema maduro |
| **Gatling** | Scala/Java, buen reporte, alto rendimiento |
| **Locust** | Python, escenarios complejos con lógica |
| **Artillery** | YAML, rápido de arrancar para APIs |

---

## Proporcionalidad

No todo proyecto necesita una suite de performance.

| Contexto | Qué corresponde |
|----------|-----------------|
| Proyecto personal, pocos usuarios | Medir una vez el flujo principal. Suficiente |
| Producto con usuarios reales | Prueba de carga del flujo crítico antes de cada release importante |
| Sistema con dinero o alto volumen | Suite completa en CI, con umbrales que bloquean el release |

**El error de criterio más caro es medir performance sobre algo que nadie usa.** Empezá siempre por el flujo que más se ejecuta o el que más duele si se cae.

---

## Errores frecuentes

| Error | Por qué falla |
|-------|---------------|
| Usar el promedio como criterio | Esconde exactamente a los usuarios peor atendidos |
| Probar sin objetivo definido | El test no puede fallar, así que no informa nada |
| Medir en un entorno no comparable | Los números no extrapolan de forma lineal |
| Ignorar la tasa de errores | Un sistema que responde rápido con 500 no es rápido |
| Optimizar sin perfilar | Se optimiza lo que no era el cuello de botella |
| Probar solo el happy path | Los problemas aparecen con datos reales y operaciones mezcladas |
