#!/usr/bin/env bash
set -u

# test-hooks.sh — Unit tests for Nox hook scripts
# Portable: works on Ubuntu (CI) and Git Bash (Windows/MSYS)
# Requires: python3 in PATH (hooks use it for JSON parsing)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOKS_DIR="$(cd "$SCRIPT_DIR/../hooks" && pwd)"

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

# Check python3 is available (hooks require it)
if ! command -v python3 &>/dev/null; then
  echo "SKIP: python3 not found — hooks require python3 for JSON parsing"
  exit 0
fi

echo "=== Nox Hook Tests ==="
echo ""

# ================================================================
# destructive-guard.sh
# ================================================================
echo "--- destructive-guard ---"

# Ensure the env var is not set to bypass
unset NOX_ALLOW_DESTRUCTIVE

# Test: Block rm -rf /
RC=0
echo '{"tool_name":"Bash","tool_input":{"command":"rm -rf /"}}' \
  | bash "$HOOKS_DIR/destructive-guard.sh" > /dev/null 2>&1 || RC=$?
if [ "$RC" -eq 2 ]; then
  pass "destructive-guard blocks rm -rf /"
else
  fail "destructive-guard: rm -rf / returned $RC (expected 2)"
fi

# Test: Block git reset --hard
RC=0
echo '{"tool_name":"Bash","tool_input":{"command":"git reset --hard"}}' \
  | bash "$HOOKS_DIR/destructive-guard.sh" > /dev/null 2>&1 || RC=$?
if [ "$RC" -eq 2 ]; then
  pass "destructive-guard blocks git reset --hard"
else
  fail "destructive-guard: git reset --hard returned $RC (expected 2)"
fi

# Test: Allow safe command (ls -la)
RC=0
echo '{"tool_name":"Bash","tool_input":{"command":"ls -la"}}' \
  | bash "$HOOKS_DIR/destructive-guard.sh" > /dev/null 2>&1 || RC=$?
if [ "$RC" -eq 0 ]; then
  pass "destructive-guard allows safe command (ls -la)"
else
  fail "destructive-guard: ls -la returned $RC (expected 0)"
fi

# Test: Allow non-Bash tool
RC=0
echo '{"tool_name":"Write","tool_input":{"command":"rm -rf /"}}' \
  | bash "$HOOKS_DIR/destructive-guard.sh" > /dev/null 2>&1 || RC=$?
if [ "$RC" -eq 0 ]; then
  pass "destructive-guard ignores non-Bash tools"
else
  fail "destructive-guard: non-Bash tool returned $RC (expected 0)"
fi

# Test: Block git push --force main
RC=0
echo '{"tool_name":"Bash","tool_input":{"command":"git push --force origin main"}}' \
  | bash "$HOOKS_DIR/destructive-guard.sh" > /dev/null 2>&1 || RC=$?
if [ "$RC" -eq 2 ]; then
  pass "destructive-guard blocks git push --force main"
else
  fail "destructive-guard: force push main returned $RC (expected 2)"
fi

echo ""

# ================================================================
# commit-lint.sh
# ================================================================
echo "--- commit-lint ---"

unset NOX_SKIP_COMMIT_LINT

# Test: Block bad commit message
RC=0
echo '{"tool_name":"Bash","tool_input":{"command":"git commit -m \"did some stuff\""}}' \
  | bash "$HOOKS_DIR/commit-lint.sh" > /dev/null 2>&1 || RC=$?
if [ "$RC" -eq 2 ]; then
  pass "commit-lint blocks bad message"
else
  fail "commit-lint: bad message returned $RC (expected 2)"
fi

# Test: Allow good commit message (feat: something)
RC=0
echo '{"tool_name":"Bash","tool_input":{"command":"git commit -m \"feat: add user auth\""}}' \
  | bash "$HOOKS_DIR/commit-lint.sh" > /dev/null 2>&1 || RC=$?
if [ "$RC" -eq 0 ]; then
  pass "commit-lint allows good message (feat: add user auth)"
else
  fail "commit-lint: good message returned $RC (expected 0)"
fi

# Test: Allow scoped message
RC=0
echo '{"tool_name":"Bash","tool_input":{"command":"git commit -m \"fix(auth): resolve token bug\""}}' \
  | bash "$HOOKS_DIR/commit-lint.sh" > /dev/null 2>&1 || RC=$?
