#!/usr/bin/env fish
# lib/init.fish - dotfiles 核心初始化库 (Fish Shell 版本)
# 面向 macOS 15+ (Apple Silicon)

# 防止重复加载
if set -q DOTFILES_INIT_LOADED
    return 0
end

# ============================================================================
# 颜色定义
# ============================================================================

# 基础颜色定义
set -g GREEN '\033[0;32m'
set -g RED '\033[0;31m'
set -g YELLOW '\033[0;33m'
set -g BLUE '\033[0;34m'
set -g PURPLE '\033[0;35m'
set -g CYAN '\033[0;36m'
set -g WHITE '\033[0;37m'
set -g NC '\033[0m' # No Color

# 粗体颜色
set -g BOLD_GREEN '\033[1;32m'
set -g BOLD_RED '\033[1;31m'
set -g BOLD_YELLOW '\033[1;33m'
set -g BOLD_BLUE '\033[1;34m'
set -g BOLD_PURPLE '\033[1;35m'
set -g BOLD_CYAN '\033[1;36m'
set -g BOLD_WHITE '\033[1;37m'

# 背景颜色
set -g BG_RED '\033[41m'
set -g BG_GREEN '\033[42m'
set -g BG_YELLOW '\033[43m'
set -g BG_BLUE '\033[44m'

# ============================================================================
# 颜色函数
# ============================================================================

# 检查终端是否支持颜色
function is_color_supported
    if isatty stdout
        and test -n "$TERM"
        and test "$TERM" != "dumb"
        return 0
    end
    return 1
end

# 安全的颜色输出函数
function safe_color
    if test (count $argv) -lt 2
        return 1
    end
    set -l color "$argv[1]"
    set -l text "$argv[2]"

    if is_color_supported
        echo -e "$color$text$NC"
    else
        echo "$text"
    end
end

# ============================================================================
# 日志配置
# ============================================================================

# 全局日志配置
set -g LOG_ENABLED true
set -g LOG_SHOW_TIMESTAMP true
set -g LOG_SHOW_LEVEL true
set -g LOG_SHOW_CALLER false

# ============================================================================
# 日志函数
# ============================================================================

# 格式化日志前缀
function format_log_prefix
    if test (count $argv) -lt 1
        echo ""
        return
    end
    set -l level "$argv[1]"
    set -l prefix ""

    if test "$LOG_SHOW_TIMESTAMP" = "true"
        set -l timestamp (date '+%Y-%m-%d %H:%M:%S')
        set prefix "[$timestamp]"
    end

    if test "$LOG_SHOW_LEVEL" = "true"
        set prefix "$prefix [$level]"
    end

    echo "$prefix"
end

# 写入日志
function write_log
    if test (count $argv) -lt 1
        return 1
    end
    set -l message "$argv[1]"
    set -l level "$argv[2]"
    if test -z "$level"
        set level "INFO"
    end

    if test "$LOG_ENABLED" = "true"
        set -l prefix (format_log_prefix "$level")
        if test -n "$prefix"
            echo "$prefix $message" >&2
        else
            echo "$message" >&2
        end
    end
end

# ============================================================================
# 显示函数
# ============================================================================

# 显示成功消息
function show_success
    if test (count $argv) -lt 1
        return 1
    end
    set -l message "$argv[1]"
    set -l log_message "$argv[2]"
    if test -z "$log_message"
        set log_message "$message"
    end

    if is_color_supported
        echo -e "$GREEN""✓""$NC"" ""$message"
    else
        echo "✓ $message"
    end

    write_log "$log_message" "SUCCESS"
end

# 显示错误消息
function show_error
    if test (count $argv) -lt 1
        return 1
    end
    set -l message "$argv[1]"
    set -l exit_code "$argv[2]"
    if test -z "$exit_code"
        set exit_code 1
    end
    set -l log_message "$argv[3]"
    if test -z "$log_message"
        set log_message "$message"
    end

    if is_color_supported
        echo -e "$RED""✗""$NC"" ""$message" >&2
    else
        echo "✗ $message" >&2
    end

    write_log "$log_message" "ERROR"

    # CI 环境下：所有错误都应该导致非零退出码
    # 非 CI 环境下：仅当 exit_code 非0时退出
    if test "$CI" = "true"
        # CI 下直接退出
        exit $exit_code
    else if test "$exit_code" != "0"
        # 非 CI 下，仅当 exit_code 非0时退出
        exit $exit_code
    end
    # 否则仅报告，不退出
    return 0
end

# 显示警告消息
function show_warning
    if test (count $argv) -lt 1
        return 1
    end
    set -l message "$argv[1]"
    set -l log_message "$argv[2]"
    if test -z "$log_message"
        set log_message "$message"
    end

    if is_color_supported
        echo -e "$YELLOW""!""$NC"" ""$message"
    else
        echo "! $message"
    end

    write_log "$log_message" "WARNING"
end

# 显示信息消息
function show_info
    if test (count $argv) -lt 1
        return 1
    end
    set -l message "$argv[1]"
    set -l log_message "$argv[2]"
    if test -z "$log_message"
        set log_message "$message"
    end

    if is_color_supported
        echo -e "$BLUE""$message""$NC"
    else
        echo "$message"
    end

    write_log "$log_message" "INFO"
end

# 显示测试项目
function show_test
    if test (count $argv) -lt 1
        return 1
    end
    set -l message "$argv[1]"
    set -l log_message "$argv[2]"
    if test -z "$log_message"
        set log_message "测试: $message"
    end

    if is_color_supported
        echo -e "$BLUE""测试: ""$message""$NC"
    else
        echo "测试: $message"
    end

    write_log "$log_message" "TEST"
end

