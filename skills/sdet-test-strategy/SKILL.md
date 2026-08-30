---
name: sdet-test-strategy
description: >
  Genera estrategias y planes de testing a partir de user stories, requisitos o contexto del proyecto.
  Trigger: estrategia de testing, plan de testing, estrategia de calidad, approach de testing
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-sdet
---

# Generador de estrategias de testing

Crea estrategias de testing completas alineadas con la metodología ISTQB. Usalo cuando el usuario necesite definir cómo abordar el testing de una feature, sprint o proyecto.

## Entrada

El usuario puede proporcionar:
- **User stories** con criterios de aceptación
- **Documentos de requisitos**
- **Descripciones de features**
- **Contexto del proyecto** (stack tecnológico, equipo y restricciones)

Si el usuario solo proporciona el nombre de una feature o una descripción breve, hacé preguntas aclaratorias sobre alcance, restricciones y tolerancia al riesgo antes de generar.

## Plantilla de salida

Generá la estrategia de testing con TODAS las secciones siguientes:

```markdown
# Estrategia de testing: {Feature/Project Name}

## 1. Alcance

### Dentro del alcance
- {Lista de lo que se probará}

### Fuera del alcance
- {Lista de lo que NO se probará y por qué}

## 2. Niveles de testing

| Nivel | Aplicado | Justificación |
|-------|---------|-----------|
| Componente | ✅/❌ | {Por qué sí o por qué no} |
| Integración | ✅/❌ | {Por qué sí o por qué no} |
| Sistema | ✅/❌ | {Por qué sí o por qué no} |
| Aceptación | ✅/❌ | {Por qué sí o por qué no} |

## 3. Tipos de testing

| Tipo | Aplicado | Justificación |
|------|---------|-----------|
| Funcional | ✅/❌ | {Por qué sí o por qué no} |
| No funcional (performance) | ✅/❌ | {Por qué sí o por qué no} |
| No funcional (seguridad) | ✅/❌ | {Por qué sí o por qué no} |
| No funcional (usabilidad) | ✅/❌ | {Por qué sí o por qué no} |
| Estructural | ✅/❌ | {Por qué sí o por qué no} |
| Regresión | ✅/❌ | {Por qué sí o por qué no} |

## 4. Priorización basada en riesgos

| Área de riesgo | Nivel | Impacto | Enfoque de testing |
|-----------|-------|--------|------------|
| {Área 1} | Alto/Medio/Bajo | {Qué ocurre si falla} | {Qué probar} |
| {Área 2} | Alto/Medio/Bajo | {Qué ocurre si falla} | {Qué probar} |
| {Área 3} | Alto/Medio/Bajo | {Qué ocurre si falla} | {Qué probar} |

## 5. Criterios de entrada y salida

### Criterios de entrada
- [ ] Los requisitos están documentados y revisados
- [ ] El entorno de testing está configurado y verificado
- [ ] Los datos de test están preparados
- [ ] El build está desplegado en el entorno de testing
- [ ] Los smoke tests pasan

### Criterios de salida
- [ ] Todos los casos de prueba planificados fueron ejecutados
- [ ] Los defectos P1/P2 fueron resueltos o aceptados como problemas conocidos
- [ ] Los defectos P3/P4 fueron documentados para futuros sprints
- [ ] La cobertura de código alcanza el umbral mínimo ({X}%)
- [ ] Se generó el informe resumido de tests

## 6. Requisitos del entorno de testing

| Entorno | Propósito | Configuración |
|-------------|---------|---------------|
| Desarrollo | Testing unitario y de componentes | Máquina local |
| QA/Staging | Testing de sistema y aceptación | Espejo de producción |
| Performance | Testing de carga y estrés | Entorno dedicado de performance |

## 7. Estrategia de automatización

| Área | ¿Automatizar? | Framework | Prioridad |
|------|-----------|-----------|----------|
| {Área de feature 1} | Sí/No | {Framework} | Alta/Media/Baja |
| {Área de feature 2} | Sí/No | {Framework} | Alta/Media/Baja |

### Criterios para decidir la automatización
- **Automatizar**: Tests repetitivos, suite de regresión, tests data-driven y smoke tests
- **Solo manual**: Testing exploratorio, testing de usabilidad, testing ad-hoc y tests de una sola ejecución

## 8. Roles y responsabilidades

| Rol | Responsabilidad |
|------|---------------|
| {Rol 1} | {Qué hace} |
| {Rol 2} | {Qué hace} |

## 9. Riesgos y mitigaciones

| Riesgo | Probabilidad | Impacto | Mitigación |
|------|------------|--------|------------|
| {Riesgo 1} | Alta/Media/Baja | Alto/Medio/Bajo | {Cómo abordarlo} |
| {Riesgo 2} | Alta/Media/Baja | Alto/Medio/Bajo | {Cómo abordarlo} |
```

## Ejemplo de entrada

