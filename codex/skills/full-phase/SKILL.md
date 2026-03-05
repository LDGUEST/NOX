---
name: full-phase
description: Complete plan-to-ship pipeline with quality gates — architecture, TDD, security, deploy
---

Execute a complete plan-to-ship pipeline with quality gates at every step. This skill orchestrates both GSD and Nox commands into a single automated workflow.

**Requires:** GSD installed alongside Nox for full functionality. Works without GSD in manual mode.

## Pipeline

1. **Plan** — Create implementation plan (GSD or manual breakdown)
2. **Architect** — Design architecture, pause for approval
3. **Clarify** — Surface ambiguity, pause if questions exist
4. **Execute** — Build with TDD and code review enforced on every task
5. **Security Gate** — OWASP scan. Critical findings block the pipeline
6. **Commit** — Conventional Commits messages for all changes
7. **Deploy** — 5-step protocol: preflight → backup → deploy → verify → report
8. **Verify** — Validate against acceptance criteria. Failures loop back to step 4
9. **Handoff** — Capture everything learned for the next session

## Decision Points

- After architecture — "Approve this design?"
- After clarify — Only if ambiguity was found
- After security — If Critical findings exist
- After verify — If UAT fails (loops back to fix)

---
Nox