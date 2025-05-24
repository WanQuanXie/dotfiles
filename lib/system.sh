#!/usr/bin/env bash

# 系统检测和兼容性库
# 兼容 POSIX shell (bash 4+/zsh 5+) 和 macOS (Intel/Apple Silicon)

# 加载依赖库
# shellcheck source=./display.sh
source "$(dirname "${BASH_SOURCE[0]}")/display.sh"

# 检测操作系统类型
detect_os() {
    case "$OSTYPE" in
        darwin*)
            echo "macos"
            ;;
        linux*)
            echo "linux"
            ;;
        msys*|cygwin*)
            echo "windows"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# 检测 macOS 架构
detect_macos_arch() {
    if [[ "$(detect_os)" == "macos" ]]; then
        case "$(uname -m)" in
            arm64)
                echo "apple_silicon"
                ;;
            x86_64)
                echo "intel"
                ;;
            *)
                echo "unknown"
                ;;
        esac
    else
        echo "not_macos"
    fi
}

# 获取 Homebrew 前缀路径
get_brew_prefix() {
    local arch
    arch="$(detect_macos_arch)"
    
    case "$arch" in
        apple_silicon)
            echo "/opt/homebrew"
            ;;
        intel)
            echo "/usr/local"
            ;;
        *)
            # 尝试动态检测
            if command -v brew >/dev/null 2>&1; then
                brew --prefix
            else
                echo "/usr/local"  # 默认值
            fi
            ;;
    esac
}

# 检查 shell 类型和版本
check_shell_compatibility() {
    local shell_name="$1"
    
    case "$shell_name" in
        bash)
            if command -v bash >/dev/null 2>&1; then
                local bash_version
                bash_version=$(bash --version | head -n1 | grep -o '[0-9]\+\.[0-9]\+' | head -n1)
                local major_version
                major_version=$(echo "$bash_version" | cut -d. -f1)
                
                if [[ "$major_version" -ge 4 ]]; then
                    echo "compatible"
                else
                    echo "incompatible"
                fi
            else
                echo "not_found"
            fi
            ;;
        zsh)
            if command -v zsh >/dev/null 2>&1; then
                local zsh_version
                zsh_version=$(zsh --version | grep -o '[0-9]\+\.[0-9]\+' | head -n1)
                local major_version
                major_version=$(echo "$zsh_version" | cut -d. -f1)
                
                if [[ "$major_version" -ge 5 ]]; then
                    echo "compatible"
                else
                    echo "incompatible"
                fi
            else
                echo "not_found"
            fi
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# 检查 macOS 版本兼容性
check_macos_compatibility() {
    if [[ "$(detect_os)" != "macos" ]]; then
        echo "not_macos"
        return
    fi
    
    local macos_version
    macos_version=$(sw_vers -productVersion)
    local major_version
    major_version=$(echo "$macos_version" | cut -d. -f1)
    local minor_version
    minor_version=$(echo "$macos_version" | cut -d. -f2)
    
    # 检查是否为 macOS 10.15+ (Catalina+)
    if [[ "$major_version" -gt 10 ]] || [[ "$major_version" -eq 10 && "$minor_version" -ge 15 ]]; then
        echo "compatible"
    else
        echo "incompatible"
    fi
}

# 运行 POSIX 兼容性测试
run_posix_compatibility_tests() {
    local component_name="$1"
    
    show_test "POSIX 兼容性测试"
    
    # 测试 bash 兼容性
    local bash_compat
    bash_compat=$(check_shell_compatibility "bash")
    case "$bash_compat" in
        compatible)
            test_command "bash -c 'command -v $component_name'" "测试 bash 中的 $component_name 可用性"
            ;;
        incompatible)
            show_warning "bash 版本不兼容 (需要 4.0+)"
            ;;
        not_found)
            show_warning "未找到 bash"
            ;;
    esac
    
    # 测试 zsh 兼容性
    local zsh_compat
    zsh_compat=$(check_shell_compatibility "zsh")
    case "$zsh_compat" in
        compatible)
            test_command "zsh -c 'command -v $component_name'" "测试 zsh 中的 $component_name 可用性"
            ;;
        incompatible)
            show_warning "zsh 版本不兼容 (需要 5.0+)"
            ;;
        not_found)
            show_warning "未找到 zsh"
            ;;
    esac
}

# 运行 macOS 兼容性测试
run_macos_compatibility_tests() {
    local component_name="$1"
    
    show_test "macOS 兼容性测试"
    
    local os_type
    os_type=$(detect_os)
    if [[ "$os_type" != "macos" ]]; then
        show_warning "非 macOS 系统，跳过 macOS 特定测试"
        return
    fi
    
    local macos_compat
    macos_compat=$(check_macos_compatibility)
    if [[ "$macos_compat" == "incompatible" ]]; then
        show_warning "macOS 版本可能不兼容 (建议 10.15+)"
    fi
    
    local arch
    arch=$(detect_macos_arch)
    case "$arch" in
        apple_silicon)
            show_success "Apple Silicon 架构下的 $component_name 运行正常"
            ;;
        intel)
            show_success "Intel 架构下的 $component_name 运行正常"
            ;;
        *)
            show_warning "未知架构"
            ;;
    esac
    
    # 检查是否使用 Homebrew 安装
    if command -v "$component_name" >/dev/null 2>&1; then
        local component_path
        component_path=$(which "$component_name")
        local brew_prefix
        brew_prefix=$(get_brew_prefix)
        
        if [[ "$component_path" == "$brew_prefix"* ]]; then
            show_success "使用 Homebrew 安装的 $component_name"
        else
            show_warning "可能使用系统自带的 $component_name"
        fi
    fi
}

# 设置基础环境变量
setup_base_environment() {
    local brew_prefix
    brew_prefix=$(get_brew_prefix)
    
    # 导出 Homebrew 相关环境变量
    export PATH="$brew_prefix/bin:$brew_prefix/sbin:$PATH"
    export HOMEBREW_PREFIX="$brew_prefix"
    
    write_log "基础环境变量设置完成: HOMEBREW_PREFIX=$brew_prefix" "ENV_SETUP"
}

# 导出系统检测函数
export -f detect_os detect_macos_arch get_brew_prefix
export -f check_shell_compatibility check_macos_compatibility
export -f run_posix_compatibility_tests run_macos_compatibility_tests
export -f setup_base_environment
