---
name: sdet-automation-robot
description: >
  Generates Robot Framework test suites for web, API, and desktop testing.
  Trigger: When user asks to generate Robot Framework tests, create .robot files, or set up RF-based automation.
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-sdet
---

# Robot Framework Test Suite Generator

Generates Robot Framework test suites for web, API, and desktop testing. Use this when the user needs keyword-driven, data-driven tests using Robot Framework.

## Framework Structure

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
│       ├── env.robot                # Environment variables
│       └── credentials.robot        # Test credentials (use secrets in CI)
├── output/                          # Test execution output
└── README.md
```

## Variables File

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

## Resource Keyword Pattern

### resources/pages/login.resource

```robot
*** Settings ***
Library    SeleniumLibrary
Library    Collections
Resource   ../common/setup.resource

*** Keywords ***
Open Login Page
    [Documentation]    Navigates to the login page
    Go To    ${BASE_URL}/login
    Wait Until Element Is Visible    id:email    timeout=${TIMEOUT}

Login With Credentials
    [Documentation]    Fills login form and submits
    [Arguments]    ${email}    ${password}
    Input Text    id:email    ${email}
    Input Text    id:password    ${password}
    Click Button    css:[data-testid='submit-btn']

Login As Valid User
    [Documentation]    Convenience keyword for valid login
    Login With Credentials    ${VALID_EMAIL}    ${VALID_PASSWORD}

Get Login Error Message
    [Documentation]    Returns the login error text
    ${message}=    Get Text    css:[role='alert']
    [Return]    ${message}

Login Page Should Show Error
    [Documentation]    Asserts error message is displayed
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
    [Documentation]    Opens browser with configured options
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys
    Call Method    ${options}    add_argument    --start-maximized
    Call Method    ${options}    add_argument    --headless
    Open Browser    ${BASE_URL}    browser=${BROWSER}    options=${options}
    Set Selenium Implicit Wait    ${IMPLICIT_WAIT}

Teardown Browser
    [Documentation]    Closes all browsers
    Close All Browsers

Setup Test Data
    [Documentation]    Loads test data from file
    ${data}=    Load JSON From File    ${CURDIR}/../test-data.json
    [Return]    ${data}
```

## Web Test Suite Example

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
    [Documentation]    Verify successful login with valid email and password
    [Tags]    login    smoke    regression
    Open Login Page
    Login As Valid User
    Location Should Be    ${BASE_URL}/dashboard

Login With Invalid Email
    [Documentation]    Verify error message for invalid email format
    [Tags]    login    regression
    Open Login Page
    Login With Credentials    not-an-email    ${VALID_PASSWORD}
    Login Page Should Show Error    Please enter a valid email

Login With Wrong Password
    [Documentation]    Verify error for incorrect password
    [Tags]    login    regression
    Open Login Page
    Login With Credentials    ${VALID_EMAIL}    ${INVALID_PASSWORD}
    Login Page Should Show Error    Invalid email or password

Login With Empty Fields
    [Documentation]    Verify validation for required fields
    [Tags]    login    validation
    Open Login Page
    Login With Credentials    ${EMPTY}    ${EMPTY}
    Login Page Should Show Error    Email is required
```

## API Test Suite Example

### tests/api/healthcheck.robot

```robot
*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary

*** Variables ***
${API_URL}    http://localhost:3001

*** Test Cases ***
Health Check Returns 200
    [Documentation]    Verify health endpoint returns 200
    [Tags]    api    smoke
    Create Session    api    ${API_URL}
    ${response}=    GET On Session    api    /health    expected_status=200
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    status
    Should Be Equal    ${response.json()['status']}    ok

Get Users Returns Array
    [Documentation]    Verify users endpoint returns list
    [Tags]    api    users
    Create Session    api    ${API_URL}
    ${response}=    GET On Session    api    /users    expected_status=200
    Should Be Equal As Integers    ${response.status_code}    200
    ${length}=    Get Length    ${response.json()}
    Should Be True    ${length} >= 0
```

## Data-Driven Test Example

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
    [Documentation]    Parametrized login test using template
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

## Configuration Files

### requirements.txt (Python)

```txt
robotframework==7.1.1
robotframework-seleniumlibrary==6.6.2
robotframework-requests==0.9.7
robotframework-jsonlibrary==0.5.0
```

### Running Tests

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

## Trigger Keywords

Load this skill when the user says any of:
- "Robot Framework", "Robot Framework tests", ".robot files"
- "generate Robot Framework", "RF test suite"
- "keyword-driven testing", "data-driven testing"
- "pruebas Robot Framework", "archivos .robot", "framework de Robot"
