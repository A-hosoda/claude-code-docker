#!/bin/bash
# Verify Docker environment for Claude Code
# Run inside the container to check all required components

set -euo pipefail

pass=0
fail=0

check() {
    local label="$1"
    local condition="$2"
    printf "[CHECK] %-35s" "$label"
    if eval "$condition" > /dev/null 2>&1; then
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
check "Node.js" "command -v node"

# 2. npm
check "npm" "command -v npm"

# 3. Claude Code CLI
check "Claude Code CLI" "command -v claude"

# 4. GitHub CLI
check "gh CLI" "command -v gh"

# 5. gh auth
check "gh auth" "gh auth status"

# 6. gh extensions directory
check "gh extensions directory" "[ -d ~/.local/share/gh/extensions ]"

# 7-10. Individual gh extensions
check "gh-pr-unresolved" "gh pr-unresolved --help"
check "gh-auto-review-fix" "gh auto-review-fix --help"
check "gh-pr-check" "gh pr-check --help"
check "gh-ai-review" "gh ai-review --help"

# 11. ripgrep
check "ripgrep" "command -v rg"

# 12. Python3
check "Python3" "command -v python3"

# 13. uv
check "uv" "command -v uv"

# 14. Workspace directory
check "Workspace (/workspace)" "[ -d /workspace ]"

# 15. Claude Code settings
check "Claude Code settings" "[ -f /workspace/.claude/settings.local.json ] && jq empty /workspace/.claude/settings.local.json"

# 16. Custom commands (project)
check "Custom commands (project)" "[ -d /workspace/.claude/commands ] && [ -n \"\$(find /workspace/.claude/commands -maxdepth 1 -type f 2>/dev/null | head -1)\" ]"

# 17. Global commands
check "Global commands" "[ -d /home/dev/.claude/commands ] && [ -n \"\$(ls -A /home/dev/.claude/commands/ 2>/dev/null)\" ]"

# 18. Global agents
check "Global agents" "[ -d /home/dev/.claude/agents ] && [ -n \"\$(ls -A /home/dev/.claude/agents/ 2>/dev/null)\" ]"

# 19. Custom scripts in PATH
check "Custom scripts in PATH" "echo \"\$PATH\" | grep -q custom-scripts"

# 20. Docker entrypoint
check "Entrypoint script" "[ -x /home/dev/docker-entrypoint.sh ]"

echo ""
echo "=== Results: ${pass} passed, ${fail} failed ==="

if [ "$fail" -gt 0 ]; then
    exit 1
fi
