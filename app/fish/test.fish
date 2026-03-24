#!/usr/bin/env fish

# 获取项目根目录的绝对路径
# 使用 status -f 获取脚本的绝对路径，然后取其目录 (app/xxx 的父目录的父目录)
set -g APP_TEST_PROJECT_ROOT (cd (dirname (dirname (status -f))); and pwd)

# 加载测试库 (使用绝对路径)
source "$APP_TEST_PROJECT_ROOT/lib/test.fish"

# 初始化测试环境
init_test_env (basename (dirname (status -f)))

show_test "Fish Shell 配置测试开始"

# 检查 Fish 工具链
check_executable "fish" "检查 Fish shell"

# 检查版本信息
check_version "fish" "--version" "检查 Fish 版本"

# 检查配置文件
check_file "$HOME/.config/fish/config.fish" "检查 fish config.fish 配置文件"

# 检查 conf.d 模块化配置
check_file "$HOME/.config/fish/conf.d/01-env.fish" "检查环境变量配置"
check_file "$HOME/.config/fish/conf.d/02-path.fish" "检查 PATH 配置"
check_file "$HOME/.config/fish/conf.d/20-tools.fish" "检查工具初始化配置"

# 检查 Fisher 插件管理器
check_file "$HOME/.config/fish/functions/fisher.fish" "检查 Fisher 插件管理器"

# 验证 fish 可正常启动且环境变量加载正确
test_command "fish -ic 'echo \$LANG'" "检查 Fish 交互模式启动"

test_summary "Fish Shell 配置测试"
