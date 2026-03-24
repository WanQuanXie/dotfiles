#!/usr/bin/env fish

# 获取项目根目录的绝对路径
# 使用 status -f 获取脚本的绝对路径，然后取其目录 (app/xxx 的父目录的父目录)
set -g APP_TEST_PROJECT_ROOT (cd (dirname (dirname (dirname (status -f)))); and pwd)

# 加载测试库 (使用绝对路径)
source "$APP_TEST_PROJECT_ROOT/lib/test.fish"

# 注意: fish 不支持 set -e (errexit)
# 如需错误处理，请使用 `; or exit 1` 语法显式处理

# 检查 SSH 配置
test -d ~/.ssh
test -f ~/.ssh/config

# 检查 SSH 密钥
test -f ~/.ssh/id_ed25519; or test -f ~/.ssh/id_rsa

# 检查 SSH 代理
ssh-add -l > /dev/null 2>&1; or echo "SSH 代理未运行，这可能是正常的"
