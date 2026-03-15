# NOX Roadmap

## v1.0 — Foundation (shipped 2026-03-02)

- [x] 28 skills across 6 categories
- [x] Claude Code, Gemini CLI, and Codex CLI support
- [x] Auto-installer with `--symlink`, `--claude-only`, `--gemini-only`, `--codex-only`
- [x] GSD combo skills (`full-phase`, `quick-phase`)
- [x] Multi-agent coordination suite (syncagents, handoff, unloop, iterate, overwrite, error)
- [x] Zero-config install — no API keys, no dependencies

---

## v1.1–1.6 — Agents, Hooks, & Skills v2 (shipped through 2026-03-09)

- [x] 8 Claude Code agents for parallel quality gates
- [x] 23 hooks across 8 hook events (up from 2 hooks in v1.0)
- [x] MCP server — any MCP client can invoke Nox skills
- [x] One-liner curl install
- [x] `/nox:guardrails` — inline safety checks for Gemini/Codex
- [x] YAML frontmatter on all skills (Agent Skills Open Standard)
- [x] `/nox:scan` meta-skill dispatching 4 parallel agents
- [x] `/nox:context-engineer` with 11 structural diagnostics
- [x] Progressive disclosure on heavy skills
- [x] Skill count: 28 → 35

---

## v2.0 — Production Hardening (shipped 2026-03-14)

- [x] Skills v2 frontmatter — `disable-model-invocation`, `argument-hint`, `user-invocable`, `context: fork`, `agent`
- [x] Subagent isolation (`context: fork`) on 12 heavy skills
- [x] 35/35 cross-CLI content parity (Claude → Gemini/Codex sync)
- [x] `lib-json.sh` — shared POSIX ERE JSON extraction (~50x faster than python3)
- [x] Session cost tracker with SQLite metrics DB
- [x] `nox-metrics.sh` — query tool for A/B comparison (hooks ON vs OFF)
- [x] CI pipeline (`.github/workflows/ci.yml`)
- [x] Hook + install test suites (45 tests total)
- [x] Content parity validation in `validate.sh`
- [x] Windows Git Bash compatibility fixes across all hooks
- [x] Repo renamed to `NOX-CLI-ADD-ONS`

---

## v2.5 — New Skills & Hook Intelligence (shipped 2026-03-14)

Expanded the skill catalog with 6 high-demand additions, made hooks smarter, and improved Windows compatibility.

### New Skills
- [x] **`/nox:doc`** — Generate documentation from code (JSDoc, docstrings, README sections)
- [x] **`/nox:api`** — Design and scaffold REST/GraphQL API endpoints from a spec
- [x] **`/nox:schema`** — Database schema designer — ER diagrams, migration planning, normalization review
- [x] **`/nox:env`** — Environment variable auditor — find missing vars, detect secrets in code, generate `.env.example`
- [x] **`/nox:explain`** — Onboarding guide generator — explain any codebase to a new contributor
- [x] **`/nox:a11y`** — Accessibility audit — WCAG compliance, ARIA, keyboard nav, color contrast

### Hook Improvements
- [x] **Smart hook routing** — hooks skip irrelevant events faster via early-exit fast paths
- [x] **Hook health dashboard** — `nox-metrics.sh health` validates hook files, checks settings references, reports broken hooks

### Infrastructure
- [x] **SQLite fallback to JSONL** — session cost tracker falls back to `.nox_metrics.jsonl` when sqlite3 is unavailable (Windows)
- [x] **JSONL metrics queries** — `nox-metrics.sh` supports `summary` and `recent` without sqlite3
- [x] **Smoke test suite** — `tests/test-smoke.sh` validates skill parity, frontmatter, hook presence, and lib-json sourcing
- [x] Skill count: 35 → 41

---

## v3.0 — Platform & Community (next)

The jump from "personal tool" to "team/community platform." Nox becomes installable, shareable, and configurable by teams — not just solo developers.

### Nox CLI — Standalone Binary

The foundation for everything else in v3. Today Nox is a collection of markdown files that piggyback on Claude/Gemini/Codex. v3 ships a real CLI.

