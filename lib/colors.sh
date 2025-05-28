#!/usr/bin/env bash

# 颜色定义库 - 统一的颜色常量定义
# 兼容 POSIX shell (bash 4+/zsh 5+) 和 macOS (Intel/Apple Silicon)

# 防止重复加载
if [[ -n "${DOTFILES_COLORS_LOADED:-}" ]]; then
    return 0
fi

# 基础颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
NC='\033[0m' # No Color

# 粗体颜色
BOLD_GREEN='\033[1;32m'
BOLD_RED='\033[1;31m'
BOLD_YELLOW='\033[1;33m'
BOLD_BLUE='\033[1;34m'
BOLD_PURPLE='\033[1;35m'
BOLD_CYAN='\033[1;36m'
BOLD_WHITE='\033[1;37m'

# 背景颜色
BG_RED='\033[41m'
BG_GREEN='\033[42m'
BG_YELLOW='\033[43m'
BG_BLUE='\033[44m'

# 检查终端是否支持颜色
is_color_supported() {
    # 检查 TERM 环境变量和 tty
    if [[ -t 1 ]] && [[ "${TERM:-}" != "dumb" ]] && [[ "${TERM:-}" != "" ]]; then
        return 0
    else
        return 1
    fi
}

# 安全的颜色输出函数 - 只在支持颜色的终端中使用颜色
safe_color() {
    local color="$1"
    local text="$2"

    if is_color_supported; then
        echo -e "${color}${text}${NC}"
    else
        echo "$text"
    fi
}

# 导出颜色变量供其他脚本使用
export GREEN RED YELLOW BLUE PURPLE CYAN WHITE NC
export BOLD_GREEN BOLD_RED BOLD_YELLOW BOLD_BLUE BOLD_PURPLE BOLD_CYAN BOLD_WHITE
export BG_RED BG_GREEN BG_YELLOW BG_BLUE

# 导出所有函数供其他脚本使用
export -f is_color_supported safe_color safe_color

# 标记库已加载
export DOTFILES_COLORS_LOADED=1
