---
name: sdet-mr-analysis
description: >
  Analiza merge requests y pull requests para detectar impacto en tests y potencial de roturas.
  Trigger: análisis de MR, análisis de PR, review de código para testing, impacto en tests
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-sdet
---

# Analizador de merge requests

Analiza merge requests/PRs e identifica impacto potencial en tests, riesgo de rotura y acciones recomendadas. Usalo cuando el usuario quiera saber qué tests ejecutar o qué podría romperse por un cambio de código.

## Salida del análisis

El análisis DEBE producir:

1. **Resumen de archivos modificados** — Lista de archivos modificados con tipo de cambio (agregado/modificado/eliminado)
2. **Evaluación de impacto** — Qué tests existentes podrían verse afectados
3. **Nivel de riesgo** — Bajo/Medio/Alto según alcance y ubicación del cambio
4. **Tests recomendados** — Qué clases de tests ejecutar para validar
5. **Cobertura faltante** — Áreas modificadas que no cubren los tests existentes

## Formato de salida

```markdown
# Análisis de MR: {Título del MR/PR}

## Resumen

| Métrica | Valor |
|---------|-------|
| Archivos modificados | {N} |
| Líneas agregadas | {N} |
| Líneas eliminadas | {N} |
| Nivel de riesgo | {🟢 Bajo / 🟡 Medio / 🔴 Alto} |

## Archivos modificados

| Archivo | Tipo de cambio | Área de impacto | Riesgo |
|---------|----------------|-----------------|--------|
| {path} | Agregado/Modificado/Eliminado | {Módulo/Feature} | Alto/Medio/Bajo |

## Evaluación de impacto

### Módulos afectados
- **{Módulo 1}**: {Cómo se ve afectado}
- **{Módulo 2}**: {Cómo se ve afectado}

### Archivos de tests afectados
| Archivo de test | Estado | Motivo |
|-----------------|--------|--------|
| {archivo de test} | Puede requerir actualización | {Por qué} |
| {archivo de test} | Sin impacto | {Por qué} |

## Análisis de riesgos

| Factor de riesgo | Puntaje | Justificación |
|------------------|---------|---------------|
| Alcance del cambio | {1-5} | {N} archivos modificados |
| Impacto en el camino crítico | {1-5} | {Afecta login/pagos/etc.} |
| Cobertura de tests | {1-5} | {X}% del código modificado tiene tests |
| Impacto en dependencias | {1-5} | {Cantidad de módulos dependientes} |

**Riesgo global: {🔴 ALTO / 🟡 MEDIO / 🟢 BAJO}**

## Tests recomendados

### Deben ejecutarse (antes del merge)
- {TC-XXX}: {Nombre del test} — {Por qué}

### Deberían ejecutarse (antes del deploy)
- {TC-XXX}: {Nombre del test} — {Por qué}

### Considerar ejecutar
- {TC-XXX}: {Nombre del test} — {Por qué}

## Cobertura faltante

| Área modificada | ¿Tiene tests? | Recomendación |
|-------------|------------|----------------|
| {Archivo/Función} | ❌ No | Agregar tests antes del merge |
| {Archivo/Función} | ⚠️ Parcial | Ampliar la cobertura de tests |
| {Archivo/Función} | ✅ Sí | Verificar que los tests pasen |

## Recomendaciones

1. **{Acción 1}**: {Recomendación concreta}
2. **{Acción 2}**: {Recomendación concreta}
3. **{Acción 3}**: {Recomendación concreta}
```

## Determinación del nivel de riesgo

> **Nota**: Esta matriz es para análisis de MRs/PRs específicos (scope limitado al cambio).
> Para análisis de features/user stories a nivel estratégico, usá `sdet-risk-analysis`
> que usa una matriz de 5 factores con pesos (30/25/20/15/10).

| Factor | Bajo (1) | Medio (3) | Alto (5) |
|--------|----------|-----------|----------|
| Archivos modificados | 1-3 | 4-10 | Más de 10 |
| Camino crítico | No | Indirecto | Directo (autenticación, pagos, datos) |
| Cobertura de tests | >80% | 40-80% | <40% |
| Dependencias | Ninguna | 1-2 módulos | 3+ módulos |

**Cálculo del puntaje**: promedio de todos los factores
- 1.0 - 2.0: 🟢 BAJO
- 2.1 - 3.5: 🟡 MEDIO
- 3.6 - 5.0: 🔴 ALTO

