# Patesi — Flujo de Quality Gate

Este workflow define cómo Patesi evalúa una puerta de calidad.

---

## Flujo

```
┌─────────────────────────────────────┐
│  EVALUACIÓN DE GATE                 │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  1. Identificar gate actual         │
│     (QG0-QG7)                      │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  2. Cargar requisitos del gate      │
│     (skills sdet-sqem-gates)        │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  3. Evaluar cada criterio           │
│     PASS / WARNING / FAIL / N/A     │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  4. Identificar gaps                │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  5. Recomendar acciones             │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  6. Dar veredicto final             │
│     PASS / WARNING / FAIL           │
└─────────────────────────────────────┘
```

---

## Detalle de Cada Paso

### Paso 1: Identificar Gate

Preguntar al usuario o detectar del contexto:
- ¿En qué gate estamos? (QG0-QG7)
- ¿Cuál es la tipología del proyecto?
- ¿Cuál es el NAQ?

### Paso 2: Cargar Requisitos

Cargar `sdet-sqem-gates` para obtener:
- Criterios del gate específico
- Matriz F/L/C/N/A para la tipología
- Entregables obligatorios
- Criterios no excepables

### Paso 3: Evaluar Criterios

Para cada criterio del gate:

| Resultado | Significado |
|-----------|-------------|
| **PASS** | Evidencia completa, actual, trazable dentro del umbral NAQ |
| **WARNING** | Evidencia parcial, control incompleto, desviación menor |
| **FAIL** | Evidencia ausente/inválida, fuera de umbral, bloqueador |
| **N/A** | No aplica por tipología/NAQ/alcance |

### Paso 4: Identificar Gaps

Listar:
- Criterios que fallaron
- Entregables faltantes
- Controles no ejecutados
- Evidencia incompleta

### Paso 5: Recomendar Acciones

Para cada gap:
- **Acción específica**: Qué hacer
- **Responsable**: Quién debe hacerlo
- **Plazo**: Cuándo debe estar listo
- **Bloqueador**: ¿Bloquea el gate?

### Paso 6: Veredicto Final

| Veredicto | Condición |
|-----------|-----------|
| **PASS** | Todos los criterios PASS, sin gaps bloqueadores |
| **WARNING** | Algunos WARNING pero sin FAIL, con plan de cierre |
| **FAIL** | Al menos un criterio FAIL, requiere excepción formal |

---

## Criterios No Excepables (Hard Blocks)

Estos criterios requieren Direction/Sponsor + QA Manager para override:
- Defecto bloqueante/crítico abierto
- Brecha seria de seguridad/datos/compliance
- Evidencia de testing mínima no disponible
- Rollback obligatorio no definido
- Riesgo alto sin mitigación o aceptación formal

---

## Excepciones Formales

Cuando el gate FALLA pero se necesita avanzar:

1. Identificar la excepción requerida
2. Determinar nivel de aprobador según severidad × NAQ
3. Documentar: criterio roto, riesgo, mitigación, aprobador
4. Registrar la excepción formalmente
5. Establecer fecha de cierre

### Escalamiento por Severidad × NAQ

| Severidad | NAQ | Aprobador mínimo |
|-----------|-----|-----------------|
| Menor (deferred) | Cualquiera | PM + QA Lead |
| Medio | Bajo/Medio | PM + Cliente/PO |
| Medio | Alto | QA Manager + Delivery |
| Alto (bloqueador, seguridad, datos, compliance) | Cualquiera | **Direction/Sponsor + QA Manager** |
