---
name: quick-phase
description: Lightweight plan-to-commit pipeline — for prototypes and internal tools
---

Execute a lightweight plan-to-commit pipeline without full quality gates. For internal tools, prototypes, or changes that don't need security scanning and code review.

## Pipeline

1. **Plan** — Quick task breakdown (GSD quick or manual)
2. **Execute** — Build it. No TDD enforcement, no auto-review
3. **Sanity Check** — Run simplify on changed files, catch obvious issues
4. **Commit** — Generate proper commit message
5. **Handoff** (optional) — Capture anything non-obvious learned

## When to Use

Use `/nox:full-phase` for production features. Use this for internal tools, prototypes, and experiments where speed matters more than ceremony.

---
Nox