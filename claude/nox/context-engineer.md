Discover, audit, and govern all AI context files across your projects. This skill goes beyond `/nox:context` (which validates a single project) — it enforces armor, scores health, detects cross-project drift, and asks the right questions to fill gaps. Built for solo developers juggling dozens of projects.

## When to Use

- Starting a session on a project you haven't touched in weeks
- After a multi-agent session where several AIs modified context files
- Periodic maintenance across all projects ("context hygiene day")
- When context files feel bloated, stale, or contradictory
- When starting a new project and need proper context scaffolding
- When you want a single dashboard of context health across everything

## Arguments

`$ARGUMENTS` — Scope and options:
- *(empty)* — audit current project only
- `--all` — sweep all projects in the workspace directory
- `--project <name>` — audit a specific project by name
- `--fix` — auto-propose fixes (still asks confirmation before writing)
- `--score-only` — just show the health dashboard, no remediation
- `--codebase` — include codebase-level diagnostics (large files, import chains, security scan)

## Context File Registry

Scan for ALL of these file types at project root, subdirectories, and global config locations:

| File | Purpose | Global Location |
|------|---------|-----------------|
| `CLAUDE.md` | Claude Code project context | `~/.claude/CLAUDE.md` |
| `MEMORY.md` | Accumulated learnings across sessions | `~/.claude/projects/*/memory/MEMORY.md` |
| `DEBUGGING.md` | Multi-model debugging knowledge | — |
| `GEMINI.md` | Gemini CLI context | `~/.gemini/GEMINI.md` |
| `.cursorrules` | Cursor AI rules | — |
| `.clinerules` | Cline rules | — |
| `.windsurfrules` | Windsurf rules | — |
| `.roomodes` | Roo Code mode definitions | — |
| `copilot-instructions.md` | GitHub Copilot instructions | `.github/copilot-instructions.md` |
| `CLAUDE.local.md` | Deprecated local overrides (flag for migration) | — |
| `AGENTS.md` | Agent definitions | — |
| `.claude/settings.json` | Claude Code project settings | `~/.claude/settings.json` |

## Process

### Phase 1: Discovery

```bash
# Current project
ls -la CLAUDE.md MEMORY.md DEBUGGING.md GEMINI.md AGENTS.md .cursorrules .clinerules .windsurfrules .roomodes 2>/dev/null
ls -la .claude/settings.json .github/copilot-instructions.md 2>/dev/null
find . -maxdepth 2 -name "CLAUDE.md" 2>/dev/null  # subdirectory context files

# Global
ls -la ~/.claude/CLAUDE.md ~/.claude/MEMORY.md ~/.gemini/GEMINI.md 2>/dev/null
ls ~/.claude/projects/*/memory/MEMORY.md 2>/dev/null

# If --all: sweep workspace
ls -d ~/projects/*/ ~/.cursor/projects/*/ 2>/dev/null  # adapt path to OS
```

For each file found, record:
- File path
- Line count
- Last modified date (from `stat` or `git log -1`)
- Whether it has a `NOX-ARMOR` header (line 1 HTML comment or PROTECTED MODULE header)
- File size category: lean (<50 lines), normal (50-150), heavy (150-250), bloated (>250)

### Phase 2: Diagnostics

Run structural and security checks across discovered context files and (with `--codebase` or `--all`) the broader codebase.

#### Context File Diagnostics

**❌ Circular references** — context files that reference each other in loops:
```bash
# Extract all cross-references between context files (e.g., "see src/CLAUDE.md")
# Build a reference graph and detect cycles
# Example cycle: CLAUDE.md → src/CLAUDE.md → ../CLAUDE.md → CLAUDE.md
grep -rn 'see \|refer to \|defined in \|→.*CLAUDE\|→.*MEMORY\|→.*DEBUGGING' \
  CLAUDE.md */CLAUDE.md MEMORY.md DEBUGGING.md 2>/dev/null
```

