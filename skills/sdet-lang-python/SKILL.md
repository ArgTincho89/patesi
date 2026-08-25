---
name: sdet-lang-python
description: >
  Python testing patterns and conventions for SDET work.
  Trigger: Python testing, pytest, patrones Python, automatización Python
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-sdet
---

# Python Testing Patterns for SDET

Patterns, fixtures, and conventions for Python test automation. Covers pytest, fixtures, parametrize, and common libraries.

## Project Structure

```
tests/
├── conftest.py           # Shared fixtures
├── test_{module}.py      # Test modules
├── pages/                # Page Objects (if UI)
│   ├── base_page.py
│   └── login_page.py
├── api/                  # API clients
│   └── api_client.py
├── utils/
│   ├── test_data.py
│   └── helpers.py
├── pytest.ini            # Pytest configuration
└── requirements.txt
```

## pytest.ini Configuration

```ini
[pytest]
testpaths = tests
python_files = test_*.py
python_classes = Test*
python_functions = test_*
addopts =
    -v
    --tb=short
    --strict-markers
    -m "not slow"
markers =
    smoke: Quick sanity tests
    regression: Full regression suite
    slow: Long-running tests
    api: API-only tests
    ui: UI/browser tests
```

## Fixture Patterns

### Basic Fixtures

```python
import pytest

@pytest.fixture
def api_client():
    """Base API client with base URL configured."""
    from httpx import Client
    client = Client(base_url="http://localhost:8080", timeout=10.0)
    yield client
    client.close()

@pytest.fixture
def authenticated_client(api_client):
    """API client with auth token pre-set."""
    response = api_client.post("/auth/login", json={
        "email": "test@example.com",
        "password": "TestPass123"
    })
    token = response.json()["access_token"]
    api_client.headers["Authorization"] = f"Bearer {token}"
    return api_client
```

### Scope Control

```python
@pytest.fixture(scope="session")
def browser():
    """One browser for entire test session."""
    from playwright.sync_api import sync_playwright
    pw = sync_playwright().start()
    browser = pw.chromium.launch(headless=True)
    yield browser
    browser.close()
    pw.stop()

@pytest.fixture(scope="module")
def test_user(db_connection):
    """One user created per test module."""
    user = create_test_user(db_connection)
    yield user
    delete_test_user(db_connection, user.id)
```

## Parametrize Patterns

```python
@pytest.mark.parametrize("email,expected_status", [
    ("valid@example.com", 200),
    ("invalid-email", 422),
    ("", 422),
    ("missing@domain", 422),
])
def test_login_validation(api_client, email, expected_status):
    response = api_client.post("/auth/login", json={
        "email": email,
        "password": "TestPass123"
    })
    assert response.status_code == expected_status

@pytest.mark.parametrize("user_type", ["admin", "editor", "viewer"])
def test_role_permissions(api_client, user_type):
    client = authenticate_as(api_client, user_type)
    response = client.get("/admin/dashboard")
    if user_type == "admin":
        assert response.status_code == 200
    else:
        assert response.status_code == 403
```

### Fixtures with Parametrize

```python
@pytest.fixture
def user_data(request):
    """Generate test data based on parametrize marker."""
    users = {
        "admin": {"email": "admin@test.com", "role": "admin"},
        "user": {"email": "user@test.com", "role": "user"},
    }
    return users[request.param]

@pytest.mark.parametrize("user_type", ["admin", "user"], indirect=True)
def test_user_access(user_data):
    assert user_data["role"] in ["admin", "user"]
```

## Markers and Selection

```python
import pytest

@pytest.mark.smoke
def test_login_smoke():
    assert login("admin@test.com", "pass") is True

@pytest.mark.regression
@pytest.mark.slow
def test_large_dataset_processing():
    process_huge_dataset()
    assert queue_is_empty()

@pytest.mark.skip(reason="Feature not yet implemented")
def test_future_feature():
    pass

@pytest.mark.skipif(
    sys.platform == "win32",
    reason="Linux-only filesystem test"
)
def test_symlink_creation():
    os.symlink("/src", "/dst")
```

## conftest.py Best Practices

```python
# conftest.py — shared fixtures across ALL tests in directory
import pytest
from httpx import Client

def pytest_configure(config):
    """Register custom markers."""
    config.addinivalue_line("markers", "smoke: Quick sanity tests")
    config.addinivalue_line("markers", "slow: Long-running tests")

@pytest.fixture(autouse=True)
def setup_test_env(tmp_path):
    """Auto-run for every test: clean temp directory."""
    os.environ["TEST_OUTPUT_DIR"] = str(tmp_path)
    yield
    # Cleanup after each test if needed

@pytest.fixture
def db_connection():
    """Database connection using test config."""
    conn = create_connection(host="localhost", database="test_db")
    yield conn
    conn.execute("ROLLBACK")
    conn.close()
```

## Popular Python Testing Libraries

| Library | Purpose |
|---------|---------|
| `pytest` | Core test runner |
| `pytest-cov` | Coverage reporting |
| `pytest-xdist` | Parallel test execution |
| `pytest-html` | HTML test reports |
| `pytest-mock` | Mockito-style mocking |
| `requests` | HTTP API testing |
| `httpx` | Async-capable HTTP client |
| `beautifulsoup4` | HTML/XML parsing |
| `playwright` | Browser automation |
| `faker` | Test data generation |
| `factory-boy` | Test object factories |
| `responses` | Mock `requests` library |

## API Test Pattern

```python
import pytest
from httpx import Client

class TestUserAPI:
    def setup_method(self):
        self.client = Client(base_url="http://localhost:8080")
        self.client.headers["Authorization"] = f"Bearer {get_token()}"

    def teardown_method(self):
        self.client.close()

    def test_create_user(self):
        response = self.client.post("/users", json={
            "name": "John Doe",
            "email": "john@example.com"
        })
        assert response.status_code == 201
        data = response.json()
        assert data["name"] == "John Doe"
        assert "id" in data

    @pytest.mark.parametrize("invalid_payload,expected_field", [
        ({"name": ""}, "name"),
        ({"email": "bad"}, "email"),
        ({}, "name"),
    ])
    def test_create_user_validation(self, invalid_payload, expected_field):
        response = self.client.post("/users", json=invalid_payload)
        assert response.status_code == 422
        errors = response.json()["detail"]
        assert any(e["field"] == expected_field for e in errors)
```

## Virtual Environment Setup

```bash
# Create and activate
python -m venv .venv
source .venv/bin/activate        # Linux/macOS
.venv\Scripts\activate           # Windows

# Install dependencies
pip install -r requirements.txt

# Pin versions
pip freeze > requirements.txt

# Run tests
pytest                           # All non-slow tests
pytest -m smoke                  # Only smoke tests
pytest tests/test_api.py         # Specific file
pytest -k "test_login"           # By name pattern
pytest --cov=src --cov-report=html  # With coverage
pytest -n auto                   # Parallel execution
```


