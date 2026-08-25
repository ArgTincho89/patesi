# Patesi — Auto-Revisión

Este archivo define la checklist de auto-revisión que Patesi ejecuta ANTES de presentar cualquier output al usuario.

---

## Checklist de Auto-Revisión

### Completitud

- [ ] ¿El output cubre todo lo que el usuario pidió?
- [ ] ¿Faltan secciones obligatorias para este tipo de deliverable?
- [ ] ¿Todos los campos requeridos están completos?
- [ ] ¿Hay placeholder text que debería ser contenido real?

### Precisión

- [ ] ¿Las referencias ISTQB/SQEM son correctas?
- [ ] ¿Los cálculos de riesgo son consistentes con los inputs?
- [ ] ¿Los casos de prueba cubren happy/unhappy/corner?
- [ ] ¿Las prioridades son consistentes con el análisis de riesgos?

### Cobertura

- [ ] ¿Se cubrieron los tres tipos de casos (happy/unhappy/corner)?
- [ ] ¿Los gaps de cobertura están explícitamente listados?
- [ ] ¿El porcentaje de cobertura es consistente con el análisis?

### Consistencia

- [ ] ¿El formato es consistente en todo el output?
- [ ] ¿Los términos técnicos se usan consistentemente?
- [ ] ¿Las recomendaciones no se contradicen entre sí?

### Alcance del Proyecto

- [ ] ¿El output es específico para este proyecto (no genérico)?
- [ ] ¿Se aplicaron las convenciones del proyecto cuando se conocen?
- [ ] ¿Se respetó el framework de calidad (SQEM/ISTQB/cliente)?

### Calidad SQEM (Modo A)

- [ ] ¿Se citaron las secciones SQEM aplicables?
- [ ] ¿Se validó contra NAQ + tipología?
- [ ] ¿Se cubrieron los controles obligatorios?
- [ ] ¿Se señaló si hay desviaciones del SQEM?

### Formato

- [ ] ¿El output usa estructura (tablas, lists, etc.)?
- [ ] ¿Es fácil de leer y navegar?
- [ ] ¿Los ejemplos son claros y relevantes?

---

## Errores Comunes a Cazar

### En Estrategias
- Falta de criterios de salida
- No mencionar entorno de testing
- Olvidar componentes NF
- No alinear con NAQ (Modo A)

### En Análisis de Riesgos
- Todos los items con la misma prioridad
- No justificar los pesos
- Olvidar dependencias externas

### En Casos de Prueba
- Solo happy path
- Sin precondiciones
- Sin expected results claros
- Sin priorización

### En Clasificación
- Todos los tests en la misma categoría
- Sin justificación de la clasificación
- Sin estrategia de ejecución

### En Automatización
- Sin Page Object Model
- Tests muy acoplados al DOM
- Sin fixtures para test data

### En CI/CD
- Sin caching
- Sin reportes de cobertura
- Sin manejo de errores

---

## Cuándo Preguntar al Usuario

- Si falta información crítica para generar un deliverable completo
- Si hay ambigüedad real en los requisitos
- Si el usuario pide algo que requiere decisiones de negocio
- Si hay múltiples opciones válidas con trade-offs significativos

**Nunca preguntras por preguntar.** Si podés generar un output útil con la información que tenés, hacelo y mencioná las suposiciones.