**❌ Missing references** — context files that point to files or paths that don't exist:
```bash
# Extract all file paths mentioned in context files
# Verify each referenced file/directory exists on disk
# Flag: CLAUDE.md:45 references "src/api/CLAUDE.md" — file does not exist
```

**⚠️ Duplicate references** — same file, section, or instruction referenced multiple times:
```bash
# Within a single file: same path/section mentioned 2+ times
# Across files: identical instructions duplicated in CLAUDE.md AND MEMORY.md
# Flag but don't auto-remove — duplicates may be intentional
```

**⚠️ Deep reference chains** — context file hierarchies deeper than 3 levels:
```bash
# Trace: root CLAUDE.md → subdir/CLAUDE.md → subdir/sub/CLAUDE.md → ...
# Chains deeper than 3 levels cause context dilution for AI agents
find . -name "CLAUDE.md" -not -path './node_modules/*' -not -path './.git/*' | \
  awk -F'/' '{print NF-1, $0}' | sort -rn
```

**🔒 Security issues in context files** — exposed secrets in AI-readable files:
```bash
# Context files are read by EVERY AI agent — leaked secrets here are worst-case
# Scan for: API keys, tokens, passwords, connection strings, private keys
grep -rn 'sk-\|pk_\|PRIVATE_KEY\|password.*=\|secret.*=\|Bearer \|-----BEGIN' \
  CLAUDE.md */CLAUDE.md MEMORY.md DEBUGGING.md GEMINI.md 2>/dev/null
```

#### Codebase Diagnostics (with `--codebase` or `--all`)

**⚠️ Large files (>1MB)** — files that bloat context or cause performance issues:
```bash
find . -type f -size +1M \
  -not -path './.git/*' -not -path './node_modules/*' \
  -not -path './.next/*' -not -path './dist/*' \
  -not -path './build/*' -not -path './.vercel/*' \
  -exec ls -lh {} \;
```

**❌ Circular imports** — source files that import each other in loops:
```bash
# For TypeScript/JavaScript projects:
# Build import graph from import/require statements
# Detect cycles: a.ts → b.ts → c.ts → a.ts
# Use: grep -rn "^import\|require(" --include="*.ts" --include="*.tsx" --include="*.js"
```

**❌ Missing import files** — imports pointing to files that don't exist:
```bash
# Resolve each import path relative to the importing file
# Flag: src/utils.ts:3 imports "./helpers" — file does not exist
# Respect tsconfig paths, package.json exports, index files
```

**⚠️ Deep import chains** — import hierarchies deeper than 5 levels:
```bash
# Trace: page.tsx → component.tsx → hook.ts → util.ts → helper.ts → ...
# Deep chains increase cognitive load and fragility
# Report the longest chains and their depths
```

**⚠️ Duplicate imports** — same module imported multiple times in a file:
```bash
# Same module path imported on multiple lines
# Different aliases for the same import
# Mixed default/named imports that could be consolidated
grep -rn "^import" --include="*.ts" --include="*.tsx" --include="*.js" | \
  awk -F: '{file=$1; import=$3} seen[file,import]++'
```

**🔒 Security issues in codebase** — exposed secrets beyond context files:
```bash
# Scan source code for hardcoded secrets, API keys, passwords
# Check: .env files not in .gitignore, secrets in committed code
# Patterns: API_KEY=, SECRET=, password=, sk-, pk_live_, -----BEGIN
grep -rn 'API_KEY\s*=\s*["\x27]\|SECRET\s*=\s*["\x27]\|password\s*=\s*["\x27]' \
  --include="*.ts" --include="*.js" --include="*.py" --include="*.env*" \
  -not -path './node_modules/*' -not -path './.git/*'
# Also check: is .env in .gitignore?
grep -q '\.env' .gitignore 2>/dev/null || echo "WARNING: .env not in .gitignore"
```

