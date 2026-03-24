#!/usr/bin/env fish

source lib/test.fish

# Neovim 配置测试 - 使用共享库重构
# 兼容 POSIX shell (bash 4+/fish 4+) 和 macOS (Intel/Apple Silicon)

# 初始化测试环境
init_test_env (basename (dirname (status --current-filename)))

# 注意: fish 不支持 set -e (errexit)
# 如需错误处理，请使用 `; or exit 1` 语法显式处理

# 检查 nvim 是否安装
test -x (which nvim)

# 检查配置文件
test -d ~/.config/nvim
test -f ~/.config/nvim/init.lua

# 检查插件管理器
test -d ~/.local/share/nvim/lazy

# 验证插件安装
nvim --headless "+lua print(#vim.tbl_keys(require('lazy').plugins()))" +qa 2>&1 | grep -q "[1-9]"

# 检查语言服务器
nvim --headless "+lua print(#vim.tbl_keys(require('mason-registry').get_installed_packages()))" +qa 2>&1 | grep -q "[1-9]"
