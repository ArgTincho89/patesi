# Patesi — Adaptador para opencode

Usá este adaptador para componer el system prompt en opencode.

```json
{
  "agent": {
    "patesi": {
      "description": "Patesi — Agente SDET de IA",
      "mode": "primary",
      "prompt": "{file:./agent.md}\n\n---\n\n{file:./system.md}",
      "tools": { "edit": true, "write": true }
    }
  }
}
```

## Qué hace este adaptador

1. Carga `agent.md` (identidad, personalidad, principios core)
2. Carga `system.md` (reglas de comportamiento, protocolo de sesión, jerarquía de frameworks)
3. Los skills se auto-descubren desde `skills/` y se cargan bajo demanda vía la herramienta `skill`

## Instalación

### Opción A — Script (recomendado)

```bash
# Linux/macOS
bash scripts/install.sh

# Windows
.\scripts\install.ps1
```

Esto copia el agente y los 13 skills a `~/.config/opencode/`. Después reiniciá opencode y cambiá al agente con **Tab** o `@patesi`.

### Opción B — Manual

1. Copiá `agent.md` a `~/.config/opencode/agents/patesi.md`
2. Copiá `system.md` al mismo directorio (`~/.config/opencode/agents/system.md`)
3. Copiá los directorios `skills/sdet-*/` a `~/.config/opencode/skills/`
4. Agregá a tu `opencode.json`:

```json
{
  "agent": {
    "patesi": {
      "description": "Patesi — Agente SDET de IA",
      "mode": "primary",
      "prompt": "{file:./agents/patesi.md}\n\n---\n\n{file:./agents/system.md}",
      "tools": { "edit": true, "write": true }
    }
  }
}
```

5. Reiniciá opencode.

## Skills

Los skills se cargan bajo demanda cuando la solicitud del usuario coincide con un trigger. Ver `config.yaml` para el registro completo.

### Cuándo cargar skills

- Usuario pregunta sobre ISTQB → `sdet-istqb`
- Usuario pide estrategia de testing → `sdet-test-strategy`
- Usuario pide análisis de riesgos → `sdet-risk-analysis`
- Usuario pide generar casos de prueba → `sdet-test-cases`
- Usuario pide clasificar tests → `sdet-test-classification`
- Usuario pide Playwright/automatización → `sdet-automation`
- Usuario pide pipelines CI/CD → `sdet-cicd`
- Usuario pide analizar un MR/PR → `sdet-mr-analysis`
- Usuario pide aprender de proyecto → `sdet-project-learning`
- Proyecto Seidor + necesita NAQ/clasificación → `sdet-sqem-classification`
- Proyecto Seidor + necesita gates → `sdet-sqem-gates`
- Proyecto Seidor + necesita controles/umbrales → `sdet-sqem-controls`
- Proyecto Seidor + IA/ML/GenAI → `sdet-sqem-ia`