# 显示检查项目
function show_check
    if test (count $argv) -lt 1
        return 1
    end
    set -l message "$argv[1]"
    set -l log_message "$argv[2]"
    if test -z "$log_message"
        set log_message "检查: $message"
    end

    if is_color_supported
        echo -e "$BLUE""检查: ""$message""$NC"
    else
        echo "检查: $message"
    end

    write_log "$log_message" "CHECK"
end

# 显示进度信息
function show_progress
    if test (count $argv) -lt 1
        return 1
    end
    set -l message "$argv[1]"
    set -l current "$argv[2]"
    set -l total "$argv[3]"
    set -l log_message "$argv[4]"
    if test -z "$log_message"
        set log_message "$message"
    end

    set -l progress_text "$message"
    if test -n "$current"; and test -n "$total"
        set progress_text "[$current/$total] $message"
    end

    if is_color_supported
        echo -e "$BLUE""$progress_text""$NC"
    else
        echo "$progress_text"
    end

    write_log "$log_message" "PROGRESS"
end

# 显示分组标题
function show_group
    if test (count $argv) -lt 1
        return 1
    end
    set -l title "$argv[1]"
    set -l log_message "$argv[2]"
    if test -z "$log_message"
        set log_message "分组: $title"
    end

    if is_color_supported
        echo -e "\n""$BOLD_BLUE""=== ""$title"" ===""$NC"
    else
        echo -e "\n=== $title ==="
    end

    write_log "$log_message" "GROUP"
end

# ============================================================================
# 系统函数
# ============================================================================

# 获取 Homebrew 前缀路径
function get_brew_prefix
    if test -d /opt/homebrew
        echo "/opt/homebrew"
    else if test -d /usr/local/homebrew
        echo "/usr/local/homebrew"
    else
        brew --prefix 2>/dev/null
    end
end

# 设置基础环境变量
function setup_base_environment
    # 获取 Homebrew 前缀
    set -l brew_prefix (get_brew_prefix)

    # 设置 PATH
    set -gx PATH "$brew_prefix/bin" "$brew_prefix/sbin" $PATH
    set -gx HOMEBREW_PREFIX "$brew_prefix"

    write_log "基础环境变量设置完成: HOMEBREW_PREFIX=$brew_prefix" "ENV_SETUP"
end

# ============================================================================
# 通用工具函数
# ============================================================================

# 确保目录存在
function ensure_directory
    if test (count $argv) -lt 1
        return 1
    end
    set -l dir "$argv[1]"
    set -l msg "$argv[2]"
    if test -z "$msg"
        set msg "创建目录 $dir"
    end

    if not test -d "$dir"
        show_info "$msg"
        if command mkdir -p "$dir"
            show_success "目录创建成功: $dir"
        else
            show_error "目录创建失败: $dir" 0
            return 1
        end
    end
    return 0
end

# 备份文件
function backup_file
    if test (count $argv) -lt 1
        return 1
    end
    set -l file "$argv[1]"
    set -l backup_dir "$argv[2]"
    if test -z "$backup_dir"
        set backup_dir "$HOME/.dotfiles_backup"
    end

    if test -f "$file"
        ensure_directory "$backup_dir"
        set -l backup_name (basename "$file")
        set -l backup_file "$backup_dir/$backup_name."(date '+%Y%m%d_%H%M%S')
        if command cp "$file" "$backup_file"
            show_info "已备份 $file 到 $backup_file"
            return 0
        else
            show_error "备份失败: $file" 0
            return 1
        end
    end
    return 0
end

# 安全创建符号链接
function safe_symlink
    if test (count $argv) -lt 2
        return 1
    end
    set -l source "$argv[1]"
    set -l target "$argv[2]"
    set -l backup "$argv[3]"
    if test -z "$backup"
        set backup "true"
    end

    # 检查源文件是否存在
    if not test -e "$source"
        show_error "源文件不存在: $source" 0
        return 1
    end

    # 如果目标已存在，先备份
    if test -e "$target" -o -L "$target"
        if test "$backup" = "true"
            backup_file "$target"
        end
        command rm -f "$target"
    end

    # 确保目标目录存在
    set -l target_dir (dirname "$target")
    ensure_directory "$target_dir"

    # 创建符号链接
    if command ln -s "$source" "$target"
        show_success "符号链接创建成功: $target -> $source"
        return 0
    else
        show_error "符号链接创建失败: $target -> $source" 0
        return 1
    end
end

# 检查应用是否已配置
function is_app_configured
    if test (count $argv) -lt 1
        return 1
    end
    set -l app "$argv[1]"
    set -l marker_file "$HOME/.dotfiles_configured_""$app"

    if test -f "$marker_file"
        return 0  # 已配置
    else
        return 1  # 未配置
    end
end

# 标记应用已配置
function mark_app_configured
    if test (count $argv) -lt 1
        return 1
    end
    set -l app "$argv[1]"
    set -l marker_file "$HOME/.dotfiles_configured_""$app"
    command touch "$marker_file"
    write_log "应用标记为已配置: $app" "APP_CONFIG"
end

# 清除应用配置标记
function clear_app_configured
    if test (count $argv) -lt 1
        return 1
    end
    set -l app "$argv[1]"
    set -l marker_file "$HOME/.dotfiles_configured_""$app"
    if test -f "$marker_file"
        command rm -f "$marker_file"
        write_log "应用配置标记已清除: $app" "APP_CONFIG"
    end
end

# ============================================================================
# 初始化
# ============================================================================

# 初始化 dotfiles 环境
function init_dotfiles_env
    setup_base_environment
    write_log "dotfiles 环境初始化完成" "INIT"
end

# 标记库已加载
set -gx DOTFILES_INIT_LOADED 1
