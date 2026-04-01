#!/usr/bin/env fish
# app/sdkman/init.fish - SDKMAN 安装脚本

# 获取项目根目录
set -l SCRIPT_DIR (cd (dirname (status -f)); and pwd)
set -l PROJECT_ROOT (dirname (dirname "$SCRIPT_DIR"))

# 加载共享库 (使用绝对路径)
source "$PROJECT_ROOT/lib/init.fish"

show_info "正在设置 SDKMAN"

# 检查前置条件
set -l BASH_PATH (get_brew_prefix)/bin/bash

# 检查 Bash 版本（SDKMAN 需要 Bash 4+）
if test -f "$BASH_PATH"
    set -l BASH_VERSION (bash -c "echo \$BASH_VERSION" 2>/dev/null | string split '.' | head -1)
    if test "$BASH_VERSION" -lt 4
        show_warning "Homebrew Bash 版本低于 4，SDKMAN 可能无法正常工作"
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
