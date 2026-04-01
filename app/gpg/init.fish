#!/usr/bin/env fish

# GPG 签名配置脚本 (macOS Apple Silicon 版)
# 完整流程：安装依赖、配置 pinentry-mac、生成/导入密钥、配置 Git

# 注意: fish 不支持 set -e (errexit)
# 如需错误处理，请使用 `; or exit 1` 语法显式处理

# 获取项目根目录
set -l SCRIPT_DIR (cd (dirname (status -f)); and pwd)
set -l PROJECT_ROOT (dirname (dirname "$SCRIPT_DIR"))

# 加载共享库 (使用绝对路径)
source "$PROJECT_ROOT/lib/init.fish"

# GPG 配置信息
set -g GPG_EMAIL "i2cherry941219@gmail.com"
set -g GPG_NAME "WanQuanXie"
set -g GPG_SIGNING_KEY "4489322F7F539EA8"  # 预设签名密钥

# 检测 CI 环境
if test "$CI" = "true"
    set -g IS_CI true
else
    set -g IS_CI false
end

show_group "GPG 签名配置"

# ============================================
# 1. 幂等性检查
# ============================================
show_info "检查是否已配置 GPG..."

if is_app_configured "gpg"
    show_success "GPG 已配置，跳过初始化"
    show_info "如需重新配置，请先运行: rm -f $HOME/.dotfiles_configured_gpg"
    exit 0
end

# 检查是否已有 GPG 密钥
if gpg --list-secret-keys --keyid-format=long 2>/dev/null | grep -q "$GPG_SIGNING_KEY"
    show_info "检测到已存在的 GPG 密钥: $GPG_SIGNING_KEY"
    set -g KEY_EXISTS true
else if test "$IS_CI" = "true"
    # CI 环境：直接生成新密钥，不做额外检查
    show_info "CI 环境检测到，密钥不存在，将生成新密钥"
    set -g KEY_EXISTS false
else
    set -g KEY_EXISTS false
end

# ============================================
# 2. 安装依赖
# ============================================
show_progress "安装 GPG 相关依赖"

check_and_install_dependency "gpg" "gnupg"
check_and_install_dependency "pinentry-mac" "pinentry-mac"

# ============================================
# 3. 配置 gpg-agent.conf (pinentry-mac)
# ============================================
show_progress "配置 gpg-agent.conf"

ensure_directory "$HOME/.gnupg"
chmod 700 "$HOME/.gnupg"

set -l GPG_AGENT_CONF "$HOME/.gnupg/gpg-agent.conf"

# 如果文件不存在或不含 pinentry-mac，则添加配置
if not test -f "$GPG_AGENT_CONF"; or not grep -q "pinentry-mac" "$GPG_AGENT_CONF" 2>/dev/null
    backup_file "$GPG_AGENT_CONF"
    # 使用 printf 代替 heredoc
    printf '\n# pinentry-mac 配置 (解决 macOS GPG 签名失败问题)\npinentry-program /opt/homebrew/bin/pinentry-mac\n' >> "$GPG_AGENT_CONF"
    show_success "已配置 pinentry-mac"
else
    show_info "pinentry-mac 已配置"
end

# ============================================
# 4. 配置 GPG_TTY 环境变量
# ============================================
show_progress "配置 GPG_TTY 环境变量"

set -l FISH_CONFIG "$HOME/.config/fish/config.fish"

# 确保 fish 配置目录存在
ensure_directory "$HOME/.config/fish"

if not test -f "$FISH_CONFIG"; or not grep -q "GPG_TTY" "$FISH_CONFIG" 2>/dev/null
    backup_file "$FISH_CONFIG"
    # 使用 printf 代替 heredoc
    printf '\n# GPG TTY 配置 (解决签名时无法输入密码的问题)\nset -gx GPG_TTY (tty)\n' >> "$FISH_CONFIG"
    show_success "已添加 GPG_TTY 到 ~/.config/fish/config.fish"
else
    show_info "GPG_TTY 已配置"
end

# 立即导出当前 TTY（CI 环境中可能不存在 tty）
if test "$IS_CI" = "true"
    set -g GPG_TTY ""
else
    set -g GPG_TTY (tty 2>/dev/null; or echo "")
end
set -gx GPG_TTY $GPG_TTY

# ============================================
# 5. 生成/验证 GPG 密钥
# ============================================
show_progress "检查 GPG 密钥"

