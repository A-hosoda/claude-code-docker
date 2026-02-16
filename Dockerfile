# ./Dockerfile
FROM node:20-bullseye-slim

# ---- Install system dependencies ----
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    ripgrep \
    ca-certificates \
    gnupg \
    jq \
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

# ---- Create directories for custom commands and scripts ----
RUN mkdir -p /home/dev/.config/claude /home/dev/custom-scripts /workspace/.claude/commands \
    && chown -R dev:dev /home/dev/ /workspace/

# ---- Install Python and uv for MCP servers ----
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install --no-cache-dir --upgrade pip \
    && curl -LsSf https://astral.sh/uv/install.sh | sh \
    && mv /root/.local/bin/uv /usr/local/bin/uv \
    && mv /root/.local/bin/uvx /usr/local/bin/uvx

# ---- Working directory (to be mounted from host) ----
WORKDIR /workspace
USER dev

# ---- Install GitHub CLI extensions ----
# Copy from local repos via docker-compose additional_contexts (no auth required)
RUN mkdir -p ~/.local/share/gh/extensions
COPY --from=gh-ext-pr-unresolved --chown=dev:dev . /home/dev/.local/share/gh/extensions/gh-pr-unresolved
COPY --from=gh-ext-auto-review-fix --chown=dev:dev . /home/dev/.local/share/gh/extensions/gh-auto-review-fix
COPY --from=gh-ext-pr-check --chown=dev:dev . /home/dev/.local/share/gh/extensions/gh-pr-check
COPY --from=gh-ext-ai-review --chown=dev:dev . /home/dev/.local/share/gh/extensions/gh-ai-review
RUN chmod +x ~/.local/share/gh/extensions/*/gh-*

# Add custom scripts directory to PATH
ENV PATH="/home/dev/custom-scripts:${PATH}"

# ---- Entrypoint script (copies Docker-specific Claude settings at startup) ----
COPY --chown=dev:dev docker-entrypoint.sh /home/dev/docker-entrypoint.sh
RUN chmod +x /home/dev/docker-entrypoint.sh

ENTRYPOINT ["/home/dev/docker-entrypoint.sh"]
CMD ["/bin/bash"]
