# Claude Code Docker

Run [Claude Code CLI](https://docs.anthropic.com/claude/docs/claude-code-cli-usage) safely in a Docker container. This containerized setup provides a controlled environment for macOS and Linux users who want to interact with Claude's coding capabilities without risking accidental file modifications.

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
- Isolated execution environment
- Consistent configuration across team members
- Option for read-only file access
- Persistent authentication
- Easy installation and updates

---

## 🧱 Requirements

- **Docker and Docker Compose** installed  
  - macOS: [Docker Desktop](https://www.docker.com/products/docker-desktop/)
  - Linux: [Docker Engine](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/)
- **Claude account** with API access
  - Sign up at [Anthropic Console](https://console.anthropic.com/)
  - Get your API key from the [API Keys section](https://console.anthropic.com/settings/keys)

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

### 4. Set up your API key (optional for interactive mode)

For non-interactive usage, you can set your API key as an environment variable:

```bash
export ANTHROPIC_API_KEY=sk-your-api-key
```

Or create a `.env` file in the project directory:

```
ANTHROPIC_API_KEY=sk-your-api-key
```

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
└── src/  <- This is mounted to /workspace in the container
    ├── your-project/
    └── another-project/
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

