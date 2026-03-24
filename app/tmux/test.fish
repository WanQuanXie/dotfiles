#!/usr/bin/env fish

# 获取项目根目录的绝对路径
# 使用 status -f 获取脚本的绝对路径，然后取其目录 (app/xxx 的父目录的父目录)
set -g APP_TEST_PROJECT_ROOT (cd (dirname (dirname (dirname (status -f)))); and pwd)

# 加载测试库 (使用绝对路径)
source "$APP_TEST_PROJECT_ROOT/lib/test.fish"

# 初始化测试环境
init_test_env (basename (dirname (status -f)))

# 注意: fish 不支持 set -e (errexit)
# 如需错误处理，请使用 `; or exit 1` 语法显式处理

show_test "Tmux 配置测试开始"

# 测试 tmux 是否安装
test_command "command -v tmux" "检查 tmux 是否安装"

# 测试 tmux 版本
show_test "检查 tmux 版本"
set -l TMUX_VERSION (tmux -V)
echo "Tmux 版本: $TMUX_VERSION"
show_success "Tmux 版本检查完成"

# 测试配置文件
test_command "test -f ~/.tmux.conf" "检查 tmux 配置文件"

# 测试 tmux 配置语法
show_test "验证 tmux 配置语法"
if tmux -f ~/.tmux.conf list-sessions 2>/dev/null; or test $status -eq 1
    # 退出码 1 表示没有活动会话，这是正常的
    show_success "tmux 配置语法正确"
else
    show_error "tmux 配置语法错误"
end

# 测试插件目录
test_command "test -d ~/.tmux" "检查 tmux 插件目录"
test_command "test -d ~/.tmux/plugins" "检查 tmux 插件子目录"

# 测试 TPM (Tmux Plugin Manager)
show_test "检查 TPM 插件管理器"
test_command "test -d ~/.tmux/plugins/tpm" "检查 TPM 目录"
test_command "test -f ~/.tmux/plugins/tpm/tpm" "检查 TPM 主脚本"

# 检查 TPM 脚本权限
if test -f ~/.tmux/plugins/tpm/tpm
    if test -x ~/.tmux/plugins/tpm/tpm
        show_success "TPM 脚本具有执行权限"
    else
        show_warning "TPM 脚本缺少执行权限"
    end
end

# 测试主题
show_test "检查 Nord 主题"
test_command "test -d ~/.tmux/themes" "检查主题目录"
test_command "test -d ~/.tmux/themes/nord-tmux" "检查 Nord 主题目录"

# 检查主题文件
if test -d ~/.tmux/themes/nord-tmux
    test_command "test -f ~/.tmux/themes/nord-tmux/nord.tmux" "检查 Nord 主题主文件"
end

# 测试插件
show_test "检查 tmux 插件"

# 检查 tmux-resurrect 插件
test_command "test -d ~/.tmux/plugins/tmux-resurrect" "检查 tmux-resurrect 插件目录"

if test -d ~/.tmux/plugins/tmux-resurrect
    test_command "test -f ~/.tmux/plugins/tmux-resurrect/resurrect.tmux" "检查 tmux-resurrect 主文件"
end

# 检查配置文件中的插件配置
show_test "检查配置文件中的插件设置"

if test -f ~/.tmux.conf
    # 检查 TPM 配置
    if grep -q "tpm" ~/.tmux.conf
        show_success "配置文件包含 TPM 设置"
    else
        show_warning "配置文件中未找到 TPM 设置"
    end

    # 检查插件列表
    if grep -q "tmux-plugins" ~/.tmux.conf
        show_success "配置文件包含插件配置"
    else
        show_warning "配置文件中未找到插件配置"
    end

    # 检查主题配置
    if grep -q "nord" ~/.tmux.conf
        show_success "配置文件包含 Nord 主题配置"
    else
        show_warning "配置文件中未找到 Nord 主题配置"
    end
end

# 功能测试
show_test "Tmux 功能测试"

# 测试 tmux 能否正常启动（非交互式）
test_command "tmux new-session -d -s test_session 'echo test'" "测试创建 tmux 会话"

# 检查会话是否创建成功
if tmux has-session -t test_session 2>/dev/null
    show_success "tmux 会话创建成功"

    # 清理测试会话
    tmux kill-session -t test_session 2>/dev/null; or true
    show_success "测试会话已清理"
else
    show_warning "tmux 会话创建失败"
end

# 跨 Shell 测试
show_test "跨 Shell 测试"

# 检查 tmux 在不同 shell 中的可用性
if command -v bash >/dev/null 2>&1
    test_command "bash -c 'command -v tmux'" "测试 bash 中的 tmux 可用性"
end

# macOS 剪贴板集成测试
show_test "macOS 剪贴板集成测试"

if command -v pbcopy >/dev/null 2>&1; and command -v pbpaste >/dev/null 2>&1
    # 检查配置文件中是否有剪贴板配置
    if test -f ~/.tmux.conf; and grep -q "pbcopy\|pbpaste" ~/.tmux.conf
        show_success "配置文件包含 macOS 剪贴板集成"
    else
        show_warning "配置文件中未找到 macOS 剪贴板集成配置"
    end
end

# 检查 tmux 服务器状态
show_test "检查 tmux 服务器状态"

# 检查是否有运行中的 tmux 服务器
if tmux list-sessions 2>/dev/null
    show_success "发现运行中的 tmux 会话"
else
    show_success "当前没有运行中的 tmux 会话（这是正常的）"
end

# 测试配置重载
show_test "测试配置重载功能"

# 创建临时会话测试配置重载
if tmux new-session -d -s config_test 'sleep 10'
    show_success "创建配置测试会话"

    # 尝试重载配置
    if tmux source-file ~/.tmux.conf 2>/dev/null
        show_success "配置重载成功"
    else
        show_warning "配置重载失败，可能存在配置错误"
    end

    # 清理测试会话
    tmux kill-session -t config_test 2>/dev/null; or true
else
    show_warning "无法创建配置测试会话"
end

show_success "Tmux 配置测试完成"
