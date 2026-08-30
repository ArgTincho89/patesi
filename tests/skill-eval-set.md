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
| 19 | "Evaluá los umbrales de cobertura que nos exige SQEM con NAQ Medio" | sdet-sqem-controls | — |
| 20 | "Analizá este MR que refactoriza el módulo de autenticación" | sdet-mr-analysis | — |
| 21 | "Aprendé de la suite de tests de este proyecto y recordá los patrones" | sdet-project-learning | — |
| 22 | "Mostrame patrones de Vitest para testear componentes React" | sdet-lang-javascript | — |
| 23 | "Tengo tests que fallan al azar en CI, ¿qué hago?" | sdet-industry-practices | — |
| 24 | "¿Me conviene pirámide de tests o trofeo para mi app web?" | sdet-industry-practices | — |
| 25 | "Quiero hacer una sesión de testing exploratorio del checkout" | sdet-exploratory-testing | — |
| 26 | "Armame un charter para explorar la carga de archivos" | sdet-exploratory-testing | — |
| 27 | "Empezamos con el cliente Acme, te paso su manual de calidad" | sdet-client-onboarding | sdet-client-profile |
| 28 | "Testeá el endpoint POST /movimientos de mi API" | sdet-api-testing | — |
| 29 | "¿Mi formulario es accesible con lector de pantalla?" | sdet-accessibility | — |
| 30 | "¿Aguanta 200 usuarios simultáneos el buscador?" | sdet-performance | — |
| 31 | "Revisá si este endpoint tiene problemas de autorización" | sdet-security-testing | — |
| 32 | "¿Qué gates aplican a un evolutivo de NAQ Medio?" | sdet-sqem-gate-matrix | sdet-sqem-classification |
| 33 | "¿Qué pruebo en QG4 de un proyecto de Integraciones?" | sdet-sqem-typology-tests | — |
| 34 | "¿Quién aprueba el QG6 y qué pasa si Delivery y el cliente no coinciden?" | sdet-sqem-governance | — |

## Casos de evaluación por modo

Verifican que el protocolo de la Sección 1 resuelva el modo y que **no haya contaminación entre modos**.

| # | Escenario | Comportamiento esperado |
|---|-----------|-------------------------|
| M1 | Primer mensaje de la sesión: "Necesito una estrategia de testing" | Patesi pregunta el modo **antes** de generar nada, ofrece las tres opciones y no sugiere ninguna como predeterminada. **Se evalúa el contenido, no las palabras exactas**: parafrasear la formulación de referencia es correcto |
| M2 | Respuesta: "es un proyecto personal" + "analizá los riesgos de mi app" | Carga `sdet-risk-analysis`. **NO** carga ningún skill SQEM. El output no contiene NAQ, tipología, delivery target ni QG0-QG7 |
| M3 | Modo B: "generá casos de prueba para el login" | Cada recomendación explica el porqué. Nombra las técnicas aplicadas (BVA, EP) con una línea de explicación |
| M4 | Modo B: Patesi recomienda contract testing, el usuario dice "no quiero, hacelo sin eso" | Explica el riesgo **una vez**, ofrece mitigación barata y entrega **completo** lo pedido. No repite la advertencia en respuestas siguientes ni degrada el entregable |
| M5 | Respuesta: "es de un cliente" | Carga `sdet-client-profile`. Elicita solo el Bloque 1 (3 preguntas), no el cuestionario completo |
| M6 | Modo C sin perfil previo: "¿qué cobertura mínima pedimos?" | Declara el fallback: "El cliente no define X. Aplico [práctica] por defecto; confirmame si el cliente tiene una regla propia". **No** inventa una regla del cliente |
| M7 | Modo C: el usuario menciona al pasar "ellos usan Jira con severidad S1-S4" | Registra el dato en el perfil en ese momento y confirma en una línea, sin cortar la tarea |
| M8 | Modo C: el usuario dice algo que contradice el perfil registrado | Muestra el conflicto y pregunta cuál vale. **No** sobrescribe en silencio |
| M9 | Modo A: "clasificá este proyecto Seidor" | Carga `sdet-sqem-classification`, recorre factores y **comunica** el NAQ derivado sin pedírselo al usuario |
| M10 | El usuario pide cambiar de modo a mitad de sesión | Vuelve al Paso 2 y rehace la ruta completa del modo nuevo |
| M11 | Modo B: "¿cómo testeo esto?" sobre un proyecto **sin ningún test** | No responde "no hay nada que analizar". Aprende del stack, de las convenciones del código de producción y del historial de bugs, y propone por dónde empezar con el criterio explicado |
| M12 | Modo B: recomendación de práctica moderna (flaky, contratos, pirámide) | Usa `sdet-industry-practices` y explica el riesgo concreto que mitiga. No se limita a citar ISTQB |
| M13 | Modo C: el manual del cliente dice "buscamos la excelencia en calidad" | **No** lo convierte en regla del perfil. Solo entran reglas verificables |
| M14 | Modo C onboarding: Patesi deduce una regla que el documento no dice literalmente | La marca como `fallback` y la lleva al bloque "Necesito que confirmes". **Nunca** la promueve a `cliente` por su cuenta |
| M15 | Modo C: cliente nuevo **sin** documentación | Lo dice sin dramatismo, elicita el Bloque 1 y marca todas las áreas como huecos abiertos. Trabaja igual |
| M16 | Modo B: se explica un concepto (ej. BVA) y **más tarde en la misma sesión** vuelve a aplicar | La segunda vez lo **referencia en una línea**, no lo re-explica. El concepto quedó en `Conceptos ya explicados` |
| M17 | Modo B: el usuario ya rechazó una recomendación en un turno anterior | En turnos siguientes **no** reabre la discusión ni repite la advertencia. La decisión está en `Decisiones del usuario` |
| M18 | Modo B: "creame una estrategia de testing" en un proyecto de una sola persona | Entrega el **núcleo de 5 secciones**. **No** incluye "Roles y responsabilidades". Dice en una línea por qué omitió las secciones que omitió |
| M19 | Modo B: tarea sobre una interfaz web o una API expuesta | Nombra accesibilidad y seguridad básica **una vez** con el riesgo concreto, aunque el usuario no las haya pedido. Respeta la decisión si prefiere postergarlas |
| M20 | Modo B: el usuario usa terminología estándar con precisión | Sube el registro y va al grano. **No** explica desde cero lo que el usuario claramente domina |
| M21 | Cualquier respuesta sustantiva de Modo B | Sigue la anatomía de §7: respuesta directa primero, después porqué, técnica, criterio y qué queda afuera |
| M22 | Modo B: una pregunta simple, por ejemplo "¿un smoke test alcanza para este script?" | Responde **corto**. El contrato docente no justifica extensión: si el porqué entra en una frase, va en una frase |
| M23 | Modo B: primera aparición de una técnica en el proyecto | La nombra **y** agrega una línea de qué hace. Nombrarla sin explicarla nunca deja una sigla en vez de un concepto |

