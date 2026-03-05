Audit project dependencies for health, security, and bloat.

## Checks

### 1. Vulnerability Scan
- Run `npm audit` / `pip audit` / `cargo audit` / equivalent
- Flag any known CVEs with severity rating
- Provide upgrade path for each vulnerable package

### 2. Outdated Dependencies
- Run `npm outdated` / `pip list --outdated` / equivalent
- Categorize: patch (safe), minor (review), major (breaking changes likely)
- Flag dependencies more than 2 major versions behind

### 3. Unused Dependencies
- Cross-reference `package.json` / `requirements.txt` / `Cargo.toml` against actual imports
- Flag packages listed but never imported
- Flag devDependencies used in production code (or vice versa)

### 4. Duplicate Dependencies
- Check for multiple versions of the same package in the dependency tree
- Identify which top-level packages pull in conflicting versions
- Suggest resolution strategy (dedupe, override, or upgrade)

### 5. License Compliance
- List all dependency licenses
- Flag any copyleft licenses (GPL, AGPL) in an otherwise permissive project
- Flag any packages with no license specified

### 6. Maintenance Health
- Flag packages with no commits in 2+ years
- Flag packages with no maintainer response to issues
- Suggest alternatives for abandoned packages

## Output Format

```
DEPENDENCY HEALTH REPORT
========================

Vulnerabilities:  2 critical, 1 high, 3 moderate
Outdated:         12 packages (3 major, 5 minor, 4 patch)
Unused:           4 packages (est. savings: ~2MB)
Duplicates:       2 packages with version conflicts
License issues:   1 package (GPL in MIT project)
Unmaintained:     1 package (no updates since 2023)

[Details for each category follow]
```

---
Nox