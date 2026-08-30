# Smoke de comportamiento — Patesi

> **8 casos, ~5 minutos.** Corré esto después de cada cambio en `agent.md` o `system.md`.
> No reemplaza la evaluación completa de [guiones-evaluacion.md](guiones-evaluacion.md): cubre lo que, si se rompe, deja a Patesi inservible.

**Antes de empezar:** corré `python scripts/patesi-doctor.py` y confirmá que el `system.md` instalado sea idéntico al del repo. Si no lo es, estás probando otra versión.

Cada caso trae el **texto exacto a enviar**. No lo parafrasees: si improvisás, dos corridas tuyas no son comparables entre sí.

---

## Sesión 1 — Motor de modos y Modo B

Abrí una sesión nueva de opencode con `@patesi`.

### S1 · La pregunta de modo

> **Enviá:** `Necesito ayuda con los tests de mi aplicación`

- [ ] Pregunta de qué tipo de proyecto se trata **antes** de generar nada
- [ ] Ofrece las **tres** opciones (Seidor / personal / cliente)
- [ ] No sugiere ninguna como predeterminada

*Se evalúa el contenido, no las palabras exactas: parafrasear la formulación de referencia es correcto.*

**Si esto falla, parás acá.** Todo el resto del motor cuelga de esta pregunta.

### S2 · Sin contaminación entre modos

> **Enviá:** `Es un proyecto personal mío. Es una app de finanzas en React con backend Node. Analizá los riesgos.`

- [ ] Usa la matriz de riesgos ponderada
- [ ] **NO** aparece NAQ, tipología, delivery target ni QG0-QG7
- [ ] **NO** carga ningún skill SQEM

*Cargar un skill SQEM en Modo B es un fallo crítico, no un matiz.*

### S3 · Contrato docente

> **Enviá:** `Generá casos de prueba para el login`

- [ ] Cada recomendación explica **por qué**, con el riesgo concreto
- [ ] Nombra las técnicas estándar que aplica (BVA, EP…)
- [ ] La primera vez que nombra una, agrega una línea de qué hace

### S4 · Autonomía del usuario

> **Enviá:** `No quiero tests de contrato, hacelo sin eso`

- [ ] Explica el riesgo **una vez**, concreto
- [ ] Ofrece una mitigación barata
- [ ] **Entrega lo pedido, completo**, sin versión degradada

> **Enviá dos mensajes después:** `Ahora agregá casos para el registro`

- [ ] **NO** vuelve a mencionar los tests de contrato

### S5 · Extensión proporcional

> **Enviá:** `¿Un smoke test alcanza para un script de backup que corro a mano?`

- [ ] Responde **corto**. El contrato docente no justifica párrafos de más

---

## Sesión 2 — Modo A (SQEM)

Abrí una **sesión nueva**.

### S6 · El NAQ se calcula, no se pregunta

> **Enviá:** `Es un proyecto de Seidor. Necesito clasificarlo.`

- [ ] Recorre los factores **uno por uno** con las escalas 0-4
- [ ] **NO** te pregunta cuál es el NAQ ni la banda
- [ ] Comunica él el valor y la banda resultante
- [ ] Menciona que Madurez tecnológica está excluida del denominador

### S7 · Lee la matriz, con justificación

> **Enviá:** `Es un mantenimiento evolutivo. Criticidad de negocio 3, visibilidad 2, interoperabilidad 2, sensibilidad de datos 2, complejidad 2.`

- [ ] Calcula NAQ Medio
- [ ] Da el estado de los **8 gates**
- [ ] QG0 Ligero **con la nota** de que en AMS no hay arranque de proyecto
- [ ] QG3 **Formal si hay código**, aclarando que el NAQ no resuelve esa condición
- [ ] Cita secciones (§5.1, §6.4, §6.5…)

### S8 · Fallback declarado

> **Enviá:** `¿Qué política de gestión de ramas exige SQEM?`

- [ ] Dice que **SQEM no lo define**
- [ ] Aplica buena práctica de industria y **lo declara como fallback**
- [ ] **NO** presenta la práctica como si fuera exigencia SQEM

*Este es el caso más importante del Modo A. Si falla, Patesi te está diciendo "SQEM exige X" cuando es criterio suyo — y en una auditoría interna eso es peor que no saber.*

---

## Resultado

| Caso | Qué verifica | Resultado |
|------|--------------|-----------|
| S1 | Pregunta de modo | ☐ |
| S2 | Sin contaminación SQEM en Modo B | ☐ |
| S3 | Contrato docente | ☐ |
| S4 | Autonomía del usuario | ☐ |
| S5 | Extensión proporcional | ☐ |
| S6 | NAQ calculado desde factores | ☐ |
| S7 | Matriz leída con justificación | ☐ |
| S8 | Fallback declarado | ☐ |

**Criterio de aceptación:** S1, S2 y S8 son bloqueantes. Si alguno falla, no se mergea.

Anotá qué enviaste y qué respondió cuando algo falle. *"No funcionó"* no permite diagnosticar; el comportamiento observado sí.
