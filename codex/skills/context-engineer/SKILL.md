---
name: context-engineer
description: Audit and govern all AI context files — health scoring, armor enforcement, bloat detection, cross-project drift. Never writes to global system files.
---

Discover, audit, and govern all AI context files across your projects. Goes beyond simple validation — enforces armor, scores health, detects cross-project drift, and asks the right questions to fill gaps. Built for solo developers juggling dozens of projects.

## When to Use

- Starting a session on a project you haven't touched in weeks
- After a multi-agent session where several AIs modified context files
- Periodic maintenance across all projects
- When context files feel bloated, stale, or contradictory
- When starting a new project and need proper context scaffolding

## Arguments

- *(empty)* — audit current project only
- `--all` — sweep all projects in workspace
- `--project <name>` — audit a specific project
- `--fix` — auto-propose fixes (still confirms before writing)
- `--score-only` — health dashboard only, no remediation
- `--codebase` — include codebase-level diagnostics (large files, import chains, security scan)

## Context File Registry

Scan for: CLAUDE.md, CLAUDE.local.md (deprecated — flag for migration), MEMORY.md, DEBUGGING.md, GEMINI.md, .cursorrules, .clinerules, .windsurfrules, .roomodes, copilot-instructions.md, AGENTS.md, .claude/settings.json

## Process

### Phase 1: Discovery
Find all context files at project root, subdirectories, and global config. For each, record: path, line count, last modified, armor status, size category (lean/normal/heavy/bloated).

### Phase 2: Diagnostics
Run structural and security checks on context files and (with `--codebase` or `--all`) the broader codebase.

**Context file checks:**
- ❌ **Circular references** — context files that reference each other in loops
- ❌ **Missing references** — context files pointing to files/paths that don't exist
- ⚠️ **Duplicate references** — same file/section referenced multiple times within or across context files
- ⚠️ **Deep reference chains** — context file hierarchies deeper than 3 levels
- 🔒 **Exposed secrets** — API keys, tokens, passwords in context files (worst-case: every AI reads them)

**Codebase checks (with `--codebase` or `--all`):**
- ❌ **Circular imports** — source files importing each other in loops (build import graph, detect cycles)
- ❌ **Missing import files** — imports pointing to files that don't exist (respect tsconfig paths, index files)
- ⚠️ **Large files (>1MB)** — excluding .git, node_modules, .next, dist, build
- ⚠️ **Deep import chains** — import hierarchies deeper than 5 levels
- ⚠️ **Duplicate imports** — same module imported multiple times in a file
- 🔒 **Security issues** — hardcoded secrets in source, .env not in .gitignore

Diagnostic findings feed into health scoring as deductions: ❌ = -5 Accuracy, ⚠️ = -2 Bloat/Consistency, 🔒 = -10 Accuracy.

### Phase 3: Health Scoring (0-100)
| Dimension | Weight | What it measures |
|-----------|--------|-----------------|
| Completeness | 20 | Has essential files (CLAUDE.md, MEMORY.md, etc.) |
| Freshness | 20 | Files modified recently, no stale references |
| Accuracy | 20 | Tech stack matches package.json, env vars match code, diagnostic deductions |
| Protection | 15 | NOX-ARMOR headers present |
| Consistency | 15 | Matches global conventions, no contradictions |
| Bloat | 10 | Under line limits, no duplicates |

### Phase 4: Dashboard
```
Context Health Dashboard
━━━━━━━━━━━━━━━━━━━━━━━━
Project                  Score   Grade   Issues
Scriber                  72/100  C       [no armor] [stale env vars]
GAV-Admin                88/100  B+      [1 stale entry]

DIAGNOSTICS:
  ❌ Circular refs: 0  ❌ Missing refs: 1  ⚠️ Large files: 2
  ⚠️ Deep chains: 0    ⚠️ Duplicates: 1    🔒 Security: 0
```

### Phase 5: Armor Check
For files without NOX-ARMOR, ask targeted questions per file type, generate armor headers, confirm before writing.

### Phase 6: Remediation (--fix)
Propose exact fixes for stale entries, missing files, bloat, inconsistencies, missing armor. Always show diff and confirm.

### Phase 7: Cross-Project Sync (--all only)
Check global pattern propagation, convention drift, orphaned memories, missing subsystem context files.

## Rules

- **NEVER write to `~/.claude/CLAUDE.md`, `~/.claude/settings.json`, `~/.gemini/GEMINI.md`, or any global system context file** — READ-ONLY references for scoring only. Only modify project-scoped files. If global file exceeds 200 lines, flag bloat and suggest what to move — never add to it.
- NEVER modify files without showing diff and getting confirmation
- NEVER delete context entries — only update, archive, or flag
- NEVER fabricate health scores — if unverifiable, score 0 and note why
- Generate missing files from actual codebase analysis, not blind templates
- Respect existing armor — LOCKED sections are off-limits
- Armor questionnaire is mandatory for first-time armor
- Use `[maybe stale]` when uncertain

---
Nox
