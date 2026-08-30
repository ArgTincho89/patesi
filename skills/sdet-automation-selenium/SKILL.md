---
name: sdet-automation-selenium
description: >
  Genera frameworks de tests con Selenium WebDriver para Java y Python.
  Trigger: Selenium, WebDriver, tests Selenium, automatización Selenium
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-sdet
---

# Generador de frameworks de tests con Selenium WebDriver

Genera frameworks de tests con Selenium WebDriver para Java (Maven + TestNG) y Python (pytest + Selenium) siguiendo buenas prácticas de la industria. Usalo cuando el usuario necesite automatizar tests con Selenium.

---

## Java (Maven + TestNG)

### Estructura del framework

```
src/
├── main/
│   └── java/
│       └── {package}/
│           └── pages/
│               ├── BasePage.java       # Abstract base page
│               └── {Feature}Page.java  # Page objects
├── test/
│   ├── java/
│   │   └── {package}/
│   │       ├── tests/
│   │       │   └── {Feature}Test.java  # Test classes
│   │       ├── utils/
│   │       │   ├── DriverFactory.java  # WebDriver setup
│   │       │   └── TestDataProvider.java
│   │       └── listeners/
│   │           └── TestListener.java   # TestNG listeners
│   └── resources/
│       └── testdata/
│           └── users.json              # Test data
pom.xml
```

### pom.xml Template

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.{company}</groupId>
    <artifactId>selenium-tests</artifactId>
    <version>1.0.0</version>
    <packaging>jar</packaging>

    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <selenium.version>4.27.0</selenium.version>
        <testng.version>7.10.2</testng.version>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.seleniumhq.selenium</groupId>
            <artifactId>selenium-java</artifactId>
            <version>${selenium.version}</version>
        </dependency>
        <dependency>
            <groupId>org.testng</groupId>
            <artifactId>testng</artifactId>
            <version>${testng.version}</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>com.aventstack</groupId>
            <artifactId>extentreports</artifactId>
            <version>5.1.3</version>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>3.5.2</version>
                <configuration>
                    <suiteXmlFiles>
                        <suiteXmlFile>testng.xml</suiteXmlFile>
                    </suiteXmlFiles>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
```

### DriverFactory.java

```java
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.edge.EdgeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.firefox.FirefoxOptions;

public class DriverFactory {
    private static final ThreadLocal<WebDriver> driver = new ThreadLocal<>();

    public static WebDriver getDriver(String browser) {
        if (driver.get() == null) {
            switch (browser.toLowerCase()) {
                case "firefox":
                    driver.set(new FirefoxDriver(new FirefoxOptions()));
                    break;
                case "edge":
                    driver.set(new EdgeDriver());
                    break;
                default:
                    driver.set(new ChromeDriver(new ChromeOptions()));
            }
            driver.get().manage().window().maximize();
        }
        return driver.get();
    }

    public static void quitDriver() {
        if (driver.get() != null) {
            driver.get().quit();
            driver.remove();
        }
    }
}
```

### BasePage.java

```java
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.openqa.selenium.support.ui.ExpectedConditions;
import java.time.Duration;

public abstract class BasePage {
    protected WebDriver driver;
    protected WebDriverWait wait;

    public BasePage(WebDriver driver) {
        this.driver = driver;
        this.wait = new WebDriverWait(driver, Duration.ofSeconds(10));
    }

    public void navigateTo(String path) {
        driver.get(path);
        waitForPageLoad();
    }

    public void waitForPageLoad() {
        wait.until(webDriver ->
            ((org.openqa.selenium.JavascriptExecutor) webDriver)
                .executeScript("return document.readyState").equals("complete")
        );
    }

    protected void waitForVisibility(org.openqa.selenium.WebElement element) {
        wait.until(ExpectedConditions.visibilityOf(element));
    }

    protected void waitForClickability(org.openqa.selenium.WebElement element) {
        wait.until(ExpectedConditions.elementToBeClickable(element));
    }
}
```

### {Feature}Page.java

```java
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class {Feature}Page extends BasePage {

    @FindBy(id = "email")
    private WebElement emailInput;

    @FindBy(id = "password")
    private WebElement passwordInput;

    @FindBy(css = "[data-testid='submit-btn']")
    private WebElement submitButton;

    @FindBy(css = "[role='alert']")
    private WebElement errorMessage;

    public {Feature}Page(WebDriver driver) {
        super(driver);
        PageFactory.initElements(driver, this);
    }

    public void navigate() {
        navigateTo("http://localhost:3000/{feature-route}");
    }

    public void fillForm(String email, String password) {
        waitForVisibility(emailInput);
        emailInput.sendKeys(email);
        passwordInput.sendKeys(password);
    }

    public void submit() {
        waitForClickability(submitButton);
        submitButton.click();
    }

    public String getErrorMessage() {
        waitForVisibility(errorMessage);
        return errorMessage.getText();
    }
}
```

### Ejemplo de test (Java)

```java
import org.testng.annotations.*;
import org.openqa.selenium.WebDriver;
import static org.testng.Assert.*;

