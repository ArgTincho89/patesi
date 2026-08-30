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
| Non-functional (Performance) | ✅/❌ | {Why or why not} |
| Non-functional (Security) | ✅/❌ | {Why or why not} |
| Non-functional (Usability) | ✅/❌ | {Why or why not} |
| Structural | ✅/❌ | {Why or why not} |
| Regression | ✅/❌ | {Why or why not} |

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
| Development | Unit/component testing | Local machine |
| QA/Staging | System/acceptance testing | Mirror of production |
| Performance | Load/stress testing | Dedicated performance environment |

## 7. Estrategia de automatización

| Área | ¿Automatizar? | Framework | Prioridad |
|------|-----------|-----------|----------|
| {Feature area 1} | Yes/No | {Framework} | High/Medium/Low |
| {Feature area 2} | Yes/No | {Framework} | High/Medium/Low |

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
| {Risk 1} | High/Medium/Low | High/Medium/Low | {How to handle} |
| {Risk 2} | High/Medium/Low | High/Medium/Low | {How to handle} |
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
- Password reset request flow (email submission)
- Email delivery and reset link generation
- Reset link validation and expiration
- Password update with validation
- Confirmation messaging
- Security considerations (link uniqueness, rate limiting)

### Fuera del alcance
- Login functionality (existing, already tested)
- Account creation flow
- Email template design (covered by design review)
- Third-party email service internals

## 2. Niveles de testing

| Nivel | Aplicado | Justificación |
|-------|---------|-----------|
| Component | ✅ | Test password validation logic, token generation |
| Integration | ✅ | Test email service integration, database operations |
| System | ✅ | End-to-end reset flow across UI, API, email |
| Acceptance | ✅ | Validación de los criterios de aceptación de la user story |

## 3. Tipos de testing

| Tipo | Aplicado | Justificación |
|------|---------|-----------|
| Functional | ✅ | Core reset functionality |
| Security | ✅ | Token security, rate limiting, brute force protection |
| Usability | ✅ | Reset form clarity, email content |
| Performance | ❌ | Low-volume feature, not performance-critical |
| Regression | ✅ | Ensure reset doesn't break login |

## 4. Priorización basada en riesgos

| Risk Area | Level | Impact | Test Focus |
|-----------|-------|--------|------------|
| Security (token) | High | Account compromise if tokens weak | Token uniqueness, expiration, single-use |
| Email delivery | Medium | Users can't reset if email fails | Delivery confirmation, retry logic |
| Password validation | Medium | Weak passwords accepted | Complexity rules, common password check |
| Link expiration | Low | Old links usable | 24-hour expiration enforcement |

## 5. Criterios de entrada y salida

### Entry Criteria
- [ ] Password reset API endpoint implemented
- [ ] Email service configured and accessible
- [ ] QA environment with email testing (e.g., Mailhog)
- [ ] Test accounts with valid emails available

### Exit Criteria
- [ ] All P1/P2 test cases pass
- [ ] No open critical security defects
- [ ] Token expiration verified
- [ ] Rate limiting verified (max 3 requests/hour)
- [ ] Test summary report generated

## 6. Requisitos del entorno de testing

| Entorno | Propósito | Configuración |
|-------------|---------|---------------|
| QA | Functional testing | App + Mailhog (email capture) |
| Security | Token testing | App + database access for token inspection |

## 7. Estrategia de automatización

| Area | Automate? | Framework | Priority |
|------|-----------|-----------|----------|
| Happy path reset flow | Yes | Playwright + TS | High |
| Password validation rules | Yes | Jest unit tests | High |
| Token expiration | Yes | API tests | Medium |
| Email delivery | Semi | Mailhog API checks | Medium |
| Usability testing | No | Manual only | - |

## 8. Roles y responsabilidades

| Role | Responsibility |
|------|---------------|
| QA Engineer | Diseñar y ejecutar casos de prueba, automatizar la regresión |
| Developer | Fix defects, review security aspects |
| Product Owner | Aceptar o rechazar la story, aclarar requisitos |

## 9. Riesgos y mitigaciones

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Email service unreliable in QA | Medium | Can't test email flow | Use Mailhog/local SMTP, mock if needed |
| Token timing issues in tests | High | Flaky tests | Use deterministic time in tests |
| Security vulnerability undetected | Medium | Production risk | Include security checklist, OWASP Top 10 review |
```
