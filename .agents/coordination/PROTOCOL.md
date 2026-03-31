# Agent Coordination Protocol

> When multiple AI agents work on this project simultaneously, follow this protocol to avoid conflicts.

## Before Starting Work

1. **Read `ACTIVE.md`** — check if another agent is working on overlapping files
2. **Read `HANDOFFS.md`** — catch up on recent completed work (last 5 entries max)
3. If conflict detected: wait for the other agent to finish that area
4. **Write your entry** to ACTIVE.md before touching any files

## While Working

- **Re-read files before editing** — another agent may have modified them since your last read
- **Surgical edits only** — smallest possible change, don't rewrite whole files
- **Prefer additive changes** — new files/functions are safer than modifying shared code
- **Commit frequently** — small atomic commits reduce merge conflict surface

## When Done

1. **Remove your entry** from ACTIVE.md
2. **Write a handoff note** to HANDOFFS.md (prepend — newest first)
3. **Rotate**: if HANDOFFS.md has more than 5 entries, move the oldest to ARCHIVE.md
4. **Commit your work** so the other agent can pull/see changes

## File Roles

| File | Always Read? | Purpose |
|------|-------------|---------|
| `ACTIVE.md` | YES | Who is working on what right now. Remove entry when done. |
| `HANDOFFS.md` | YES | Last 5 completed handoffs. Recent context for the next agent. |
| `ARCHIVE.md` | NO | Completed handoffs older than the last 5. Only read when investigating history or debugging a regression. |

## ACTIVE.md Format

```markdown
## Currently Active

- **Agent**: Claude Code (terminal 1)
  **Task**: Implementing auth middleware
  **Files**: src/middleware/auth.ts, src/lib/session.ts
  **Started**: 2026-03-23 14:00 ET
```

## HANDOFFS.md Format (newest first, max 5)

```markdown
## 2026-03-23 15:30 ET — Claude Code → next agent

**Completed**: Auth middleware + session management
**Files changed**: src/middleware/auth.ts, src/lib/session.ts
**Context for next agent**: Session token is now in httpOnly cookie, not localStorage.
**Tests**: All passing
```

## Rotation Rule

When adding a 6th entry to HANDOFFS.md:
1. Cut the oldest entry (bottom of file)
2. Prepend it to ARCHIVE.md (newest-first order preserved)
3. ARCHIVE.md grows indefinitely but is never read unless explicitly needed