if [ "$RC" -eq 0 ]; then
  pass "commit-lint allows scoped message (fix(auth): ...)"
else
  fail "commit-lint: scoped message returned $RC (expected 0)"
fi

# Test: Ignore non-commit commands
RC=0
echo '{"tool_name":"Bash","tool_input":{"command":"git status"}}' \
  | bash "$HOOKS_DIR/commit-lint.sh" > /dev/null 2>&1 || RC=$?
if [ "$RC" -eq 0 ]; then
  pass "commit-lint ignores non-commit commands"
else
  fail "commit-lint: non-commit returned $RC (expected 0)"
fi

echo ""

# ================================================================
# secret-scanner.sh
# ================================================================
echo "--- secret-scanner ---"

unset NOX_SKIP_SECRET_SCAN

TMPDIR_SECRETS="$(mktemp -d)"

# Test: Detect Anthropic API key in file
SECRET_FILE="$TMPDIR_SECRETS/has-secret.ts"
cat > "$SECRET_FILE" <<'EOF'
const apiKey = "sk-ant-api03-abcdefghijklmnopqrstuvwxyz0123456789ABCDEF";
EOF

RC=0
echo "{\"tool_name\":\"Write\",\"tool_input\":{\"file_path\":\"$SECRET_FILE\"}}" \
  | bash "$HOOKS_DIR/secret-scanner.sh" > /dev/null 2>&1 || RC=$?
if [ "$RC" -eq 2 ]; then
  pass "secret-scanner detects Anthropic API key"
else
  fail "secret-scanner: Anthropic key returned $RC (expected 2)"
fi

# Test: Clean file passes
CLEAN_FILE="$TMPDIR_SECRETS/clean.ts"
cat > "$CLEAN_FILE" <<'EOF'
const greeting = "hello world";
const count = 42;
EOF

RC=0
echo "{\"tool_name\":\"Write\",\"tool_input\":{\"file_path\":\"$CLEAN_FILE\"}}" \
  | bash "$HOOKS_DIR/secret-scanner.sh" > /dev/null 2>&1 || RC=$?
if [ "$RC" -eq 0 ]; then
  pass "secret-scanner allows clean file"
else
  fail "secret-scanner: clean file returned $RC (expected 0)"
fi

# Test: Detect GitHub PAT
GH_FILE="$TMPDIR_SECRETS/gh-token.js"
cat > "$GH_FILE" <<'EOF'
const token = "ghp_ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefgh1234";
EOF

RC=0
echo "{\"tool_name\":\"Write\",\"tool_input\":{\"file_path\":\"$GH_FILE\"}}" \
  | bash "$HOOKS_DIR/secret-scanner.sh" > /dev/null 2>&1 || RC=$?
if [ "$RC" -eq 2 ]; then
  pass "secret-scanner detects GitHub PAT"
else
  fail "secret-scanner: GitHub PAT returned $RC (expected 2)"
fi

# Test: Ignore non-Write/Edit tools
RC=0
echo "{\"tool_name\":\"Bash\",\"tool_input\":{\"file_path\":\"$SECRET_FILE\"}}" \
  | bash "$HOOKS_DIR/secret-scanner.sh" > /dev/null 2>&1 || RC=$?
if [ "$RC" -eq 0 ]; then
  pass "secret-scanner ignores non-Write/Edit tools"
else
  fail "secret-scanner: non-Write tool returned $RC (expected 0)"
fi

rm -rf "$TMPDIR_SECRETS"

echo ""

# ================================================================
# file-size-guard.sh
# ================================================================
echo "--- file-size-guard ---"

unset NOX_SKIP_FILE_SIZE_GUARD
unset NOX_FILE_SIZE_LIMIT

# Test: Block large file (>500KB content)
# Generate a large content string via python3
LARGE_CONTENT=$(python3 -c "print('x' * 600000)")

RC=0
python3 -c "
import json, sys
data = {
    'tool_name': 'Write',
    'tool_input': {
        'file_path': '/tmp/big-file.txt',
        'content': 'x' * 600000
    }
}
json.dump(data, sys.stdout)
" | bash "$HOOKS_DIR/file-size-guard.sh" > /dev/null 2>&1 || RC=$?
if [ "$RC" -eq 2 ]; then
  pass "file-size-guard blocks large file (600KB)"