#### Diagnostic Output Format
```
Diagnostics
━━━━━━━━━━━

Context Files:
  ❌ Circular references:    0 found
  ❌ Missing references:     2 found
     → CLAUDE.md:45 references "src/api/CLAUDE.md" — file does not exist
     → MEMORY.md:12 references "DEBUGGING.md" — file does not exist
  ⚠️ Duplicate references:   1 found
     → "coding standards" referenced in both CLAUDE.md:30 and CLAUDE.md:88
  ⚠️ Deep reference chains:  0 found
  🔒 Exposed secrets:        1 found
     → MEMORY.md:15 contains what appears to be an API key: "sk-..."

Codebase (--codebase):
  ❌ Circular imports:       1 found
     → src/a.ts → src/b.ts → src/a.ts
  ❌ Missing imports:        0 found
  ⚠️ Large files (>1MB):     2 found
     → data/seed.json (4.2MB)
     → public/hero.png (1.8MB)
  ⚠️ Deep import chains:     1 found (depth: 7)
     → pages/dashboard.tsx → ... → lib/constants.ts
  ⚠️ Duplicate imports:      3 found
  🔒 Security issues:        1 found
     → .env not listed in .gitignore
```

Diagnostic findings feed into Phase 3 Health Scoring as deductions:
- Each ❌ finding: -5 from Accuracy
- Each ⚠️ finding: -2 from Bloat or Consistency
- Each 🔒 finding: -10 from Accuracy (security issues are critical)

### Phase 3: Health Scoring

Score each project on 6 dimensions (0-100 total):

| Dimension | Weight | Scoring |
|-----------|--------|---------|
| **Completeness** | 20 | Has CLAUDE.md (+10), MEMORY.md (+5), DEBUGGING.md (+3), other context file (+2) |
| **Freshness** | 20 | All files modified within 30 days (+20), 30-90 days (+10), >90 days (+0). Deduct 5 per stale reference found. |
| **Accuracy** | 20 | Tech stack in CLAUDE.md matches package.json/go.mod/Cargo.toml (+10). Env vars match .env.example or code (+5). File paths are valid (+5). Deductions from Phase 2 diagnostics (❌ = -5, 🔒 = -10). |
| **Protection** | 15 | CLAUDE.md has NOX-ARMOR (+8). MEMORY.md has armor (+4). Other protected files (+3). |
| **Consistency** | 15 | Context patterns match global CLAUDE.md conventions (+8). No contradictions between files (+7). |
| **Bloat** | 10 | All files under max-lines (+5). No duplicate entries across files (+3). No orphaned entries (+2). |

### Phase 4: Report

Output the dashboard:

```
Context Health Dashboard
━━━━━━━━━━━━━━━━━━━━━━━━
Project                  Score   Grade   Issues
─────────────────────────────────────────────────
Scriber                  72/100  C       [no armor] [stale env vars] [missing DEBUGGING.md]
Happy-Turtle-Market      45/100  F       [bloated: 340 lines] [no MEMORY.md] [3 conflicts]
GAV-Admin                88/100  B+      [1 stale entry]
NOX-AI-SKILLS            94/100  A       [all clear]
Foundry-Wealth-Group     61/100  D       [no armor] [wrong auth provider listed] [2 stale]
...

Grade scale: A (90-100) B (80-89) C (70-79) D (60-69) F (<60)

DIAGNOSTICS:
  ❌ Circular references:  0    ❌ Missing references:   1
  ⚠️ Large files (>1MB):   2    ⚠️ Deep chains:          0
  ⚠️ Duplicate references: 1    🔒 Security issues:      0

GLOBAL CONTEXT:
  ~/.claude/CLAUDE.md        — 180 lines — armored: NO — last modified: 2026-03-01
  ~/.claude/MEMORY.md        — 42 lines  — armored: NO — last modified: 2026-03-05
```

### Phase 5: Armor Check

For each context file WITHOUT a `NOX-ARMOR` header, run an interactive questionnaire:

**For CLAUDE.md files:**
1. "Which sections should be LOCKED (agents cannot modify without explicit permission)?"
   - Offer detected section names as choices
   - Common locks: tech stack, env vars, auth config, deployment, coding standards
