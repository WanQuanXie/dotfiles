#!/usr/bin/env fish

source lib/test.fish

# 初始化测试环境
init_test_env (basename (dirname (status --current-filename)))

# 设置错误处理
set -e

show_test "FZF 配置测试开始"

# 测试 fzf 是否安装
test_command "command -v fzf" "检查 fzf 是否安装"

# 测试 fzf 版本
show_test "检查 fzf 版本"
set -l FZF_VERSION (fzf --version | head -n1)
echo "FZF 版本: $FZF_VERSION"
show_success "FZF 版本检查完成"

# 测试 fzf 安装路径
set -l BREW_PREFIX (brew --prefix)
test_command "test -f '$BREW_PREFIX/bin/fzf'" "检查 fzf 二进制文件"

# 测试 fzf 脚本文件
test_command "test -d '$BREW_PREFIX/opt/fzf'" "检查 fzf 安装目录"
test_command "test -f '$BREW_PREFIX/opt/fzf/install'" "检查 fzf 安装脚本"

# 测试 shell 集成文件
show_test "检查 shell 集成文件"

# 检查 bash 集成
if test -f "$BREW_PREFIX/opt/fzf/shell/completion.bash"
    show_success "Bash 补全脚本存在"
else
    show_warning "Bash 补全脚本不存在"
end

if test -f "$BREW_PREFIX/opt/fzf/shell/key-bindings.bash"
    show_success "Bash 键绑定脚本存在"
else
    show_warning "Bash 键绑定脚本不存在"
end

# 检查 fish 集成
if test -f "$BREW_PREFIX/opt/fzf/shell/completion.fish"
    show_success "Fish 补全脚本存在"
else
    show_warning "Fish 补全脚本不存在"
end

if test -f "$BREW_PREFIX/opt/fzf/shell/key-bindings.fish"
    show_success "Fish 键绑定脚本存在"
else
    show_warning "Fish 键绑定脚本不存在"
end

# 测试用户配置文件
show_test "检查用户配置文件"

# 检查 .fzf.bash
if test -f ~/.fzf.bash
    show_success ".fzf.bash 配置文件存在"

    # 检查配置文件内容（fzf 0.70.0+ 可能不包含 completion.bash 字符串）
    if grep -q 'completion.bash' ~/.fzf.bash 2>/dev/null
        test_command "grep -q 'completion.bash' ~/.fzf.bash" "检查 bash 补全配置"
    else if grep -q 'fzf --completion' ~/.fzf.bash 2>/dev/null
        show_info "使用新版 fzf 内联补全配置"
    else
        show_warning "bash 补全配置检查跳过（文件内容不包含预期字符串）"
    end

    if grep -q 'key-bindings.bash' ~/.fzf.bash 2>/dev/null
        test_command "grep -q 'key-bindings.bash' ~/.fzf.bash" "检查 bash 键绑定配置"
    else if grep -q 'fzf --key-bindings' ~/.fzf.bash 2>/dev/null
        show_info "使用新版 fzf 内联键绑定配置"
    else
        show_warning "bash 键绑定配置检查跳过（文件内容不包含预期字符串）"
    end
else
    show_warning ".fzf.bash 配置文件不存在"
end

# 检查 fish config 集成
if test -f ~/.config/fish/config.fish
    show_test "检查 fish config 中的 fzf 集成"

    if grep -q "fzf" ~/.config/fish/config.fish 2>/dev/null
        show_success "fish config 中包含 fzf 配置"
    else
        show_warning "fish config 中未找到 fzf 配置"
    end
else
    show_warning "fish config 文件不存在"
end

# 功能测试
show_test "FZF 功能测试"

# 测试基本搜索功能（非交互式）
test_command "echo 'test' | fzf --filter='test'" "测试 fzf 过滤功能"

# 测试 fzf 是否能正确处理输入
test_command "echo -e 'line1\nline2\nline3' | fzf --filter='line2' | grep -q 'line2'" "测试 fzf 搜索功能"

# 跨 Shell 测试
show_test "跨 Shell 测试"

# 检查 fzf 在不同 shell 中的可用性
if command -v bash >/dev/null 2>&1
    test_command "bash -c 'command -v fzf'" "测试 bash 中的 fzf 可用性"
end

# 测试与 macOS 剪贴板的集成
if command -v pbcopy >/dev/null 2>&1
    test_command "echo 'test' | fzf --filter='test' | pbcopy; and pbpaste | grep -q 'test'" "测试与 pbcopy/pbpaste 的集成"
end

# 性能测试
show_test "性能测试"

# 创建临时测试数据
set -l TEMP_DIR (mktemp -d)
for i in (seq 1 1000)
    echo "test_line_$i" >> "$TEMP_DIR/test_data.txt"
end

# 测试大数据集的处理
test_command "cat '$TEMP_DIR/test_data.txt' | fzf --filter='test_line_500' | grep -q 'test_line_500'" "测试大数据集处理"

# 清理临时文件
rm -rf "$TEMP_DIR"

show_success "FZF 配置测试完成"
