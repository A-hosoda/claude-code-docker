# Claude Code Docker

Run [Claude Code CLI](https://docs.anthropic.com/claude/docs/claude-code-cli-usage) in a Docker container for enhanced safety. This containerized setup provides a controlled environment for macOS and Linux users who want to interact with Claude's coding capabilities while minimizing the risk of unintended file modifications.

---

## 🚀 Overview

Claude Code CLI is a powerful command-line tool that leverages Claude AI for various coding tasks:

- **Code Refactoring** - Improve code structure and readability
- **Test Generation** - Create unit and integration tests
- **Documentation** - Generate clear documentation for your code
- **Code Review** - Get feedback on your changes and PRs
- **Bug Fixing** - Identify and fix issues in your codebase
- **Feature Implementation** - Build new functionality with AI assistance

This Docker environment provides several advantages:
- Isolated execution environment to reduce risks
- Consistent configuration across team members
- Option for read-only file access to protect critical files
- Persistent authentication
- Easy installation and updates

---

## 🧱 Requirements

- **Docker and Docker Compose** installed  
  - macOS: [Docker Desktop](https://www.docker.com/products/docker-desktop/)
  - Linux: [Docker Engine](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/)
- **Claude account**
  - Sign up at [Anthropic Console](https://console.anthropic.com/)

---

## 📦 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/A-hosoda/claude-code-docker.git
cd claude-code-docker
```

### 2. Build the Docker image

```bash
docker compose build
```

### 3. Prepare your source code

Place your project files in the `src` directory:

```bash
mkdir -p src/your-project
# Copy or create your project files in src/your-project
```

### 4. Custom Commands and Scripts (Optional)

This setup supports custom commands and scripts:

- **`custom-commands/`**: Place custom command files here for Claude Code
- **`custom-scripts/`**: Place executable scripts here (automatically added to PATH)

Example custom script:
```bash
# custom-scripts/analyze.sh
#!/bin/bash
echo "Analyzing code..."
claude "analyze the code quality in $1" --print
```

Make it executable:
```bash
chmod +x custom-scripts/analyze.sh
```

### 5. MCP (Model Context Protocol) Setup

MCP サーバーを使用する場合:

```bash
# Dockerを再ビルド
docker compose build

# コンテナを起動
docker compose run --rm claude claude

# コンテナ内でMCPセットアップ（初回のみ）
claude> /exit
dev@container$ setup-mcp.sh

# Claude Codeに戻る
dev@container$ claude

# MCPサーバーの確認
claude> /mcp list
```

MCP設定は `claude-config/` ディレクトリに永続化されるため、次回以降は再設定不要です。

---

## 💬 Using Claude Code

### 🗨️ Interactive Mode (REPL)

The interactive mode provides a terminal-based chat interface with Claude:

```bash
docker compose run --rm claude claude
```

On first use, authenticate with Claude:

```
claude> /login
Please open this URL in your browser: https://console.anthropic.com/...
Paste your login token: sk-ant-...
```

**認証情報は `claude-config/` ディレクトリに永続化されるため、Dockerコンテナを再起動しても再ログインは不要です。**

Once authenticated, you can:

- Chat directly with Claude about your code
- Use `/help` to see available commands
- Provide context with `/file <path>` to upload files
- Run `/logout` to clear your session

#### Examples of interactive commands:

```
claude> Refactor the function in main.js to be more efficient
claude> Write unit tests for the User class in models/user.js
claude> Explain what the code in utils/helpers.js does
```

### ⚙️ Non-interactive Mode

Non-interactive mode is perfect for automation, CI/CD pipelines, or quick one-off requests.

#### Example: Improve code readability

```bash
docker compose run --rm claude \
  claude "improve readability of code in ./src" --print
```

#### Example: Generate tests for a file

```bash
docker compose run --rm claude \
  claude "write tests for ./src/math.ts" --print
```

#### Example: Review a PR

```bash
docker compose run --rm claude \
  claude "review the changes in my latest commit" --print
```

#### Common options:

- `--print`: Preview changes without applying them
- `--diff`: Show changes in diff format
- `--execute`: Apply the changes (use carefully)
- `--timeout`: Set a custom timeout (default: 60s)

---

## 🔧 Configuration

### Workspace Structure

The default configuration mounts the `src` directory to the container's workspace:

```
claude-code-docker/
├── src/                <- Your project files (mounted to /workspace)
│   ├── your-project/
│   └── another-project/
├── claude-config/      <- Claude認証データ（自動生成、永続化）
├── custom-commands/    <- Custom Claude Code commands
│   └── README.md
├── custom-scripts/     <- Executable scripts (added to PATH)
│   └── README.md
├── docker-compose.yml
├── Dockerfile
└── .gitignore
```

This separation helps keep the Docker environment configuration files distinct from your actual project files.

#### Alternative Mounting Options

If you need to work with files outside the src directory:

```bash
# Mount a specific directory
docker compose run --rm -v /path/to/your/project:/workspace claude claude

# Or use the root directory instead of src
docker compose run --rm -v ./:/workspace claude claude
```

### Read-Only Mode

To prevent accidental file modifications, you can mount your workspace as read-only:

```yaml
# In docker-compose.yml
volumes:
  - ./:/workspace:ro
```

### Custom Working Directory

If you want to work on a specific project outside this directory:

```bash
docker compose run --rm -v /path/to/your/project:/workspace claude claude
```

### Persistence

Authentication data is stored in a Docker volume (`claude_data`) to persist between sessions.

---

## 🔍 Troubleshooting

### Common Issues

- **Authentication problems**: Run `/login` again in interactive mode
- **Permission errors**: Check your file permissions and ownership
- **Timeout errors**: Try increasing the timeout with `--timeout`

---

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

