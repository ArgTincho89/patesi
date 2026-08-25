# Patesi — Protocolo de Inicio de Sesión

Este workflow define cómo Patesi inicia cada sesión de trabajo.

---

## Flujo

```
┌─────────────────────────────────────┐
│  INICIO DE SESIÓN                   │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  1. ¿Existe contexto del proyecto?  │
└──────────────┬──────────────────────┘
               │
       ┌───────┴───────┐
       │               │
       ▼               ▼
   ┌───────┐      ┌─────────┐
   │  SÍ   │      │   NO    │
   └───┬───┘      └────┬────┘
       │               │
       ▼               ▼
┌──────────────┐ ┌─────────────────────┐
│ Cargar       │ │ 2. Preguntar tipo   │
│ contexto     │ │    de proyecto      │
└──────┬───────┘ └──────────┬──────────┘
       │                    │
       │            ┌───────┴───────┐
       │            │               │
       │            ▼               ▼
       │     ┌────────────┐  ┌────────────┐
       │     │  Seidor    │  │  Personal  │
       │     └─────┬──────┘  └─────┬──────┘
       │           │               │
       │           ▼               │
       │  ┌────────────────────┐   │
       │  │ 3. Clasificar NAQ  │   │
       │  └─────────┬──────────┘   │
       │            │              │
       │            ▼              │
       │  ┌────────────────────┐   │
       │  │ Derivar delivery   │   │
       │  │ target + controls  │   │
       │  └─────────┬──────────┘   │
       │            │              │
       ▼            ▼              ▼
┌─────────────────────────────────────┐
│  4. Persistir contexto en memoria   │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  5. READY — Listo para trabajar     │
└─────────────────────────────────────┘
```

---

## Detalle de Cada Paso

### Paso 1: Detectar Contexto

Buscar en:
- `memory/context.yaml` (archivo local)
- Engram: `mem_search(query: "qa-patterns/{project}", project: "{project}")`

Si existe → cargar y confirmar con usuario.
Si no existe → continuar al paso 2.

### Paso 2: Preguntar Tipo de Proyecto

Pregunta: _"¿Este es un proyecto de la empresa Seidor, un proyecto personal, o un proyecto gobernado por cliente?"_

- **Seidor** → Paso 3 (Clasificación NAQ)
- **Personal** → ISTQB como framework primario, saltar al paso 4
- **Cliente** → Framework del cliente + SQEM como suficiencia, saltar al paso 4

### Paso 3: Clasificación NAQ (Solo Seidor)

Colectar los 5 factores:

| Factor | Pregunta |
|--------|----------|
| Criticidad de negocio | Impacto si falla (0-4) |
| Visibilidad / uso | Visible para usuarios (0-4) |
| Interoperabilidad | Sistemas externos (0-4) |
| Sensibilidad de datos | Sensibilidad (0-4) |
| Complejidad | Complejidad técnica (0-4) |

Calcular NAQ:
```
NAQ = (Criticidad×8 + Visibilidad×4 + Interop×4 + Sensibilidad×4 + Complejidad×2) / pesos activos
```

Aplicar overrides:
- Criticidad=4 O Sensibilidad=4 → **NAQ Alto forzado**
- Criticidad≥3 Y Sensibilidad≥3 → **mínimo NAQ Medio**

Derivar:
- Delivery Target (Básico / Integrado / Continuo)
- Gates aplicables (QG0-QG7 con F/L/C/N/A)
- Controles obligatorios
- Entregables mínimos

### Paso 4: Persistir Contexto

Guardar en:
- **Engram**: `mem_save(topic_key: "qa-patterns/{project}/context", ...)`
- **Archivos**: `~/.config/opencode/patesi-memory/{project}/context.yaml`

---

## Multi-Proyecto

**CRÍTICO**: Cada proyecto tiene su propio contexto. Al cambiar de proyecto:
1. Guardá el contexto actual
2. Cargá el contexto del nuevo proyecto
3. NUNCA mezcles contextos entre proyectos
