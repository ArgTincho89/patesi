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
# Análisis de MR: {MR/PR Title}

## Resumen

| Metric | Value |
|--------|-------|
| Files changed | {N} |
| Lines added | {N} |
| Lines deleted | {N} |
| Risk level | {🟢 Low / 🟡 Medium / 🔴 High} |

## Archivos modificados

| File | Change Type | Impact Area | Risk |
|------|------------|-------------|------|
| {path} | Agregado/Modificado/Eliminado | {Módulo/Feature} | Alto/Medio/Bajo |

## Evaluación de impacto

### Módulos afectados
- **{Module 1}**: {How it's affected}
- **{Module 2}**: {How it's affected}

### Archivos de tests afectados
| Test File | Status | Reason |
|-----------|--------|--------|
| {test file} | May need update | {Why} |
| {test file} | No impact | {Why} |

## Análisis de riesgos

| Risk Factor | Score | Justification |
|-------------|-------|---------------|
| Change scope | {1-5} | {N} files changed |
| Critical path impact | {1-5} | {Affects login/payment/etc.} |
| Test coverage | {1-5} | {X}% of changed code has tests |
| Dependency impact | {1-5} | {Number of dependent modules} |

**Overall Risk: {🔴 HIGH / 🟡 MEDIUM / 🟢 LOW}**

## Tests recomendados

### Deben ejecutarse (antes del merge)
- {TC-XXX}: {Test name} — {Why}

### Deberían ejecutarse (antes del deploy)
- {TC-XXX}: {Test name} — {Why}

### Considerar ejecutar
- {TC-XXX}: {Test name} — {Why}

## Cobertura faltante

| Área modificada | ¿Tiene tests? | Recomendación |
|-------------|------------|----------------|
| {File/Function} | ❌ No | Add tests before merge |
| {File/Function} | ⚠️ Partial | Expand test coverage |
| {File/Function} | ✅ Yes | Verify tests pass |

## Recomendaciones

1. **{Action 1}**: {Specific recommendation}
2. **{Action 2}**: {Specific recommendation}
3. **{Action 3}**: {Specific recommendation}
```

## Determinación del nivel de riesgo

> **Nota**: Esta matriz es para análisis de MRs/PRs específicos (scope limitado al cambio).
> Para análisis de features/user stories a nivel estratégico, usá `sdet-risk-analysis`
> que usa una matriz de 5 factores con pesos (30/25/20/15/10).

| Factor | Low (1) | Medium (3) | High (5) |
|--------|---------|------------|----------|
| Files changed | 1-3 | 4-10 | 10+ |
| Critical path | No | Indirect | Direct (auth, payment, data) |
| Test coverage | >80% | 40-80% | <40% |
| Dependencias | Ninguna | 1-2 módulos | 3+ módulos |

**Score calculation**: Average of all factors
- 1.0 - 2.0: 🟢 LOW
- 2.1 - 3.5: 🟡 MEDIUM
- 3.6 - 5.0: 🔴 HIGH

## Ejemplo de análisis

### Input

```
MR: "Refactor user authentication to use JWT tokens"
Files changed:
- src/auth/login.ts (modified)
- src/auth/token.ts (new)
- src/auth/middleware.ts (modified)
- src/routes/api.ts (modified)
- tests/auth/login.test.ts (modified)
```

### Output

```markdown
# Análisis de MR: Refactorizar la autenticación de usuarios para usar tokens JWT

## Summary

| Metric | Value |
|--------|-------|
| Files changed | 5 |
| Lines added | ~200 |
| Lines deleted | ~80 |
| Risk level | 🔴 High |

## Archivos modificados

| File | Change Type | Impact Area | Risk |
|------|------------|-------------|------|
| src/auth/login.ts | Modified | Authentication | High |
| src/auth/token.ts | Added | Authentication | High |
| src/auth/middleware.ts | Modified | Auth middleware | High |
| src/routes/api.ts | Modified | API routing | Medium |
| tests/auth/login.test.ts | Modified | Auth tests | Medium |

## Impact Assessment

### Módulos afectados
- **Authentication**: Core login flow refactored — all auth tests must pass
- **API Routes**: Middleware changes affect ALL protected routes
- **Session Management**: Token-based auth replaces session-based

### Affected Test Files
| Test File | Status | Reason |
|-----------|--------|--------|
| tests/auth/login.test.ts | Updated | Must verify new JWT flow |
| tests/auth/middleware.test.ts | Needs update | Middleware behavior changed |
| tests/routes/api.test.ts | May need update | Protected routes use new middleware |

## Análisis de riesgos

| Risk Factor | Score | Justification |
|-------------|-------|---------------|
| Change scope | 4 | 5 files, core auth module |
| Critical path impact | 5 | Authentication is critical path |
| Test coverage | 3 | Auth tests exist but middleware untested |
| Dependency impact | 4 | ALL protected routes depend on auth |

**Overall Risk: 🔴 HIGH**

## Recommended Tests

### Deben ejecutarse (antes del merge)
- TC-AUTH-001: Login with valid credentials — Verify JWT token generation
- TC-AUTH-002: Login with invalid credentials — Verify error handling
- TC-AUTH-003: Token expiration — Verify expired tokens are rejected
- TC-AUTH-004: Protected route access — Verify middleware works with JWT

### Deberían ejecutarse (antes del deploy)
- TC-AUTH-005: Token refresh flow — Verify seamless token renewal
- TC-API-001: All API endpoints with authentication — Verify no regression

### Consider Running
- TC-PERF-001: Login performance — JWT may be faster/slower than sessions

## Missing Coverage

| Área modificada | ¿Tiene tests? | Recomendación |
|-------------|------------|----------------|
| src/auth/token.ts | ❌ No (new file) | MUST add tests before merge |
| src/auth/middleware.ts | ⚠️ Partial | Expand tests for edge cases |
| src/auth/login.test.ts | ✅ Yes | Verify all scenarios still pass |

## Recommendations

1. **BLOCK MERGE**: New file `src/auth/token.ts` has no tests — add unit tests
2. **ADD TESTS**: JWT token validation edge cases (expired, malformed, missing)
3. **INTEGRATION TESTS**: Test full auth flow with real API calls
4. **PERFORMANCE**: Benchmark JWT vs session auth before/after
5. **SECURITY REVIEW**: JWT implementation should be reviewed for security best practices
```
