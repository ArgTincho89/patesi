---
name: sdet-automation-robot
description: >
  Genera suites de tests de Robot Framework para testing web, de API y de escritorio.
  Trigger: Robot Framework, tests RF, keyword-driven, .robot files
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-sdet
---

# Generador de suites de tests de Robot Framework

Genera suites de tests de Robot Framework para testing web, de API y de escritorio. Usalo cuando el usuario necesite tests keyword-driven y data-driven con Robot Framework.

## Estructura del framework

```
robot-tests/
├── tests/
│   ├── web/
│   │   ├── login.robot              # Web test suites
│   │   └── navigation.robot
│   ├── api/
│   │   ├── users_api.robot          # API test suites
│   │   └── healthcheck.robot
│   └── data-driven/
│       └── login_data.robot         # Data-driven tests
├── resources/
│   ├── pages/
│   │   ├── login.resource           # Page-level keywords
│   │   └── dashboard.resource
│   ├── common/
│   │   ├── setup.resource           # Shared setup/teardown
│   │   └── assertions.resource      # Custom assertions
│   └── variables/
│       ├── env.robot                # Variables de entorno
│       └── credentials.robot        # Test credentials (use secrets in CI)
├── output/                          # Test execution output
└── README.md
```

## Archivo de variables

### variables/env.robot

```robot
*** Variables ***
${BASE_URL}         http://localhost:3000
${API_URL}          http://localhost:3001
${BROWSER}          chrome
${TIMEOUT}          10s
${IMPLICIT_WAIT}    5s
```

### variables/credentials.robot

```robot
*** Variables ***
${VALID_EMAIL}      user@example.com
${VALID_PASSWORD}   SecurePass123!
${INVALID_EMAIL}    invalid@test.com
${INVALID_PASSWORD} WrongPass
```

## Patrón de keywords de recursos

### resources/pages/login.resource

```robot
*** Settings ***
Library    SeleniumLibrary
Library    Collections
Resource   ../common/setup.resource

*** Keywords ***
Open Login Page
    [Documentation]    Navega a la página de login
    Go To    ${BASE_URL}/login
    Wait Until Element Is Visible    id:email    timeout=${TIMEOUT}

Login With Credentials
    [Documentation]    Completa el formulario de login y lo envía
    [Arguments]    ${email}    ${password}
    Input Text    id:email    ${email}
    Input Text    id:password    ${password}
    Click Button    css:[data-testid='submit-btn']

Login As Valid User
    [Documentation]    Keyword auxiliar para login válido
    Login With Credentials    ${VALID_EMAIL}    ${VALID_PASSWORD}

Get Login Error Message
    [Documentation]    Devuelve el texto del error de login
    ${message}=    Get Text    css:[role='alert']
    [Return]    ${message}

Login Page Should Show Error
    [Documentation]    Verifica que se muestre el mensaje de error
    [Arguments]    ${expected}
    ${actual}=    Get Login Error Message
    Should Be Equal    ${actual}    ${expected}
```

### resources/common/setup.resource

```robot
*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem

*** Keywords ***
Setup Browser
    [Documentation]    Abre el navegador con las opciones configuradas
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys
    Call Method    ${options}    add_argument    --start-maximized
    Call Method    ${options}    add_argument    --headless
    Open Browser    ${BASE_URL}    browser=${BROWSER}    options=${options}
    Set Selenium Implicit Wait    ${IMPLICIT_WAIT}

Teardown Browser
    [Documentation]    Cierra todos los navegadores
    Close All Browsers

Setup Test Data
    [Documentation]    Carga datos de test desde un archivo
    ${data}=    Load JSON From File    ${CURDIR}/../test-data.json
    [Return]    ${data}
```

## Ejemplo de suite de tests web

### tests/web/login.robot

```robot
*** Settings ***
Library    SeleniumLibrary
Resource   ../../resources/pages/login.resource
Resource   ../../resources/common/setup.resource
Suite Setup       Setup Browser
Suite Teardown    Teardown Browser
Test Teardown     Go To    ${BASE_URL}/login

*** Test Cases ***
Login With Valid Credentials
    [Documentation]    Verifica el login exitoso con email y contraseña válidos
    [Tags]    login    smoke    regression
    Open Login Page
    Login As Valid User
    Location Should Be    ${BASE_URL}/dashboard

Login With Invalid Email
    [Documentation]    Verifica el mensaje de error para un formato de email inválido
    [Tags]    login    regression
    Open Login Page
    Login With Credentials    not-an-email    ${VALID_PASSWORD}
    Login Page Should Show Error    Please enter a valid email

Login With Wrong Password
    [Documentation]    Verifica el error para una contraseña incorrecta
    [Tags]    login    regression
    Open Login Page
    Login With Credentials    ${VALID_EMAIL}    ${INVALID_PASSWORD}
    Login Page Should Show Error    Invalid email or password

Login With Empty Fields
    [Documentation]    Verifica la validación de campos obligatorios
    [Tags]    login    validation
    Open Login Page
    Login With Credentials    ${EMPTY}    ${EMPTY}
    Login Page Should Show Error    Email is required
```

## Ejemplo de suite de tests de API

### tests/api/healthcheck.robot

```robot
*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary

*** Variables ***
${API_URL}    http://localhost:3001

*** Test Cases ***
El health check devuelve 200
    [Documentation]    Verifica que el endpoint de salud devuelva 200
    [Tags]    api    smoke
    Create Session    api    ${API_URL}
    ${response}=    GET On Session    api    /health    expected_status=200
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    status
    Should Be Equal    ${response.json()['status']}    ok

Obtener usuarios devuelve un array
    [Documentation]    Verifica que el endpoint de usuarios devuelva una lista
    [Tags]    api    users
    Create Session    api    ${API_URL}
    ${response}=    GET On Session    api    /users    expected_status=200
    Should Be Equal As Integers    ${response.status_code}    200
    ${length}=    Get Length    ${response.json()}
    Should Be True    ${length} >= 0
```

## Ejemplo de test data-driven

### tests/data-driven/login_data.robot

```robot
*** Settings ***
Library    SeleniumLibrary
Resource   ../../resources/pages/login.resource
Resource   ../../resources/common/setup.resource
Suite Setup       Setup Browser
Suite Teardown    Teardown Browser

*** Test Cases ***
Login With Various Credentials
    [Documentation]    Test de login parametrizado usando una plantilla
    [Template]    Login With Credentials And Verify Result
    ${VALID_EMAIL}    ${VALID_PASSWORD}    success
    invalid@test.com  WrongPass            error
    ${EMPTY}          ${EMPTY}             error
    user@test.com     ${EMPTY}             error

*** Keywords ***
Login With Credentials And Verify Result
    [Arguments]    ${email}    ${password}    ${expected}
    Open Login Page
    Login With Credentials    ${email}    ${password}
    Run Keyword If    "${expected}" == "success"
    ...    Location Should Be    ${BASE_URL}/dashboard
    Run Keyword If    "${expected}" == "error"
    ...    Element Should Be Visible    css:[role='alert']
```

## Archivos de configuración

### requirements.txt (Python)

```txt
robotframework==7.1.1
robotframework-seleniumlibrary==6.6.2
robotframework-requests==0.9.7
robotframework-jsonlibrary==0.5.0
```

### Ejecución de tests

```bash
# Run all tests
robot tests/

# Run specific suite
robot tests/web/login.robot

# Run by tag
robot --include smoke tests/

# Run with output directory
robot --outputdir output tests/

# Dry run (validate syntax only)
robot --dryrun tests/
```
