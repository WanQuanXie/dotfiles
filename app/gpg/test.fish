#!/usr/bin/env fish

# GPG 配置验证脚本
# 验证 GPG 签名配置是否正确

# 注意: fish 不支持 set -e (errexit)
# 如需错误处理，请使用 `; or exit 1` 语法显式处理

# 获取项目根目录
set -l SCRIPT_DIR (cd (dirname (status --current-filename)); and pwd)
set -l PROJECT_ROOT (dirname (dirname "$SCRIPT_DIR"))

# 加载共享库 (使用 $PROJECT_ROOT 绝对路径)
source $PROJECT_ROOT/lib/init.fish
source $PROJECT_ROOT/lib/test.fish

init_test_env "GPG"

show_group "GPG 配置测试"

# 基础检查
show_progress "执行基础检查"

check_command "gpg" "GPG 命令"
check_version "gpg" "--version"
check_file "$HOME/.gnupg/gpg-agent.conf" "gpg-agent.conf"
check_file_contains "$HOME/.gnupg/gpg-agent.conf" "pinentry-mac" "pinentry-mac 配置"

# CI 环境中 GPG_TTY 可能为空，跳过检查
if test "$CI" = "true"
    show_warning "CI 环境检测到，跳过 GPG_TTY 环境变量检查"
else
    check_env_var "GPG_TTY" "GPG_TTY 环境变量"
end

# Git 配置检查
show_progress "检查 Git GPG 配置"
check_file_contains "$HOME/.config/fish/config.fish" "GPG_TTY" "GPG_TTY 在 fish config 中"

# 检查 Git 配置
if git config --global user.signingkey &>/dev/null
    show_success "Git signingkey 已配置: "(git config --global user.signingkey)
else
    show_warning "Git signingkey 未配置"
end

if git config --global commit.gpgsign &>/dev/null
    show_success "Git commit.gpgsign 已启用"
else
    show_warning "Git commit.gpgsign 未启用"
end

# 密钥检查
show_progress "检查 GPG 密钥"
if gpg --list-secret-keys &>/dev/null
    show_success "GPG 密钥已配置"
    echo ""
    echo "密钥详情："
    gpg --list-secret-keys --keyid-format=long 2>/dev/null | head -20; or true
else
    show_warning "未找到 GPG 密钥"
end

# GPG agent 配置检查
show_progress "检查 GPG agent 配置"
if gpgconf --list-dirs &>/dev/null
    set -l AGENT_DIR (gpgconf --list-dirs | grep agent | head -1)
    if test -n "$AGENT_DIR"
        show_success "GPG agent 目录: $AGENT_DIR"
    end
end

# Pinentry 路径检查
show_progress "检查 pinentry 配置"
if command -v pinentry-mac &>/dev/null
    show_success "pinentry-mac 已安装: "(which pinentry-mac)
else
    show_warning "pinentry-mac 未安装"
end

test_summary "GPG 配置"
