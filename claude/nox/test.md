Generate comprehensive tests for existing code. Auto-detect the framework and write tests that match the project's conventions.

## Step 1: Detect Test Framework

Scan the project for:
- `jest.config.*` or `package.json[jest]` → **Jest**
- `vitest.config.*` → **Vitest**
- `pytest.ini`, `pyproject.toml[tool.pytest]`, `conftest.py` → **Pytest**
- `*_test.go` files → **Go test**
- `Cargo.toml` with `[dev-dependencies]` → **cargo test**
- Existing test files → match their patterns and conventions

## Step 2: Analyze Code Under Test

- Identify all public functions, methods, and exported APIs
- Map input types, return types, and side effects
- Find edge cases: null/undefined, empty collections, boundary values, error states
- Identify external dependencies that need mocking

## Step 3: Write Tests

Cover three categories for each function:

### Happy Path
- Standard inputs produce expected outputs
- Common use cases work correctly

### Edge Cases
- Empty/null/undefined inputs
- Boundary values (0, -1, MAX_INT, empty string)
- Large inputs, unicode, special characters
- Concurrent access (if applicable)

### Error Paths
- Invalid inputs throw/return appropriate errors
- Network failures are handled gracefully
- Missing dependencies fail with clear messages

## Step 4: Coverage Target

- Aim for 80%+ line coverage on new tests
- 100% coverage on critical paths (auth, payments, data mutations)
- Report uncovered lines and explain why they're not tested (if intentional)

## Rules

- Match the project's existing test file naming convention
- Use the project's existing assertion library and patterns
- Mock external dependencies, never real network calls in unit tests
- Each test should test ONE thing and have a descriptive name
- Tests must be deterministic — no random data, no time-dependent assertions

---
Nox