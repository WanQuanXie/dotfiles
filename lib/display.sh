#!/usr/bin/env bash

# 显示函数库 - 统一的消息显示和日志记录
# 兼容 POSIX shell (bash 4+/zsh 5+) 和 macOS (Intel/Apple Silicon)

# 加载颜色定义
# shellcheck source=./colors.sh
source "$(dirname "${BASH_SOURCE[0]}")/colors.sh"

# 全局日志配置 - 统一控制台输出格式
LOG_ENABLED="${LOG_ENABLED:-true}"
LOG_SHOW_TIMESTAMP="${LOG_SHOW_TIMESTAMP:-true}"
LOG_SHOW_LEVEL="${LOG_SHOW_LEVEL:-true}"
LOG_SHOW_CALLER="${LOG_SHOW_CALLER:-false}"

# 获取调用者信息用于日志
get_caller_info() {
    local script_name
    script_name="$(basename "${BASH_SOURCE[2]}" 2>/dev/null || echo "unknown")"
    echo "$script_name"
}

# 格式化日志前缀
format_log_prefix() {
    local level="$1"
    local prefix=""

    if [[ "$LOG_SHOW_TIMESTAMP" == "true" ]]; then
        local timestamp
        timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
        prefix="[$timestamp]"
    fi

    if [[ "$LOG_SHOW_LEVEL" == "true" ]]; then
        prefix="$prefix [$level]"
    fi

    if [[ "$LOG_SHOW_CALLER" == "true" ]]; then
        local caller
        caller="$(get_caller_info)"
        prefix="$prefix [$caller]"
    fi

    echo "$prefix"
}

# 写入日志（现在输出到控制台而不是文件）
write_log() {
    local message="$1"
    local level="${2:-INFO}"

    if [[ "$LOG_ENABLED" == "true" ]]; then
        local prefix
        prefix="$(format_log_prefix "$level")"
        if [[ -n "$prefix" ]]; then
            echo "$prefix $message" >&2
        else
            echo "$message" >&2
        fi
    fi
}

# 显示成功消息
show_success() {
    local message="$1"
    local log_message="${2:-$message}"

    if is_color_supported; then
        echo -e "${GREEN}✓ $message${NC}"
    else
        echo "✓ $message"
    fi

    write_log "$log_message" "SUCCESS"
}

# 显示错误消息
show_error() {
    local message="$1"
    local exit_code="${2:-1}"
    local log_message="${3:-$message}"

    if is_color_supported; then
        echo -e "${RED}✗ $message${NC}" >&2
    else
        echo "✗ $message" >&2
    fi

    write_log "$log_message" "ERROR"

    # 如果提供了退出代码，则退出
    if [[ "$exit_code" != "0" ]]; then
        exit "$exit_code"
    fi
}

# 显示警告消息
show_warning() {
    local message="$1"
    local log_message="${2:-$message}"

    if is_color_supported; then
        echo -e "${YELLOW}! $message${NC}"
    else
        echo "! $message"
    fi

    write_log "$log_message" "WARNING"
}

# 显示信息消息
show_info() {
    local message="$1"
    local log_message="${2:-$message}"

    if is_color_supported; then
        echo -e "${BLUE}$message${NC}"
    else
        echo "$message"
    fi

    write_log "$log_message" "INFO"
}

# 显示测试项目
show_test() {
    local message="$1"
    local log_message="${2:-测试: $message}"

    if is_color_supported; then
        echo -e "${BLUE}测试: $message${NC}"
    else
        echo "测试: $message"
    fi

    write_log "$log_message" "TEST"
}

# 显示检查项目
show_check() {
    local message="$1"
    local log_message="${2:-检查: $message}"

    if is_color_supported; then
        echo -e "${BLUE}检查: $message${NC}"
    else
        echo "检查: $message"
    fi

    write_log "$log_message" "CHECK"
}

# 显示进度信息
show_progress() {
    local message="$1"
    local current="${2:-}"
    local total="${3:-}"
    local log_message="${4:-$message}"

    local progress_text="$message"
    if [[ -n "$current" && -n "$total" ]]; then
        progress_text="[$current/$total] $message"
    fi

    if is_color_supported; then
        echo -e "${BLUE}$progress_text${NC}"
    else
        echo "$progress_text"
    fi

    write_log "$log_message" "PROGRESS"
}

# 显示分组标题
show_group() {
    local title="$1"
    local log_message="${2:-分组: $title}"

    if is_color_supported; then
        echo -e "\n${BOLD_BLUE}=== $title ===${NC}"
    else
        echo -e "\n=== $title ==="
    fi

    write_log "$log_message" "GROUP"
}

# 导出所有函数供其他脚本使用
export -f get_caller_info format_log_prefix write_log show_success show_error show_warning show_info show_test show_check show_progress show_group
