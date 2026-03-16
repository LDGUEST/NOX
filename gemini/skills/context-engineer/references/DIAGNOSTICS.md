# Diagnostic Reference — /nox:context-engineer

Bash commands and output formats for Phase 2 diagnostics.

## Context File Checks

### Circular References
Build a reference graph across all context files and detect cycles.
```bash
grep -rn 'see \|refer to \|defined in \|→.*CLAUDE\|→.*MEMORY\|→.*DEBUGGING' \
  CLAUDE.md */CLAUDE.md MEMORY.md DEBUGGING.md 2>/dev/null
```
Example cycle: `CLAUDE.md → src/CLAUDE.md → ../CLAUDE.md → CLAUDE.md`

### Missing References
Extract every file path mentioned in context files and verify each exists on disk.
```bash
# Flag: CLAUDE.md:45 references "src/api/CLAUDE.md" — file does not exist
grep -rn '\./\|\.\./' CLAUDE.md MEMORY.md DEBUGGING.md 2>/dev/null
```

### Deep Reference Chains
Context file hierarchies deeper than 3 levels cause context dilution.
```bash
find . -name "CLAUDE.md" -not -path './node_modules/*' -not -path './.git/*' | \
  awk -F'/' '{print NF-1, $0}' | sort -rn
```

### Exposed Secrets in Context Files
Context files are read by every AI agent — leaked secrets here are worst-case.
```bash
grep -rn 'sk-\|pk_\|PRIVATE_KEY\|password.*=\|secret.*=\|Bearer \|-----BEGIN' \
  CLAUDE.md */CLAUDE.md MEMORY.md DEBUGGING.md GEMINI.md 2>/dev/null
```

---

## Codebase Checks (--codebase / --all)

### Large Files (>1MB)
```bash
find . -type f -size +1M \
  -not -path './.git/*' -not -path './node_modules/*' \
  -not -path './.next/*' -not -path './dist/*' \
  -not -path './build/*' -not -path './.vercel/*' \
  -exec ls -lh {} \;
```

### Circular Imports (TypeScript/JavaScript)
Build import graph from import/require statements. Detect cycles: `a.ts → b.ts → c.ts → a.ts`
```bash
grep -rn "^import\|require(" --include="*.ts" --include="*.tsx" --include="*.js" \
  -not -path './node_modules/*'
# Then trace the graph for cycles
```

### Missing Import Files
```bash
# Resolve each import path relative to the importing file
# Respect tsconfig paths, package.json exports, index files
# Flag: src/utils.ts:3 imports "./helpers" — file does not exist
```

### Deep Import Chains (>5 levels)
```bash
# Trace: page.tsx → component.tsx → hook.ts → util.ts → helper.ts → ...
# Report the longest chains and their entry/exit points
```

### Duplicate Imports
```bash
grep -rn "^import" --include="*.ts" --include="*.tsx" --include="*.js" | \
  awk -F: '{file=$1; import=$3} seen[file,import]++'
```

### Security Issues in Codebase
```bash
grep -rn 'API_KEY\s*=\s*["\x27]\|SECRET\s*=\s*["\x27]\|password\s*=\s*["\x27]' \
  --include="*.ts" --include="*.js" --include="*.py" \
  -not -path './node_modules/*' -not -path './.git/*'

# Check .env is gitignored
grep -q '\.env' .gitignore 2>/dev/null || echo "WARNING: .env not in .gitignore"
```

---

## Diagnostic Output Format

```
Diagnostics
━━━━━━━━━━━

Context Files:
  ❌ Circular references:    0 found
  ❌ Missing references:     2 found
     → CLAUDE.md:45 references "src/api/CLAUDE.md" — file does not exist
     → MEMORY.md:12 references "DEBUGGING.md" — file does not exist
  ⚠️  Duplicate references:   1 found
     → "coding standards" in CLAUDE.md:30 and CLAUDE.md:88
  ⚠️  Deep reference chains:  0 found
  🔒 Exposed secrets:        1 found
     → MEMORY.md:15 contains what appears to be an API key: "sk-..."

Codebase (--codebase):
  ❌ Circular imports:       1 found → src/a.ts → src/b.ts → src/a.ts
  ❌ Missing imports:        0 found
  ⚠️  Large files (>1MB):     2 found → data/seed.json (4.2MB)
  ⚠️  Deep import chains:     1 found (depth: 7)
  ⚠️  Duplicate imports:      3 found
  🔒 Security issues:        1 found → .env not listed in .gitignore
```

## Scoring Deductions

| Finding | Deduction |
|---------|-----------|
| Each ❌ | -5 from Accuracy |
| Each ⚠️ | -2 from Bloat or Consistency |
| Each 🔒 | -10 from Accuracy |
