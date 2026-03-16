#!/usr/bin/env bash
set -u

# test-skills.sh — Validates skills, agents, parity, MCP, and edge cases
# Portable: works on Ubuntu (CI) and Git Bash (Windows/MSYS)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="$SCRIPT_DIR/claude/nox"
GEMINI_DIR="$SCRIPT_DIR/gemini/skills"
CODEX_DIR="$SCRIPT_DIR/codex/skills"
AGENTS_DIR="$SCRIPT_DIR/agents"
REGISTRY_CLAUDE="$SCRIPT_DIR/registry/claude"
REGISTRY_GEMINI="$SCRIPT_DIR/registry/gemini"
REGISTRY_CODEX="$SCRIPT_DIR/registry/codex"
MCP_DIR="$SCRIPT_DIR/mcp-server"

PASS_COUNT=0
FAIL_COUNT=0

pass() {
  echo "PASS: $1"
  PASS_COUNT=$((PASS_COUNT + 1))
}

fail() {
  echo "FAIL: $1"
  FAIL_COUNT=$((FAIL_COUNT + 1))
}

echo "=== Nox Skill & Agent Tests ==="
echo ""

# ================================================================
# SKILL TESTS — Claude source of truth
# ================================================================
echo "--- Core skill existence (30 skills) ---"

CORE_SKILLS="architect armor audit brainstorm changelog cicd commit context-engineer deploy diagnose full-phase guardrails handoff help-forge iterate migrate perf prompt questions quick-phase refactor review scan security skill-create start syncagents tdd update uxtest"

CORE_MISSING=0
for skill in $CORE_SKILLS; do
  if [ ! -f "$CLAUDE_DIR/$skill.md" ]; then
    echo "  Missing core skill: $skill"
    CORE_MISSING=$((CORE_MISSING + 1))
  fi
done

if [ "$CORE_MISSING" -eq 0 ]; then
  pass "All 30 core skills exist in claude/nox/"
else
  fail "$CORE_MISSING core skills missing from claude/nox/"
fi

echo ""

# ================================================================
# REGISTRY SKILLS (7 skills)
# ================================================================
echo "--- Registry skill existence (8 skills) ---"

REGISTRY_SKILLS="api schema landing doc swot monitorlive explain env"

REG_MISSING=0
for skill in $REGISTRY_SKILLS; do
  if [ ! -f "$REGISTRY_CLAUDE/$skill.md" ]; then
    echo "  Missing registry skill: $skill"
    REG_MISSING=$((REG_MISSING + 1))
  fi
done

if [ "$REG_MISSING" -eq 0 ]; then
  pass "All 8 registry skills exist in registry/claude/"
else
  fail "$REG_MISSING registry skills missing from registry/claude/"
fi

echo ""

# ================================================================
# REMOVED SKILLS — must not exist
# ================================================================
echo "--- Removed skills are gone ---"

REMOVED_SKILLS="overwrite a11y unloop push"
REMOVED_FOUND=0

for skill in $REMOVED_SKILLS; do
  if [ -f "$CLAUDE_DIR/$skill.md" ]; then
    echo "  Should be removed: $skill.md"
    REMOVED_FOUND=$((REMOVED_FOUND + 1))
  fi
done

if [ "$REMOVED_FOUND" -eq 0 ]; then
  pass "No removed skills remain in claude/nox/ (overwrite, a11y, unloop, push)"
else
  fail "$REMOVED_FOUND removed skills still present in claude/nox/"
fi

echo ""

# ================================================================
# FRONTMATTER VALIDATION — every skill has ---, name:, description:
# ================================================================
echo "--- Frontmatter validation ---"

FM_MISSING=0
FM_NO_NAME=0
FM_NO_DESC=0

