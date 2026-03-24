#!/usr/bin/env fish

source lib/test.fish

# 注意: fish 不支持 set -e (errexit)
# 如需错误处理，请使用 `; or exit 1` 语法显式处理

# 检查 SSH 配置
test -d ~/.ssh
test -f ~/.ssh/config

# 检查 SSH 密钥
test -f ~/.ssh/id_ed25519; or test -f ~/.ssh/id_rsa

# 检查 SSH 代理
ssh-add -l > /dev/null 2>&1; or echo "SSH 代理未运行，这可能是正常的"
