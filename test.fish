#!/usr/bin/env fish
# test.fish - 主测试脚本
# 运行基础测试和各个 app 的测试脚本

# 加载测试库
source lib/test.fish

# ============================================================================
# 主测试入口
# ============================================================================

show_group "开始运行测试"

# 设置错误处理
set -e

# 测试基础命令
show_group "检查基础命令"

set -l base_commands git fish nvim tmux
for cmd in $base_commands
    check_command $cmd "检查 $cmd 是否安装"
end

# 测试配置文件
show_group "检查配置文件"

set -l configs \
    "$HOME/.config/fish/config.fish" \
    "$HOME/.gitconfig" \
    "$HOME/.tmux.conf"

for config in $configs
    check_file $config "检查 $config 是否存在"
end

# 运行各个 app 的测试
show_group "运行应用测试"

set -l test_apps ssh gpg fish git tmux vim nvim go rust ruby java node fzf VSCode MavenDaemon

for app in $test_apps
    set -l test_script "app/$app/test.fish"
    if test -f "$test_script"
        show_info "运行 $app 测试..."
        fish "$test_script"
        if test $status -eq 0
            show_success "$app 测试通过"
        else
            show_error "$app 测试失败" 0
        end
    else
        show_warning "跳过 $app (测试脚本不存在)"
    end
end

show_success "所有测试完成"
test_summary "主测试"