```
User story: Como usuario registrado, quiero restablecer mi contraseña por email
para recuperar el acceso a mi cuenta si olvido la contraseña.

Criterios de aceptación:
- El usuario puede solicitar el restablecimiento desde la página de login
- El sistema envía el enlace de restablecimiento por email en un plazo de 5 minutos
- El enlace de restablecimiento vence después de 24 horas
- La nueva contraseña debe cumplir los requisitos de seguridad
- El usuario recibe una confirmación después del restablecimiento exitoso
```

## Ejemplo de salida

```markdown
# Estrategia de testing: restablecimiento de contraseña

## 1. Alcance

### Dentro del alcance
- Flujo de solicitud de restablecimiento de contraseña (envío del email)
- Entrega del email y generación del enlace de restablecimiento
- Validación y expiración del enlace de restablecimiento
- Actualización de la contraseña con validación
- Mensajes de confirmación
- Consideraciones de seguridad (unicidad del enlace, rate limiting)

### Fuera del alcance
- Funcionalidad de login (existente, ya testeada)
- Flujo de creación de cuenta
- Diseño de las plantillas de email (cubierto por la revisión de diseño)
- Internals del servicio de email de terceros

## 2. Niveles de testing

| Nivel | Aplicado | Justificación |
|-------|---------|-----------|
| Componente | ✅ | Testear la lógica de validación de contraseña y la generación de tokens |
| Integración | ✅ | Testear la integración con el servicio de email y las operaciones de base de datos |
| Sistema | ✅ | Flujo de restablecimiento end-to-end entre UI, API y email |
| Aceptación | ✅ | Validación de los criterios de aceptación de la user story |

## 3. Tipos de testing

| Tipo | Aplicado | Justificación |
|------|---------|-----------|
| Funcional | ✅ | Funcionalidad central de restablecimiento |
| Seguridad | ✅ | Seguridad del token, rate limiting, protección contra fuerza bruta |
| Usabilidad | ✅ | Claridad del formulario de restablecimiento y del contenido del email |
| Performance | ❌ | Feature de bajo volumen, no crítica en performance |
| Regresión | ✅ | Asegurar que el restablecimiento no rompa el login |

## 4. Priorización basada en riesgos

| Área de riesgo | Nivel | Impacto | Enfoque de testing |
|----------------|-------|---------|--------------------|
| Seguridad (token) | Alto | Compromiso de cuenta si los tokens son débiles | Unicidad del token, expiración, uso único |
| Entrega del email | Medio | El usuario no puede restablecer si falla el email | Confirmación de entrega, lógica de reintento |
| Validación de contraseña | Medio | Se aceptan contraseñas débiles | Reglas de complejidad, chequeo de contraseñas comunes |
| Expiración del enlace | Bajo | Enlaces viejos utilizables | Aplicación de la expiración a las 24 horas |

## 5. Criterios de entrada y salida

### Criterios de entrada
- [ ] Endpoint de API de restablecimiento de contraseña implementado
- [ ] Servicio de email configurado y accesible
- [ ] Entorno de QA con testing de email (por ejemplo, Mailhog)
- [ ] Cuentas de prueba con emails válidos disponibles

### Criterios de salida
- [ ] Todos los casos de prueba P1/P2 pasan
- [ ] Sin defectos críticos de seguridad abiertos
- [ ] Expiración del token verificada
- [ ] Rate limiting verificado (máximo 3 solicitudes por hora)
- [ ] Informe resumido de tests generado

## 6. Requisitos del entorno de testing

| Entorno | Propósito | Configuración |
|-------------|---------|---------------|
| QA | Testing funcional | App + Mailhog (captura de emails) |
| Seguridad | Testing de tokens | App + acceso a base de datos para inspeccionar tokens |

## 7. Estrategia de automatización

| Área | ¿Automatizar? | Framework | Prioridad |
|------|---------------|-----------|-----------|
| Flujo de restablecimiento happy path | Sí | Playwright + TS | Alta |
| Reglas de validación de contraseña | Sí | Tests unitarios con Jest | Alta |
| Expiración del token | Sí | Tests de API | Media |
| Entrega del email | Parcial | Checks vía API de Mailhog | Media |
| Testing de usabilidad | No | Solo manual | - |

## 8. Roles y responsabilidades

| Rol | Responsabilidad |
|-----|-----------------|
| QA Engineer | Diseñar y ejecutar casos de prueba, automatizar la regresión |
| Developer | Corregir defectos, revisar los aspectos de seguridad |
| Product Owner | Aceptar o rechazar la story, aclarar requisitos |

## 9. Riesgos y mitigaciones

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|------------|
| Servicio de email poco fiable en QA | Media | No se puede testear el flujo de email | Usar Mailhog/SMTP local, mockear si hace falta |
| Problemas de timing del token en los tests | Alta | Tests flaky | Usar tiempo determinista en los tests |
| Vulnerabilidad de seguridad no detectada | Media | Riesgo en producción | Incluir checklist de seguridad y revisión OWASP Top 10 |
```
