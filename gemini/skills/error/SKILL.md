---
name: error
description: Root cause analysis with DEBUGGING.md integration
---

FIRST: Check if a `DEBUGGING.md` exists in this project. If it does, read it before diagnosing — another model or developer may have already solved this exact issue.

SECOND: Check `CHANGELOG.md` and recent `git log --oneline -20` for related changes that may have introduced this error.

## Analysis Protocol

1. **Identify the root cause** — Don't just fix the symptom. Trace the error to its origin.
2. **Map the failure sequence** — What events led to this crash? What was the trigger?
3. **Provide the specific fix** — Configuration change, code fix, or environment adjustment needed.
4. **Verify the fix** — Explain how to confirm the fix works and doesn't introduce regressions.

## Output Format

```
ROOT CAUSE: [one sentence]
FAILURE CHAIN: [sequence of events]
FIX: [specific change required]
VERIFY: [how to confirm it's fixed]
```

## Post-Fix

If you resolve a non-obvious bug, propose a `DEBUGGING.md` entry so the next developer or model doesn't repeat the investigation.

---
Nox