- [ ] **`nox` binary** — standalone shell wrapper (bash or compiled Go/Rust) that wraps all commands without needing a host CLI running. `nox scan`, `nox review`, `nox metrics summary` work from any terminal
- [ ] **`nox init`** — interactive project setup: detects stack, creates `.noxrc`, suggests skills, installs hooks, writes initial CLAUDE.md scaffold
- [ ] **`nox doctor`** — system health check: verifies all 3 CLIs installed, hooks wired, skills present, no broken references, sqlite3 available, node version OK
- [ ] **`nox list`** — replaces help-forge for terminal use. Colored output, filterable by category, shows installed vs available
- [ ] **`nox run <skill> [args]`** — invoke any skill directly, routing to whichever CLI is available (prefers Claude, falls back to Gemini, then Codex)
- [ ] **`nox metrics`** — wraps nox-metrics.sh with better output formatting, auto-detects sqlite3 vs JSONL mode
- [ ] **`nox sync`** — push skills + hooks to N machines via SSH. Config in `.noxrc` under `[machines]`
- [ ] **`nox test`** — wraps all 3 test suites (hooks, install, smoke) in a single command with colored output

### Skill Ecosystem

- [ ] **Nox Hub** — community skill registry hosted on GitHub. Structure: `nox install <author>/<skill>` clones a repo into `~/.nox/community/<author>/<skill>/` and symlinks into the appropriate CLI directories
- [ ] **Skill manifest** (`nox-skill.json`) — metadata file for community skills: name, description, author, version, compatibility (which CLIs, which Nox version), dependencies (other skills required), tags
- [ ] **Skill packs** — curated bundles by use case. A pack is a manifest listing N skills to install together:
  - `nox install --pack frontend` → a11y, uxtest, landing, perf
  - `nox install --pack backend` → api, schema, env, migrate, security
  - `nox install --pack devops` → cicd, deploy, push, monitorlive, diagnose
  - `nox install --pack solo` → full-phase, iterate, unloop, handoff, syncagents
- [ ] **Skill versioning** — skills declare compatibility ranges in `nox-skill.json`. `nox update` respects semver, warns on breaking changes, shows changelog diff
- [ ] **Skill dependencies** — skills can declare they need other skills (e.g., `full-phase` requires `architect`, `review`, `security`). `nox install` resolves the dependency tree
- [ ] **Skill validation** — `nox validate <skill>` checks a community skill against the spec: frontmatter, parity, naming, body structure, no secrets, no arbitrary code execution

### Team Features

- [ ] **`.noxrc` project config** — per-project configuration file (TOML or JSON) that lives in the repo root:
  ```toml
  [team]
  name = "acme-corp"
  enforce_hooks = true

  [skills]
  allowed = ["audit", "review", "security", "commit", "tdd"]  # whitelist
  blocked = ["overwrite", "unloop"]  # too dangerous for juniors

  [hooks]
  required = ["destructive-guard", "secret-scanner", "commit-lint"]

  [quality]
  min_review_score = "approve"  # block merge unless review passes
  require_tdd = true
  max_file_size = 300  # lines, not bytes

  [machines]
  pc = { host = "100.116.255.86", user = "Admin" }
  mac = { host = "100.124.63.67", user = "openclaw" }
  ```
- [ ] **Team onboarding** — `nox init --team` reads `.noxrc`, installs required hooks, blocks disallowed skills, sets up shared metrics DB
- [ ] **Org-level metrics** — aggregate cost/efficiency data across team members. Each member's session-cost-tracker writes to a shared DB (SQLite on a network path, or future: Supabase/Postgres). `nox metrics team` shows per-person breakdown
- [ ] **Skill allowlists/blocklists** — admins control which skills are available via `.noxrc`. Blocked skills show a message explaining why and who to contact
- [ ] **Shared hook policies** — `.noxrc` declares required hooks. `nox doctor` warns if a team member is missing required hooks. CI can enforce with `nox doctor --strict`

### Metrics & Observability

- [ ] **Metrics dashboard (TUI)** — `nox dashboard` launches a terminal UI (blessed/ink or similar) showing:
  - Real-time session cost ticker
  - Context usage gauge
  - Skill usage heatmap (which skills used most this week)
  - Hook performance (avg latency per hook, skip rates)
  - Model comparison (cost per 1k tokens by model, tokens per tool call)
  - Active sessions across machines
- [ ] **Cost alerting** — configurable thresholds with multiple notification channels:
  - Desktop notification (existing, via notify-complete)
  - Slack webhook (new: `NOX_SLACK_WEBHOOK` env var)
  - Email via Resend (new: `NOX_ALERT_EMAIL` env var)
  - Configurable: per-session limit, daily limit, weekly limit
- [ ] **Skill analytics** — `nox metrics skills` shows:
  - Which skills are used most (by invocation count)
  - Which skills save the most time (by comparing session efficiency with/without)
  - Which skills are never used (candidates for removal)
  - Adoption trends over time (weekly usage graphs in terminal)
