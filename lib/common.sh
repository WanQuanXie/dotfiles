#!/usr/bin/env bash

# 通用库加载器 - dotfiles 项目的主要共享库
# 兼容 POSIX shell (bash 4+/zsh 5+) 和 macOS (Intel/Apple Silicon)

# 获取库目录路径
LIB_DIR="$(dirname "${BASH_SOURCE[0]}")"

# 防止重复加载
if [[ -n "${DOTFILES_COMMON_LOADED:-}" ]]; then
    return 0
fi

# 加载所有库模块
# shellcheck source=./colors.sh
source "$LIB_DIR/colors.sh"

# shellcheck source=./display.sh
source "$LIB_DIR/display.sh"

# shellcheck source=./system.sh
source "$LIB_DIR/system.sh"

# shellcheck source=./testing.sh
source "$LIB_DIR/testing.sh"

# 标记库已加载
export DOTFILES_COMMON_LOADED=1

# 通用工具函数

# 检查依赖是否已安装，如果没有则尝试安装
check_and_install_dependency() {
    local cmd="$1"
    local package="${2:-$cmd}"
    local installer="${3:-brew}"

    if ! command -v "$cmd" &> /dev/null; then
        show_warning "未找到命令: $cmd，尝试安装 $package..."

        case "$installer" in
            brew)
                if command -v brew >/dev/null 2>&1; then
                    if brew install "$package"; then
                        show_success "$package 安装成功"
                        return 0
                    else
                        show_error "$package 安装失败" 0
                        return 1
                    fi
                else
                    show_error "Homebrew 未安装，无法自动安装 $package" 0
                    return 1
                fi
                ;;
            *)
                show_error "不支持的安装器: $installer" 0
                return 1
                ;;
        esac
    fi
    return 0
}

# 创建目录（如果不存在）
ensure_directory() {
    local dir="$1"
    local msg="${2:-创建目录 $dir}"

    if [[ ! -d "$dir" ]]; then
        show_info "$msg"
        if mkdir -p "$dir"; then
            show_success "目录创建成功: $dir"
        else
            show_error "目录创建失败: $dir" 0
            return 1
        fi
    fi
    return 0
}

# 安全地备份文件
backup_file() {
    local file="$1"
    local backup_dir="${2:-$HOME/.dotfiles_backup}"

    if [[ -f "$file" ]]; then
        ensure_directory "$backup_dir"
        local backup_file="$backup_dir/$(basename "$file").$(date +%Y%m%d_%H%M%S)"
        if cp "$file" "$backup_file"; then
            show_info "已备份 $file 到 $backup_file"
            return 0
        else
            show_error "备份失败: $file" 0
            return 1
        fi
    fi
    return 0
}

# 安全地创建符号链接
safe_symlink() {
    local source="$1"
    local target="$2"
    local backup="${3:-true}"

    # 检查源文件是否存在
    if [[ ! -e "$source" ]]; then
        show_error "源文件不存在: $source" 0
        return 1
    fi

    # 如果目标已存在，先备份
    if [[ -e "$target" || -L "$target" ]]; then
        if [[ "$backup" == "true" ]]; then
            backup_file "$target"
        fi
        rm -f "$target"
    fi

    # 确保目标目录存在
    ensure_directory "$(dirname "$target")"

    # 创建符号链接
    if ln -s "$source" "$target"; then
        show_success "符号链接创建成功: $target -> $source"
        return 0
    else
        show_error "符号链接创建失败: $target -> $source" 0
        return 1
    fi
}

# 检查应用是否已配置
is_app_configured() {
    local app="$1"
    local marker_file="$HOME/.dotfiles_configured_$app"

    if [[ -f "$marker_file" ]]; then
        return 0  # 已配置
    else
        return 1  # 未配置
    fi
}

# 标记应用已配置
mark_app_configured() {
    local app="$1"
    local marker_file="$HOME/.dotfiles_configured_$app"
    touch "$marker_file"
    write_log "应用标记为已配置: $app" "APP_CONFIG"
}

# 清除应用配置标记
clear_app_configured() {
    local app="$1"
    local marker_file="$HOME/.dotfiles_configured_$app"
    if [[ -f "$marker_file" ]]; then
        rm -f "$marker_file"
        write_log "应用配置标记已清除: $app" "APP_CONFIG"
    fi
}

# 运行命令并记录日志（控制台输出）
run_with_log() {
    local cmd="$1"
    local description="$2"
    local show_output="${3:-false}"  # 是否显示命令输出

    show_info "正在执行: $description"
    write_log "开始执行命令: $cmd" "COMMAND"

    local exit_code=0
    if [[ "$show_output" == "true" ]]; then
        # 显示命令输出
        if eval "$cmd"; then
            exit_code=0
        else
            exit_code=$?
        fi
    else
        # 隐藏命令输出
        if eval "$cmd" >/dev/null 2>&1; then
            exit_code=0
        else
            exit_code=$?
        fi
    fi

    if [[ $exit_code -eq 0 ]]; then
        show_success "$description 完成"
        write_log "命令执行成功: $cmd" "COMMAND"
        return 0
    else
        show_error "$description 失败 (退出代码: $exit_code)" 0
        write_log "命令执行失败: $cmd (退出代码: $exit_code)" "COMMAND"
        return $exit_code
    fi
}

# 初始化 dotfiles 环境
init_dotfiles_env() {
    # 设置基础环境
    setup_base_environment

    # 设置错误处理
    set -e

    write_log "dotfiles 环境初始化完成" "INIT"
}

# 显示库版本信息
show_lib_info() {
    show_info "dotfiles 共享库已加载"
    show_info "支持的功能: 颜色显示、日志记录、系统检测、测试工具"
    show_info "兼容性: POSIX shell (bash 4+/zsh 5+), macOS 10.15+ (Intel/Apple Silicon)"
}

# 如果直接运行此脚本，显示库信息
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    show_lib_info
fi

# 导出所有函数供其他脚本使用
export -f check_and_install_dependency ensure_directory backup_file safe_symlink is_app_configured mark_app_configured clear_app_configured run_with_log init_dotfiles_env show_lib_info
