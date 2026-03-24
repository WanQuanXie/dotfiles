#!/usr/bin/env fish

source lib/test.fish

# Neovim 配置测试 - 使用共享库重构
# 兼容 POSIX shell (bash 4+/fish 4+) 和 macOS (Intel/Apple Silicon)

# 初始化测试环境
init_test_env (basename (dirname (status --current-filename)))

# 测试命令并提供反馈
function test_command
    if test (count $argv) -lt 2
        echo "test_command 需要至少 2 个参数" >&2
        return 1
    end

    set -l cmd "$argv[1]"
    set -l msg "$argv[2]"
    set -l err_msg "$argv[3]"
    if test -z "$err_msg"
        set err_msg "$msg 失败"
    end

    show_test "$msg"
    if eval "$cmd" >> "$TEST_LOG" 2>&1
        show_success "$msg 通过"
        return 0
    else
        set -l exit_code $status
        show_error "$err_msg (错误代码: $exit_code)"
    end
end

# 设置错误处理
set -e

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
