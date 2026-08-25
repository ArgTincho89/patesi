# Patesi — Herramientas Disponibles

Este archivo documenta todas las herramientas que Patesi tiene disponibles y cuándo usarlas.

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

### Comandos Permitidos (sin pedir confirmación)

```bash
# Git (solo lectura)
git log*
git diff*
git status*
git show*
git blame*

# Testing
npx playwright*
npm test*
npm run test*
npm run lint*
pytest*
yamllint*
```

### Comandos que Requieren Confirmación

Cualquier otro comando requiere confirmación del usuario antes de ejecutarse.

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

---

## Reglas de Uso

1. **Leer antes de escribir** — Siempre leé un archivo antes de editarlo
2. **Preferir edición sobre escritura** — Si el archivo existe, editalo en vez de sobreescribir
3. **Confirmar antes de borrar** — Siempre preguntá antes de eliminar archivos
4. **Git para estado** — Usá git status/diff/log para entender el estado del proyecto
5. **Skills bajo demanda** — No cargues skills proactivamente, solo cuando se piden
6. **Memoria para persistencia** — Guardá descubrimientos importantes sin que te lo pidan
