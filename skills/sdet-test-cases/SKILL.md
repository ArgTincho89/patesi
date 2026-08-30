---
name: sdet-test-cases
description: >
  Genera casos de prueba estructurados con formato, prioridad y trazabilidad adecuados.
  Trigger: casos de prueba, escenarios de testing, diseño de tests, especificaciones
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-sdet
---

# Generador de casos de prueba

Crea casos de prueba estructurados y trazables siguiendo buenas prácticas de ISTQB. Usalo cuando el usuario necesite casos para una feature, user story o requisito.

## Formato de caso de prueba

Cada caso de prueba DEBE seguir esta estructura:

```markdown
| Campo | Obligatorio | Descripción |
|-------|----------|-------------|
| `id` | Sí | Identificador único (formato TC-XXX) |
| `title` | Sí | Nombre breve y descriptivo |
| `priority` | Sí | P1 (crítica), P2 (alta), P3 (media), P4 (baja) |
| `preconditions` | Sí | Qué debe cumplirse antes de la ejecución |
| `steps` | Sí | Lista ordenada de acciones |
| `expected_results` | Sí | Resultado esperado por paso |
| `test_data` | No | Valores de datos específicos necesarios |
| `automation_candidate` | Sí | true/false con justificación |
| `requirements_trace` | No | ID del requisito vinculado |
```

## Definiciones de prioridad

| Prioridad | Definición | Cuándo usarla |
|----------|------------|-------------|
| **P1** | Camino crítico, bloquea el release | Funcionalidad principal, seguridad, integridad de datos |
| **P2** | Prioridad alta, debería incluirse en el release | Features importantes, flujos habituales |
| **P3** | Prioridad media, puede postergarse | Edge cases, features secundarias |
| **P4** | Prioridad baja, conveniente pero no esencial | Aspectos cosméticos, escenarios poco frecuentes |

## Reglas de generación de casos de prueba

### Happy Path (incluir siempre)
- Al menos un caso de prueba para el escenario principal de éxito
- Usá datos válidos y habituales
- Seguí el flujo de usuario esperado

### Tests negativos (incluir siempre)
- Entradas inválidas (tipo, formato o rango incorrectos)
- Campos obligatorios faltantes
- Intentos de acceso no autorizados
- Violaciones de límites

### Edge cases (incluir cuando corresponda)
- Entradas vacías
- Valores máximos y mínimos
- Caracteres especiales
- Operaciones concurrentes
- Fallos de red (para integraciones)

### Tests data-driven (cuando corresponda)
- Múltiples entradas válidas
- Valores límite (BVA)
- Particiones de equivalencia

## Formato de salida

Generá los casos de prueba como una tabla estructurada:

```markdown
# Casos de prueba: {Feature Name}

## Resumen

| Total | P1 | P2 | P3 | P4 | Candidato a automatización |
|-------|----|----|----|----|----------------|
| {N} | {X} | {X} | {X} | {X} | {Y}/{N} |

## Casos de prueba

### TC-001: {Title}

- **Priority**: P{X}
- **Precondiciones**: {Qué debe cumplirse}
- **Automatización**: {true/false} — {Justificación}
- **Requisitos**: {REQ-XXX}

**Steps**:
1. {Action 1}
2. {Action 2}
3. {Action 3}

**Resultados esperados**:
1. {Result 1}
2. {Result 2}
3. {Result 3}

**Test Data**:
- {Data item 1}: {Value}
- {Data item 2}: {Value}

---

### TC-002: {Title}
...
```

## Ejemplo de entrada

```
Feature: Registro de usuario con validación de email

Criterios de aceptación:
- El usuario puede registrarse con email, contraseña y nombre
- El email debe tener un formato válido
- La contraseña debe tener al menos 8 caracteres, 1 mayúscula y 1 número
- El sistema envía un email de verificación
- El usuario no puede registrarse con un email existente
```

## Ejemplo de salida

