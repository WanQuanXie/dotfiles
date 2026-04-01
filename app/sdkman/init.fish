#!/usr/bin/env fish
# app/sdkman/init.fish - SDKMAN 安装脚本

# 获取项目根目录
set -l SCRIPT_DIR (cd (dirname (status -f)); and pwd)
set -l PROJECT_ROOT (dirname (dirname "$SCRIPT_DIR"))

# 加载共享库 (使用绝对路径)
source "$PROJECT_ROOT/lib/init.fish"

show_info "正在设置 SDKMAN"

# 检查前置条件
set -l BREW_PREFIX (get_brew_prefix)
set -l BREW_BASH_PATH "$BREW_PREFIX/bin/bash"

# 检查系统 Bash 版本（macOS 预装 Bash 3.2，SDKMAN 需要 Bash 4+）
set -l SYSTEM_BASH_VERSION (bash --version 2>/dev/null | string split '.' | head -1 | string match -r '\d+')
if test "$SYSTEM_BASH_VERSION" -lt 4
    show_warning "系统 Bash 版本低于 4，将使用 Homebrew Bash 替代"

    # 安装 Homebrew Bash（如尚未安装）
    if not test -f "$BREW_BASH_PATH"
        show_info "安装 Homebrew Bash..."
        if not brew install bash
            show_error "Homebrew Bash 安装失败" 1
        end
    end

    # 添加到 allowed shells
    set -l BREW_BASH_VERSION ($BREW_BASH_PATH --version 2>/dev/null | string split '.' | head -1 | string match -r '\d+')
    if test "$BREW_BASH_VERSION" -ge 4
        if not grep -q "$BREW_BASH_PATH" /etc/shells
            show_info "将 Homebrew Bash 添加到 allowed shells..."
            echo "$BREW_BASH_PATH" | sudo tee -a /etc/shells >/dev/null 2>&1
            if test (grep -c "$BREW_BASH_PATH" /etc/shells) -gt 0
                show_success "Homebrew Bash 已添加到 allowed shells"
            else
                show_warning "添加失败，请手动执行: echo $BREW_BASH_PATH | sudo tee -a /etc/shells"
            end
        else
            show_info "Homebrew Bash 已在 allowed shells 中"
        end

        # 注意：不切换默认 shell，默认 shell 始终为 fish
        # Homebrew Bash 仅供 sdkman-for-fish 插件调用 sdkman-init.sh 使用
        show_info "Homebrew Bash 仅用于 SDKMAN，不更改默认 shell"
    end
end

# 检查 SDKMAN_DIR
set -l SDKMAN_DIR "$HOME/.sdkman"
set -g SDKMAN_DIR "$SDKMAN_DIR"

# 检查 SDKMAN 是否已安装
if test -f "$SDKMAN_DIR/bin/sdkman-init.sh"
    show_warning "SDKMAN 已安装，跳过安装"
else
    show_info "安装 SDKMAN..."
    # 安装 SDKMAN（不自动修改 shell 配置）
    if curl -s "https://get.sdkman.io?rcupdate=false" | bash
        show_success "SDKMAN 安装完成"
    else
        show_error "SDKMAN 安装失败" 1
    end
end

# 标记 SDKMAN 已安装（即使上面检查跳过，也标记）
mark_app_configured "sdkman"

# 通过 fisher 安装 sdkman-for-fish 插件
# 检查 fisher 是否可用
if not fish -c 'type -q fisher' 2>/dev/null
    show_warning "Fisher 未安装，无法安装 sdkman-for-fish 插件"
else
    # 检查插件是否已安装
    if fish -c 'fisher list 2>/dev/null | grep -q reitzig/sdkman-for-fish'
        show_warning "sdkman-for-fish 插件已安装，跳过"
    else
        show_info "安装 sdkman-for-fish 插件..."
        if fish -c 'fisher install reitzig/sdkman-for-fish@v2.1.0'
            show_success "sdkman-for-fish 插件安装完成"
        else
            show_error "sdkman-for-fish 插件安装失败" 1
        end
    end
end

show_success "SDKMAN 设置完成"
