# Testing Guide

This guide covers testing strategies, tools, and best practices for this project.

## Testing Philosophy

We follow a comprehensive testing approach that includes:

- **Unit Tests**: Test individual components in isolation
- **Integration Tests**: Test component interactions
- **End-to-End Tests**: Test complete user workflows
- **Performance Tests**: Ensure acceptable performance under load

## Testing Framework

This project uses:
- **[Testing Framework]** (e.g., pytest for Python, Jest for JavaScript)
- **[Mocking Library]** (e.g., unittest.mock, jest.mock)
- **[Coverage Tool]** (e.g., coverage.py, jest coverage)

## Test Structure

```
tests/
├── unit/                   # Unit tests
│   ├── test_calculator.py
│   ├── test_validator.py
│   └── __init__.py
├── integration/           # Integration tests
│   ├── test_api.py
│   ├── test_database.py
│   └── __init__.py
├── e2e/                   # End-to-end tests
│   ├── test_user_flows.py
│   └── __init__.py
├── fixtures/              # Test data and fixtures
│   ├── sample_data.json
│   └── mock_responses.py
├── conftest.py           # Pytest configuration
└── __init__.py
```

## Writing Tests

### Unit Tests

Unit tests should test individual functions or methods in isolation:

```python
import pytest
from unittest.mock import Mock, patch
from src.calculator import Calculator

class TestCalculator:
    def setup_method(self):
        """Set up test fixtures before each test method."""
        self.calculator = Calculator()
    
    def test_add_positive_numbers(self):
        """Test addition of positive numbers."""
        result = self.calculator.add(2, 3)
        assert result == 5
    
    def test_add_negative_numbers(self):
        """Test addition of negative numbers."""
        result = self.calculator.add(-2, -3)
        assert result == -5
    
    def test_divide_by_zero(self):
        """Test division by zero raises appropriate exception."""
        with pytest.raises(ZeroDivisionError):
            self.calculator.divide(10, 0)
    
    @patch('src.calculator.external_service')
    def test_with_external_dependency(self, mock_service):
        """Test function that depends on external service."""
        mock_service.get_data.return_value = {"value": 10}
        result = self.calculator.calculate_with_service()
        assert result == 10
        mock_service.get_data.assert_called_once()
```

### Integration Tests

Integration tests verify that components work together correctly:

```python
import pytest
from src.api import create_app
from src.database import db

@pytest.fixture
def client():
    """Create test client."""
    app = create_app(testing=True)
    with app.test_client() as client:
        with app.app_context():
            db.create_all()
            yield client
            db.drop_all()

def test_user_creation_flow(client):
    """Test complete user creation flow."""
    # Create user
    response = client.post('/api/users', json={
        'name': 'Test User',
        'email': 'test@example.com'
    })
    assert response.status_code == 201
    
    # Verify user exists
    user_id = response.json['id']
    response = client.get(f'/api/users/{user_id}')
    assert response.status_code == 200
    assert response.json['name'] == 'Test User'
```

### End-to-End Tests

E2E tests simulate real user interactions:

```python
import pytest
from selenium import webdriver
from selenium.webdriver.common.by import By

@pytest.fixture
def browser():
    """Set up browser for E2E tests."""
    driver = webdriver.Chrome()
    yield driver
    driver.quit()

def test_user_login_flow(browser):
    """Test complete user login flow."""
    browser.get("http://localhost:3000/login")
    
    # Enter credentials
    browser.find_element(By.ID, "email").send_keys("test@example.com")
    browser.find_element(By.ID, "password").send_keys("password")
    browser.find_element(By.ID, "login-button").click()
    
    # Verify successful login
    assert "Dashboard" in browser.title
    assert browser.find_element(By.CLASS_NAME, "welcome-message").is_displayed()
```

## Test Data and Fixtures

### Using Fixtures

Create reusable test data with fixtures:

```python
import pytest
from src.models import User

@pytest.fixture
def sample_user():
    """Create a sample user for testing."""
    return User(
        name="Test User",
        email="test@example.com",
        age=25
    )

@pytest.fixture
def user_data():
    """Sample user data dictionary."""
    return {
        "name": "Test User",
        "email": "test@example.com",
        "preferences": {"theme": "dark"}
    }

def test_user_creation(sample_user):
    """Test using fixture."""
    assert sample_user.name == "Test User"
    assert sample_user.is_valid()
```

### Parametrized Tests

Test multiple scenarios efficiently:

```python
import pytest

@pytest.mark.parametrize("input_value,expected", [
    (0, 0),
    (1, 1),
    (2, 4),
    (3, 9),
    (-2, 4),
])
def test_square_function(input_value, expected):
    from src.math_utils import square
    assert square(input_value) == expected
```

