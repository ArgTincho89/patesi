---
name: sdet-project-learning
description: >
  Almacena y recupera patrones de QA específicos del proyecto usando memoria persistente.
  Trigger: aprender del proyecto, recordar patrones, guardar convenciones QA
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-sdet
---

# Aprendizaje del proyecto (memoria persistente)

Almacena y recupera patrones de QA específicos del proyecto. Usalo cuando el usuario quiera recordar convenciones, aprender del proyecto o recuperar decisiones anteriores.

## Formato de almacenamiento

### Categorías de patrones

| Categoría | Ejemplo | Cuándo almacenar |
|----------|---------|---------------|
| **test-naming** | "Los tests usan `describe('Feature')` con `it('should X')`" | Tras analizar la suite de tests |
| **framework** | "El proyecto usa Playwright con fixtures, no page objects" | Al descubrir patrones de framework |
| **coverage** | "El módulo de pagos no tiene tests de integración" | Al encontrar gaps de cobertura |
| **cicd** | "Los checks de PR ejecutan la clase S+M; los nocturnos, la clase L" | Al conocer la configuración de CI/CD |
| **bug-pattern** | "El módulo de autenticación regresiona seguido en el refresco de tokens" | Al descubrir bugs recurrentes |
| **convention** | "Todos los archivos de test terminan en `.spec.ts`, no en `.test.ts`" | Al encontrar convenciones de nombres |
| **stack** | "Next.js 14 + Prisma + PostgreSQL; despliegue en Vercel" | Al identificar tecnología y despliegue |
| **code-convention** | "Errores de dominio con clases propias, nunca `throw` de strings" | Al leer código de producción |
| **risk-area** | "El cálculo de precios concentra la lógica de negocio crítica" | Al identificar dónde duele un fallo |

### Comando de almacenamiento

Almacená los patrones usando el mecanismo de persistencia disponible en tu entorno. El formato de la clave siempre es:

```
qa-patterns/{project}/{pattern-name}
```

Estructura del contenido:
```
## Patrón: {nombre}
## Categoría: {categoría}
## Descripción: {en qué consiste el patrón}
## Ejemplo: {ejemplo concreto}
## Aplicar cuando: {condiciones para usar este patrón}
```

### Comando de recuperación

Buscá patrones por clave: `qa-patterns/{project}`

## Flujo de trabajo

### Fase de aprendizaje (cuando el usuario dice "Aprendé del proyecto")

1. **Analizar la suite de tests existente** — Leer los archivos de test y contar patrones
2. **Identificar convenciones** — Nombres, estructura, frameworks usados
3. **Encontrar gaps** — Qué está testeado y qué no
4. **Almacenar patrones** — Guardar cada patrón con su etiqueta de categoría
5. **Reportar hallazgos** — Contarle al usuario qué se aprendió

### Proyecto sin tests

**No hay suite que analizar no significa que no haya nada que aprender.** Es el caso más común en proyectos personales, y es justo donde más valor aporta aprender primero y proponer después.

Cuando no existe suite de tests, aprendé de estas tres fuentes:

**1. Stack y despliegue** → categoría `stack`

- Lenguaje, framework, gestor de dependencias y versiones
- Base de datos y servicios externos de los que depende
- Dónde y cómo se despliega; si hay pipeline de CI
- Qué infraestructura de testing ya existe aunque no se use (un `jest.config` huérfano cuenta)

**2. Convenciones del código de producción** → categoría `code-convention`

El código de producción ya declara cómo va a tener que escribirse el código de test:

- Cómo se organizan los módulos y dónde vive la lógica de negocio
- Cómo se manejan los errores: excepciones propias, códigos de retorno, resultados tipados
- Si hay inyección de dependencias o todo está acoplado — determina qué se puede testear sin refactorizar
- Estilo de nombres, tipado, formato

**3. Historial de bugs** → categoría `bug-pattern` y `risk-area`

Si hay historial de git, issues o changelog, ahí está la evidencia empírica de dónde falla este proyecto:

