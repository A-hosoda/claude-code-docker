#!/bin/bash
# Test MCP setup and configuration

echo "=== MCP Configuration Test ==="

# Check if claude is available
if ! command -v claude &> /dev/null; then
    echo "❌ Error: claude command not found"
    exit 1
fi
echo "✅ Claude CLI found"

# Check if uvx is available
if ! command -v uvx &> /dev/null; then
    echo "❌ Error: uvx command not found"
    exit 1
fi
echo "✅ uvx found"

# Check configuration directory
if [ -d "/home/dev/.config/claude" ]; then
    echo "✅ Claude config directory exists"
else
    echo "⚠️  Claude config directory not found"
fi

# List current MCP servers
echo ""
echo "=== Current MCP Servers ==="
claude mcp list

echo ""
echo "=== MCP Configuration ==="
if [ -f "/home/dev/.config/claude/claude.json" ]; then
    echo "Configuration file found:"
    cat /home/dev/.config/claude/claude.json
elif [ -f "/home/dev/.claude.json" ]; then
    echo "Configuration file found (legacy location):"
    cat /home/dev/.claude.json
else
    echo "⚠️  No MCP configuration file found"
fi