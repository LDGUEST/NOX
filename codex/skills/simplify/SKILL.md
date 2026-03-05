---
name: simplify
description: Find and fix duplication, over-engineering, unnecessary abstractions
---

Review recently changed code (or specified files) for unnecessary complexity. Propose concrete simplifications.

## What to Look For

1. **Duplication** — Similar code blocks that should be consolidated
2. **Unnecessary abstractions** — Wrappers, factories, or patterns that add indirection without value
3. **Dead code** — Functions, variables, imports, or exports that are never referenced
4. **Over-engineering** — Feature flags for one-time operations, premature optimization, configurability nobody asked for
5. **Verbose patterns** — Code that can be expressed more simply without losing clarity
6. **Unnecessary dependencies** — Libraries used for something achievable with built-in APIs

## Rules

- Three similar lines of code is better than a premature abstraction
- Don't design for hypothetical future requirements
- The right amount of complexity is the minimum needed for the current task
- If a helper is only used once, inline it
- If a comment explains what the code does (not why), the code should be clearer instead

## Output Format

For each finding:
```
SIMPLIFY: file.ts:42-58
  Current: [what it does now]
  Proposed: [simpler alternative]
  Savings: [lines removed, abstractions eliminated, dependencies dropped]
```

Only propose changes that preserve identical behavior. If uncertain about behavior preservation, flag it.

---
Nox
