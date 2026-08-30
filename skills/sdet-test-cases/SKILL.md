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
# Casos de prueba: {Nombre de la feature}

## Resumen

| Total | P1 | P2 | P3 | P4 | Candidato a automatización |
|-------|----|----|----|----|----------------|
| {N} | {X} | {X} | {X} | {X} | {Y}/{N} |

## Casos de prueba

### TC-001: {Título}

- **Prioridad**: P{X}
- **Precondiciones**: {Qué debe cumplirse}
- **Automatización**: {true/false} — {Justificación}
- **Requisitos**: {REQ-XXX}

**Pasos**:
1. {Acción 1}
2. {Acción 2}
3. {Acción 3}

**Resultados esperados**:
1. {Resultado 1}
2. {Resultado 2}
3. {Resultado 3}

**Datos de prueba**:
- {Dato 1}: {Valor}
- {Dato 2}: {Valor}

---

### TC-002: {Título}
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

| Total | P1 | P2 | P3 | P4 | Candidato a automatización |
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

**Datos de prueba**:
- Email: newuser@example.com
- Contraseña: SecurePass1
- Nombre: Test User

---

### TC-002: Registro rechazado - formato de email inválido

- **Prioridad**: P1
- **Precondiciones**: La página de registro es accesible
- **Automatización**: true — Data-driven, fácil de automatizar
- **Requisitos**: REQ-REG-002

**Pasos**:
1. Navegar a la página de registro
2. Ingresar el email: "notanemail"
3. Ingresar una contraseña válida: "SecurePass1"
4. Ingresar el nombre: "Test User"
5. Hacer clic en el botón "Register"

**Resultados esperados**:
1. La página de registro carga correctamente
2. El campo de email acepta la entrada
3. El campo de contraseña acepta la entrada
4. El campo de nombre acepta la entrada
5. El sistema muestra el error: "Please enter a valid email address"

---

### TC-003: Registro rechazado - contraseña débil

- **Prioridad**: P1
- **Precondiciones**: La página de registro es accesible
- **Automatización**: true — Data-driven, fácil de automatizar
- **Requisitos**: REQ-REG-003

**Pasos**:
1. Navegar a la página de registro
2. Ingresar un email válido: "user@example.com"
3. Ingresar una contraseña débil: "password"
4. Ingresar el nombre: "Test User"
5. Hacer clic en el botón "Register"

**Resultados esperados**:
1. La página de registro carga correctamente
2. El campo de email acepta la entrada
3. El campo de contraseña acepta la entrada
4. El campo de nombre acepta la entrada
5. El sistema muestra el error: "Password must be at least 8 characters with 1 uppercase letter and 1 number"

---

### TC-004: Registro rechazado - email duplicado

- **Prioridad**: P2
- **Precondiciones**: El usuario "existing@example.com" ya existe
- **Automatización**: true — Requiere preparación de datos de prueba
- **Requisitos**: REQ-REG-004

**Pasos**:
1. Navegar a la página de registro
2. Ingresar el email: "existing@example.com"
3. Ingresar una contraseña válida: "SecurePass1"
4. Ingresar el nombre: "Duplicate User"
5. Hacer clic en el botón "Register"

**Resultados esperados**:
1. La página de registro carga correctamente
2. El campo de email acepta la entrada
3. El campo de contraseña acepta la entrada
4. El campo de nombre acepta la entrada
5. El sistema muestra el error: "An account with this email already exists"

---

### TC-005: Registro con el campo de nombre vacío

- **Prioridad**: P2
- **Precondiciones**: La página de registro es accesible
- **Automatización**: true — Corner case, fácil de automatizar
- **Requisitos**: REQ-REG-005

**Pasos**:
1. Navegar a la página de registro
2. Ingresar un email válido: "noname@example.com"
3. Ingresar una contraseña válida: "SecurePass1"
4. Dejar el campo de nombre vacío
5. Hacer clic en el botón "Register"

**Resultados esperados**:
1. La página de registro carga correctamente
2. El campo de email acepta la entrada
3. El campo de contraseña acepta la entrada
4. El campo de nombre queda vacío
5. El sistema muestra el error: "Name is required"

---

### TC-006: El email de verificación contiene un enlace válido

- **Prioridad**: P2
- **Precondiciones**: El usuario acaba de registrarse
- **Automatización**: true — Requiere un mock del servicio de email
- **Requisitos**: REQ-REG-006

**Pasos**:
1. Completar un registro exitoso (TC-001)
2. Abrir el email de verificación
3. Hacer clic en el enlace de verificación

**Resultados esperados**:
1. El registro se completa correctamente
2. El email llega en menos de 5 minutos con el asunto "Verify your email"
3. El enlace abre una página que muestra "Email verified successfully"

---

### TC-007: Registro con entradas de longitud máxima

- **Prioridad**: P3
- **Precondiciones**: La página de registro es accesible
- **Automatización**: true — Testing de valores de borde
- **Requisitos**: REQ-REG-007

**Pasos**:
1. Navegar a la página de registro
2. Ingresar un email de 254 caracteres (email válido máximo)
3. Ingresar una contraseña de 128 caracteres (máximo permitido)
4. Ingresar un nombre de 100 caracteres
5. Hacer clic en el botón "Register"

**Resultados esperados**:
1. La página de registro carga correctamente
2-4. Los campos aceptan entradas de longitud máxima
5. El sistema procesa el registro (con éxito o con el error correspondiente)

---

### TC-008: El formulario de registro conserva los valores tras un error de validación

- **Prioridad**: P3
- **Precondiciones**: La página de registro es accesible
- **Automatización**: false — Comportamiento de UX, se prefiere verificación manual
- **Requisitos**: REQ-REG-008

**Pasos**:
1. Navegar a la página de registro
2. Ingresar el email: "valid@example.com"
3. Ingresar una contraseña débil: "123"
4. Ingresar el nombre: "Test User"
5. Hacer clic en el botón "Register"
6. Observar el formulario después del mensaje de error

**Resultados esperados**:
1. La página de registro carga correctamente
2-4. Los campos aceptan la entrada
5. El sistema muestra el error de contraseña
6. Los campos de email y nombre conservan sus valores (el usuario no necesita volver a ingresarlos)
```
