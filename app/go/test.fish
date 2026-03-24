#!/usr/bin/env fish

# 获取项目根目录的绝对路径
# 使用 status -f 获取脚本的绝对路径，然后取其目录 (app/xxx 的父目录的父目录)
set -g APP_TEST_PROJECT_ROOT (dirname (dirname (status -f)))

# 加载测试库 (使用绝对路径)
source "$APP_TEST_PROJECT_ROOT/lib/test.fish"

# Go 配置测试 - 使用共享库重构
# 面向 macOS 15+ (Apple Silicon)

# 初始化测试环境
init_test_env (basename (dirname (status --current-filename)))

show_test "Go 配置测试开始"

# 检查 Go 工具链
check_executable "go" "检查 Go 编译器"

# 检查 Go 工作目录
check_directory "$HOME/go" "检查 Go 工作目录"

# 检查版本信息
check_version "go" "version" "检查 Go 版本"

test_summary "Go 配置测试"
