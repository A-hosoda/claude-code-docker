# Claude Code Custom Scripts

このディレクトリには、実行可能なスクリプトを配置します。

## 使い方

1. このディレクトリに実行可能なスクリプトを配置すると、コンテナ内の `/home/dev/.claude-code/scripts/` にマウントされます
2. このディレクトリはPATHに追加されているため、どこからでも実行可能です

## 例

```bash
#!/bin/bash
# custom-scripts/my-tool.sh
echo "Running my custom tool!"
```

スクリプトを実行可能にする:
```bash
chmod +x custom-scripts/my-tool.sh
```