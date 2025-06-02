# ./Dockerfile
FROM node:20-bullseye-slim

# ---- Install system dependencies ----
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    ripgrep \
    ca-certificates \
    gnupg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ---- Install GitHub CLI ----
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install -y gh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

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