Perform a PR-style code review on the current changes or specified files. Act as a senior reviewer focused on shipping quality code.

## Review Scope

If there are staged/unstaged git changes, review those. Otherwise, review the files or components specified by the user.

## Review Categories

For each finding, assign a severity:

- **Critical** — Must fix before merge. Logic errors, security vulnerabilities, data loss risks, breaking changes.
- **Warning** — Should fix. Performance issues, error handling gaps, potential race conditions, maintainability concerns.
- **Nit** — Nice to fix. Style inconsistencies, naming improvements, minor readability tweaks.

## Checklist

- [ ] **Logic** — Does the code do what it claims? Are there off-by-one errors, missing null checks, wrong comparisons?
- [ ] **Security** — Injection vectors, auth bypass, data exposure, XSS, CSRF?
- [ ] **Performance** — N+1 queries, unnecessary re-renders, missing memoization, large bundle imports?
- [ ] **Error handling** — Are failures caught and handled gracefully? Are errors surfaced to the user?
- [ ] **Edge cases** — Empty arrays, null values, concurrent access, network failures?
- [ ] **Style** — Consistent with the project's existing patterns and conventions?
- [ ] **Tests** — Are new code paths covered? Do existing tests still pass?

## Output Format

For each finding:
```
[CRITICAL|WARNING|NIT] file.ts:42 — Brief description
  → Suggested fix or approach
```

End with an overall verdict: **Approve**, **Request Changes**, or **Comment**.

---
Nox