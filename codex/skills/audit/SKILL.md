---
name: audit
description: Deep technical audit — bugs, security, perf, dead code, accessibility
---

Conduct a rigorous technical audit of the current codebase. Do not build new features or write final code yet. Act as a strict Senior Reviewer and identify vulnerabilities, performance bottlenecks, logical flaws, and bad practices.

## Audit Categories

1. **Critical Bugs & Blockers** — Logic errors, crashes, data corruption risks
2. **Architecture & Optimization** — Structural issues, performance bottlenecks, scaling concerns
3. **Edge Cases & Security Risks** — Input validation gaps, injection vectors, auth flaws
4. **Dependency Health** — Outdated packages, known CVEs, unnecessary dependencies
5. **Dead Code & Unused Exports** — Functions, variables, imports that are never referenced
6. **Accessibility** — Missing ARIA attributes, keyboard navigation gaps, contrast issues (if UI project)

## Known Tripwires (check these explicitly)

- Env var hygiene: service/secret keys must NEVER appear in client-side code or public env vars
- Console.log / debug statements left in production code
- Functions over 80 lines or files over 300 lines
- Missing input validation at system boundaries (user input, external APIs)
- Hardcoded secrets, API keys, or credentials anywhere in the codebase
- SQL injection vectors (raw string interpolation in queries)
- Missing error handling on async operations

## Output Format

Present your audit as a structured report with severity ratings (Critical / Warning / Info) for each finding. Include file path and line number for every issue. Ask any clarifying questions before proposing fixes.

---
Nox
