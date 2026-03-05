Execute a lightweight plan-to-commit pipeline without full quality gates. For internal tools, prototypes, or changes that don't need security scanning and code review.

**Requires:** [GSD](https://github.com/get-shit-done-ai/gsd) installed alongside Nox for full functionality. Works without GSD in manual mode.

## Pipeline

### Step 1: Plan
Quick task breakdown — either via `/gsd:quick` or a manual decomposition. No architecture phase.

### Step 2: Execute
Build it. No TDD enforcement, no auto-review. Just get it done.

### Step 3: Sanity Check
Run `/nox:simplify` on changed files — catch obvious issues, but don't block on warnings.

### Step 4: Commit
Run `/nox:commit` to generate a proper commit message.

### Step 5: Handoff (optional)
If anything non-obvious was learned, run `/nox:handoff` to capture it.

## When to Use This vs /nox:full-phase

| | `/nox:full-phase` | `/nox:quick-phase` |
|---|---|---|
| **Use for** | Production features, user-facing changes | Internal tools, prototypes, experiments |
| **Quality gates** | TDD, review, security scan, deploy protocol | Simplify check only |
| **Speed** | Thorough — takes longer | Fast — minimal overhead |
| **Deploy** | Full 5-step protocol | Manual or skip |
| **Best when** | Shipping to users | Iterating quickly |

## Without GSD

Works standalone — Step 1 creates a manual task list instead of using GSD's planning system.

---
Nox