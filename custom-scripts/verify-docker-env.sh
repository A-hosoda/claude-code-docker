#!/bin/bash
# Verify Docker environment for Claude Code
# Run inside the container to check all required components

set -euo pipefail

pass=0
fail=0

check() {
    local label="$1"
    shift
    printf "[CHECK] %-35s" "$label"
    if "$@" > /dev/null 2>&1; then
        echo "OK"
        ((pass++))
    else
        echo "FAIL"
        ((fail++))
    fi
}

echo "=== Claude Code Docker Environment Verification ==="
echo ""

# 1. Node.js
check "Node.js" command -v node

# 2. npm
check "npm" command -v npm

# 3. Claude Code CLI
check "Claude Code CLI" command -v claude

# 4. GitHub CLI
check "gh CLI" command -v gh

# 5. gh extensions
check "gh extensions directory" test -d ~/.local/share/gh/extensions

# 6. ripgrep
check "ripgrep" command -v rg

# 7. Python / uv
check "Python3" command -v python3
check "uv" command -v uv

# 8. Workspace directory
check "Workspace (/workspace)" test -d /workspace

# 9. Global commands (directory existence only; may be empty)
check "Global commands" test -d /home/dev/.claude/commands

# 10. Global agents (directory existence only; may be empty)
check "Global agents" test -d /home/dev/.claude/agents

# 11. Custom scripts in PATH
check "Custom scripts in PATH" bash -c 'echo "$PATH" | grep -q custom-scripts'

# 12. Docker entrypoint
check "Entrypoint script" test -x /home/dev/docker-entrypoint.sh

echo ""
echo "=== Results: ${pass} passed, ${fail} failed ==="

if [ "$fail" -gt 0 ]; then
    exit 1
fi
