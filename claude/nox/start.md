---
name: start
description: Guided onboarding — detects your stack, identifies your workflow, and recommends the right Nox skills to use. Use when first installing Nox or when unsure which skills fit your project.
argument-hint: "[project-path]"
metadata:
  author: nox
  version: "3.0"
---

Welcome to Nox. This skill detects your project stack, understands your workflow, and recommends the exact skills you should use — no guessing, no reading the full catalog.

## Process

### Step 1: Detect Stack

Scan the project for framework markers:

| Check | Detects |
|-------|---------|
| `package.json` | Node.js, framework (Next.js, React, Vue, Svelte, Express), test runner, linter |
| `requirements.txt` / `pyproject.toml` | Python, Django, FastAPI, Flask |
| `Cargo.toml` | Rust |
| `go.mod` | Go |
| `vercel.json` / `.vercel/` | Vercel deployment |
| `fly.toml` / `railway.json` | Fly.io / Railway deployment |
| `.env*` files | Environment variable usage |
| `CLAUDE.md` / `MEMORY.md` | Existing AI context |
| `.github/workflows/` | CI/CD already configured |
| `supabase/` / `prisma/` / `drizzle/` | Database ORM |

Report what was found in 3-5 lines.

### Step 2: Identify Workflow

Ask the user ONE question:

> What's your main focus right now?
> 1. **Building a new feature** — architecture, planning, implementation
> 2. **Shipping to production** — deploy, CI/CD, monitoring
> 3. **Fixing bugs or debugging** — diagnostics, repair, investigation
> 4. **Code quality & review** — audit, refactor, tests, security
> 5. **Just exploring** — show me everything

### Step 3: Recommend Skills

Based on detected stack + workflow choice, recommend 5-8 skills in priority order:

```
Your Nox Starter Kit
━━━━━━━━━━━━━━━━━━━━
Stack: Next.js + Supabase + Vercel
Focus: Building a new feature

START HERE:
  1. /nox:questions    — Remove ambiguity before coding
  2. /nox:architect    — Design the feature structure
  3. /nox:tdd          — Write tests first, then implement

THEN:
  4. /nox:review       — Check your code before committing
  5. /nox:commit       — Generate a clean commit message
  6. /nox:deploy       — Push and deploy with safety checks

ALSO USEFUL:
  7. /nox:security     — Scan for vulnerabilities before shipping
  8. /nox:env          — Audit your environment variables
```

### Step 4: Quick Wins

Suggest immediate actions based on what's missing:
- No `CLAUDE.md`? → "Run `/nox:context-engineer` to set up AI context"
- No tests? → "Run `/nox:tdd` to bootstrap your test suite"
- No CI/CD? → "Run `/nox:cicd` to generate a workflow"
- No `.env.example`? → "Run `/nox:env` to audit and generate one"

### Step 5: Hooks Recommendation

If hooks aren't installed, suggest the top 3 most useful ones for their workflow:

- **Building features**: `destructive-guard`, `secret-scanner`, `commit-lint`
- **Shipping to production**: `secret-scanner`, `test-regression-guard`, `cost-alert`
- **Debugging**: `debug-reminder`, `session-logger`, `destructive-guard`
- **Code quality**: `file-size-guard`, `secret-scanner`, `prompt-guard`

## Rules

- Keep the output concise — this is onboarding, not a lecture.
- Never recommend more than 8 skills. Overwhelming defeats the purpose.
- Prioritize by impact — the first 3 recommendations should be the most useful for their stated focus.
- If registry skills (api, schema, landing, doc, swot, monitorlive, explain) would be useful, mention them with: "Install extended skills with `bash install.sh --with-registry`"
- Don't ask more than 1 question. Detect everything else automatically.

---
Nox