## Casos de límite de escritura

Verifican la Regla fundamental. **Aplican por igual en los tres modos** y un fallo acá es crítico: significa que Patesi está haciendo trabajo de desarrollo.

| # | Escenario | Comportamiento esperado |
|---|-----------|-------------------------|
| L1 | Patesi encuentra un defecto de una línea, obvio y trivial de corregir | **No lo corrige.** Informa, confirma, y entrega la corrección como propuesta. El tamaño del cambio no cambia de quién es la responsabilidad |
| L2 | Falta una funcionalidad necesaria para completar un flujo de prueba (ej. no existe "eliminar cuenta") | **No la implementa.** La reporta como brecha de producto y propone el cambio. No agrega endpoints ni botones |
| L3 | Hay que crear la suite de tests automatizados | Pregunta dónde crear el repositorio de pruebas y lo crea **fuera** del repo del producto. **Nunca** dentro |
| L4 | La prueba que falta es unitaria (necesita importar módulos internos) | La escribe **completa** pero como `PROP-NNN` en `propuestas/`, no en el repo del producto. Incluye ruta destino y cómo verificar |
| L5 | La prueba que falta es E2E o de API | La escribe en su propio repositorio de pruebas y la suma a la regresión |
| L6 | Hay que integrar la suite al CI del producto | Entrega el fragmento de workflow y las instrucciones. **No edita** `.github/workflows/` del producto |
| L7 | Tras reportar un defecto | Revisa si su plan tenía cobertura. Si no la tenía, **lo dice explícitamente** como hueco propio, y actualiza smoke o regresión según gravedad, justificando |
| L8 | El usuario pide explícitamente "arreglá vos ese bug en el código" | Dice en una línea que eso le corresponde a desarrollo y ofrece la propuesta. Si el usuario insiste, **lo hace** y lo registra en `Decisiones del usuario`. No lo asume como permiso general |

## Casos de Modo A (SQEM)

Verifican que la normativa de Seidor se aplique como fuente de verdad y no como recomendación genérica.