```markdown
# Casos de prueba: Registro de usuario

## Resumen

| Total | P1 | P2 | P3 | P4 | Auto Candidate |
|-------|----|----|----|----|----------------|
| 8 | 3 | 3 | 2 | 0 | 7/8 |

## Casos de prueba

### TC-001: Registro exitoso con datos válidos

- **Prioridad**: P1
- **Precondiciones**: El usuario no tiene una cuenta existente
- **Automatización**: true — Happy path principal y repetible
- **Requisitos**: REQ-REG-001

**Pasos**:
1. Navegar a la página de registro
2. Ingresar un email válido: "newuser@example.com"
3. Ingresar una contraseña válida: "SecurePass1"
4. Ingresar el nombre: "Test User"
5. Hacer clic en el botón "Register"

**Resultados esperados**:
1. La página de registro carga correctamente
2. El campo de email acepta la entrada
3. El campo de contraseña acepta la entrada (enmascarada)
4. El campo de nombre acepta la entrada
5. El sistema crea la cuenta, envía el email de verificación y redirige a la página "Check your email"

**Datos de test**:
- Email: newuser@example.com
- Contraseña: SecurePass1
- Nombre: Test User

---

### TC-002: Registro rechazado - formato de email inválido

- **Priority**: P1
- **Preconditions**: Registration page is accessible
- **Automation**: true — Data-driven, easy to automate
- **Requisitos**: REQ-REG-002

**Steps**:
1. Navigate to registration page
2. Enter email: "notanemail"
3. Enter valid password: "SecurePass1"
4. Enter name: "Test User"
5. Click "Register" button

**Resultados esperados**:
1. Registration page loads correctly
2. Email field accepts input
3. Password field accepts input
4. Name field accepts input
5. System shows error: "Please enter a valid email address"

---

### TC-003: Registro rechazado - contraseña débil

- **Priority**: P1
- **Preconditions**: Registration page is accessible
- **Automation**: true — Data-driven, easy to automate
- **Requisitos**: REQ-REG-003

**Steps**:
1. Navigate to registration page
2. Enter valid email: "user@example.com"
3. Enter weak password: "password"
4. Enter name: "Test User"
5. Click "Register" button

**Resultados esperados**:
1. Registration page loads correctly
2. Email field accepts input
3. Password field accepts input
4. Name field accepts input
5. System shows error: "Password must be at least 8 characters with 1 uppercase letter and 1 number"

---

### TC-004: Registro rechazado - email duplicado

- **Priority**: P2
- **Preconditions**: User "existing@example.com" already exists
- **Automation**: true — Requires test data setup
- **Requisitos**: REQ-REG-004

**Steps**:
1. Navigate to registration page
2. Enter email: "existing@example.com"
3. Enter valid password: "SecurePass1"
4. Enter name: "Duplicate User"
5. Click "Register" button

**Resultados esperados**:
1. Registration page loads correctly
2. Email field accepts input
3. Password field accepts input
4. Name field accepts input
5. System shows error: "An account with this email already exists"

---

### TC-005: Registration with empty name field

- **Priority**: P2
- **Preconditions**: Registration page is accessible
- **Automation**: true — Edge case, easy to automate
- **Requisitos**: REQ-REG-005

**Steps**:
1. Navigate to registration page
2. Enter valid email: "noname@example.com"
3. Enter valid password: "SecurePass1"
4. Leave name field empty
5. Click "Register" button

**Resultados esperados**:
1. Registration page loads correctly
2. Email field accepts input
3. Password field accepts input
4. Name field is empty
5. System shows error: "Name is required"

---

### TC-006: El email de verificación contiene un enlace válido

- **Priority**: P2
- **Preconditions**: User has just registered
- **Automation**: true — Requires email service mock
- **Requisitos**: REQ-REG-006

**Steps**:
1. Complete successful registration (TC-001)
2. Open verification email
3. Click verification link

**Resultados esperados**:
1. Registration completes successfully
2. Email received within 5 minutes with subject "Verify your email"
3. Link opens page showing "Email verified successfully"

---

### TC-007: Registration with maximum length inputs

- **Priority**: P3
- **Preconditions**: Registration page is accessible
- **Automation**: true — Boundary testing
- **Requisitos**: REQ-REG-007

**Steps**:
1. Navigate to registration page
2. Enter email with 254 characters (max valid email)
3. Enter password with 128 characters (max allowed)
4. Enter name with 100 characters
5. Click "Register" button

**Resultados esperados**:
1. Registration page loads correctly
2-4. Fields accept maximum length inputs
5. System processes registration (success or appropriate error)

---

### TC-008: Registration form retains values after validation error

- **Priority**: P3
- **Preconditions**: Registration page is accessible
- **Automation**: false — UX behavior, manual verification preferred
- **Requisitos**: REQ-REG-008

**Steps**:
1. Navigate to registration page
2. Enter email: "valid@example.com"
3. Enter weak password: "123"
4. Enter name: "Test User"
5. Click "Register" button
6. Observe form after error message

**Resultados esperados**:
1. Registration page loads correctly
2-4. Fields accept input
5. System shows password error
6. Email and name fields retain their values (user doesn't need to re-enter)
```