2. "Max line count before this file is considered bloated?" (suggest 150-200)
3. "Any sections that should auto-expire? (e.g., temporary workarounds)"

**For MEMORY.md files:**
1. "Max entries before old ones should be flagged for review?" (suggest 30-50)
2. "Should entries older than N days be auto-flagged?" (suggest 90)
3. "Required categories?" (suggest: bugs, decisions, patterns, off-limits)

**For DEBUGGING.md files:**
1. "Should solved bugs be archived after N days?" (suggest 60)
2. "Lock the attribution format? (e.g., `[Model | Date]`)"

After gathering answers, generate the appropriate armor header and section markers. Show the proposed changes and ask for confirmation before writing.

### Phase 6: Remediation (if --fix or user requests)

For each issue found, propose the EXACT fix:

**Stale entries:**
```
[stale] MEMORY.md line 23: "Use Prisma for DB access" — but package.json shows Drizzle
  → Proposed fix: Update to "Use Drizzle ORM for DB access (migrated from Prisma 2026-01)"
  → Apply? [y/n]
```

**Missing context files:**
```
[missing] GAV-Records has no CLAUDE.md
  → I can see it's Next.js 14, no auth, no DB. Generate a starter CLAUDE.md? [y/n]
  → (generates from detected codebase, not a blind template)
```

**Bloated files:**
```
[bloat] Happy-Turtle-Market CLAUDE.md is 340 lines (max: 200)
  → Found 12 duplicate entries also in MEMORY.md
  → Found 4 sections that could move to subdirectory CLAUDE.md files
  → Show proposed restructure? [y/n]
```

**Cross-project inconsistency:**
```
[inconsistent] Supabase RLS pattern differs:
  - Global CLAUDE.md:  USING ((select auth.uid()) = user_id)
  - Scriber CLAUDE.md: USING (auth.uid() = user_id)  ← wrong pattern
  → Align Scriber with global convention? [y/n]
```

**Missing armor:**
```
[unprotected] Scriber CLAUDE.md has no NOX-ARMOR header
  → Run armor questionnaire for this file? [y/n]
```

### Phase 7: Cross-Project Sync Check (--all mode only)

When scanning all projects, also check:
1. **Global propagation** — patterns in global CLAUDE.md that should exist in all project CLAUDE.md files (coding standards, env var naming, deployment workflow)
2. **Convention drift** — same concept described differently across projects
3. **Orphaned global memories** — entries in global MEMORY.md referencing projects that no longer exist
4. **Missing subsystem CLAUDE.md** — subdirectories with >5 source files and no local CLAUDE.md

## Output Summary

After all phases, print:

```
Context Engineering Report
━━━━━━━━━━━━━━━━━━━━━━━━━━
Projects scanned:    12
Context files found: 34
Average health score: 71/100

Actions taken:
  ✓ 3 files armored (CLAUDE.md × 2, MEMORY.md × 1)
  ✓ 5 stale entries flagged
  ✓ 1 CLAUDE.md generated for GAV-Records
  ✓ 2 cross-project inconsistencies resolved
  ⊘ 4 issues deferred (user declined fix)

Next audit recommended: 2026-04-08 (30 days)
```

## Rules

- NEVER modify any file without showing the exact diff and getting confirmation
- NEVER delete context file entries — only update, archive, or flag for review
- NEVER fabricate health scores — if you can't verify a dimension, score it as 0 and note why
- When generating missing CLAUDE.md files, ALWAYS analyze the actual codebase (package.json, imports, directory structure) — never use a blind template
- Respect existing armor headers — if a section is LOCKED, do not propose changes to it
- The questionnaire in Phase 4 is mandatory for first-time armor — do not skip it or assume answers
- For `--all` mode, ask permission before scanning projects outside the current workspace
- If a project has no package.json/go.mod/Cargo.toml, note "unable to verify tech stack" instead of guessing
- Flag uncertainty: use `[maybe stale]` when unsure, never silently remove entries
- Keep the dashboard concise — details go in per-project sections below it

---
Nox
