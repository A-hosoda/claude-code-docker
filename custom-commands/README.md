# Claude Code Custom Commands

このディレクトリには、Claude Codeで使用するカスタムコマンドを配置します。

## 使い方

1. このディレクトリに `.md` ファイルを配置すると、コンテナ内の `/workspace/.claude/commands/` にマウントされます
2. ファイル名がコマンド名になります（例: `ask.md` → `/ask` コマンド）
3. Claude Code内でカスタムコマンドとして利用可能になります

## カスタムコマンドのフォーマット

```markdown
---
description: "コマンドの説明"
---

Claudeへの指示をここに書きます

# User request

$ARGUMENTS
```

## 提供されているコマンド

- `/ask` - プログラミングに関する質問をする
- `/review` - コードレビューを依頼する

## 使用例

```bash
# Claude Code内で
claude> /ask Pythonでファイルを読み込む方法を教えて
claude> /review def calculate(x, y): return x + y
```