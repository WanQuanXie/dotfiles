#!/usr/bin/env fish
# bootstrap.fish - 主引导脚本 (Fish Shell 版本)
# 面向 macOS 15+ (Apple Silicon)

# 加载核心库
include lib/init

# 检查是否需要强制重新执行
if test "$argv[1]" = "--force"
    rm -f "$HOME/.dotfiles_bootstrapped"
end

# 幂等性检查：如果已配置完成且非强制模式，则跳过
set -l BOOTSTRAP_MARKER "$HOME/.dotfiles_bootstrapped"
if test -f "$BOOTSTRAP_MARKER"
    echo "Dotfiles 已配置完成。使用 --force 强制重新执行。"
    exit 0
end

# 初始化环境
init_dotfiles_env

# 进度计数器
set -g TOTAL_STEPS 8
set -g CURRENT_STEP 0

# 显示进度函数
function show_bootstrap_progress
    set -g CURRENT_STEP (math $CURRENT_STEP + 1)
    show_progress "$argv[1]" "$CURRENT_STEP" "$TOTAL_STEPS"
end

# 设置基础环境变量
show_bootstrap_progress "正在设置基础环境变量"
setup_base_environment
show_success "基础环境变量设置完成"

show_bootstrap_progress "正在安装 Homebrew"
if not command -v brew
    echo "正在安装 Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 2>/dev/null
    or show_warning "Homebrew 安装可能失败，请检查日志"
    show_success "Homebrew 安装完成"
else
    show_success "Homebrew 已安装"
end

show_bootstrap_progress "正在设置主机名"
set -l HOSTNAME ""
if test -n "$DOTFILES_HOSTNAME"
    set HOSTNAME "$DOTFILES_HOSTNAME"
else
    set -l COMPUTER_NAME (scutil --get ComputerName 2>/dev/null)
    if test -n "$COMPUTER_NAME"
        set HOSTNAME "$COMPUTER_NAME"
    end
end
if test -z "$HOSTNAME"
    set HOSTNAME "$USER-macbookpro"
end

# 仅在主机名需要变更时才执行（幂等性优化）
set -l CURRENT_HOSTNAME (scutil --get HostName 2>/dev/null)
if test "$CURRENT_HOSTNAME" != "$HOSTNAME"
    sudo scutil --set HostName "$HOSTNAME"
    or show_error "设置主机名失败"
    show_success "主机名设置完成: $HOSTNAME"
else
    show_success "主机名已正确设置: $HOSTNAME"
end

show_bootstrap_progress "正在使用 Brew Bundle 安装软件包"
set -l brew_exit_code 0
brew bundle
or set brew_exit_code 1
if test $brew_exit_code -ne 0
    show_warning "部分软件包安装可能失败，请检查日志"
else
    show_success "软件包安装完成"
end

show_bootstrap_progress "正在创建工作目录"
mkdir -p ~/workspace/dev
mkdir -p ~/workspace/work
show_success "工作目录创建完成"

# 创建必要的配置目录
show_bootstrap_progress "正在准备配置目录"
mkdir -p ~/.config/nvim
mkdir -p ~/.config/fish
mkdir -p ~/.tmux/plugins
show_success "配置目录准备完成"

show_bootstrap_progress "正在安装 dotfiles"
if not command -v rcup &>/dev/null
    show_error "rcm 未安装，请先运行: brew install rcm"
end
rcup -d ./rc -f
or show_warning "dotfiles 安装可能失败，请检查日志"

# 验证关键配置文件
echo "验证配置文件..."
set -l config_files \
    "$HOME/.config/fish/config.fish" \
    "$HOME/.gitconfig" \
    "$HOME/.tmux.conf" \
    "$HOME/.config/nvim/init.lua" \
    "$HOME/.gemrc"

for config in $config_files
    if test -s "$config"
        echo "  - $config 已链接"
    else
        show_warning "  - $config 未正确链接"
    end
end

show_success "dotfiles 安装完成"

show_bootstrap_progress "正在配置应用程序"
bash ./app/bootstrap
or show_warning "应用程序配置可能失败，请检查日志"
show_success "应用程序配置完成"

echo "$GREEN""正在进行最终测试""$NC"
fish ./test.fish
or show_warning "测试可能失败，请检查日志"
show_success "所有配置已完成！系统设置已就绪。"

# 创建完成标记文件（幂等性）
touch "$BOOTSTRAP_MARKER"