## Ejemplo de análisis

### Entrada

```
MR: "Refactor user authentication to use JWT tokens"
Archivos modificados:
- src/auth/login.ts (modified)
- src/auth/token.ts (new)
- src/auth/middleware.ts (modified)
- src/routes/api.ts (modified)
- tests/auth/login.test.ts (modified)
```

### Salida

```markdown
# Análisis de MR: Refactorizar la autenticación de usuarios para usar tokens JWT

## Resumen

| Métrica | Valor |
|---------|-------|
| Archivos modificados | 5 |
| Líneas agregadas | ~200 |
| Líneas eliminadas | ~80 |
| Nivel de riesgo | 🔴 Alto |

## Archivos modificados

| Archivo | Tipo de cambio | Área de impacto | Riesgo |
|---------|----------------|-----------------|--------|
| src/auth/login.ts | Modificado | Autenticación | Alto |
| src/auth/token.ts | Agregado | Autenticación | Alto |
| src/auth/middleware.ts | Modificado | Middleware de autenticación | Alto |
| src/routes/api.ts | Modificado | Ruteo de la API | Medio |
| tests/auth/login.test.ts | Modificado | Tests de autenticación | Medio |

## Evaluación de impacto

### Módulos afectados
- **Autenticación**: se refactorizó el flujo central de login — todos los tests de autenticación deben pasar
- **Rutas de la API**: los cambios de middleware afectan a TODAS las rutas protegidas
- **Gestión de sesiones**: la autenticación por token reemplaza a la basada en sesión

### Archivos de tests afectados
| Archivo de test | Estado | Motivo |
|-----------------|--------|--------|
| tests/auth/login.test.ts | Actualizado | Debe verificar el nuevo flujo JWT |
| tests/auth/middleware.test.ts | Requiere actualización | Cambió el comportamiento del middleware |
| tests/routes/api.test.ts | Puede requerir actualización | Las rutas protegidas usan el nuevo middleware |

## Análisis de riesgos

| Factor de riesgo | Puntaje | Justificación |
|------------------|---------|---------------|
| Alcance del cambio | 4 | 5 archivos, módulo central de autenticación |
| Impacto en el camino crítico | 5 | La autenticación es camino crítico |
| Cobertura de tests | 3 | Existen tests de autenticación, pero el middleware no está testeado |
| Impacto en dependencias | 4 | TODAS las rutas protegidas dependen de la autenticación |

**Riesgo global: 🔴 ALTO**

## Tests recomendados

### Deben ejecutarse (antes del merge)
- TC-AUTH-001: Login con credenciales válidas — Verificar la generación del token JWT
- TC-AUTH-002: Login con credenciales inválidas — Verificar el manejo de errores
- TC-AUTH-003: Expiración de token — Verificar que se rechacen los tokens vencidos
- TC-AUTH-004: Acceso a ruta protegida — Verificar que el middleware funcione con JWT

### Deberían ejecutarse (antes del deploy)
- TC-AUTH-005: Flujo de refresco de token — Verificar la renovación transparente del token
- TC-API-001: Todos los endpoints de la API con autenticación — Verificar que no haya regresión

### Considerar ejecutar
- TC-PERF-001: Performance del login — JWT puede ser más rápido o más lento que las sesiones

## Cobertura faltante

| Área modificada | ¿Tiene tests? | Recomendación |
|-------------|------------|----------------|
| src/auth/token.ts | ❌ No (archivo nuevo) | OBLIGATORIO agregar tests antes del merge |
| src/auth/middleware.ts | ⚠️ Parcial | Ampliar tests para corner cases |
| src/auth/login.test.ts | ✅ Sí | Verificar que todos los escenarios sigan pasando |

## Recomendaciones

1. **BLOQUEAR EL MERGE**: el archivo nuevo `src/auth/token.ts` no tiene tests — agregar tests unitarios
2. **AGREGAR TESTS**: corner cases de validación del token JWT (vencido, malformado, ausente)
3. **TESTS DE INTEGRACIÓN**: probar el flujo completo de autenticación con llamadas reales a la API
4. **PERFORMANCE**: hacer benchmark de JWT frente a sesiones, antes y después
5. **REVISIÓN DE SEGURIDAD**: revisar la implementación de JWT contra buenas prácticas de seguridad
```
