---
name: sdet-lang-java
description: >
  Patrones y convenciones de testing Java para trabajo SDET.
  Trigger: Java testing, JUnit, TestNG, patrones Java, automatización Java
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-sdet
---

# Patrones de testing Java para SDET

Patrones de JUnit 5 y TestNG, librerías de aserciones, mocking y estructura de proyectos para automatización de tests Java.

## Estructura del proyecto

```
src/
├── main/java/com/example/
│   ├── service/
│   │   └── UserService.java
│   └── model/
│       └── User.java
└── test/java/com/example/
    ├── service/
    │   └── UserServiceTest.java
    ├── api/
    │   └── UserApiTest.java
    ├── pages/              # Page Objects (UI)
    │   ├── BasePage.java
    │   └── LoginPage.java
    └── utils/
        ├── TestDataFactory.java
        └── ApiHelper.java
```

## Patrones de JUnit 5

### Estructura básica de un test

```java
import org.junit.jupiter.api.*;
import static org.assertj.core.api.Assertions.*;

@DisplayName("UserService Tests")
class UserServiceTest {

    private UserService service;

    @BeforeEach
    void setUp() {
        service = new UserService();
    }

    @Test
    @DisplayName("should create user with valid data")
    void shouldCreateUserWithValidData() {
        // Arrange
        CreateUserRequest request = new CreateUserRequest("John", "john@test.com");

        // Act
        User result = service.create(request);

        // Assert
        assertThat(result.getName()).isEqualTo("John");
        assertThat(result.getEmail()).isEqualTo("john@test.com");
        assertThat(result.getId()).isNotNull();
    }

    @AfterEach
    void tearDown() {
        // Cleanup if needed
    }
}
```

### Tests parametrizados

```java
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.*;

class LoginValidationTest {

    @ParameterizedTest(name = "email={0} should return status={1}")
    @CsvSource({
        "valid@example.com, 200",
        "invalid-email, 422",
        "'', 422",
        "missing@domain, 422"
    })
    void testLoginValidation(String email, int expectedStatus) {
        HttpResponse response = login(email, "password123");
        assertThat(response.statusCode()).isEqualTo(expectedStatus);
    }

    @ParameterizedTest
    @ValueSource(strings = {"admin", "editor", "viewer"})
    void testRolePermissions(String role) {
        AuthenticatedClient client = authenticateAs(role);
        HttpResponse response = client.get("/admin/dashboard");
        if ("admin".equals(role)) {
            assertThat(response.statusCode()).isEqualTo(200);
        } else {
            assertThat(response.statusCode()).isEqualTo(403);
        }
    }

    @ParameterizedTest
    @MethodSource("invalidRegistrationData")
    void testRegistrationValidation(String name, String email, String expectedField) {
        RegistrationRequest req = new RegistrationRequest(name, email, "pass123");
        ValidationException ex = assertThrows(ValidationException.class,
            () -> service.register(req));
        assertThat(ex.getField()).isEqualTo(expectedField);
    }

    static Stream<Arguments> invalidRegistrationData() {
        return Stream.of(
            Arguments.of("", "test@test.com", "name"),
            Arguments.of("John", "invalid", "email"),
            Arguments.of(null, "test@test.com", "name")
        );
    }
}
```

### Tests anidados y ciclo de vida

```java
@DisplayName("Order Processing")
class OrderTest {

    @Nested
    @DisplayName("when order is valid")
    class ValidOrder {
        private Order order;

        @BeforeEach
        void setUp() {
            order = OrderFactory.createValidOrder();
        }

        @Test
        void shouldCalculateTotal() {
            assertThat(order.getTotal()).isPositive();
        }

        @Test
        void shouldHaveValidStatus() {
            assertThat(order.getStatus()).isEqualTo(OrderStatus.PENDING);
        }
    }

    @Nested
    @DisplayName("when order is invalid")
    class InvalidOrder {
        @Test
        void shouldRejectEmptyOrder() {
            assertThrows(IllegalArgumentException.class,
                () -> new Order(Collections.emptyList()));
        }
    }
}
```

## Patrones de TestNG

