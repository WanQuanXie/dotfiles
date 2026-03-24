#!/usr/bin/env fish


# 获取项目根目录
set -l SCRIPT_DIR (cd (dirname (status -f)); and pwd)
set -l PROJECT_ROOT (dirname (dirname "$SCRIPT_DIR"))

# 加载共享库 (使用绝对路径)
source "$PROJECT_ROOT/lib/init.fish"

# Neovim 初始化脚本 - 使用共享库重构
# 兼容 POSIX shell (bash 4+/fish 4+) 和 macOS (Intel/Apple Silicon)

show_info "正在设置 Neovim"

# 检查 Lazy.nvim 是否已安装
set -l LAZY_PATH "$HOME/.local/share/nvim/lazy/lazy.nvim"
if test -d "$LAZY_PATH"
    show_warning "Lazy.nvim 已安装，跳过插件安装"
else
    show_info "安装 Neovim 插件..."
    # 运行 nvim 触发插件安装
    run_with_log "nvim --headless '+Lazy! sync' +qa" "安装 Neovim 插件"
end

show_info "安装格式化工具..."
# 安装格式化工具（语言服务器由 mason-lspconfig 确保）
run_with_log "nvim --headless '+MasonInstall prettier stylua shfmt' +qa" "安装格式化工具"

show_success "Neovim 设置完成"