for skill_file in "$CLAUDE_DIR"/*.md; do
  [ -f "$skill_file" ] || continue
  skill=$(basename "$skill_file" .md)

  FIRST_LINE=$(head -1 "$skill_file")
  if [ "$FIRST_LINE" != "---" ]; then
    echo "  Missing frontmatter: $skill"
    FM_MISSING=$((FM_MISSING + 1))
    continue
  fi

  HAS_NAME=false
  HAS_DESC=false
  IN_FM=false
  LINE_NUM=0

  while IFS= read -r line; do
    LINE_NUM=$((LINE_NUM + 1))
    if [ "$LINE_NUM" -eq 1 ]; then
      IN_FM=true
      continue
    fi
    if [ "$IN_FM" = true ] && [ "$line" = "---" ]; then
      break
    fi
    if [ "$IN_FM" = true ]; then
      case "$line" in
        name:*) HAS_NAME=true ;;
        description:*) HAS_DESC=true ;;
      esac
    fi
  done < "$skill_file"

  if [ "$HAS_NAME" = false ]; then
    echo "  Missing 'name:' in frontmatter: $skill"
    FM_NO_NAME=$((FM_NO_NAME + 1))
  fi
  if [ "$HAS_DESC" = false ]; then
    echo "  Missing 'description:' in frontmatter: $skill"
    FM_NO_DESC=$((FM_NO_DESC + 1))
  fi
done

if [ "$FM_MISSING" -eq 0 ]; then
  pass "All Claude skills have YAML frontmatter"
else
  fail "$FM_MISSING Claude skills missing frontmatter"
fi

if [ "$FM_NO_NAME" -eq 0 ]; then
  pass "All Claude skills have 'name' field"
else
  fail "$FM_NO_NAME Claude skills missing 'name' field"
fi

if [ "$FM_NO_DESC" -eq 0 ]; then
  pass "All Claude skills have 'description' field"
else
  fail "$FM_NO_DESC Claude skills missing 'description' field"
fi

echo ""

# ================================================================
# MERGED SKILLS — absorbed content checks
# ================================================================
echo "--- Merged skill content ---"

if grep -qi "reset" "$CLAUDE_DIR/context-engineer.md" 2>/dev/null; then
  pass "context-engineer.md contains 'reset' (absorbed from overwrite)"
else
  fail "context-engineer.md missing 'reset' content"
fi

if grep -q "WCAG" "$CLAUDE_DIR/uxtest.md" 2>/dev/null; then
  pass "uxtest.md contains 'WCAG' (absorbed from a11y)"
else
  fail "uxtest.md missing 'WCAG' content"
fi

if grep -qi "Unattended" "$CLAUDE_DIR/iterate.md" 2>/dev/null; then
  pass "iterate.md contains 'Unattended' (absorbed from unloop)"
else
  fail "iterate.md missing 'Unattended' content"
fi

if grep -qi "Platform auto-detection" "$CLAUDE_DIR/deploy.md" 2>/dev/null; then
  pass "deploy.md contains 'Platform auto-detection' (absorbed from push)"
else
  fail "deploy.md missing 'Platform auto-detection' content"
fi

echo ""

# ================================================================
# REGISTRY SKILLS NOT IN CORE
# ================================================================
echo "--- Registry skills not in core ---"

REG_IN_CORE=0
for skill in $REGISTRY_SKILLS; do
  if [ -f "$CLAUDE_DIR/$skill.md" ]; then
    echo "  Registry skill in core: $skill"
    REG_IN_CORE=$((REG_IN_CORE + 1))
  fi
done

if [ "$REG_IN_CORE" -eq 0 ]; then
  pass "Registry skills (api, schema, landing, doc, swot, monitorlive, explain, env) not in claude/nox/"
else
  fail "$REG_IN_CORE registry skills found in claude/nox/"
fi

echo ""

# ================================================================
# SKILL COUNT MATCHES EXACTLY 31
# ================================================================
echo "--- Skill count ---"

ACTUAL_COUNT=$(ls -1 "$CLAUDE_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')

if [ "$ACTUAL_COUNT" -eq 30 ]; then
  pass "Exactly 30 .md files in claude/nox/ ($ACTUAL_COUNT)"
else
  fail "Expected 30 .md files in claude/nox/, found $ACTUAL_COUNT"
fi

echo ""

# ================================================================
# AGENT TESTS
# ================================================================
echo "--- Agent existence (8 agents) ---"

EXPECTED_AGENTS="nox-reviewer nox-security-scanner nox-pentester nox-dep-auditor nox-perf-profiler nox-ux-tester nox-prompt-auditor nox-monitor"

AGENT_MISSING=0
for agent in $EXPECTED_AGENTS; do
  if [ ! -f "$AGENTS_DIR/$agent.md" ]; then
    echo "  Missing agent: $agent"
    AGENT_MISSING=$((AGENT_MISSING + 1))
  fi
done

if [ "$AGENT_MISSING" -eq 0 ]; then
  pass "All 8 agents exist in agents/"
else
  fail "$AGENT_MISSING agents missing from agents/"
fi

echo ""

echo "--- Agent frontmatter ---"

AGENT_FM_MISSING=0
AGENT_NO_NAME=0
AGENT_NO_DESC=0

for agent_file in "$AGENTS_DIR"/*.md; do
  [ -f "$agent_file" ] || continue
  agent=$(basename "$agent_file" .md)

  FIRST_LINE=$(head -1 "$agent_file")
  if [ "$FIRST_LINE" != "---" ]; then
    echo "  Missing frontmatter: $agent"
    AGENT_FM_MISSING=$((AGENT_FM_MISSING + 1))
    continue
  fi

  HAS_NAME=false
  HAS_DESC=false
  IN_FM=false
  LINE_NUM=0

  while IFS= read -r line; do
    LINE_NUM=$((LINE_NUM + 1))
    if [ "$LINE_NUM" -eq 1 ]; then
      IN_FM=true
      continue
    fi
    if [ "$IN_FM" = true ] && [ "$line" = "---" ]; then
      break
    fi
    if [ "$IN_FM" = true ]; then
      case "$line" in
        name:*) HAS_NAME=true ;;
        description:*) HAS_DESC=true ;;
      esac
    fi
  done < "$agent_file"

  if [ "$HAS_NAME" = false ]; then
    echo "  Missing 'name:' in agent frontmatter: $agent"
    AGENT_NO_NAME=$((AGENT_NO_NAME + 1))
  fi
  if [ "$HAS_DESC" = false ]; then
    echo "  Missing 'description:' in agent frontmatter: $agent"
    AGENT_NO_DESC=$((AGENT_NO_DESC + 1))
  fi
done

if [ "$AGENT_FM_MISSING" -eq 0 ]; then
  pass "All agents have YAML frontmatter"
else
  fail "$AGENT_FM_MISSING agents missing frontmatter"
fi

if [ "$AGENT_NO_NAME" -eq 0 ]; then
  pass "All agents have 'name' field"
else
  fail "$AGENT_NO_NAME agents missing 'name' field"
fi

if [ "$AGENT_NO_DESC" -eq 0 ]; then
  pass "All agents have 'description' field"
else
  fail "$AGENT_NO_DESC agents missing 'description' field"
fi

echo ""

echo "--- Agent line count (min 100 lines) ---"

AGENT_STUB=0
for agent_file in "$AGENTS_DIR"/*.md; do
  [ -f "$agent_file" ] || continue
  agent=$(basename "$agent_file" .md)
  LINE_COUNT=$(wc -l < "$agent_file" | tr -d ' ')
  if [ "$LINE_COUNT" -lt 100 ]; then
    echo "  Stub agent ($LINE_COUNT lines): $agent"
    AGENT_STUB=$((AGENT_STUB + 1))
  fi
done

if [ "$AGENT_STUB" -eq 0 ]; then
  pass "All agents are at least 100 lines (not stubs)"
else
  fail "$AGENT_STUB agents are under 100 lines"
fi

echo ""

# ================================================================
# PARITY TESTS
# ================================================================
echo "--- CLI parity ---"

CLAUDE_COUNT=$(ls -1 "$CLAUDE_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')
GEMINI_COUNT=$(ls -1d "$GEMINI_DIR"/*/ 2>/dev/null | wc -l | tr -d ' ')
CODEX_COUNT=$(ls -1d "$CODEX_DIR"/*/ 2>/dev/null | wc -l | tr -d ' ')

echo "  Claude=$CLAUDE_COUNT  Gemini=$GEMINI_COUNT  Codex=$CODEX_COUNT"

if [ "$CLAUDE_COUNT" -eq "$GEMINI_COUNT" ] && [ "$CLAUDE_COUNT" -eq "$CODEX_COUNT" ]; then
  pass "Gemini/Codex counts match Claude ($CLAUDE_COUNT)"
else
  fail "Skill count mismatch: Claude=$CLAUDE_COUNT Gemini=$GEMINI_COUNT Codex=$CODEX_COUNT"
fi

echo ""

echo "--- No orphaned Gemini/Codex skills ---"

ORPHAN_GEMINI=0
for skill_dir in "$GEMINI_DIR"/*/; do
  [ -d "$skill_dir" ] || continue
  skill=$(basename "$skill_dir")
  if [ ! -f "$CLAUDE_DIR/$skill.md" ]; then
    echo "  Orphaned Gemini skill: $skill (no Claude counterpart)"
    ORPHAN_GEMINI=$((ORPHAN_GEMINI + 1))
  fi
done

if [ "$ORPHAN_GEMINI" -eq 0 ]; then
  pass "No orphaned Gemini skills (all have Claude counterpart)"
else
  fail "$ORPHAN_GEMINI orphaned Gemini skills found"
fi

ORPHAN_CODEX=0
for skill_dir in "$CODEX_DIR"/*/; do
  [ -d "$skill_dir" ] || continue
  skill=$(basename "$skill_dir")
  if [ ! -f "$CLAUDE_DIR/$skill.md" ]; then
    echo "  Orphaned Codex skill: $skill (no Claude counterpart)"
    ORPHAN_CODEX=$((ORPHAN_CODEX + 1))
  fi
done

if [ "$ORPHAN_CODEX" -eq 0 ]; then
  pass "No orphaned Codex skills (all have Claude counterpart)"
else
  fail "$ORPHAN_CODEX orphaned Codex skills found"
fi

echo ""

echo "--- Registry parity ---"

REG_CLAUDE_COUNT=$(ls -1 "$REGISTRY_CLAUDE"/*.md 2>/dev/null | wc -l | tr -d ' ')
REG_GEMINI_COUNT=$(ls -1d "$REGISTRY_GEMINI"/*/ 2>/dev/null | wc -l | tr -d ' ')
REG_CODEX_COUNT=$(ls -1d "$REGISTRY_CODEX"/*/ 2>/dev/null | wc -l | tr -d ' ')

echo "  Registry: Claude=$REG_CLAUDE_COUNT  Gemini=$REG_GEMINI_COUNT  Codex=$REG_CODEX_COUNT"

if [ "$REG_CLAUDE_COUNT" -eq "$REG_GEMINI_COUNT" ] && [ "$REG_CLAUDE_COUNT" -eq "$REG_CODEX_COUNT" ]; then
  pass "Registry counts match across all 3 CLIs ($REG_CLAUDE_COUNT)"
else
  fail "Registry count mismatch: Claude=$REG_CLAUDE_COUNT Gemini=$REG_GEMINI_COUNT Codex=$REG_CODEX_COUNT"
fi

echo ""

# ================================================================
# MCP SERVER TESTS
# ================================================================
echo "--- MCP server ---"

if [ -f "$MCP_DIR/server.js" ]; then
  pass "MCP server file exists (mcp-server/server.js)"
else
  fail "MCP server file missing (mcp-server/server.js)"
fi

if grep -q "2.5.0" "$MCP_DIR/server.js" 2>/dev/null; then
  pass "MCP server.js contains version 2.5.0"
else
  fail "MCP server.js does not contain version 2.5.0"
fi

echo ""

# ================================================================
# INSTALL/UNINSTALL TESTS
# ================================================================
echo "--- Install/uninstall script checks ---"

if grep -q "\-\-with-registry" "$SCRIPT_DIR/install.sh" 2>/dev/null; then
  pass "install.sh has --with-registry flag"
else
  fail "install.sh missing --with-registry flag"
fi

if grep -q "start" "$SCRIPT_DIR/uninstall.sh" 2>/dev/null; then
  pass "uninstall.sh lists 'start' in Codex skills list"
else
  fail "uninstall.sh missing 'start' in Codex skills list"
fi

echo ""

# ================================================================
# EDGE CASES
# ================================================================
echo "--- Edge cases: file size limits ---"

OVER_300=0
for skill_file in "$CLAUDE_DIR"/*.md; do
  [ -f "$skill_file" ] || continue
  skill=$(basename "$skill_file" .md)
  LINE_COUNT=$(wc -l < "$skill_file" | tr -d ' ')
  if [ "$LINE_COUNT" -gt 300 ]; then
    echo "  Over 300 lines ($LINE_COUNT): $skill"
    OVER_300=$((OVER_300 + 1))
  fi
done

if [ "$OVER_300" -eq 0 ]; then
  pass "No skill file exceeds 300 lines"
else
  fail "$OVER_300 skill files exceed 300 lines"
fi

UNDER_10=0
for skill_file in "$CLAUDE_DIR"/*.md; do
  [ -f "$skill_file" ] || continue
  skill=$(basename "$skill_file" .md)
  LINE_COUNT=$(wc -l < "$skill_file" | tr -d ' ')
  if [ "$LINE_COUNT" -lt 10 ]; then
    echo "  Under 10 lines ($LINE_COUNT): $skill"
    UNDER_10=$((UNDER_10 + 1))
  fi
done

if [ "$UNDER_10" -eq 0 ]; then
  pass "No empty/stub skill files (all >= 10 lines)"
else
  fail "$UNDER_10 skill files are under 10 lines"
fi

echo ""

echo "--- help-forge catalog count ---"

if grep -q "30 core" "$CLAUDE_DIR/help-forge.md" 2>/dev/null; then
  pass "help-forge.md contains '30 core' in catalog"
else
  fail "help-forge.md missing '30 core' count"
fi

echo ""

# ── Summary ─────────────────────────────────────────────────────
echo "==========================="
echo "Results: $PASS_COUNT passed, $FAIL_COUNT failed"
echo "==========================="

if [ "$FAIL_COUNT" -gt 0 ]; then
  exit 1
fi
exit 0
