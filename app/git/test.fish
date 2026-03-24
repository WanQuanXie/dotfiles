#!/usr/bin/env fish

# 获取项目根目录的绝对路径
# 使用 status -f 获取脚本的绝对路径，然后取其目录 (app/xxx 的父目录的父目录)
set -g APP_TEST_PROJECT_ROOT (dirname (dirname (status -f)))

# 加载测试库 (使用绝对路径)
source "$APP_TEST_PROJECT_ROOT/lib/test.fish"

# Git 配置测试 - 使用共享库重构
# 面向 macOS 15+ (Apple Silicon)

# 初始化测试环境
init_test_env (basename (dirname (status --current-filename)))

# 注意: fish 不支持 set -e (errexit)
# 如需错误处理，请使用 `; or exit 1` 语法显式处理

show_test "Git 配置测试开始"

# 基本安装测试
test_command "command -v git" "检查 git 是否安装"

# 版本信息测试
check_version "git" "--version" "检查 Git 版本"

# 用户配置测试
show_test "检查 Git 用户配置"

set -l GIT_NAME (git config --global --get user.name; or echo '')
set -l GIT_EMAIL (git config --global --get user.email; or echo '')

if test -n "$GIT_NAME"
    show_info "Git 用户名: $GIT_NAME"
    show_success "Git 用户名已配置"
else
    show_warning "Git 用户名未配置"
end

if test -n "$GIT_EMAIL"
    show_info "Git 邮箱: $GIT_EMAIL"
    show_success "Git 邮箱已配置"
else
    show_warning "Git 邮箱未配置"
end

# 检查配置文件
show_test "检查 Git 配置文件"
test_command "test -f ~/.gitconfig" "检查全局配置文件"

# GPG 签名配置测试
show_test "检查 GPG 签名配置"

set -l GPG_SIGNING_KEY (git config --global --get user.signingkey; or echo '')
set -l GPG_COMMIT_SIGN (git config --global --get commit.gpgsign; or echo '')

if test -n "$GPG_SIGNING_KEY"
    show_info "GPG 签名密钥: $GPG_SIGNING_KEY"
    show_success "GPG 签名密钥已配置"

    if test "$GPG_COMMIT_SIGN" = "true"
        show_success "自动 GPG 签名已启用"
    else
        show_warning "自动 GPG 签名未启用"
    end
else
    show_warning "GPG 签名密钥未配置"
end

# 检查其他重要配置
show_test "检查其他 Git 配置"

# 检查默认分支名
set -l DEFAULT_BRANCH (git config --global --get init.defaultBranch; or echo '')
if test -n "$DEFAULT_BRANCH"
    show_info "默认分支名: $DEFAULT_BRANCH"
    show_success "默认分支名已配置"
else
    show_warning "默认分支名未配置"
end

# 检查编辑器配置
set -l GIT_EDITOR (git config --global --get core.editor; or echo '')
if test -n "$GIT_EDITOR"
    show_info "Git 编辑器: $GIT_EDITOR"
    show_success "Git 编辑器已配置"
else
    show_warning "Git 编辑器未配置"
end

# 功能测试
show_test "Git 功能测试"

# 创建临时仓库进行测试
set -l TEMP_DIR (mktemp -d)
cd "$TEMP_DIR"

# 初始化仓库
test_command "git init" "初始化 Git 仓库"

# 创建测试文件
echo "test content" > test.txt
test_command "git add test.txt" "添加文件到暂存区"

# 提交测试（如果用户配置完整）
if test -n "$GIT_NAME"; and test -n "$GIT_EMAIL"
    # CI 环境没有 GPG 私钥，使用 --no-gpg-sign 跳过签名
    if test "$CI" = "true"
        test_command "git commit --no-gpg-sign -m 'Test commit'" "创建测试提交"
    else
        test_command "git commit -m 'Test commit'" "创建测试提交"
    end
    show_success "Git 基本功能正常"
else
    show_warning "由于用户配置不完整，跳过提交测试"
end

# 清理
cd - >/dev/null
rm -rf "$TEMP_DIR"

# 跨 Shell 测试
show_test "跨 Shell 测试"

if command -v bash >/dev/null 2>&1
    test_command "bash -c 'command -v git'" "测试 bash 中的 git 可用性"
end

# Homebrew 安装检查
show_test "Homebrew 安装检查"

set -l GIT_PATH (which git)
if test "$GIT_PATH" = *"/opt/homebrew/"*
    show_success "使用 Homebrew 安装的 Git"
else
    show_warning "可能使用系统自带的 Git"
end

test_summary "Git 配置测试"
