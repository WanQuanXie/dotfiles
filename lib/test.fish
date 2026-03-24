#!/usr/bin/env fish
# lib/test.fish - 测试工具库 (Fish Shell 版本)
# 面向 macOS 15+ (Apple Silicon)

# 加载核心库
include lib/init

# ============================================================================
# 测试函数
# ============================================================================

# 初始化测试环境
function init_test_env
    set -l test_name "$argv[1]"
    if test -z "$test_name"
        set -l dir (pwd)
        set test_name (basename "$dir")
    end

    write_log "测试环境初始化完成: $test_name" "TEST_INIT"
end

# 测试命令并提供反馈
function test_command
    if test (count $argv) -lt 2
        echo "test_command 需要至少 2 个参数" >&2
        return 1
    end

    set -l cmd "$argv[1]"
    set -l msg "$argv[2]"
    set -l err_msg "$argv[3]"
    if test -z "$err_msg"
        set err_msg "$msg 失败"
    end
    set -l show_output "$argv[4]"
    if test -z "$show_output"
        set show_output "false"
    end

    show_test "$msg"

    set -l result 0
    if test "$show_output" = "true"
        # 显示命令输出
        eval $cmd
        set result $status
    else
        # 隐藏命令输出
        eval $cmd >/dev/null 2>&1
        set result $status
    end

    if test $result -eq 0
        show_success "$msg 通过"
        return 0
    else
        show_error "$err_msg (错误代码: $result)" 0
        exit 1
    end
end

# 检查命令是否存在
function check_command
    if test (count $argv) -lt 1
        echo "check_command 需要至少 1 个参数" >&2
        return 1
    end

    set -l cmd "$argv[1]"
    set -l package "$argv[2]"
    if test -z "$package"
        set package "$cmd"
    end
    set -l msg "$argv[3]"
    if test -z "$msg"
        set msg "检查 $cmd 是否安装"
    end

    test_command "command -v '$cmd'" "$msg"
end

# 检查可执行文件
function check_executable
    if test (count $argv) -lt 1
        echo "check_executable 需要至少 1 个参数" >&2
        return 1
    end

    set -l cmd "$argv[1]"
    set -l msg "$argv[2]"
    if test -z "$msg"
        set msg "检查 $cmd 可执行文件"
    end

    test_command "command -v '$cmd'" "$msg"
end

# 检查目录是否存在
function check_directory
    if test (count $argv) -lt 1
        echo "check_directory 需要至少 1 个参数" >&2
        return 1
    end

    set -l dir "$argv[1]"
    set -l msg "$argv[2]"
    if test -z "$msg"
        set msg "检查目录 $dir"
    end

    test_command "test -d '$dir'" "$msg"
end

# 检查文件是否存在
function check_file
    if test (count $argv) -lt 1
        echo "check_file 需要至少 1 个参数" >&2
        return 1
    end

    set -l file "$argv[1]"
    set -l msg "$argv[2]"
    if test -z "$msg"
        set msg "检查文件 $file"
    end

    test_command "test -f '$file'" "$msg"
end

# 检查版本信息
function check_version
    if test (count $argv) -lt 1
        echo "check_version 需要至少 1 个参数" >&2
        return 1
    end

    set -l cmd "$argv[1]"
    set -l version_flag "$argv[2]"
    if test -z "$version_flag"
        set version_flag "--version"
    end
    set -l msg "$argv[3]"
    if test -z "$msg"
        set msg "检查 $cmd 版本"
    end

    show_test "$msg"
    if command -v "$cmd" >/dev/null 2>&1
        set -l version_output ($cmd $version_flag 2>&1; or echo "版本信息获取失败")
        show_info "$cmd 版本: $version_output"
        show_success "$msg 完成"
    else
        show_error "$cmd 未安装" 0
        exit 1
    end
end

# 检查文件是否可读
function check_readable
    if test (count $argv) -lt 1
        echo "check_readable 需要至少 1 个参数" >&2
        return 1
    end

    set -l file "$argv[1]"
    set -l msg "$argv[2]"
    if test -z "$msg"
        set msg "检查文件 $file 是否可读"
    end

    test_command "test -r '$file'" "$msg"
end

# 检查文件是否可写
function check_writable
    if test (count $argv) -lt 1
        echo "check_writable 需要至少 1 个参数" >&2
        return 1
    end

    set -l file "$argv[1]"
    set -l msg "$argv[2]"
    if test -z "$msg"
        set msg "检查文件 $file 是否可写"
    end

    test_command "test -w '$file'" "$msg"
end

# 检查文件内容包含指定字符串
function check_file_contains
    if test (count $argv) -lt 2
        echo "check_file_contains 需要至少 2 个参数" >&2
        return 1
    end

    set -l file "$argv[1]"
    set -l pattern "$argv[2]"
    set -l msg "$argv[3]"
    if test -z "$msg"
        set msg "检查文件 $file 包含 $pattern"
    end

    test_command "grep -q '$pattern' '$file'" "$msg"
end

# 创建临时测试环境
function create_temp_test_env
    set -l temp_dir (mktemp -d)
    echo "$temp_dir"
end

# 清理临时测试环境
function cleanup_temp_test_env
    if test (count $argv) -lt 1
        return 1
    end

    set -l temp_dir "$argv[1]"
    if test -n "$temp_dir"; and test -d "$temp_dir"
        rm -rf "$temp_dir"
    end
end

# 测试完成总结
function test_summary
    set -l test_name "$argv[1]"
    if test -z "$test_name"
        set test_name "测试"
    end

    show_success "$test_name 完成"
    write_log "测试完成: $test_name" "TEST_COMPLETE"
end
