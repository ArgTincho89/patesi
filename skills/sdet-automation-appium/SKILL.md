---
name: sdet-automation-appium
description: >
  Genera automatización de tests móviles con Appium para iOS y Android.
  Trigger: Appium, tests móviles, automatización móvil, iOS, Android
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-sdet
---

# Generador de frameworks de automatización móvil con Appium

Genera frameworks de automatización móvil basados en Appium para iOS y Android, con soporte para Java y Python. Usalo cuando el usuario necesite automatizar tests de aplicaciones móviles.

## Estructura del framework

```
mobile-tests/
├── src/
│   ├── main/
│   │   └── java/
│   │       └── {package}/
│   │           └── pages/
│   │               ├── BasePage.java
│   │               ├── LoginPage.java
│   │               └── DashboardPage.java
│   └── test/
│       ├── java/
│       │   └── {package}/
│       │       └── tests/
│       │           ├── LoginTest.java
│       │           └── DashboardTest.java
│       └── resources/
│           └── config/
│               ├── android-capabilities.json
│               └── ios-capabilities.json
├── pom.xml
└── README.md
```

## Capabilities deseadas

### Android

```json
{
  "platformName": "Android",
  "appium:automationName": "UiAutomator2",
  "appium:deviceName": "Pixel_7_API_34",
  "appium:app": "./apps/app-debug.apk",
  "appium:appPackage": "com.example.app",
  "appium:appActivity": ".MainActivity",
  "appium:noReset": false,
  "appium:autoGrantPermissions": true
}
```

### iOS

```json
{
  "platformName": "iOS",
  "appium:automationName": "XCUITest",
  "appium:deviceName": "iPhone 15",
  "appium:platformVersion": "17.2",
  "appium:app": "./apps/app.ipa",
  "appium:bundleId": "com.example.app",
  "appium:noReset": false
}
```

## Patrón Page Object (Java)

### BasePage.java

```java
import io.appium.java_client.pagefactory.AppiumFieldDecorator;
import org.openqa.selenium.support.PageFactory;
import io.appium.java_client.AppiumDriver;
import org.openqa.selenium.support.ui.WebDriverWait;
import java.time.Duration;

public abstract class BasePage {
    protected AppiumDriver driver;

    public BasePage(AppiumDriver driver) {
        this.driver = driver;
        PageFactory.initElements(new AppiumFieldDecorator(driver, Duration.ofSeconds(15)), this);
    }

    public void waitForVisibility(WebElement element) {
        new WebDriverWait(driver, Duration.ofSeconds(15))
            .until(driver -> element.isDisplayed());
    }

    public void tap(WebElement element) {
        waitForVisibility(element);
        element.click();
    }

    public void type(WebElement element, String text) {
        waitForVisibility(element);
        element.clear();
        element.sendKeys(text);
    }

    public String getText(WebElement element) {
        waitForVisibility(element);
        return element.getText();
    }
}
```

### LoginPage.java

```java
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import org.openqa.selenium.WebElement;

public class LoginPage extends BasePage {

    @AndroidFindBy(id = "com.example.app:id/email")
    @iOSXCUITFindBy(accessibility = "email-field")
    private WebElement emailInput;

    @AndroidFindBy(id = "com.example.app:id/password")
    @iOSXCUITFindBy(accessibility = "password-field")
    private WebElement passwordInput;

    @AndroidFindBy(id = "com.example.app:id/login-btn")
    @iOSXCUITFindBy(accessibility = "login-button")
    private WebElement loginButton;

    @AndroidFindBy(id = "com.example.app:id/error-text")
    @iOSXCUITFindBy(accessibility = "error-label")
    private WebElement errorMessage;

    public LoginPage(AppiumDriver driver) {
        super(driver);
    }

    public void login(String email, String password) {
        type(emailInput, email);
        type(passwordInput, password);
        tap(loginButton);
    }

    public String getErrorMessage() {
        return getText(errorMessage);
    }
}
```

## Patrón Page Object (Python)

### base_page.py

```python
from appium.webdriver.webdriver import WebDriver
from appium.webdriver.common.appiumby import AppiumBy
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

class BasePage:
    def __init__(self, driver: WebDriver, timeout=15):
        self.driver = driver
        self.wait = WebDriverWait(driver, timeout)

    def tap(self, locator):
        self.wait.until(EC.element_to_be_clickable(locator)).click()

    def type_text(self, locator, text):
        element = self.wait.until(EC.presence_of_element_located(locator))
        element.clear()
        element.send_keys(text)

    def get_text(self, locator):
        return self.wait.until(EC.visibility_of_element_located(locator)).text

    def is_displayed(self, locator) -> bool:
        try:
            return self.wait.until(EC.visibility_of_element_located(locator)).is_displayed()
        except:
            return False
```

### login_page.py

```python
from appium.webdriver.common.appiumby import AppiumBy
from .base_page import BasePage

class LoginPage(BasePage):
    EMAIL = (AppiumBy.ID, "com.example.app:id/email")
    PASSWORD = (AppiumBy.ID, "com.example.app:id/password")
    LOGIN_BUTTON = (AppiumBy.ID, "com.example.app:id/login-btn")
    ERROR_MESSAGE = (AppiumBy.ID, "com.example.app:id/error-text")

    def login(self, email: str, password: str):
        self.type_text(self.EMAIL, email)
        self.type_text(self.PASSWORD, password)
        self.tap(self.LOGIN_BUTTON)

    def get_error_message(self) -> str:
        return self.get_text(self.ERROR_MESSAGE)
```

## Ejemplo de test (Java)

```java
import org.testng.annotations.*;
import io.appium.java_client.android.AndroidDriver;
import io.appium.java_client.ios.IOSDriver;
import static org.testng.Assert.*;

public class LoginTest {
    private AppiumDriver driver;
    private LoginPage loginPage;

    @BeforeMethod
    public void setUp() {
        // Initialize driver based on platform
        // driver = new AndroidDriver(new URL("http://localhost:4723"), androidCapabilities());
        // driver = new IOSDriver(new URL("http://localhost:4723"), iosCapabilities());
        loginPage = new LoginPage(driver);
    }

    @AfterMethod
    public void tearDown() {
        if (driver != null) driver.quit();
    }

    @Test
    public void testValidLogin() {
        loginPage.login("user@example.com", "ValidPass1");
        // Assert dashboard is displayed
    }

    @Test
    public void testInvalidLogin() {
        loginPage.login("invalid@test.com", "WrongPass");
        assertEquals(loginPage.getErrorMessage(), "Invalid credentials");
    }
}
```

## Ejemplo de test (Python)

```python
import pytest
from appium import webdriver as appium_driver

@pytest.fixture
def driver():
    desired_caps = {
        "platformName": "Android",
        "appium:automationName": "UiAutomator2",
        "appium:deviceName": "Pixel_7_API_34",
        "appium:app": "./apps/app-debug.apk",
    }
    driver = appium_driver.Remote("http://localhost:4723", desired_caps)
    yield driver
    driver.quit()

class TestLogin:
    def test_valid_login(self, driver):
        login_page = LoginPage(driver)
        login_page.login("user@example.com", "ValidPass1")
        assert "/dashboard" in driver.current_url

    def test_invalid_login(self, driver):
        login_page = LoginPage(driver)
        login_page.login("invalid@test.com", "WrongPass")
        assert login_page.get_error_message() == "Invalid credentials"
```

