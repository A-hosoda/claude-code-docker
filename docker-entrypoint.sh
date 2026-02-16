#!/bin/bash
# Copy Docker-specific Claude Code settings to project config directory
if [ -f /home/dev/docker-claude-config/settings.local.json ]; then
    mkdir -p /workspace/.claude
    cp /home/dev/docker-claude-config/settings.local.json /workspace/.claude/settings.local.json
fi

exec "$@"
