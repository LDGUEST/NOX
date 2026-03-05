---
name: tdd
description: Red-green-refactor enforcement — test-first development
---

Enforce the Red-Green-Refactor cycle. No skipping steps.

## Protocol

### Step 1: RED — Write a Failing Test

- Write a test that describes the expected behavior
- Run it and **verify it fails** with the expected error
- If it passes immediately, the test is wrong or the feature already exists — investigate

### Step 2: GREEN — Write Minimal Code to Pass

- Write the absolute minimum code to make the test pass
- No extra features, no premature optimization, no "while I'm here" additions
- Run the test and **verify it passes**

### Step 3: REFACTOR — Clean Up

- Now improve the code: remove duplication, improve naming, extract functions
- Run the test after every change to ensure it still passes
- If any test breaks during refactoring, revert and try again

## Rules

1. **Never write production code without a failing test first**
2. **Never write more test code than needed to create a failure**
3. **Never write more production code than needed to pass the test**
4. **Run tests after every change** — no batching up changes and hoping they work
5. **Commit after each green-refactor cycle** — small, atomic commits

## Test Framework Detection

Auto-detect the project's test framework:
- `jest.config.*` or `package.json[jest]` → Jest
- `vitest.config.*` → Vitest
- `pytest.ini` or `pyproject.toml[tool.pytest]` → Pytest
- `*_test.go` → Go test
- `Cargo.toml` → cargo test

Use the detected framework's conventions for file naming, assertion style, and test organization.

---
Nox
