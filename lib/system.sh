#!/usr/bin/env bash

# 系统环境库
# 面向 macOS 15+ (Apple Silicon)

# 加载依赖库
# shellcheck source=./display.sh
source "$(dirname "${BASH_SOURCE[0]}")/display.sh"

# 获取 Homebrew 前缀路径
get_brew_prefix() {
    echo "/opt/homebrew"
}

# 设置基础环境变量
setup_base_environment() {
    # 导出 Homebrew 相关环境变量
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
    export HOMEBREW_PREFIX="/opt/homebrew"

    write_log "基础环境变量设置完成: HOMEBREW_PREFIX=/opt/homebrew" "ENV_SETUP"
}

# 导出函数
export -f get_brew_prefix
export -f setup_base_environment