- [ ] **Export** — `nox metrics export --format csv|json` for external analysis

### Cross-IDE Support

- [ ] **Cursor integration** — Nox skills as Cursor rules (`.cursor/rules/`). Skill format adapter that strips YAML frontmatter and converts body to Cursor rule format. `nox install --cursor` writes rules to the project
- [ ] **Windsurf / Cline / Aider support** — skill format adapters for additional AI editors. Each adapter translates Nox skill format to the target's native format:
  - Windsurf: `.windsurfrules` files
  - Cline: system prompt injection
  - Aider: `.aider.conf.yml` conventions
- [ ] **VS Code extension** — sidebar panel showing:
  - Installed skills with search/filter
  - Hook status (active/disabled, error count)
  - Session metrics (cost, context, tokens)
  - Quick-invoke buttons for common skills
  - Settings UI for `.noxrc` editing
- [ ] **JetBrains plugin** — same feature set as VS Code extension for IntelliJ/WebStorm/PyCharm users
- [ ] **Neovim integration** — Lua plugin that exposes skills via telescope picker and shows metrics in statusline

### Advanced Automation

- [ ] **Skill chaining** — skills declare `pre` and `post` hooks in frontmatter:
  ```yaml
  chain:
    pre: ["review"]      # auto-run review before this skill
    post: ["commit"]     # auto-run commit after this skill
  ```
  `commit` auto-runs `review` first. `deploy` auto-runs `security` first. Users can override with `--no-chain`
- [ ] **Conditional hooks** — hooks declare conditions in settings.json:
  ```json
  {
    "matcher": "Bash",
    "condition": { "branch": "main", "project": "production-*" },
    "hooks": [...]
  }
  ```
  Hooks only fire for specific projects, branches, or file patterns. Reduces noise on personal/experimental branches
- [ ] **Agent profiles** — configure skill behavior per role via `.noxrc`:
  ```toml
  [profiles.strict]
  review_depth = "thorough"
  block_on_warnings = true
  require_tests = true

  [profiles.fast]
  review_depth = "surface"
  block_on_warnings = false
  skip_gates = ["perf", "a11y"]
  ```
  Switch profiles: `nox profile strict` or `NOX_PROFILE=fast`
- [ ] **Recovery mode** — on session crash or unexpected exit, auto-restore context from cost tracker + handoff notes. `nox recover` reads the latest recovery playbook and session log, generates a briefing for the next session
- [ ] **Scheduled skills** — `nox schedule "0 9 * * 1" scan --deep` runs a deep scan every Monday at 9am. Uses system cron/Task Scheduler. Results logged to metrics DB
- [ ] **Webhook triggers** — `nox webhook <skill>` exposes a local HTTP endpoint that triggers a skill on POST. Useful for CI/CD integration: GitHub Actions calls `nox webhook security` after every PR

### New Skills (v3 candidates)

- [ ] **`/nox:translate`** — i18n extraction and translation management. Scans for hardcoded strings, extracts to locale files, generates translation keys, validates completeness across locales
- [ ] **`/nox:design`** — generate UI mockups (ASCII wireframes or component specs from natural language descriptions)
- [ ] **`/nox:legal`** — license compliance checker across all dependencies. Flags GPL in MIT projects, generates NOTICE files, checks for license conflicts
- [ ] **`/nox:estimate`** — effort estimation for tasks based on codebase complexity analysis. Outputs t-shirt sizes with confidence intervals
- [ ] **`/nox:bench`** — benchmark runner. Profile functions, compare before/after, detect regressions. Outputs flame graphs (ASCII) and comparison tables
- [ ] **`/nox:onboard`** — interactive onboarding for new team members. Combines `explain` output with guided tour of key files, architecture decisions, and common tasks
- [ ] **`/nox:release`** — full release workflow: bump version, update changelog, tag, push, create GitHub release with notes, notify team
- [ ] **`/nox:rollback`** — emergency rollback: revert last deploy, restore previous DB migration, notify team, create incident report skeleton

---

## Ideas (unscheduled)

- [ ] **`/nox:monitor`** — generate monitoring configs (Prometheus, Grafana, alerting rules)
- [ ] **Skill playground** — web UI to test skills against sample repos before installing
- [ ] **AI model routing** — skills auto-select the best model for the task (Opus for review, Haiku for lint)
- [ ] **Plugin system** — hooks for custom pre/post logic on any skill (subsumed by skill chaining in v3)
- [ ] **Nox Cloud** — hosted metrics, team management, skill registry. The SaaS play (if there's demand)
