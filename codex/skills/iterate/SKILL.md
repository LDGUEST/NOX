---
name: iterate
description: Deploys specialized sub-agents to execute tasks and recursively self-correct until the objective is fully complete. Use for complex, multi-step tasks requiring autonomous execution, verification, or unattended repair sessions.
---


Deploy specialized sub-agents for all required steps. Execute, verify against the goal, and recursively self-correct until the objective is 100% complete.

**Guardrails Active:** All [Nox Guardrails](/nox:guardrails) are enforced — especially the agent limiter (max 10 sub-operations before progress check) and zero-regression test tracking.

## When to Use

- Complex tasks with 3+ interdependent steps that must all succeed
- Fixing multiple related issues across a codebase
- Migration or refactoring tasks that touch many files
- With `--unattended` for overnight repair sessions or unattended bug fixing

## Execution Protocol

### Step 1: Decompose

Break the objective into discrete, verifiable steps:
- Each step must have a clear success criterion ("test passes", "endpoint returns 200", "file renders correctly")
- Order steps by dependency — don't start step 3 if it depends on step 2's output
- Estimate step count upfront — if >15 steps, break into sub-objectives first

### Step 2: Execute

Complete each step one at a time:
- Write the code change
- Run relevant tests immediately — don't batch test runs across multiple steps
- If the step involves UI, take a screenshot before and after

### Step 3: Verify

After each step, confirm ALL of these:
- The change produces the expected output
- No existing tests are broken (run the full relevant test suite, not just the new test)
- No regressions in related functionality
- The change is consistent with the project's coding standards

**Visual verification (UI tasks):** If the step touches any UI, use Playwright to screenshot the affected page/component. Compare against the expected outcome. If the layout is broken, overlapping, or missing content — this counts as a failed verification and triggers a self-correct cycle. Do not move to the next step with broken UI.

### Step 4: Self-Correct

If verification fails:
1. Read the error message carefully — don't guess at the fix
2. Check `DEBUGGING.md` — this issue may have been solved before
3. Identify the root cause, not just the symptom
4. Apply a targeted fix — don't rewrite the entire step
5. Re-verify from Step 3

## Safety Guards

- **Max iterations**: Do not attempt more than 10 correction cycles on a single step. If stuck after 10 attempts, halt and report the blocker with:
  - What was attempted
  - What error persists
  - What approaches were tried and why they failed
- **Rollback on failure**: If a fix introduces more problems than it solves, revert to the last known good state using `git checkout` on the affected files.
- **Progress logging**: Log each step's status (pass/fail/skip) for the final report. Include timing and iteration count per step.
- **Hook safety net**: If Nox hooks are installed, `destructive-guard` prevents dangerous commands during autonomous execution, `debug-reminder` points to DEBUGGING.md on failures (saving rediagnosis), and `cost-alert` warns if the session gets expensive. These run passively on every tool call — no action needed from the agent.

## Unattended Repair Mode

When the user invokes with `--unattended` or says "fix everything" / "overnight repair", enter autonomous repair state with these additional protocols:

### Zero-Regression Mandate

Under no circumstances may you break existing functionality to patch a new issue. Every solution must be cleanly implemented without collateral damage.

Before starting any fix:
1. Run the existing test suite and record the baseline pass/fail count
2. After each fix, re-run the full suite — if failures increase, revert immediately
3. If a fix requires changing a shared module, trace all downstream consumers first

### Micro-Iteration Protocol

For every file you modify, follow this exact loop:

1. **Analysis** — Read the code, identify the root cause. Check git blame for context on why the current code exists. Never fix a symptom without understanding the cause.
2. **Implementation** — Apply a precise, targeted fix. Change the minimum number of lines. Don't refactor adjacent code.
3. **Testing** — Test your modification in isolation. Run the specific test file, not the full suite (save full suite for holistic audit).
4. **Holistic Audit** — After confirming the fix works in isolation, run the full related test suite. Trace import dependencies — if you changed a utility function, run tests for every module that imports it. Prove your change didn't introduce silent bugs.

### Anti-Hanging Rules

Unattended sessions can't afford to burn time on dead ends:

- **5-Minute Reassessment**: If you spend over 5 minutes on a single micro-issue without measurable progress, halt that approach immediately. "Measurable progress" means either a test that was failing now passes, or you have a concrete new hypothesis to test.
- **Pivot Mandate**: Log the failed approach (what you tried, why it didn't work), reassess the problem from scratch, and try a fundamentally different approach. Don't vary the same approach slightly.
- **Max Retries**: No more than 3 pivot attempts per issue. If still stuck after 3 fundamentally different approaches, log it as a blocker with full context and move to the next issue. The user will handle it manually.

### Cross-Machine Operations

If configured, you have authorization to SSH into machines defined in `$FORGE_SSH_HOSTS` to diagnose or fix remote issues:

```bash
# Example: export FORGE_SSH_HOSTS='["prod:user@server1.com", "staging:user@server2.com"]'
```

Treat remote machines with the same zero-regression strictness as the local environment. Never run destructive commands on remote machines. Always verify the remote state before modifying it.

### Hook Safety Net (critical for unattended operation)

If Nox hooks are installed (`bash install.sh --with-hooks`), these protections run passively on every tool call during your entire session:

| Hook | What It Prevents |
|------|-----------------|
| `destructive-guard` | Blocks `rm -rf`, `git reset --hard`, force push, DROP TABLE — your guardrail against catastrophic mistakes at 3am |
| `sync-guard` | Warns if another process modified files since your last read |
| `secret-scanner` | Catches leaked API keys before they reach git |
| `debug-reminder` | Points to DEBUGGING.md when commands fail — prevents rediagnosis of known issues |
| `cost-alert` | Warns if session cost exceeds threshold (default $15) — critical for overnight sessions |

These hooks require NO action from you — they fire automatically. If a hook blocks a command, respect it and find a safer alternative.

### Pre-Flight

Before starting unattended execution:
1. Run `git status` — ensure clean working tree or stash changes
2. Run the full test suite — record baseline results
3. Confirm you understand the zero-regression and anti-hanging protocols
4. List any clarifying questions needed to complete the task — ask them NOW, not mid-repair

## Completion

Do not pause, ask for input, or terminate until the final objective is fully validated. When complete, provide a summary:

```
Iteration Report
━━━━━━━━━━━━━━━━
Objective: [original objective]
Steps completed: X/Y
Total iterations: Z (across all steps)

Step Results:
  1. [step] — PASS (2 iterations, 45s)
  2. [step] — PASS (1 iteration, 12s)
  3. [step] — FAIL — BLOCKER: [reason]

Blockers: [list any unresolved issues with full context]
Tests: X passed, Y failed (baseline: A passed, B failed)
Files changed: [count]
```

---
Nox
