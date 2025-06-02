# ./Dockerfile
FROM node:20-bullseye-slim

# ---- Create non-root user for security ----
RUN useradd -m -d /home/dev -s /bin/bash dev

# ---- Install Claude Code CLI ----
# - npm config set os linux   : Prevents OS detection issues
# - --force --no-os-check     : Disable OS check even on Linux
RUN npm config set os linux \
 && npm install -g @anthropic-ai/claude-code --force --no-os-check

# ---- Working directory (to be mounted from host) ----
WORKDIR /workspace
USER dev

# Default to shell. Customize as needed
ENTRYPOINT ["/bin/bash"]