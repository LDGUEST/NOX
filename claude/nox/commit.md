---
name: commit
description: Pre-ship quality gate + conventional commit message. Validates changed files for secrets, build errors, and code quality before generating a commit. Use when creating a commit or before pushing.
disable-model-invocation: true
argument-hint: "[extra-context]"
metadata:
  author: nox
  version: "3.0"
---

Validate the current changes and generate a commit message. This is a two-phase process: **pre-ship checks first**, then commit message.

**Guardrails Active:** [Nox Guardrails](/nox:guardrails) are enforced — secret scanning on all file writes, branch protection on commits, and test regression tracking.

## Phase 1: Pre-Ship Checklist

Before generating a commit message, validate every changed file. Run through this checklist and **only flag failures** — if everything passes, move silently to Phase 2.

### 1. Build Check
- Run the project's build command (`npm run build`, `cargo build`, `go build`, `python -m py_compile`, etc.)
- If no build system is detected, skip this step
- **FAIL** if the build produces errors (warnings are OK)

### 2. Secret Scan
Scan all staged/changed files for leaked secrets. **BLOCK the commit** if any are found:
- API keys: `sk-`, `sk-ant-`, `AKIA`, `ghp_`, `gho_`, `xoxb-`, `xoxp-`, `rk_live_`, `pk_live_`
- JWTs: `eyJ...` (long base64 with two dots)
- Connection strings with embedded credentials
- Hardcoded passwords, tokens, or secrets assigned to variables
- `.env` file contents pasted directly into source code
- **Fix:** Replace with environment variable references (`process.env.API_KEY`, `os.environ["API_KEY"]`, etc.)

### 3. Debug Artifacts
Scan changed files for leftover debug code:
- `console.log` / `console.debug` / `console.warn` (unless behind a debug flag or in a logging utility)
- `debugger` statements
- `print()` used for debugging (not in CLI tools or scripts where print is the output mechanism)
- Commented-out code blocks (more than 3 consecutive commented lines)
- **Flag as WARNING** — suggest removal but don't block

### 4. Incomplete Work
Scan changed files for markers that suggest unfinished work:
- `TODO` / `FIXME` / `HACK` / `XXX` comments added in this changeset
- Placeholder values: `"placeholder"`, `"changeme"`, `"lorem ipsum"`, `0.0.0.0`, `example.com` in non-test files
- **Flag as WARNING** — the developer may intend to commit these, so flag but don't block

### 5. Sensitive File Check
Check if any of these files are staged for commit. **BLOCK** if found:
- `.env`, `.env.local`, `.env.production`, `.env.*.local`
- `credentials.json`, `serviceAccountKey.json`, `*.pem`, `*.key`
- `id_rsa`, `id_ed25519`, `*.p12`, `*.pfx`
- Any file matching common secret patterns that isn't in `.gitignore`

### 6. Framework-Specific Checks
Auto-detect the project framework and apply relevant checks:

**If Next.js / React:**
- No `NEXT_PUBLIC_` env vars containing secret values
- No server-only imports in client components

**If using a database ORM:**
- No raw SQL with string interpolation (SQL injection risk)
- Parameterized queries only

**If modifying auth/payments:**
- Flag to the developer: "This commit touches auth/payment code — please verify before committing"

### Pre-Ship Verdict

| Result | Action |
|--------|--------|
| All checks pass | Proceed silently to Phase 2 |
| Warnings only | Show warnings, then proceed to Phase 2 |
| Any BLOCK | Show blockers, suggest fixes, do NOT proceed to Phase 2 |

---

## Phase 2: Commit Message

Only reached after Phase 1 passes (or passes with warnings).

### Process

1. Run `git diff --cached` to see staged changes (fall back to `git diff` if nothing staged)
2. Run `git log --oneline -10` to match the repo's commit style
3. Analyze what changed and WHY

### Conventional Commits Format

```
<type>(<scope>): <description>

[optional body — what and why, not how]

[optional footer — breaking changes, issue refs]
```

### Types
- `feat` — New feature (wholly new functionality)
- `fix` — Bug fix
- `refactor` — Code change that neither fixes a bug nor adds a feature
- `perf` — Performance improvement
- `test` — Adding or updating tests
- `docs` — Documentation changes
- `chore` — Build process, dependency updates, config changes
- `style` — Formatting, semicolons, whitespace (no code change)
- `ci` — CI/CD pipeline changes

### Rules

- **Summarize the WHY**, not just the what
- Keep the first line under 72 characters
- Detect breaking changes and add `BREAKING CHANGE:` footer
- Reference issue numbers if apparent from branch name or changes
- If changes span multiple concerns, suggest splitting into separate commits
- Show the proposed message and wait for approval before committing

---
Nox