if test "$KEY_EXISTS" = "true"
    show_success "GPG 密钥已存在: $GPG_SIGNING_KEY"
else
    show_info "未检测到预设密钥，开始生成新密钥..."

    # 创建临时批处理文件用于 GPG 密钥生成
    # 使用 printf 代替 heredoc
    printf '%%echo 正在生成 GPG 密钥\nKey-Type: RSA\nKey-Length: 4096\nSubkey-Type: RSA\nSubkey-Length: 4096\nName-Real: %s\nName-Email: %s\nExpire-Date: 0\n%%no-protection\n%%commit\n%%echo 完成\n' "$GPG_NAME" "$GPG_EMAIL" > /tmp/gpg-batch

    # 使用批处理文件生成密钥
    if gpg --batch --generate-key /tmp/gpg-batch
        show_success "GPG 密钥生成成功"
    else
        if test "$IS_CI" = "true"
            show_warning "GPG 密钥生成失败（CI 环境，跳过此步骤）"
        else
            show_error "GPG 密钥生成失败"
        end
    end

    # 清理临时批处理文件
    rm -f /tmp/gpg-batch
end

# 获取密钥 ID（优先使用预设密钥）
set -l KEY_ID ""
if test -n "$GPG_SIGNING_KEY"
    set KEY_ID "$GPG_SIGNING_KEY"
else
    set KEY_ID (gpg --list-secret-keys --keyid-format=long 2>/dev/null | grep -E "^sec" | head -n 1 | sed -E 's/.*\//([A-F0-9]+) .*/\1/')
end

if test -z "$KEY_ID"
    if test "$IS_CI" = "true"
        show_warning "无法提取 GPG 密钥 ID（CI 环境，跳过 Git GPG 签名配置）"
        set KEY_ID ""
    else
        show_error "无法提取 GPG 密钥 ID"
        exit 1
    end
end

show_info "当前使用密钥 ID: $KEY_ID"

# 显示密钥信息
echo ""
show_info "GPG 密钥详情："
gpg --list-secret-keys --keyid-format=long 2>/dev/null; or true

# ============================================
# 6. 配置 Git GPG 设置
# ============================================
show_progress "配置 Git GPG 签名"

# 检查 rc/gitconfig 是否已配置
if test -f "$PROJECT_ROOT/rc/gitconfig"
    show_info "检测到 Git 配置文件，使用预设值"
else
    # 如果没有配置文件，手动设置
    if test -n "$KEY_ID"
        git config --global user.signingkey "$KEY_ID" 2>/dev/null; or true
    end
end

# 确保 Git GPG 签名开启
git config --global commit.gpgsign true 2>/dev/null; or true
git config --global tag.gpgSign true 2>/dev/null; or true

# 配置 GPG 程序路径
if command -sq gpg
    set -l GPG_PATH (command -v gpg 2>/dev/null; or echo "gpg")
    git config --global gpg.program "$GPG_PATH" 2>/dev/null; or true
end

# 验证 Git 配置
show_info "Git GPG 配置状态："
echo "  签名密钥: "(git config --global user.signingkey; or echo '未设置')
echo "  自动签名: "(git config --global commit.gpgsign; or echo '未设置')
echo "  GPG 程序: "(git config --global gpg.program; or echo '默认')

# ============================================
# 7. 重启 gpg-agent
# ============================================
show_progress "重启 gpg-agent"

if not gpgconf --kill gpg-agent 2>/dev/null
    if test "$IS_CI" = "true"
        show_warning "gpg-agent 重启失败，可能已在 CI 环境中运行"
    else
        show_warning "gpg-agent 重启失败"
    end
else
    show_success "gpg-agent 已重启"
end

# ============================================
# 8. 标记完成
# ============================================
mark_app_configured "gpg"

# ============================================
# 输出总结
# ============================================
echo ""
show_group "GPG 配置完成"
show_success "GPG 签名配置已成功完成！"

echo ""
echo "===== 使用说明 ====="
echo "1. 测试 GPG 签名："
echo "   echo 'test' | gpg --clearsign"
echo ""
echo "2. 验证 Git 提交签名："
echo "   git log --show-signature -1"
echo ""
echo "3. 如果遇到问题，请检查："
echo "   - GPG_TTY 环境变量: echo \$GPG_TTY"
echo "   - pinentry 配置: cat ~/.gnupg/gpg-agent.conf"
echo ""
