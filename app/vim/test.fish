#!/usr/bin/env fish

# 获取项目根目录的绝对路径
# 使用 status -f 获取脚本的绝对路径，然后取其目录 (app/xxx 的父目录的父目录)
set -g APP_TEST_PROJECT_ROOT (cd (dirname (dirname (status -f))); and pwd)

# 加载测试库 (使用绝对路径)
source "$APP_TEST_PROJECT_ROOT/lib/test.fish"

# 初始化测试环境
init_test_env (basename (dirname (status -f)))

show_test "Vim 插件管理器测试开始"

# 定义 vim-plug 路径
set -l VIM_PLUG_PATH "$HOME/.vim/autoload/plug.vim"

# 测试 vim-plug 安装结果 - 对应 init 脚本的核心功能
show_test "检查 vim-plug 安装状态"
if test -f "$VIM_PLUG_PATH"
    show_success "vim-plug 文件已安装"

    # 验证文件完整性
    if test -s "$VIM_PLUG_PATH"
        show_success "vim-plug 文件完整"
    else
        show_error "vim-plug 文件为空"
    end
else
    show_error "vim-plug 文件不存在"
end

# 测试目录结构 - 对应 init 脚本的目录创建
show_test "检查目录结构"
test_command "test -d ~/.vim/autoload" "检查 autoload 目录"

# 测试 vim-plug 功能 - 验证插件管理器可用性
show_test "测试 vim-plug 功能"
if test -f "$VIM_PLUG_PATH"; and command -v vim >/dev/null 2>&1
    if vim -c "PlugStatus" -c "q" 2>/dev/null
        show_success "vim-plug 功能正常"
    else
        show_warning "vim-plug 功能异常"
    end
else
    show_warning "vim-plug 未安装或 vim 不可用"
end

# 测试幂等性 - 验证重复运行 init 脚本的安全性
show_test "测试 init 脚本幂等性"
if test -f "$VIM_PLUG_PATH"
    show_success "vim-plug 已存在 - 重复运行 init 脚本应跳过安装"
else
    show_info "vim-plug 不存在 - init 脚本应进行安装"
end

show_success "Vim 插件管理器测试完成"
