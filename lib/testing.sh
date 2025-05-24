#!/usr/bin/env bash

# 测试工具库 - 统一的测试函数和模式
# 兼容 POSIX shell (bash 4+/zsh 5+) 和 macOS (Intel/Apple Silicon)

# 加载依赖库
# shellcheck source=./display.sh
source "$(dirname "${BASH_SOURCE[0]}")/display.sh"

# 测试配置（控制台输出）
TEST_LOG_FILE=""  # 保留变量以兼容现有代码

# 初始化测试环境
init_test_env() {
    local test_name="${1:-$(basename "$(dirname "$0")")}"

    # 不再创建日志文件，使用控制台输出
    TEST_LOG_FILE="/dev/null"  # 兼容性设置

    # 设置错误处理
    set -e

    write_log "测试环境初始化完成: $test_name" "TEST_INIT"
}

# 测试命令并提供反馈（控制台输出）
test_command() {
    local cmd="$1"
    local msg="$2"
    local err_msg="${3:-$msg 失败}"
    local show_output="${4:-false}"  # 是否显示命令输出

    show_test "$msg"

    local result=0
    if [[ "$show_output" == "true" ]]; then
        # 显示命令输出
        if eval "$cmd"; then
            result=0
        else
            result=$?
        fi
    else
        # 隐藏命令输出
        if eval "$cmd" >/dev/null 2>&1; then
            result=0
        else
            result=$?
        fi
    fi

    if [[ $result -eq 0 ]]; then
        show_success "$msg 通过"
        return 0
    else
        show_error "$err_msg (错误代码: $result)" 0
        exit 1
    fi
}

# 检查命令是否存在
check_command() {
    local cmd="$1"
    local package="${2:-$cmd}"
    local msg="${3:-检查 $cmd 是否安装}"

    test_command "command -v '$cmd'" "$msg"
}

# 检查可执行文件
check_executable() {
    local cmd="$1"
    local msg="${2:-检查 $cmd 可执行文件}"

    test_command "command -v '$cmd'" "$msg"
}

# 检查目录是否存在
check_directory() {
    local dir="$1"
    local msg="${2:-检查目录 $dir}"

    test_command "test -d '$dir'" "$msg"
}

# 检查文件是否存在
check_file() {
    local file="$1"
    local msg="${2:-检查文件 $file}"

    test_command "test -f '$file'" "$msg"
}

# 检查版本信息
check_version() {
    local cmd="$1"
    local version_flag="${2:---version}"
    local msg="${3:-检查 $cmd 版本}"

    show_test "$msg"
    if command -v "$cmd" >/dev/null 2>&1; then
        local version_output
        version_output=$($cmd $version_flag 2>&1 || echo "版本信息获取失败")
        show_info "$cmd 版本: $version_output"
        show_success "$msg 完成"
    else
        show_error "$cmd 未安装" 0
        exit 1
    fi
}

# 检查文件是否可读
check_readable() {
    local file="$1"
    local msg="${2:-检查文件 $file 是否可读}"

    test_command "test -r '$file'" "$msg"
}

# 检查文件是否可写
check_writable() {
    local file="$1"
    local msg="${2:-检查文件 $file 是否可写}"

    test_command "test -w '$file'" "$msg"
}

# 检查文件内容包含指定字符串
check_file_contains() {
    local file="$1"
    local pattern="$2"
    local msg="${3:-检查文件 $file 包含 $pattern}"

    test_command "grep -q '$pattern' '$file'" "$msg"
}

# 检查环境变量
check_env_var() {
    local var_name="$1"
    local expected_value="${2:-}"
    local msg="${3:-检查环境变量 $var_name}"

    if [[ -n "$expected_value" ]]; then
        test_command "test \"\${$var_name}\" = '$expected_value'" "$msg"
    else
        test_command "test -n \"\${$var_name}\"" "$msg"
    fi
}

# 创建临时测试环境
create_temp_test_env() {
    local temp_dir
    temp_dir=$(mktemp -d)
    echo "$temp_dir"
}

# 清理临时测试环境
cleanup_temp_test_env() {
    local temp_dir="$1"
    if [[ -n "$temp_dir" && -d "$temp_dir" ]]; then
        rm -rf "$temp_dir"
    fi
}

# 测试完成总结
test_summary() {
    local test_name="${1:-测试}"
    show_success "$test_name 完成"
    write_log "测试完成: $test_name" "TEST_COMPLETE"
}

# 导出测试相关变量
export TEST_LOG_DIR TEST_LOG_FILE