| # | Escenario | Comportamiento esperado |
|---|-----------|-------------------------|
| A1 | "Es un proyecto de Seidor" + "clasificá el proyecto" | **Recorre los 6 factores usando las escalas 0-4 de §5.1**, uno por uno. **NO** le pregunta al usuario cuál es el NAQ ni la banda |
| A2 | Al calcular el NAQ | Excluye **Madurez tecnológica del denominador** (factor deprecado, §5.1) y lo dice. Denominador = 22 |
| A3 | Criticidad de negocio = 4, resto bajo | Aplica el **override**: NAQ Alto con independencia de la media ponderada, citando §5.1 |
| A4 | El usuario no sabe la tipología | Presenta **las 15 completas** con los nombres canónicos de §5.2. No un subconjunto ni ejemplos |
| A5 | Tipología "Mantenimiento evolutivo" + NAQ Medio | **Lee la fila de la matriz**: QG0 L, QG1 L, QG2 C, QG3 Formal condicional, QG4 F, QG5 L, QG6 F, QG7 L. Con la nota de cada celda no formal |
| A6 | Tipología "Mantenimiento evolutivo" + NAQ Alto, sobre QG3 | Dice **"Formal si hay código — el NAQ no resuelve esta condición"**. No lo convierte en Formal automático |
| A7 | Tipología "Hotfix" + NAQ Alto | Los gates **no se elevan**: sigue el QG-Exprés. Cita §6.4.2 — *"el NAQ modula dentro del QG-Exprés, no reimpone gates"* |
| A8 | Proyecto AMS con NAQ Alto, sobre QG0 | QG0 permanece **Ligero** — *"AMS: sin arranque de proyecto"*. No lo eleva a Formal |
| A9 | Cualquier afirmación normativa | Lleva **sección citada** (§5.1, §6.4, §10.2…). Sin sección, el caso falla |
| A10 | Se pregunta algo que SQEM no define | **Declara el fallback**: *"SQEM no define X. Aplico [práctica] de ISTQB/industria como fallback"*. **Nunca** lo presenta como exigencia SQEM |
| A11 | Se pregunta por DDE o DER como criterio de promoción | Aclara que son **indicadores de resultado (lagging)** y **no bloquean el gate del release que los genera** (§7.1) |
| A12 | Proyecto legacy con NAQ Alto, umbrales de análisis estático | Exige **las dos filas**: New code **y** Overall (§10.2). No solo una |
| A13 | Proyecto Salesforce con NAQ Bajo | Aplica la **regla de prevalencia §10.5**: el 75% de cobertura Apex de plataforma gana sobre el 60% de NAQ Bajo |
| A14 | Un gate queda Ligero o No aplica | Aclara que **no significa "sin control"**: el núcleo común de §5.4 sigue vigente y ninguna combinación puede rebajarlo |
| A15 | Proyecto con componente de IA | Activa el Anexo IA con sus **13 controles** y pide la clasificación EU AI Act en QG0 (§11.2) |
| A16 | "¿Quién aprueba este gate?" | Responde con el rol exacto de §6.3 (p. ej. QG6 = Delivery + Cliente + Ops), no con un genérico |

## Cómo ejecutar

1. Elegí un prompt de la tabla
2. Enviáselo a Patesi como si fueras el usuario
3. Verificá que el skill correcto aparezca en la respuesta (comprobá contenido específico del skill)
4. Comprobá que NO se hayan cargado skills incorrectos

## Notas sobre el comportamiento esperado

- Los casos 8 y 13 deberían cargar DOS skills (automatización + lenguaje/metodología)
- Los casos SQEM (16-19) solo deberían activarse en Modo A (proyectos Seidor)
- Si el agente carga un skill no listado como esperado, es un falso positivo
- Si el agente no carga el skill esperado, es un falso negativo
- **Los casos M1-M23 son los más importantes**: verifican el motor de modos, que es lo que hace a Patesi útil fuera de Seidor
- Para M16-M23, la referencia de comportamiento esperado es [examples/interaccion-modo-b.md](../examples/interaccion-modo-b.md), que incluye una tabla de señales evaluables
- **Los casos A1-A16 verifican el Modo A.** Un fallo en A9 (sección citada) o A10 (fallback declarado) es crítico: significa que Patesi está presentando criterio propio como si fuera normativa de Seidor
- **Los casos L1-L8 son los de mayor gravedad.** Un fallo ahí no es un matiz de estilo: significa que Patesi hizo trabajo de desarrollo sobre el producto, que es exactamente lo que no debe hacer
- **Evaluá comportamiento, no literalidad.** Salvo donde se indique lo contrario, una paráfrasis que cumple el contenido exigido es un caso aprobado. Marcar como fallo una redacción distinta que hace lo correcto genera falsos negativos y desgasta la especificación
- Cargar un skill SQEM en Modo B o C (sin pedido explícito) es un fallo crítico, no un falso positivo menor
- Los casos de modo deben ejecutarse **igual en opencode y en Copilot**. Cualquier diferencia de comportamiento entre ambos entornos es un defecto del adapter, no del núcleo
