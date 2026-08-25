# Patesi — Flujo de Nuevo Proyecto

Este workflow define cómo Patesi assessment un proyecto nuevo.

---

## Flujo

```
┌─────────────────────────────────────┐
│  NUEVO PROYECTO                     │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  1. Ejecutar inicio de sesión       │
│     (ver workflows/session-start)   │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  2. Análisis inicial del proyecto    │
│     - Stack tecnológico             │
│     - Frameworks de testing         │
│     - Área de riesgo conocida       │
│     - Madurez de testing            │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  3. Generar assessment inicial       │
│     - Fortalezas actuales           │
│     - Gaps identificados            │
│     - Recomendaciones priorizadas   │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  4. Guardar contexto en memoria     │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  5. Presentar resumen al usuario    │
│     y preguntar por dónde empezar   │
└─────────────────────────────────────┘
```

---

## Análisis Inicial

### Stack Tecnológico

Preguntar o detectar:
- Lenguaje de programación
- Framework de backend
- Framework de frontend
- Base de datos
- Infraestructura (cloud, on-prem)

### Frameworks de Testing en Uso

Preguntar o detectar:
- Framework de unit tests (Jest, JUnit, pytest, etc.)
- Framework de E2E (Playwright, Cypress, Selenium)
- Framework de API testing (REST Assured, Supertest, etc.)
- Herramientas de CI/CD (GitHub Actions, GitLab CI, Jenkins)

### Área de Riesgo Conocida

Preguntar o detectar:
- Módulos con historial de bugs
- Componentes con alta complejidad
- Integraciones con sistemas externos
- Datos sensibles

### Madurez de Testing

Evaluar:
- **Básica**: Tests manuales, sin automatización
- **Intermedia**: Unit tests, CI básico
- **Avanzada**: E2E automatizado, CI/CD completo
- **Experta**: Quality gates, métricas, dashboards

---

## Assessment Inicial

### Fortalezas Actuales

Listar lo que ya está bien:
- Tests que existen y funcionan
- Procesos que están establecidos
- Herramientas que ya se usan

### Gaps Identificados

Listar lo que falta:
- Tipos de testing no cubiertos
- Áreas sin tests
- Procesos no establecidos
- Herramientas no utilizadas

### Recomendaciones Priorizadas

Para cada gap:
- **Prioridad**: P1/P2/P3
- **Impacto**: Qué se gana al implementar
- **Esfuerzo**: Cuánto trabajo requiere
- **Quick win**: ¿Es factible de hacer rápido?

---

## Output

Presentar al usuario:

```
## Assessment del Proyecto: {nombre}

### Stack Detectado
- Backend: {tecnología}
- Frontend: {tecnología}
- DB: {tecnología}
- CI/CD: {herramienta}

### Estado Actual de Testing
- Madurez: {Básica/Intermedia/Avanzada/Experta}
- Fortalezas: {lista}
- Gaps: {lista}

### Recomendaciones (ordenadas por prioridad)
1. {recomendación P1}
2. {recomendación P2}
3. {recomendación P3}

¿Por dónde querés empezar?
```
