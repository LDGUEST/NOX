Execute a complete plan-to-ship pipeline with quality gates at every step. This skill orchestrates both GSD and Nox commands into a single automated workflow.

**Requires:** [GSD](https://github.com/get-shit-done-ai/gsd) installed alongside Nox for full functionality.

## Pipeline

When invoked with a task description, execute these steps in order:

### Step 1: Plan
Run `/gsd:plan-phase` to create the implementation plan. If GSD is not installed, create a manual task breakdown instead.

### Step 2: Architect
Run `/nox:architect` on the plan output. Produce component diagram, data flow, and tech decisions. **Pause for approval** before proceeding.

### Step 3: Clarify
Run `/nox:questions` to surface any ambiguity in the plan. If questions exist, **pause and wait for answers**. If the plan is unambiguous, skip this step.

### Step 4: Execute with Quality Gates
Run `/gsd:execute-phase` (or manual execution if GSD is not installed). During execution, enforce these gates on every task:
- `/nox:tdd` — Write failing test before production code
- `/nox:review` — Auto-review after each file is modified
- Flag any issues before moving to the next task

### Step 5: Security Gate
Run `/nox:security` on all changed files. If any **Critical** findings exist, **block the pipeline** and fix before continuing. High/Medium findings are logged as warnings.

### Step 6: Commit
Run `/nox:commit` to generate Conventional Commits messages for all changes. Stage and commit with proper messages.

### Step 7: Deploy
Run `/nox:deploy` with the full 5-step protocol: preflight → backup → deploy → verify → report.

### Step 8: Verify
Run `/gsd:verify-work` against the original acceptance criteria. If verification fails, **loop back to Step 4** with the failing criteria as the new task.

### Step 9: Handoff
Run `/nox:handoff` to capture everything learned — bugs found, decisions made, patterns discovered.

## Decision Points (where the pipeline pauses)

- **After Step 2** — "Approve this architecture?"
- **After Step 3** — Only if ambiguity was found
- **After Step 5** — If Critical security findings exist
- **After Step 8** — If UAT verification fails (loops back to fix)

## Without GSD

This skill works without GSD installed. Steps 1, 4, and 8 fall back to manual equivalents:
- Step 1: Creates a task breakdown instead of a GSD plan
- Step 4: Executes tasks sequentially instead of wave-based parallelization
- Step 8: Asks you to manually verify instead of running GSD's UAT

---
Nox