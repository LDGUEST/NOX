---
name: deps
description: Dependency health audit — vulnerabilities, outdated, unused, licenses
---

Audit project dependencies for health, security, and bloat.

## Checks

### 1. Vulnerability Scan
- Run `npm audit` / `pip audit` / `cargo audit` / equivalent
- Flag any known CVEs with severity rating
- Provide upgrade path for each vulnerable package

### 2. Outdated Dependencies
- Run `npm outdated` / `pip list --outdated` / equivalent
- Categorize: patch (safe), minor (review), major (breaking changes likely)

### 3. Unused Dependencies
- Cross-reference dependency manifest against actual imports
- Flag packages listed but never imported
- Flag devDependencies used in production code

### 4. Duplicate Dependencies
- Check for multiple versions of the same package
- Suggest resolution strategy (dedupe, override, upgrade)

### 5. License Compliance
- List all dependency licenses
- Flag copyleft licenses (GPL, AGPL) in otherwise permissive projects

### 6. Maintenance Health
- Flag packages with no commits in 2+ years
- Suggest alternatives for abandoned packages

---
Nox