## Mocking

### External Dependencies

Mock external services and APIs:

```python
from unittest.mock import Mock, patch
import requests

@patch('requests.get')
def test_api_call(mock_get):
    """Test function that makes HTTP request."""
    mock_response = Mock()
    mock_response.json.return_value = {"status": "success"}
    mock_response.status_code = 200
    mock_get.return_value = mock_response
    
    from src.api_client import fetch_data
    result = fetch_data("http://api.example.com/data")
    
    assert result["status"] == "success"
    mock_get.assert_called_once_with("http://api.example.com/data")
```

### Database Mocking

```python
@patch('src.database.connection')
def test_database_query(mock_connection):
    """Test database query function."""
    mock_cursor = Mock()
    mock_cursor.fetchall.return_value = [("user1",), ("user2",)]
    mock_connection.cursor.return_value = mock_cursor
    
    from src.user_service import get_all_users
    users = get_all_users()
    
    assert len(users) == 2
    assert "user1" in users
```

## Running Tests

### Basic Commands

```bash
# Run all tests
pytest

# Run specific test file
pytest tests/unit/test_calculator.py

# Run specific test
pytest tests/unit/test_calculator.py::TestCalculator::test_add

# Run tests with verbose output
pytest -v

# Run tests and stop on first failure
pytest -x
```

### Coverage Reports

```bash
# Run tests with coverage
pytest --cov=src

# Generate HTML coverage report
pytest --cov=src --cov-report=html

# Set minimum coverage threshold
pytest --cov=src --cov-fail-under=80
```

### Parallel Execution

```bash
# Install pytest-xdist
pip install pytest-xdist

# Run tests in parallel
pytest -n auto
```

## Test Configuration

### pytest.ini

```ini
[tool:pytest]
testpaths = tests
python_files = test_*.py
python_classes = Test*
python_functions = test_*
addopts = 
    --strict-markers
    --disable-warnings
    --cov=src
    --cov-report=term-missing
    --cov-report=html:htmlcov
    --cov-fail-under=80
markers =
    slow: marks tests as slow
    integration: marks tests as integration tests
    e2e: marks tests as end-to-end tests
```

### conftest.py

```python
import pytest
from src.app import create_app
from src.database import db

@pytest.fixture(scope="session")
def app():
    """Create application for testing."""
    app = create_app(testing=True)
    return app

@pytest.fixture(scope="function")
def client(app):
    """Create test client."""
    return app.test_client()

@pytest.fixture(scope="function")
def database(app):
    """Create database for testing."""
    with app.app_context():
        db.create_all()
        yield db
        db.drop_all()
```

## Best Practices

### Test Organization

- Group related tests in classes
- Use descriptive test names
- Follow the AAA pattern (Arrange, Act, Assert)
- Keep tests independent and isolated

### Test Quality

- Test both happy path and edge cases
- Use appropriate assertions
- Avoid testing implementation details
- Keep tests simple and focused

### Test Maintenance

- Update tests when requirements change
- Remove obsolete tests
- Refactor tests to reduce duplication
- Review test coverage regularly

## Continuous Integration

Tests are automatically run on:
- Every push to feature branches
- Pull requests to main/develop
- Scheduled daily runs

See `.github/workflows/ci.yml` for CI configuration.

## Performance Testing

### Load Testing

```python
import time
import pytest

def test_performance_requirement():
    """Test that function meets performance requirement."""
    start_time = time.time()
    
    # Call function under test
    result = expensive_function()
    
    execution_time = time.time() - start_time
    assert execution_time < 1.0  # Should complete within 1 second
```

### Memory Testing

```python
import psutil
import os

def test_memory_usage():
    """Test memory usage stays within bounds."""
    process = psutil.Process(os.getpid())
    initial_memory = process.memory_info().rss
    
    # Run memory-intensive operation
    large_operation()
    
    final_memory = process.memory_info().rss
    memory_increase = final_memory - initial_memory
    
    # Should not increase memory by more than 100MB
    assert memory_increase < 100 * 1024 * 1024
```

## Troubleshooting

### Common Issues

1. **Tests fail locally but pass in CI**: Check for environment differences
2. **Flaky tests**: Often caused by timing issues or external dependencies
3. **Slow test suite**: Profile tests and optimize or parallelize

### Debugging Tests

```bash
# Run with pdb on failures
pytest --pdb

# Print output during tests
pytest -s

# Run only failed tests from last run
pytest --lf
```

## Resources

- [Pytest Documentation](https://docs.pytest.org/)
- [Testing Best Practices](https://docs.python-guide.org/writing/tests/)
- [Mock Documentation](https://docs.python.org/3/library/unittest.mock.html)