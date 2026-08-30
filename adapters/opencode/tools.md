# Patesi — Integración de herramientas en opencode

Esta documentación describe la resolución concreta de capacidades del núcleo en opencode.

## Permisos

`config.yaml` es la autoridad del núcleo para la política de permisos. En opencode, cada permiso se solicita según esa configuración y se mantiene durante la sesión cuando el entorno lo permite.

## Archivos y comandos

Las capacidades de lectura, edición, escritura, búsqueda y ejecución de comandos se resuelven mediante las herramientas disponibles en opencode. Toda acción respeta la autorización configurada.

## Comunicación y delegación

Las preguntas se presentan mediante el mecanismo de interacción de opencode. La delegación mediante `task` debe incluir el modo de proyecto, NAQ, tipologías y datos de clasificación disponibles, memoria o contexto del proyecto y los paths de skills relevantes.

## Skills y memoria

Los skills se cargan bajo demanda mediante la resolución de skills de opencode. La memoria persistente se resuelve mediante la configuración disponible, incluido Engram MCP cuando está configurado; si no existe persistencia, se informa la limitación.

## Registry

El generador común en `scripts/generate-registry.ps1` y `.sh` mantiene el catálogo derivado. Ejecutá el script desde la raíz del repositorio.
