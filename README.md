<div align="center">

<img src="assets/nox-logo.png" alt="NOX" width="360">

[![GitHub stars](https://img.shields.io/github/stars/LDGUEST/NOX-CLI-ADD-ONS?style=flat-square&color=yellow)](https://github.com/LDGUEST/NOX-CLI-ADD-ONS/stargazers)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue?style=flat-square)](LICENSE)
[![Version](https://img.shields.io/badge/version-3.0.0-blue?style=flat-square)](CHANGELOG.md)
[![Skills](https://img.shields.io/badge/skills-31%20core%20+%207%20registry-blueviolet?style=flat-square)](#skill-catalog-31-core-skills)
[![Agents](https://img.shields.io/badge/agents-8-orange?style=flat-square)](#agents-8)
[![Hooks](https://img.shields.io/badge/hooks-23-green?style=flat-square)](#hooks-23)
[![CLIs](https://img.shields.io/badge/CLIs-Claude%20%7C%20Gemini%20%7C%20Codex-lightgrey?style=flat-square)](#quick-install)
[![Zero Config](https://img.shields.io/badge/config-zero-brightgreen?style=flat-square)](#quick-install)

</div>

<table>
<tr>
<td width="33%" align="center">

### Ship Faster

`/nox:full-phase` runs a complete plan-to-deploy pipeline in one command. Architecture, TDD, security, deploy — done before your coffee gets cold.

</td>
<td width="33%" align="center">

### Catch Everything

6 agents fire in parallel: code review, OWASP security scan, dependency audit, performance profiling, UX testing, and pentest. Any agent can block the merge.

</td>
<td width="33%" align="center">

### Sleep Through It

`/nox:iterate --unattended` runs overnight with zero-regression enforcement, 5-min anti-hang timers, and max-pivot guards. Wake up to fixed code, not new bugs.

</td>
</tr>
</table>

# Nox

30 core skills + 8 registry skills + 8 agents + 23 hooks for **Claude Code**, **Gemini CLI**, and **Codex CLI**. One install, three CLIs, zero config.

Built for developers running multiple AI agents across terminals, machines, and models — Nox gives every agent the same playbook for code quality, security, deployment, and coordination.

**New to Nox?** Run `/nox:start` after install — it detects your stack and recommends the right skills for your workflow.

## Why Nox?

- **3-CLI support** — the only skill pack that works across Claude, Gemini, AND Codex
- **Multi-agent coordination** — sync repos between agents, hand off context, run unattended overnight sessions
- **Zero config** — one `bash install.sh`, no API keys, no setup, no dependencies
- **Battle-tested** — born from real multi-machine production systems, not theoretical templates
- **Security-first** — OWASP scanning, secret detection, and env var hygiene baked in
- **Autonomous modes** — `/nox:iterate --unattended` can work while you sleep

---

## Measured Impact

We run every Nox release through internal A/B testing — same developer, same projects, hooks ON vs hooks OFF — to make sure the hooks actually help and aren't just noise.

Here's what 91 sessions showed:

| Metric | Hooks ON | Hooks OFF | Impact |
|--------|----------|-----------|--------|
| Tokens per session | 46,276 | 67,388 | **31% fewer tokens** |
| Session duration | 258 min | 450 min | **43% shorter sessions** |
| Tool calls per session | 9 | 2 | **4.5x more tool usage** |
| Tokens per tool call | 2,687 | 7,396 | **2.7x more efficient per action** |

The pattern is clear: hooks steer the agent toward **doing things** (tool calls, file edits, commits) instead of **talking about things** (long-winded explanations, redundant analysis). Less token bloat, more shipped code.

The biggest driver? **Context awareness.** The `context-monitor` and `auto-context` hooks keep the agent focused — it knows where it is in the task, what it already tried, and when to wrap up. Without them, agents wander.

<details>
<summary>Methodology & caveats (click to expand)</summary>

- **Sample:** 76 sessions with hooks ON, 15 with hooks OFF. Single developer across multiple projects.
- **Controls:** Task types were NOT controlled — different work may have been done in each condition. This is observational data, not a randomized experiment.
- **Efficiency metrics** (tokens/tool, commits/hr) have very small OFF sample sizes (1-2 sessions with full data). Directionally consistent but not statistically rigorous.
- **Environment:** macOS + Linux, Claude Code (Opus/Sonnet), multi-machine setup. Results may differ on other platforms, models, or workflows.
- **Why we're sharing this:** The directional signal across the core metrics (tokens, duration, tool usage) is strong and consistent. We're not claiming laboratory precision — we're showing that the hooks measurably change agent behavior for the better in real-world use.

</details>

---

## Even More Powerful with GSD

Nox is a **standalone** skill pack — every command works on its own, no dependencies required.

But when paired with [**GSD (Get Shit Done)**](https://github.com/get-shit-done-ai/gsd), Nox unlocks automated plan-to-ship pipelines that combine GSD's project management with Nox's quality gates.

**How they work together:**

| | GSD | Nox | Together |
|---|-----|-----|----------|
| **Role** | Project manager | Senior engineer | Full team |
| **Does** | Plans phases, tracks milestones, orchestrates execution | Reviews code, scans security, deploys safely | Automated pipeline from idea to production |
| **Scope** | *What* to build | *How* to build it right | Both — end to end |

**Without GSD:** Every Nox skill works independently. You run `/nox:audit`, `/nox:deploy`, `/nox:security` whenever you need them. Skills like `audit` now include dependency health, `security` includes pentest mode, and `review` includes complexity checking.

**With GSD:** Two combo skills unlock that chain everything together automatically:

---

## Combo Skills (Nox + GSD)

**`/nox:full-phase`** — Complete plan-to-ship pipeline
> *"Build a Stripe subscription system with full quality gates"*

Automates the entire development lifecycle in one command. After execution completes, **6 quality gate agents dispatch in parallel** — reviewing code, scanning security, auditing dependencies, profiling performance, and screenshotting UX simultaneously:

```
Plan → Architect → Clarify → Execute → ┌─ Review ──┐ → Commit → Deploy → Verify → Handoff
 GSD      Nox        Nox     GSD+Nox    │  Security │     Nox      Nox      GSD       Nox
                                        │  Audit    │
                                        │  Perf     │
                                        └─ UX ──────┘
                                         6 PARALLEL
                                          AGENTS
```

Any agent returning BLOCK stops the pipeline. Fix the issue, re-run only the failed agents. Every task inside execution gets TDD enforcement and Playwright visual checks on UI work. 9 steps, 6 gates, ~80% faster than sequential.

**`/nox:quick-phase`** — Lightweight plan-to-commit
> *"Add an admin debug panel — skip the ceremony"*

Same structure, minimal overhead. Visual spot-check, advisory review (warns but doesn't block), complexity check, critical CVE scan. No TDD, no security scan, no pentest, no deploy protocol. For internal tools, prototypes, and experiments.

```
Plan → Execute → Visual Check → Review (advisory) → Review (complexity) → Audit (critical CVE only) → Commit → Handoff
```

| | `/nox:full-phase` | `/nox:quick-phase` |
|---|---|---|
| **Use for** | Production features | Prototypes, internal tools |
| **Quality gates** | 6 parallel agents (review, security, audit, perf, UX) | Advisory review, visual spot-check, complexity check, critical CVE check |
| **Blocking** | 6 agents can block the pipeline | Nothing blocks — warnings only |
| **Speed** | 9 steps, gates run in parallel | Fast — 8 steps |
| **Requires GSD** | Optional (falls back to manual) | Optional |

---

## Quick Install

**One-liner** (recommended):
```bash
curl -fsSL https://raw.githubusercontent.com/LDGUEST/NOX-CLI-ADD-ONS/main/install.sh | bash
```

**Or clone manually:**
```bash
git clone https://github.com/LDGUEST/NOX-CLI-ADD-ONS.git
cd NOX-CLI-ADD-ONS
bash install.sh              # Auto-detects installed CLIs
bash install.sh --symlink    # Symlink mode — auto-updates on git pull
```

Install for one CLI only:
```bash
bash install.sh --claude-only
bash install.sh --gemini-only
bash install.sh --codex-only
```

Extended skills (niche/specialized):
```bash
bash install.sh --with-registry    # Adds 8 extended skills (api, schema, landing, doc, swot, monitorlive, explain, env)
```

Type `/nox:start` after install to get personalized skill recommendations for your project.

## Manual Install

**Claude Code** — copy the `nox/` directory to `~/.claude/commands/`:
```bash
cp -r claude/nox ~/.claude/commands/
```

**Gemini CLI** — copy extension to `~/.gemini/extensions/nox/`:
```bash
cp -r gemini/ ~/.gemini/extensions/nox/
```

**Codex CLI** — copy skills to `~/.codex/skills/`:
```bash
cp -r codex/skills/* ~/.codex/skills/
```

## Uninstall

```bash
bash uninstall.sh              # Remove skills from all CLIs
bash uninstall.sh --hooks-too  # Also remove hooks
bash uninstall.sh --claude-only  # Remove from Claude only
```

The uninstaller removes skills, agents, and MCP server registration. Hook entries in `~/.claude/settings.json` must be removed manually.

---

## Skill Catalog (30 core skills)

### Pipelines

**`/nox:full-phase`** — Complete plan-to-ship pipeline with quality gates
> *"Add user authentication end-to-end"* — Plans, architects, executes with TDD, security scans, deploys, verifies, and captures knowledge. Pauses at decision points.

**`/nox:quick-phase`** — Lightweight plan-to-commit
> *"Scaffold a settings page quickly"* — Plan, build, sanity check, commit. No ceremony.

---

### Code Quality

**`/nox:audit`** — Deep technical audit
> *"Audit this repo before we ship v2"* — Scans for bugs, security holes, dead code, accessibility gaps, perf bottlenecks, and dependency health (vulnerabilities, outdated, unused, licenses). Returns a severity-rated report with file paths and line numbers.

**`/nox:review`** — PR-style code review
> *"Review the changes I made to the auth module"* — Acts as a senior reviewer. Categorizes findings as Critical/Warning/Nit with suggested fixes. Includes a complexity check that flags duplication, unnecessary abstractions, dead code, and over-engineering. Ends with Approve, Request Changes, or Comment.

**`/nox:refactor`** — Safe refactoring
> *"Refactor the payment module to use the new API client"* — Snapshots current tests, makes incremental changes, verifies after each step. If tests break, reverts automatically.

**`/nox:perf`** — Performance profiling
> *"Why is the dashboard so slow?"* — Profiles frontend (bundle size, re-renders, Core Web Vitals) and backend (N+1 queries, missing indexes, memory leaks). Returns impact estimates with fixes.

**`/nox:uxtest`** — UX testing + WCAG 2.1 AA accessibility audit
> *"Test the entire frontend before we ship"* — Uses Playwright to run a full UX audit: screenshots at 4 breakpoints (375/768/1280/1920px), interaction testing on every button/form/modal, comprehensive WCAG 2.1 AA accessibility audit (semantic HTML, ARIA, keyboard nav, forms, color contrast, motion), performance snapshot (LCP, CLS, JS errors), and critical user flow simulation. Outputs a structured report with screenshots and pass/fail per flow.

**`/nox:prompt`** — LLM prompt audit
> *"Are our AI prompts production-ready?"* — Finds every LLM prompt in the codebase and audits it across 8 dimensions: clarity, output reliability, cost efficiency, safety/injection resistance, context management, model portability, testability, and maintainability. Calculates per-call and monthly cost estimates, suggests model downgrades where appropriate, and rewrites weak prompts.

---

### Development Workflow

**`/nox:tdd`** — Test-driven development
> *"Add a discount calculator using TDD"* — Enforces Red-Green-Refactor. Writes failing test first, verifies it fails, writes minimal code to pass, then refactors. No skipping steps. Also includes a test generation mode for writing comprehensive tests for existing code.

**`/nox:commit`** — Smart commit messages
> *"Commit these changes"* — Reads `git diff`, analyzes staged changes, generates a Conventional Commits message focused on WHY not just what. Detects breaking changes.

**`/nox:changelog`** — Generate changelog
> *"Generate a changelog for the v2.0 release"* — Reads git history since last tag, categorizes commits (Added/Changed/Fixed/Security), outputs Keep a Changelog format.

**`/nox:iterate`** — Autonomous execution + unattended repair
> *"Fix all the TypeScript errors in this project"* — Decomposes the goal into steps, executes each one, verifies, self-corrects up to 10 cycles per step. Doesn't stop until done. With `--unattended`, enters zero-regression repair mode with anti-hang timers, max-pivot guards, and hook safety net for overnight sessions.

---

### Architecture & Planning

**`/nox:brainstorm`** — Structured ideation
> *"I need a notification system but I'm not sure how to approach it"* — Forces divergent thinking before convergence. Generates 3+ fundamentally different approaches with architecture sketches, tradeoff analysis, and a weighted evaluation matrix. Recommends one approach with a kill criterion and minimum viable slice. Hands off to `/nox:architect` when ready.

**`/nox:architect`** — Design-first gate
> *"I need a real-time notification system"* — Produces component diagram, data flow, API contracts, and tech decisions with tradeoffs. No code until you approve the architecture.

**`/nox:questions`** — Clarify before coding
> *"Build me a dashboard"* — Extracts every question needed to remove ambiguity: data flow, auth, edge cases, integrations, performance requirements. Asks first, builds perfectly once.

---

### DevOps & Infrastructure

**`/nox:cicd`** — CI/CD workflow generator
> *"Set up CI for this Next.js project"* — Auto-detects framework, package manager, and test runner. Generates GitHub Actions with caching, linting, testing, matrix builds, and deploy gates.

**`/nox:deploy`** — Push and deploy with full safety
> *"Deploy to production"* — Auto-detects platform (Vercel, Netlify, Fly, Railway, Heroku), pushes to feature branch first, waits for preview, verifies, then deploys to production. 5-step protocol: preflight → backup → push & deploy → verify (HTTP 200, visual check) → report. Retries up to 3 times on failure. Halts immediately if any step fails.

**`/nox:diagnose`** — System health check & error investigation
> *"Check if all services are running"* / *"Why is this crashing?"* — SSHs into configured machines, checks connectivity, CPU/memory/disk, Docker containers, GPU status, API endpoints. Returns a clean status table. Also includes error investigation mode: traces root cause, maps failure chain, checks DEBUGGING.md for prior solutions, and proposes entries so bugs are never re-investigated.

**`/nox:migrate`** — Database migration generator
> *"Add a status column to the orders table"* — Auto-detects ORM (Prisma, Drizzle, Alembic, Django, Supabase), generates UP + DOWN migrations, warns about destructive operations and table locks.

---

### Security

**`/nox:security`** — OWASP Top 10 scan + pentest
> *"Run a security scan before launch"* / *"Pentest this app before we ship"* — Two modes: **scan mode** checks all 10 OWASP categories (broken access control, injection, XSS, CSRF, auth flaws, vulnerable dependencies, secret exposure, SSRF) with severity and remediation steps. **Pentest mode** runs a 5-phase white-box assessment: code recon, attack surface mapping, vulnerability analysis across 5 categories (injection, XSS, auth, SSRF, authorization), live exploitation with proof-of-concept, and pentester-grade report. No Exploit, No Report — zero false positives.

---

### Multi-Agent & Session Management

**`/nox:syncagents`** — Multi-agent repo sync
> *"Another agent was working on this repo while I was away"* — Detects remote vs local repo, stashes your changes, pulls the other agent's work, rebases, pops stash, handles conflicts.

**`/nox:handoff`** — Knowledge transfer
> *"I'm done for today, capture what we did"* — Summarizes all changes, logs bugs/decisions/patterns, proposes MEMORY.md and DEBUGGING.md entries. The next session starts with full context.

**`/nox:help-forge`** — Skill catalog
> *"What Nox commands are available?"* — Lists all skills organized by category.

**`/nox:skill-create`** — Create new Nox skills
> *"I want to add a new slash command to Nox"* — Meta-skill that scaffolds a new skill in the correct format across all 3 CLIs. Guides you through naming, content structure, registration in help-forge and README, validation checklist, and deployment to all machines. Prevents the most common mistakes (stale counts, missing formats, vague instructions).

**`/nox:guardrails`** — Safety guardrails for all CLIs
> Inline safety checks that mirror Claude Code's 23 hooks for Gemini and Codex users. Destructive command blocking, secret scanning, branch protection, commit linting, drift detection, test regression tracking, and more. Automatically referenced by pipeline and autonomous skills. Claude users get these via hooks; Gemini/Codex users get them via this skill.

---

### Context Engineering

**`/nox:armor`** — File and subsystem protection
> *"Lock down the payment module — agents keep breaking it"* — Adds PROTECTED MODULE headers to code files and NOX-ARMOR comments to context files (CLAUDE.md, MEMORY.md). Gathers context from git history and codebase, writes specific hard rules with real incident references, creates safe-modification protocols in the nearest CLAUDE.md. Works with any language.

**`/nox:context-engineer`** — Context file governance + context reset
> *"Audit all my context files across every project"* — Discovers every AI context file (CLAUDE.md, MEMORY.md, DEBUGGING.md, .cursorrules, AGENTS.md, and more) across one or all projects. Scores each project's context health (0-100) on completeness, freshness, accuracy, protection, consistency, and bloat. Enforces armor on unprotected files through interactive questionnaires. Detects cross-project drift, proposes fixes for stale entries, generates missing context files from actual codebase analysis. Also supports `--reset <component>` to purge stale assumptions and set new context as source of truth.

---

### Meta

**`/nox:start`** — Guided onboarding
> *"I just installed Nox — what should I use?"* — Detects your project stack (framework, database, deployment platform, test runner), asks one question about your current focus, and recommends 5-8 skills in priority order with immediate quick wins. The fastest way to get value from Nox.

**`/nox:update`** — Self-update
> *"Update Nox to the latest version"* — Checks GitHub for new releases, shows changelog, installs updates.

---

### Registry Skills (install with `--with-registry`)

8 specialized skills for niche workflows. Not installed by default — add them with `bash install.sh --with-registry`.

| Skill | Description |
|-------|-------------|
| `/nox:api` | Design and scaffold REST/GraphQL API endpoints from a spec |
| `/nox:schema` | Database schema designer — ER diagrams, migration planning, normalization review |
| `/nox:landing` | Draft a conversion-focused landing page from scratch |
| `/nox:doc` | Generate documentation from code — JSDoc, docstrings, README sections, API reference |
| `/nox:swot` | SWOT analysis — strengths, weaknesses, opportunities, threats for your codebase |
| `/nox:monitorlive` | Real-time log monitoring — watches live traffic, surfaces errors and anomalies |
| `/nox:explain` | Onboarding guide generator — explain any codebase to a new contributor |
| `/nox:env` | Environment variable auditor — missing vars, secrets in code, `.env.example` generation |

---

## Multi-Agent Management

Nox was built for running multiple AI agents across different terminals, machines, and models. These skills keep your agents coordinated:

| Skill | What it solves |
|-------|---------------|
| `/nox:syncagents` | **Repo sync** — Safely merge work when multiple agents touch the same codebase |
| `/nox:handoff` | **Knowledge transfer** — Captures everything so the next agent starts with full context |
| `/nox:iterate` | **Sub-agent orchestration** — Decomposes objectives, self-corrects up to 10 cycles. `--unattended` for overnight repair |
| `/nox:diagnose` | **Cross-machine health + error investigation** — SSH into any machine and report service status; also traces root cause with shared DEBUGGING.md so bugs are never re-investigated |

**The workflow:** Agent A runs `/nox:handoff` when done → Agent B runs `/nox:syncagents` to pull changes → picks up right where A left off.

---

## Agents (8)

Nox includes 8 specialized subagents that power the parallel quality gates in `/nox:full-phase`. Each agent is a standalone `.md` file installed to `~/.claude/agents/`.

| Agent | Role | Verdict |
|-------|------|---------|
| `nox-reviewer` | Cross-file code review — correctness, security, performance, design, tests | APPROVE / REQUEST_CHANGES / COMMENT |
| `nox-security-scanner` | OWASP Top 10 static analysis with CWE references and remediation | PASS / WARN / BLOCK |
| `nox-pentester` | Live exploitation — 5-phase white-box pentest with proof-of-concept | PASS / WARN / BLOCK |
| `nox-dep-auditor` | CVE detection, outdated packages, license compliance, supply chain risk | PASS / WARN / BLOCK |
| `nox-perf-profiler` | N+1 queries, bundle size, memory leaks, Core Web Vitals, rendering | PASS / WARN / BLOCK |
| `nox-ux-tester` | Playwright screenshots at 4 breakpoints, interaction testing, Axe accessibility | PASS / WARN / BLOCK |
| `nox-prompt-auditor` | LLM prompt audit across 8 dimensions with cost calculation | PASS / WARN / BLOCK |
| `nox-monitor` | Background log monitoring with deduplication, correlation, anomaly detection | Continuous |

In `/nox:full-phase`, 6 of these agents (all except prompt-auditor and monitor) dispatch **simultaneously** after code execution completes. This parallel dispatch cuts gate time by ~80% compared to running them sequentially.

`nox-prompt-auditor` and `nox-monitor` are standalone — use them independently when auditing AI prompts or monitoring live logs.

---

## Hooks (23)

Opt-in Claude Code hooks that provide continuous passive protection across ALL Nox and GSD workflows. Install with `bash install.sh --with-hooks`.

23 hooks across **8 hook events** — the most comprehensive hook suite available for Claude Code.

### Safety & Protection

| Hook | Event | What It Does |
|------|-------|-------------|
| `destructive-guard` | PreToolUse (Bash) | Blocks `rm -rf`, `git reset --hard`, force push, DROP TABLE |
| `sync-guard` | PreToolUse (Edit\|Write) | Warns if unstaged changes exist (multi-agent collision prevention) |
| `secret-scanner` | PostToolUse (Write\|Edit) | Scans for leaked API keys, JWTs, AWS/Stripe/GitHub tokens |
| `file-size-guard` | PreToolUse (Write) | Blocks writing files over 500KB — catches base64 dumps, minified bundles |
| `prompt-guard` | UserPromptSubmit | Warns on vague/destructive prompts ("delete everything", "rewrite all") |

### Quality & Regression

| Hook | Event | What It Does |
|------|-------|-------------|
| `commit-lint` | PreToolUse (Bash) | Validates commit messages follow Conventional Commits (`feat:`, `fix:`, etc.) |
| `test-regression-guard` | PostToolUse (Bash) | Tracks test pass/fail counts, warns when failures increase |
| `build-tracker` | PostToolUse (Bash) | Tracks build warning/error counts, alerts on increase |
| `drift-detector` | PostToolUse (Write\|Edit) | Tracks cumulative lines changed, warns at 100/500 lines to encourage commits |
| `todo-tracker` | PostToolUse (Write\|Edit) | Detects new TODO/FIXME/HACK comments, logs them for tracking |

### Awareness & Context

| Hook | Event | What It Does |
|------|-------|-------------|
| `auto-context` | SessionStart | Injects git branch, recent commits, TODO count, DEBUGGING.md highlights. Detects recovery playbooks from pre-compact handoff |
| `context-monitor` | PostToolUse (all) | Two-stage context awareness: efficiency nudge at 65%, auto-generates recovery playbook scaffold at 83% with git state + agent-filled intent sections. Zero user intervention — agent keeps working through auto-compact |
| `statusline-unified` | StatusLine | Color-coded statusline: project name, git branch, dirty count, context bar (green/yellow/red), token count, session cost. Writes bridge file for context-monitor |
| `debug-reminder` | PostToolUse (Bash) | On failure: "check DEBUGGING.md before re-investigating" |
| `compact-saver` | PreCompact | Saves a context checkpoint before compaction — branch, diff, recent files |
| `memory-auto-save` | Stop | Reminds if bugs were fixed but DEBUGGING.md/MEMORY.md weren't updated |

### Monitoring & Alerts

| Hook | Event | What It Does |
|------|-------|-------------|
| `cost-alert` | PostToolUse (all) | Warns when session cost exceeds threshold (every 20 tool calls) |
| `notify-complete` | PostToolUse (Bash) | Desktop notification when commands take >60s (macOS/Linux) |
| `agent-tracker` | SubagentStart | Tracks subagent spawns, alerts on runaway loops (>10 agents) |
| `session-logger` | Stop | Logs session summaries — project, branch, files changed — for work history |
| `session-cost-tracker` | Stop | Records per-session token/cost metrics to SQLite for A/B comparison (hooks ON vs OFF) |

### Context Awareness & Recovery

Every AI coding agent has the same fatal flaw: when context fills up and auto-compact fires, the agent forgets what it was doing. It re-reads files it already analyzed, retries approaches that already failed, and the user has to re-explain the task. Nox solves this.

```
Without Nox                              With Nox Recovery Playbook
─────────────                            ──────────────────────────
Context fills up → auto-compact →        Context fills up → playbook written →
agent forgets everything →               auto-compact → agent reads playbook →
re-reads files, retries dead ends,       knows what failed, skips dead ends,
user has to re-explain →                 picks up exact next action →
wastes 10+ minutes                       zero interruption
```

The `context-monitor` hook and `auto-context` hook work as a pair. At **83% context usage**, the monitor auto-captures git state (branch, staged/unstaged diffs, recent commits) into a scaffold file and tells the agent to fill in the high-value sections. The agent keeps working normally. When auto-compact fires moments later, the playbook survives on disk. Post-compact, the SessionStart hook detects it, injects it, and the agent picks up exactly where it left off. No user intervention at any point.

Here is what a filled-in recovery playbook actually looks like:

```markdown
# Recovery Playbook
**Branch:** main

## Files Changed This Session
Staged: hooks/context-monitor.js | 45 +++--
Unstaged: src/auth.ts | 12 ++-

## User Request
> "Fix the JWT refresh token race condition in the auth middleware"

## Dead Ends
- Tried mutex lock on token refresh — caused deadlock with concurrent requests
- Redis-based lock worked but added 200ms latency per request (unacceptable)

## Key Decisions
- Using optimistic locking with version stamps instead of mutex
- Chose in-memory Map over Redis for token dedup (single-instance app)

## Next Action
Edit src/middleware/auth.ts:47 — add version check before writing refreshed token
to response header

## Remaining Steps
1. Add version stamp to refresh response
2. Write test for concurrent refresh scenario
3. Run existing auth test suite
```

The "Dead Ends" section is what makes this work. Without it, a post-compact agent will try the mutex approach again, waste 5 minutes, hit the same deadlock, and pivot to Redis — another 5 minutes wasted. With the playbook, it skips straight to the version-stamp approach and starts editing the right file on the right line.

**Context thresholds at a glance:**

| Context | Status Bar | Behavior |
|---------|-----------|----------|
| 0-64% | `[========--------]` green | Full speed |
| 65-82% | `[============----]` yellow | Efficiency nudge — be surgical |
| 83-85% | `[===============-]` red | Playbook auto-generated, agent fills it in |
| 85%+ | auto-compact fires | Built-in compactor runs, playbook survives on disk |
| Post-compact | green (reset) | `auto-context` detects playbook, agent resumes |

**Two-Layer Defense:** Hooks (Layer 1) run passively on every tool call. Agents (Layer 2) run at pipeline checkpoints. Together they catch issues both as they happen and in aggregate. Especially critical during autonomous execution (`/nox:iterate --unattended`) where no human is watching.

**Configuration:**

| Variable | Default | Purpose |
|----------|---------|---------|
| `NOX_COST_THRESHOLD` | `15` | Dollar amount before cost alert fires |
| `NOX_COST_CHECK_INTERVAL` | `20` | Check cost every N tool calls |
| `NOX_NOTIFY_THRESHOLD` | `60` | Seconds before command completion notification |
| `NOX_ALLOW_DESTRUCTIVE` | `0` | Set to `1` to disable destructive guard |
| `NOX_SECRET_PATTERNS` | — | Path to file with custom secret regex patterns |
| `NOX_COMMIT_TYPES` | `feat\|fix\|chore\|...` | Allowed Conventional Commit types |
| `NOX_FILE_SIZE_LIMIT` | `512000` | Max file size in bytes (500KB) |
| `NOX_DRIFT_WARN` | `100` | Lines changed before first drift warning |
| `NOX_DRIFT_ALERT` | `500` | Lines changed before escalated drift alert |
| `NOX_AGENT_LIMIT` | `10` | Max subagents before runaway loop warning |
| `NOX_SKIP_*` | — | Set any `NOX_SKIP_<HOOK_NAME>=1` to disable individually |
| `NOX_SKIP_COMPACT_SAVER` | `0` | Set to `1` to disable pre-compact checkpoint saves |
| `NOX_COMPACT_DIR` | `.claude/checkpoints/` | Override checkpoint directory path |
| `NOX_COST_DB` | `~/.claude/.nox_metrics.db` | Override metrics SQLite database path |
| `NOX_SKIP_ALL` | `0` | Set to `1` to disable all hooks (for A/B cost comparison) |

<details>
<summary>Settings.json configuration (click to expand)</summary>

Add this to your `~/.claude/settings.json` under `"hooks"`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {"type": "command", "command": "bash ~/.claude/hooks/auto-context.sh"}
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "hooks": [
          {"type": "command", "command": "bash ~/.claude/hooks/prompt-guard.sh"}
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {"type": "command", "command": "bash ~/.claude/hooks/sync-guard.sh"}
        ]
      },
      {
        "matcher": "Write",
        "hooks": [
          {"type": "command", "command": "bash ~/.claude/hooks/file-size-guard.sh"}
        ]
      },
      {
        "matcher": "Bash",
        "hooks": [
          {"type": "command", "command": "bash ~/.claude/hooks/destructive-guard.sh"},
          {"type": "command", "command": "bash ~/.claude/hooks/commit-lint.sh"},
          {"type": "command", "command": "bash ~/.claude/hooks/notify-timer-start.sh"}
        ]
      }
    ],
    "PostToolUse": [
      {
        "hooks": [
          {"type": "command", "command": "node ~/.claude/hooks/context-monitor.js"},
          {"type": "command", "command": "bash ~/.claude/hooks/cost-alert.sh"}
        ]
      },
      {
        "matcher": "Write|Edit",
        "hooks": [
          {"type": "command", "command": "bash ~/.claude/hooks/secret-scanner.sh"},
          {"type": "command", "command": "bash ~/.claude/hooks/todo-tracker.sh"},
          {"type": "command", "command": "bash ~/.claude/hooks/drift-detector.sh"}
        ]
      },
      {
        "matcher": "Bash",
        "hooks": [
          {"type": "command", "command": "bash ~/.claude/hooks/debug-reminder.sh"},
          {"type": "command", "command": "bash ~/.claude/hooks/build-tracker.sh"},
          {"type": "command", "command": "bash ~/.claude/hooks/test-regression-guard.sh"},
          {"type": "command", "command": "bash ~/.claude/hooks/notify-complete.sh"}
        ]
      }
    ],
    "SubagentStart": [
      {
        "hooks": [
          {"type": "command", "command": "bash ~/.claude/hooks/agent-tracker.sh"}
        ]
      }
    ],
    "PreCompact": [
      {
        "hooks": [
          {"type": "command", "command": "bash ~/.claude/hooks/compact-saver.sh"}
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {"type": "command", "command": "bash ~/.claude/hooks/session-logger.sh"},
          {"type": "command", "command": "bash ~/.claude/hooks/memory-auto-save.sh"},
          {"type": "command", "command": "bash ~/.claude/hooks/session-cost-tracker.sh"}
        ]
      }
    ]
  },
  "statusLine": {
    "type": "command",
    "command": "node ~/.claude/hooks/statusline-unified.js"
  }
}
```
</details>

---

## Customization

Several skills use environment variables for configuration:

| Variable | Used By | Purpose |
|----------|---------|----------|
| `DEPLOY_CMD` | deploy | Custom deploy command |
| `DEPLOY_URL` | deploy | Production URL to verify |
| `DEPLOY_BACKUP_CMD` | deploy | Pre-deploy backup command |
| `DEPLOY_HOST` | deploy | SSH deploy target |
| `PROJECT_DIR` | deploy | Remote project directory |
| `FORGE_MACHINES` | diagnose | JSON array of machines to health-check |
| `FORGE_SSH_HOSTS` | iterate | JSON array of SSH hosts for cross-machine ops |

## MCP Server

Nox includes an MCP server that exposes all skills to any MCP-compatible client (Claude Desktop, Cursor, Windsurf, etc.). The installer auto-registers it in `~/.claude/.mcp.json`.

**3 tools:**
| Tool | Description |
|------|-------------|
| `nox_list` | Returns the full skill catalog |
| `nox_skill` | Returns a skill's instructions for the LLM to follow (accepts `skill_name`, optional `mode` and `target`) |
| `nox_agent` | Returns an agent definition |

Skills and agents are discovered dynamically from the filesystem — no hardcoded lists.

**Manual setup** (if auto-registration didn't work):
```json
// ~/.claude/.mcp.json
{
  "mcpServers": {
    "nox": {
      "command": "node",
      "args": ["/path/to/NOX/mcp-server/server.js"]
    }
  }
}
```

Requires Node.js. Dependencies install automatically during `bash install.sh`.

---

## Troubleshooting

**Skills don't appear after install**
- Claude Code: Check `~/.claude/commands/nox/` exists and contains `.md` files
- Gemini CLI: Check `~/.gemini/extensions/nox/skills/` exists
- Codex CLI: Check `~/.codex/skills/` has skill directories
- Restart your CLI after installing

**Hooks not firing**
- Hooks require manual wiring in `~/.claude/settings.json` — see the settings.json config above
- Check `~/.claude/hooks/` contains the hook files and `.sh` files are executable (`chmod +x`)
- Test a hook directly: `echo '{"tool_name":"Bash","tool_input":{"command":"rm -rf /"}}' | bash ~/.claude/hooks/destructive-guard.sh`

**MCP server not working**
- Run `node ~/.nox/mcp-server/server.js` directly to check for errors
- Ensure `npm install` was run in the `mcp-server/` directory
- Check `~/.claude/.mcp.json` has a `"nox"` entry with the correct path

**Install fails on Windows**
- Use Git Bash, not cmd.exe or PowerShell
- If symlink mode fails, use copy mode (default): `bash install.sh`
- If `md5sum` is missing, install `coreutils` or use copy mode

**"Permission denied" on hooks**
- Run `chmod +x ~/.claude/hooks/*.sh` to fix
- On Windows Git Bash, this may require developer mode enabled

**Hooks cause slowdowns**
- Set `NOX_SKIP_ALL=1` to disable all hooks temporarily
- Disable individual hooks: `NOX_SKIP_SECRET_SCANNER=1`, `NOX_SKIP_COST_ALERT=1`, etc.
- The `cost-alert` hook only checks every 20 tool calls to minimize overhead

---

## Structure

```
NOX/
├── README.md
├── LICENSE                    # MIT
├── install.sh                 # Auto-installer (Claude + Gemini + Codex + Agents + Hooks + Registry)
├── uninstall.sh               # Remove all Nox artifacts
├── validate.sh                # Verify 3-CLI parity
├── hooks/                     # Claude Code hooks (opt-in with --with-hooks)
│   ├── statusline-unified.js  # StatusLine: colored 2-line status with context bar
│   ├── context-monitor.js     # PostToolUse: context awareness + recovery playbook
│   ├── auto-context.sh        # SessionStart: inject project state + detect recovery playbook
│   ├── prompt-guard.sh        # UserPromptSubmit: warn on vague/destructive prompts
│   ├── destructive-guard.sh   # PreToolUse: block dangerous commands
│   ├── commit-lint.sh         # PreToolUse: enforce Conventional Commits
│   ├── file-size-guard.sh     # PreToolUse: block oversized file writes
│   ├── sync-guard.sh          # PreToolUse: multi-agent collision warning
│   ├── secret-scanner.sh      # PostToolUse: leaked secret detection
│   ├── todo-tracker.sh        # PostToolUse: track new TODOs
│   ├── drift-detector.sh      # PostToolUse: warn on large uncommitted diffs
│   ├── test-regression-guard.sh # PostToolUse: detect test regressions
│   ├── build-tracker.sh       # PostToolUse: build health tracking
│   ├── debug-reminder.sh      # PostToolUse: DEBUGGING.md auto-check
│   ├── cost-alert.sh          # PostToolUse: session cost threshold
│   ├── notify-complete.sh     # PostToolUse: desktop notification (>60s)
│   ├── notify-timer-start.sh  # PreToolUse: timer for notify-complete
│   ├── agent-tracker.sh       # SubagentStart: runaway loop detection
│   ├── compact-saver.sh       # PreCompact: save context checkpoint
│   ├── session-logger.sh      # Stop: log session summary
│   ├── session-cost-tracker.sh # Stop: per-session token/cost metrics to SQLite
│   ├── nox-metrics.sh          # CLI: query cost tracker
│   ├── nox-parse.sh            # Shared: fast JSON field extraction
│   └── memory-auto-save.sh    # Stop: remind to update DEBUGGING.md
├── mcp-server/                # MCP server (any MCP-compatible client)
│   ├── package.json
│   └── server.js              # 3 tools: nox_list, nox_skill, nox_agent
├── agents/                    # Subagents for parallel quality gates
│   └── nox-*.md               # 8 agent definitions
├── registry/                  # Extended/niche skills (opt-in with --with-registry)
│   ├── claude/                # 8 registry skill files
│   ├── gemini/                # 8 registry skill directories
│   └── codex/                 # 8 registry skill directories
├── claude/                    # Claude Code (/nox:<name>)
│   └── nox/
│       └── *.md               # 30 core skill files
├── gemini/                    # Gemini CLI
│   ├── gemini-extension.json
│   └── skills/
│       └── <name>/SKILL.md    # 30 core skill directories
├── codex/                     # Codex CLI
│   └── skills/
│       └── <name>/SKILL.md    # 30 core skill directories
└── tests/                     # Test suites
    ├── test-hooks.sh          # Hook unit tests (21 tests)
    ├── test-install.sh        # Install/uninstall integration tests (35 tests)
    ├── test-smoke.sh          # Smoke tests (5 test groups)
    └── test-skills.sh         # Skill, agent, parity, and edge case tests (28 tests)
```

## License

MIT