- Qué archivos concentran más correcciones (`git log` sobre commits de fix)
- Qué módulos aparecen repetidamente en mensajes de bug
- Qué defectos volvieron a aparecer después de estar corregidos

**Por qué importa:** un historial de bugs concentrado en un módulo es la mejor señal disponible sobre dónde empezar a testear. Vale más que cualquier estimación teórica de riesgo, porque son fallos que ya ocurrieron en este proyecto concreto.

**Salida esperada:** en lugar de "no hay tests, no puedo aprender", entregá un mapa del proyecto con las zonas de mayor riesgo identificadas y una propuesta de por dónde empezar, explicando el criterio.

### Fase de aplicación (al generar una salida específica del proyecto)

1. **Buscar patrones** — Consultar los patrones almacenados de este proyecto
2. **Aplicar patrones** — Seguir las convenciones almacenadas al generar código
3. **Informar adhesión** — Indicar al usuario qué patrones se siguieron

## Ejemplo de salida de aprendizaje

```markdown
# Aprendizaje del proyecto: {Nombre del proyecto}

## Análisis completado

### Resumen de la suite de tests
- Total de archivos de tests: {N}
- Framework de tests: {Jest/Playwright/etc.}
- Ubicación de los tests: `{directorio}`
- Patrón de archivos: `{patrón}`

### Patrones descubiertos

| Categoría | Patrón | Ejemplo |
|----------|---------|---------|
| test-naming | {descripción} | `{ejemplo}` |
| framework | {descripción} | `{ejemplo}` |
| convention | {descripción} | `{ejemplo}` |

### Brechas de cobertura encontradas
- {Área 1}: {Qué falta}
- {Área 2}: {Qué falta}

### Patrones almacenados
- ✅ `qa-patterns/{project}/test-naming-convention`
- ✅ `qa-patterns/{project}/framework-preference`
- ✅ `qa-patterns/{project}/coverage-gaps`
```

## Degradación controlada

Si la memoria persistente no está disponible en el entorno actual:
1. **Notificar al usuario**: "La memoria persistente no está disponible; los patrones del proyecto no se recordarán entre sesiones"
2. **Continuar trabajando**: Todos los demás skills funcionan normalmente
3. **Ofrecer alternativas**: Sugerir al usuario que anote manualmente los patrones importantes

## Ejemplo de entrada

```
Usuario: "Aprendé de la suite de tests de este proyecto y recordá los patrones"
```

## Ejemplo de salida

```markdown
# Aprendizaje del proyecto: aplicación de comercio electrónico

## Análisis completado

### Resumen de la suite de tests
- Total de archivos de tests: 47
- Framework de tests: Playwright + TypeScript
- Ubicación de los tests: `tests/`
- Patrón de archivos: `*.spec.ts`

### Patrones descubiertos

| Categoría | Patrón | Ejemplo |
|----------|---------|---------|
| test-naming | Los tests usan `describe('Feature')` con `it('should X')` | `describe('Checkout')` / `it('should calculate total')` |
| framework | Usa el patrón Page Object Model | `pages/LoginPage.ts`, `pages/CartPage.ts` |
| convention | Los tests se etiquetan con `@smoke`, `@functional`, `@regression` | `test.describe '{@smoke} Login', ...)` |
| cicd | Los smoke tests corren en cada commit; la regresión, en el build nocturno | Workflow de GitHub Actions |

### Brechas de cobertura encontradas
- Módulo de pagos: sin tests de integración con Stripe
- Perfil de usuario: sin tests para la subida de avatar
- Búsqueda: sin tests de performance

### Patrones almacenados
- ✅ `qa-patterns/ecommerce/test-naming-convention`
- ✅ `qa-patterns/ecommerce/framework-patterns`
- ✅ `qa-patterns/ecommerce/test-tags`
- ✅ `qa-patterns/ecommerce/cicd-strategy`
- ✅ `qa-patterns/ecommerce/coverage-gaps`
```
