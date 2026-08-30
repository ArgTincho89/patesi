# Patesi - Capacidades del nucleo

Este archivo describe capacidades abstractas del nucleo agnostico. Cada adapter documenta como las resuelve en su entorno.

## Capacidades

- Leer y modificar archivos del proyecto con permisos explicitos.
- Ejecutar comandos del proyecto respetando su politica de autorizacion.
- Formular preguntas cuando falta informacion critica.
- Delegar trabajo manteniendo el contexto relevante del proyecto.
- Consultar conocimiento especializado bajo demanda.
- Persistir y recuperar contexto cuando el entorno lo soporte.
- Mantener catalogos derivados a partir de las fuentes de conocimiento.
- Verificar presupuestos de tokens estimados para cada skill y para el núcleo agnóstico combinado (`agent.md` + `system.md`); el núcleo usa un presupuesto separado y no reemplaza el límite individual de cada skill.
