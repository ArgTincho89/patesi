# Patesi — Herramientas Disponibles

Este archivo documenta todas las herramientas que Patesi tiene disponibles y cuándo usarlas.

---

## Política de Permisos

**config.yaml es la autoridad única.** Todos los permisos se rigen por el bloque `permission` de config.yaml.

- **Zero-trust por defecto**: cada acción requiere confirmación (`ask`)
- **Sesión-scoped**: Patesi pide permisos al inicio y los recuerda durante la sesión
- **No hay comandos "permitidos sin confirmación"** — esto es intencional para un agente QA que maneja archivos de producción

Cuando un permiso es `ask`, Patesi presenta:
1. Qué va a hacer exactamente
2. Por qué lo necesita
3. El comando o acción específica
4. Espera confirmación antes de ejecutar

---

## Herramientas de Archivos

| Herramienta | Para qué | Cuándo usar |
|-------------|----------|-------------|
| `read` | Leer archivos y directorios | Cuando necesitás contenido de un archivo |
| `write` | Crear o sobrescribir archivos | Para generar entregables nuevos |
| `edit` | Editar archivos existentes | Para modificar archivos que ya existen |
| `glob` | Buscar archivos por patrón | Cuando buscás archivos por nombre |
| `grep` | Buscar contenido en archivos | Cuando buscás un patrón en el código |

---

## Herramientas de Terminal

| Herramienta | Para qué | Cuándo usar |
|-------------|----------|-------------|
| `bash` | Ejecutar comandos | Para git, npm, pytest, etc. |

Todos los comandos requieren confirmación según la política de `config.yaml`.

---

## Herramientas de Comunicación

| Herramienta | Para qué | Cuándo usar |
|-------------|----------|-------------|
| `question` | Hacer preguntas al usuario | Cuando necesitás aclarar algo antes de generar |
| `task` | Delegar a sub-agentes | Para tareas complejas que requieren contexto fresco |

---

## Herramientas de Memoria

| Herramienta | Para qué | Cuándo usar |
|-------------|----------|-------------|
| `skill` | Cargar un skill | Cuando la solicitud coincide con un trigger |
| `mem_save` | Guardar en memoria | Para persistir patrones, decisiones, contexto |
| `mem_search` | Buscar en memoria | Para recuperar contexto de sesiones anteriores |
| `mem_context` | Ver contexto reciente | Para ver qué se hizo en sesiones recientes |

> **Nota**: Las herramientas de memoria (`mem_*`) pueden no estar disponibles en todos los entornos.
> Si no están disponibles, Patesi usará archivos como fallback o informará que la persistencia no es posible.

---

## Reglas de Uso

1. **Permisos first** — Antes de cualquier acción, consultá la política de permisos en config.yaml
2. **Leer antes de escribir** — Siempre leé un archivo antes de editarlo
3. **Preferir edición sobre escritura** — Si el archivo existe, editalo en vez de sobreescribir
4. **Confirmar antes de borrar** — Siempre preguntá antes de eliminar archivos
5. **Git para estado** — Usá git status/diff/log para entender el estado del proyecto
6. **Skills bajo demanda** — No cargues skills proactivamente, solo cuando se piden
7. **Memoria para persistencia** — Guardá descubrimientos importantes sin que te lo pidan
