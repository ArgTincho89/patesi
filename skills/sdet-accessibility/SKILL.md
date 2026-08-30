---
name: sdet-accessibility
description: >
  Testing de accesibilidad web: criterios WCAG por nivel, qué se automatiza y qué no, navegación por teclado, lectores de pantalla y herramientas.
  Trigger: accesibilidad, a11y, WCAG, lector de pantalla, navegación por teclado, contraste, ARIA
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-core
---

# Testing de accesibilidad

La accesibilidad es lo primero que se cae en un proyecto y lo último que se testea. Este skill existe para invertir eso.

**Por qué importa, sin moralina:** una barrera de accesibilidad excluye usuarios reales de forma silenciosa —no generan reporte de error, simplemente se van—. Además, en muchos contextos es exigencia legal, no preferencia.

---

## Lo primero que hay que entender

**El 70% de los problemas de accesibilidad no los detecta ninguna herramienta automática.**

| Qué detecta la automatización | Qué NO detecta |
|-------------------------------|----------------|
| Falta de `alt` en imágenes | Si el `alt` describe algo útil o dice "imagen1" |
| Contraste insuficiente | Si el foco es visible cuando navegás con teclado |
| Falta de etiquetas en formularios | Si el orden de tabulación tiene sentido |
| Atributos ARIA inválidos | Si el ARIA usado es el correcto para ese componente |
| Falta de idioma en `<html>` | Si los mensajes de error se anuncian al lector de pantalla |

**Conclusión práctica:** la herramienta automática es el piso, no el techo. Correrla y declarar la accesibilidad cubierta es autoengaño.

---

## Los 4 principios de WCAG (POUR)

| Principio | Qué exige | Ejemplo de fallo |
|-----------|-----------|------------------|
| **Perceptible** | La información se puede percibir por más de un sentido | Video sin subtítulos; error solo indicado con color rojo |
| **Operable** | Todo se puede usar sin mouse y sin límite de tiempo arbitrario | Menú que solo abre con hover; sesión que expira sin aviso |
| **Comprensible** | El contenido y la operación son predecibles | Formulario que se envía al cambiar un select; error sin explicar cómo corregirlo |
| **Robusto** | Funciona con tecnologías asistivas presentes y futuras | Componente hecho con `<div>` sin semántica ni ARIA |

---

## Niveles de conformidad

| Nivel | Qué significa | Cuándo apuntar acá |
|-------|---------------|--------------------|
| **A** | Mínimo. Sin esto hay barreras totales | Piso absoluto de cualquier sitio público |
| **AA** | Estándar de referencia en la práctica y en la mayoría de las normativas | **Objetivo por defecto** para cualquier producto con usuarios reales |
| **AAA** | Exigente; no siempre alcanzable en todo el sitio | Criterios sueltos donde el contexto lo justifique |

**Recomendación por defecto: AA.** Es lo que piden las normativas habituales y es alcanzable sin rediseñar todo.

---

## Checklist manual mínimo

Esto se hace en diez minutos y encuentra más que cualquier escaneo.

### 1. Navegación por teclado

- [ ] `Tab` recorre todos los elementos interactivos en un orden lógico
- [ ] El foco es **visible** en todo momento — nada de `outline: none` sin reemplazo
- [ ] `Enter` y `Espacio` activan botones; `Escape` cierra modales
- [ ] No hay **trampas de foco**: siempre se puede salir de un componente con teclado
- [ ] En un modal, el foco entra al abrir y vuelve al disparador al cerrar
- [ ] Existe un enlace "saltar al contenido" antes de la navegación

### 2. Contenido

- [ ] Toda imagen informativa tiene `alt` que **describe su función**, no su apariencia
- [ ] Las imágenes decorativas tienen `alt=""`, no un texto inventado
- [ ] Los encabezados bajan de nivel sin saltos (`h1` → `h2` → `h3`)
- [ ] Los enlaces se entienden fuera de contexto: "ver factura", no "hacé clic acá"
- [ ] El contraste cumple 4.5:1 en texto normal y 3:1 en texto grande

### 3. Formularios

- [ ] Cada campo tiene su `<label>` asociado, no solo un placeholder
- [ ] Los errores se anuncian al lector de pantalla, no solo se pintan de rojo
- [ ] El mensaje de error dice **cómo corregir**, no solo que hay un error
- [ ] Los campos obligatorios se indican con texto, no solo con un asterisco de color

### 4. Sin depender del color

- [ ] Ningún estado se comunica **solo** con color (error, éxito, seleccionado)
- [ ] Los gráficos distinguen series por forma o patrón además de color

---

## Qué automatizar

| Verificación | Automatizable | Herramienta típica |
|--------------|---------------|--------------------|
| Reglas WCAG mecánicas | ✅ En CI, en cada PR | axe-core, Pa11y, Lighthouse |
| Contraste de color | ✅ | axe-core, herramientas de diseño |
| Estructura de encabezados | ✅ | axe-core |
| Orden y visibilidad del foco | ⚠️ Parcial | Tests E2E con aserciones sobre `document.activeElement` |
| Calidad del texto alternativo | ❌ Manual | Revisión humana |
| Navegación con lector de pantalla | ❌ Manual | NVDA, VoiceOver, JAWS |
| Comprensibilidad de los errores | ❌ Manual | Revisión humana |

**Integración recomendada:** `axe-core` en los tests E2E que ya tenés. Cuesta pocas líneas por test y detecta regresiones automáticamente.

---

## Herramientas

| Uso | Herramientas |
|-----|--------------|
| Motor de reglas en CI | axe-core, Pa11y, Lighthouse CI |
| Extensión de navegador | axe DevTools, WAVE, Accessibility Insights |
| Lectores de pantalla | NVDA (Windows, gratis), VoiceOver (macOS/iOS), TalkBack (Android) |
| Contraste | Contrast Checker de WebAIM |

**Consejo:** aprendé lo mínimo de NVDA o VoiceOver —encender, tabular, escuchar—. Media hora de práctica cambia por completo cómo mirás una interfaz.

---

## Errores frecuentes

| Error | Por qué falla |
|-------|---------------|
| "Pasamos Lighthouse con 100" | Lighthouse cubre un subconjunto de reglas mecánicas. No prueba usabilidad real con tecnología asistiva |
| `outline: none` sin reemplazo | Deja a quien navega con teclado sin saber dónde está |
| ARIA puesto por las dudas | ARIA mal usado es **peor** que no usarlo. Preferí HTML semántico: `<button>` antes que `<div role="button">` |
| Placeholder como etiqueta | Desaparece al escribir y muchos lectores no lo anuncian |
| Dejar accesibilidad para el final | Corregirla después es rediseñar. En diseño cuesta poco; en producción cuesta un rehacer |
