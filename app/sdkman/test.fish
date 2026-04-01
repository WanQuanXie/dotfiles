#!/usr/bin/env fish
# app/sdkman/test.fish - SDKMAN 测试脚本

# 获取项目根目录的绝对路径
set -g APP_TEST_PROJECT_ROOT (cd (dirname (dirname (dirname (status -f)))); and pwd)

# 加载测试库 (使用绝对路径)
source "$APP_TEST_PROJECT_ROOT/lib/test.fish"

# 初始化测试环境
init_test_env (basename (dirname (status -f)))

show_test "SDKMAN 配置测试开始"

# 检查 SDKMAN 目录
check_directory "$HOME/.sdkman" "检查 SDKMAN 主目录"

# 检查 SDKMAN 初始化脚本
check_file "$HOME/.sdkman/bin/sdkman-init.sh" "检查 SDKMAN 初始化脚本"

# 检查 fisher 插件
if test "$CI" = "true"
    show_warning "CI 环境检测到，跳过 Fisher 插件检查"
else
    check_file "$HOME/.config/fish/functions/sdk.fish" "检查 sdk 命令函数"
    check_file "$HOME/.config/fish/conf.d/sdk.fish" "检查 SDKMAN 配置"
end

# 检查 Java 等候选工具是否可用（通过 fish 环境）
test_command "fish -c 'java --version >/dev/null 2>&1'" "检查 Java 在 Fish 中可用"

# 检查 sdkman-for-fish 插件加载正常
if test "$CI" != "true"
    test_command "fish -c 'type -q sdk'" "检查 sdk 函数定义"
end

test_summary "SDKMAN 配置测试"
