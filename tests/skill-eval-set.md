# Conjunto de evaluación de skills — Patesi

> Ejecutá estos prompts contra el agente y verificá que se cargue el skill correcto.
> Para cada prompt, el skill primario esperado es el que se carga PRIMERO (antes que cualquier otro).

## Casos de evaluación

| # | Prompt (lo que dice el usuario) | Skill primario esperado | Skill(s) secundarios esperados |
|---|---------------------------|----------------------|---------------------------|
| 1 | "¿Cuál es la diferencia entre regression testing y confirmation testing según ISTQB?" | sdet-istqb | — |
| 2 | "Creá una estrategia de testing para una feature nueva de procesamiento de pagos" | sdet-test-strategy | — |
| 3 | "Hacé un análisis de riesgos del módulo de autenticación; gestiona login, MFA y sesiones" | sdet-risk-analysis | — |
| 4 | "Generá casos de prueba para el flujo de checkout del carrito" | sdet-test-cases | — |
| 5 | "Clasificá estos 40 casos de prueba en suites S/M/L/XL para nuestro pipeline CI" | sdet-test-classification | — |
| 6 | "Configurá un framework de automatización de tests Playwright con Page Object Model para nuestra app React" | sdet-automation | — |
| 7 | "Creá una suite de tests E2E con Cypress para el registro de usuarios" | sdet-automation-cypress | — |
| 8 | "Generá tests Selenium WebDriver en Java con TestNG para la página de login" | sdet-automation-selenium | sdet-lang-java |
| 9 | "Construí un framework de tests Appium para nuestra app bancaria Android e iOS" | sdet-automation-appium | — |
| 10 | "Creá suites de tests Robot Framework para los health checks de nuestra API REST" | sdet-automation-robot | — |
| 11 | "Mostrame fixtures y patrones de parametrize de pytest para testing de API en Python" | sdet-lang-python | — |
| 12 | "Escribí feature files Gherkin para el escenario de registro de usuarios" | sdet-methodology-gherkin | — |
| 13 | "Creá step definitions de Cucumber en Java para la feature de login" | sdet-methodology-cucumber | sdet-lang-java |
| 14 | "Configurá pom.xml de Maven con el plugin Surefire para ejecutar suites TestNG" | sdet-build-maven | — |
| 15 | "Configurá un workflow de GitHub Actions para ejecutar nuestros tests Playwright en cada PR" | sdet-cicd | — |
| 16 | "Clasificá el proyecto ERP de Seidor; es una integración de complejidad media con 15 desarrolladores" | sdet-sqem-classification | — |
| 17 | "Evaluá los criterios QG3 de nuestro proyecto Seidor con NAQ Alto" | sdet-sqem-gates | — |
| 18 | "¿Qué controles de calidad de datos aplican a nuestro chatbot GenAI bajo SQEM?" | sdet-sqem-ia | — |

## Cómo ejecutar

1. Elegí un prompt de la tabla
2. Enviáselo a Patesi como si fueras el usuario
3. Verificá que el skill correcto aparezca en la respuesta (comprobá contenido específico del skill)
4. Comprobá que NO se hayan cargado skills incorrectos

## Notas sobre el comportamiento esperado

- Los casos 8 y 13 deberían cargar DOS skills (automatización + lenguaje/metodología)
- Los casos SQEM (16-18) solo deberían activarse en Modo A (proyectos Seidor)
- Si el agente carga un skill no listado como esperado, es un falso positivo
- Si el agente no carga el skill esperado, es un falso negativo
