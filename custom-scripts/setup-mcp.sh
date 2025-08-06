#!/bin/bash
# Setup MCP servers for Claude Code

echo "Setting up MCP servers..."

# Check if claude is available
if ! command -v claude &> /dev/null; then
    echo "Error: claude command not found"
    exit 1
fi

# Check if uvx is available
if ! command -v uvx &> /dev/null; then
    echo "Error: uvx command not found"
    exit 1
fi

# Add Serena MCP server using uvx
echo "Adding Serena MCP server..."
claude mcp add serena -- uvx --from git+https://github.com/oraios/serena serena-mcp-server --context ide-assistant --project /workspace --port 32000

echo "MCP setup complete!"
echo "You can verify with: claude mcp list"