```java
import org.testng.annotations.*;
import static org.assertj.core.api.Assertions.*;

public class ApiTest {

    private ApiClient client;

    @BeforeSuite
    void setupSuite() {
        // One-time setup: start containers, set env vars
    }

    @BeforeClass
    void setupClass() {
        client = new ApiClient("http://localhost:8080");
    }

    @BeforeMethod
    void setupMethod() {
        client.resetState();
    }

    @Test(dataProvider = "loginData")
    void testLogin(String email, String password, int expectedStatus) {
        HttpResponse response = client.post("/auth/login",
            Map.of("email", email, "password", password));
        assertThat(response.statusCode()).isEqualTo(expectedStatus);
    }

    @DataProvider(name = "loginData")
    Object[][] loginData() {
        return new Object[][] {
            {"valid@test.com", "pass123", 200},
            {"invalid-email", "pass123", 422},
            {"valid@test.com", "", 422},
        };
    }

    @AfterMethod
    void teardownMethod() {
        client.clearHeaders();
    }

    @AfterClass
    void teardownClass() {
        client.close();
    }

    @AfterSuite
    void teardownSuite() {
        // Cleanup: stop containers
    }
}
```

## Librerías de aserciones

### AssertJ (Recommended)

```java
import static org.assertj.core.api.Assertions.*;

// Strings
assertThat(name).isEqualTo("John").isNotBlank();
assertThat(email).containsIgnoringCase("test");
assertThat(name).matches("[A-Z][a-z]+");

// Collections
assertThat(users).hasSize(3).extracting("name").contains("John", "Jane");
assertThat(users).filteredOn(u -> u.isActive()).hasSize(2);

// Exceptions
assertThatThrownBy(() -> service.create(null))
    .isInstanceOf(IllegalArgumentException.class)
    .hasMessageContaining("required");

// Soft assertions (all checked, then reported)
SoftAssertions.assertSoftly(softly -> {
    softly.assertThat(result.getName()).isEqualTo("John");
    softly.assertThat(result.getEmail()).isEqualTo("john@test.com");
    softly.assertThat(result.getId()).isNotNull();
});
```

### Hamcrest

```java
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

assertThat(users, hasSize(3));
assertThat(users, hasItem(hasProperty("name", equalTo("John"))));
assertThat(response.body(), containsString("success"));
```

## Patrones de Mockito

```java
import org.mockito.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class OrderServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private PaymentGateway paymentGateway;

    @InjectMocks
    private OrderService orderService;

    @Captor
    private ArgumentCaptor<Order> orderCaptor;

    @Test
    void shouldCreateOrderAndProcessPayment() {
        // Arrange
        when(userRepository.findById(1L)).thenReturn(Optional.of(testUser));
        when(paymentGateway.charge(any(PaymentRequest.class)))
            .thenReturn(new PaymentResult(true, "txn-123"));

        // Act
        Order order = orderService.createOrder(1L, BigDecimal.valueOf(99.99));

        // Assert
        verify(userRepository).findById(1L);
        verify(paymentGateway).charge(orderCaptor.capture());
        assertThat(orderCaptor.getValue().getAmount())
            .isEqualTo(BigDecimal.valueOf(99.99));
    }

    @Test
    void shouldHandlePaymentFailure() {
        when(userRepository.findById(1L)).thenReturn(Optional.of(testUser));
        when(paymentGateway.charge(any()))
            .thenReturn(new PaymentResult(false, "Card declined"));

        assertThrows(PaymentException.class,
            () -> orderService.createOrder(1L, BigDecimal.valueOf(99.99)));

        verify(paymentGateway).charge(any());
    }
}
```

## Plantilla de tests de API

```java
import io.restassured.RestAssured;
import io.restassured.http.ContentType;
import org.junit.jupiter.api.*;

import static io.restassured.RestAssured.*;
import static org.assertj.core.api.Assertions.*;

@DisplayName("User API Tests")
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class UserApiTest {

    private static String authToken;

    @BeforeAll
    static void setup() {
        RestAssured.baseURI = "http://localhost:8080";
        authToken = given()
            .contentType(ContentType.JSON)
            .body(Map.of("email", "admin@test.com", "password", "pass123"))
        .when()
            .post("/auth/login")
        .then()
            .statusCode(200)
            .extract().path("access_token");
    }

    @Test
    @Order(1)
    void shouldCreateUser() {
        Integer id = given()
            .header("Authorization", "Bearer " + authToken)
            .contentType(ContentType.JSON)
            .body(Map.of("name", "John", "email", "john@test.com"))
        .when()
            .post("/users")
        .then()
            .statusCode(201)
            .extract().path("id");

        assertThat(id).isNotNull();
    }
}
```

