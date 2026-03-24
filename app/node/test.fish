#!/usr/bin/env fish

# 获取项目根目录的绝对路径
set -g APP_TEST_DIR (cd (dirname (status --current-filename)); and pwd)
set -g APP_TEST_PROJECT_ROOT (dirname (dirname "$APP_TEST_DIR"))

# 加载测试库 (使用绝对路径)
source "$APP_TEST_PROJECT_ROOT/lib/test.fish"

# Node.js 配置测试 - 使用共享库重构
# 面向 macOS 15+ (Apple Silicon)

# 初始化测试环境
init_test_env (basename (dirname (status --current-filename)))

show_test "Node.js 配置测试开始"

# 检查 Node.js 工具链
check_executable "fnm" "检查 fnm 版本管理器"
check_executable "pnpm" "检查 pnpm 包管理器"
check_executable "node" "检查 Node.js"
check_executable "npm" "检查 npm 包管理器"

# 检查版本信息
check_version "pnpm" "--version" "检查 pnpm 版本"
check_version "node" "--version" "检查 Node.js 版本"
check_version "npm" "--version" "检查 npm 版本"

test_summary "Node.js 配置测试"