else
  fail "file-size-guard: large file returned $RC (expected 2)"
fi

# Test: Allow small file (1KB)
RC=0
python3 -c "
import json, sys
data = {
    'tool_name': 'Write',
    'tool_input': {
        'file_path': '/tmp/small-file.txt',
        'content': 'x' * 1024
    }
}
json.dump(data, sys.stdout)
" | bash "$HOOKS_DIR/file-size-guard.sh" > /dev/null 2>&1 || RC=$?
if [ "$RC" -eq 0 ]; then
  pass "file-size-guard allows small file (1KB)"
else
  fail "file-size-guard: small file returned $RC (expected 0)"
fi

# Test: Ignore non-Write tool
RC=0
echo '{"tool_name":"Bash","tool_input":{"command":"echo hi"}}' \
  | bash "$HOOKS_DIR/file-size-guard.sh" > /dev/null 2>&1 || RC=$?
if [ "$RC" -eq 0 ]; then
  pass "file-size-guard ignores non-Write tools"
else
  fail "file-size-guard: non-Write tool returned $RC (expected 0)"
fi

echo ""

# ================================================================
# context-monitor.js
# ================================================================
echo "--- context-monitor ---"

# Get the actual tmpdir that Node.js resolves (may differ from $TMPDIR on Windows)
NODE_TMPDIR=$(node -e "console.log(require('os').tmpdir())")
# Normalize to forward slashes for cross-platform compatibility
NODE_TMPDIR=$(echo "$NODE_TMPDIR" | tr '\\' '/')

# Test: Handoff message at 84% usage (remaining 16%)
SESSION_ID="nox-test-$$"
METRICS_FILE="$NODE_TMPDIR/claude-ctx-${SESSION_ID}.json"

NOW_EPOCH=$(python3 -c "import time; print(int(time.time()))")
cat > "$METRICS_FILE" <<EOF
{"remaining_percentage": 16, "used_pct": 84, "timestamp": $NOW_EPOCH}
EOF

# Pipe JSON input to context-monitor via stdin
OUTPUT=""
OUTPUT=$(echo "{\"session_id\":\"$SESSION_ID\",\"tool_name\":\"Bash\",\"cwd\":\"/tmp\"}" \
  | node "$HOOKS_DIR/context-monitor.js" 2>/dev/null) || true

if echo "$OUTPUT" | grep -qi "handoff\|HANDOFF\|context\|CONTEXT\|usage\|recovery" 2>/dev/null; then
  pass "context-monitor outputs handoff message at 84% usage"
else
  fail "context-monitor: no handoff message at 84% (output: ${OUTPUT:-empty})"
fi

# Clean up handoff artifacts (checkpoint file, warned state)
rm -f "$METRICS_FILE"
rm -f "$NODE_TMPDIR/claude-ctx-${SESSION_ID}-warned.json"

# Test: No output at 30% usage (remaining 70%)
SESSION_ID2="nox-test2-$$"
METRICS_FILE2="$NODE_TMPDIR/claude-ctx-${SESSION_ID2}.json"
cat > "$METRICS_FILE2" <<EOF
{"remaining_percentage": 70, "used_pct": 30, "timestamp": $NOW_EPOCH}
EOF

OUTPUT2=""
OUTPUT2=$(echo "{\"session_id\":\"$SESSION_ID2\",\"tool_name\":\"Bash\",\"cwd\":\"/tmp\"}" \
  | node "$HOOKS_DIR/context-monitor.js" 2>/dev/null) || true

if [ -z "$OUTPUT2" ]; then
  pass "context-monitor no output at 30% usage"
else
  fail "context-monitor: unexpected output at 30% (output: $OUTPUT2)"
fi

# Clean up
rm -f "$METRICS_FILE2"
rm -f "$NODE_TMPDIR/claude-ctx-${SESSION_ID2}-warned.json"

echo ""

# ── Summary ─────────────────────────────────────────────────────
echo "==========================="
echo "Results: $PASS_COUNT passed, $FAIL_COUNT failed"
echo "==========================="

if [ "$FAIL_COUNT" -gt 0 ]; then
  exit 1
fi
exit 0
