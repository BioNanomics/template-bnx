# Tests Directory

This directory contains all test files for the project.

## Structure

```
tests/
├── unit/                 # Unit tests - test individual components
├── integration/          # Integration tests - test component interactions
├── e2e/                  # End-to-end tests - test complete workflows
├── fixtures/             # Test data and fixtures
├── conftest.py          # Test configuration (pytest)
└── README.md            # This file
```

## Test Types

### Unit Tests
- Fast execution
- Test individual functions/methods
- Use mocks for external dependencies
- High code coverage

### Integration Tests
- Test component interactions
- Use test databases/services
- Verify data flow between modules

### End-to-End Tests
- Test complete user workflows
- Use real or staging environments
- Validate business requirements

## Running Tests

```bash
# Run all tests
pytest

# Run specific test type
pytest tests/unit/
pytest tests/integration/

# Run with coverage
pytest --cov=src

# Run specific test file
pytest tests/unit/test_example.py
```

## Guidelines

- Write tests before or alongside code (TDD/BDD)
- Use descriptive test names
- Keep tests independent and isolated
- Mock external dependencies in unit tests
- Maintain good test coverage (aim for >80%)
- Update tests when changing functionality