public class LoginTest {
    private WebDriver driver;
    private LoginPage loginPage;

    @BeforeMethod
    @Parameters({"browser"})
    public void setUp(@Optional("chrome") String browser) {
        driver = DriverFactory.getDriver(browser);
        loginPage = new LoginPage(driver);
        loginPage.navigate();
    }

    @AfterMethod
    public void tearDown() {
        DriverFactory.quitDriver();
    }

    @Test(description = "Should login with valid credentials")
    public void testValidLogin() {
        loginPage.fillForm("user@example.com", "ValidPass1");
        loginPage.submit();
        assertTrue(driver.getCurrentUrl().contains("/dashboard"));
    }

    @Test(description = "Should show error for invalid credentials")
    public void testInvalidLogin() {
        loginPage.fillForm("invalid@test.com", "WrongPass");
        loginPage.submit();
        assertEquals(loginPage.getErrorMessage(), "Invalid email or password");
    }
}
```

---

## Python (pytest + Selenium)

### Estructura del framework

```
tests/
├── pages/
│   ├── base_page.py          # Base page class
│   └── login_page.py         # Page objects
├── test_data/
│   └── users.json            # Test data
├── conftest.py               # pytest fixtures
├── test_login.py             # Test files
└── requirements.txt          # Dependencias
```

### requirements.txt

```txt
selenium==4.27.0
pytest==8.3.4
pytest-html==4.1.1
```

### base_page.py

```python
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By

class BasePage:
    def __init__(self, driver, timeout=10):
        self.driver = driver
        self.wait = WebDriverWait(driver, timeout)

    def navigate_to(self, url):
        self.driver.get(url)
        self.wait_for_page_load()

    def wait_for_page_load(self):
        self.wait.until(
            lambda d: d.execute_script("return document.readyState") == "complete"
        )

    def find(self, locator):
        return self.wait.until(EC.presence_of_element_located(locator))

    def click(self, locator):
        self.wait.until(EC.element_to_be_clickable(locator)).click()

    def type_text(self, locator, text):
        element = self.find(locator)
        element.clear()
        element.send_keys(text)

    def get_text(self, locator):
        return self.find(locator).text
```

### {Feature}_page.py

```python
from selenium.webdriver.common.by import By
from .base_page import BasePage

class {Feature}Page(BasePage):
    EMAIL_INPUT = (By.ID, "email")
    PASSWORD_INPUT = (By.ID, "password")
    SUBMIT_BUTTON = (By.CSS_SELECTOR, "[data-testid='submit-btn']")
    ERROR_MESSAGE = (By.CSS_SELECTOR, "[role='alert']")

    def navigate(self):
        self.navigate_to("http://localhost:3000/{feature-route}")

    def login(self, email, password):
        self.type_text(self.EMAIL_INPUT, email)
        self.type_text(self.PASSWORD_INPUT, password)
        self.click(self.SUBMIT_BUTTON)

    def get_error_message(self):
        return self.get_text(self.ERROR_MESSAGE)
```

### conftest.py

```python
import pytest
from selenium import webdriver
from selenium.webdriver.chrome.options import Options as ChromeOptions

@pytest.fixture(scope="function")
def driver():
    options = ChromeOptions()
    options.add_argument("--start-maximized")
    driver = webdriver.Chrome(options=options)
    yield driver
    driver.quit()

@pytest.fixture
def login_page(driver):
    from pages.login_page import LoginPage
    page = LoginPage(driver)
    page.navigate()
    return page
```

### Ejemplo de test (Python)

```python
import pytest

class TestLogin:
    def test_valid_login(self, login_page):
        login_page.login("user@example.com", "ValidPass1")
        assert "/dashboard" in login_page.driver.current_url

    def test_invalid_credentials(self, login_page):
        login_page.login("invalid@test.com", "WrongPass")
        assert login_page.get_error_message() == "Invalid email or password"

    def test_empty_fields(self, login_page):
        login_page.login("", "")
        assert login_page.get_error_message() == "Email is required"
```
