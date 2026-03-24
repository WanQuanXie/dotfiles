#!/usr/bin/env fish
# 应用引导脚本 - Fish Shell 版本
# 兼容 macOS 15+ (Apple Silicon)

# 获取脚本目录的绝对路径
# 注意: status -f 可能返回相对路径，需要转换为绝对路径
set -g SCRIPT_DIR (cd (dirname (status -f)); and pwd)
set -g PROJECT_ROOT (dirname "$SCRIPT_DIR")

# 加载共享库
source $PROJECT_ROOT/lib/init.fish

# 初始化环境
init_dotfiles_env

# 错误处理函数
function handle_error
    set -l app $argv[1]
    set -l error_msg $argv[2]
    set -l exit_code $argv[3]
    if test -z "$exit_code"
        set exit_code 1
    end

    show_error "配置 $app 时发生错误: $error_msg (错误代码: $exit_code)"

    # CI 环境下必须让 step 真正失败，直接退出
    if test "$CI" = "true"
        exit $exit_code
    end

    # 非 CI 环境下询问是否继续
    read -p "是否继续安装其他应用? (y/n) " -n 1 -r
    echo
    if not string match -rq '^[Yy]$' $REPLY
        show_error "安装中止"
        exit 1
    end
end

# 应用分组 - 按依赖关系和安装时间分组
# 第1组：基础工具（快速安装）
set -g group1 fish git ssh gpg starship
# 第2组：语言环境（耗时较长，可并行）
set -g group2 go rust ruby java node
# 第3组：开发工具（依赖前两组）
set -g group3 vim nvim tmux fzf VSCode

# 计算总步骤数
set -g TOTAL_GROUPS 3
set -g CURRENT_GROUP 0

show_group "开始配置应用程序 (共 $TOTAL_GROUPS 组)"

# 检查依赖是否已安装
function check_dependency
    set -l cmd $argv[1]
    set -l package $argv[2]

    if not command -v "$cmd" > /dev/null
        show_warning "未找到命令: $cmd，尝试安装 $package..."
        if brew install "$package"
            show_success "$package 安装成功"
            return 0
        else
            show_error "$package 安装失败"
            return 1
        end
    end
    return 0
end

# 处理单个应用的函数
function process_app
    set -l app $argv[1]

    if is_app_configured "$app"
        show_warning "$app 已配置，跳过"
        return 0
    end

    # 检查应用特定依赖
    switch "$app"
        case 'nvim'
            check_dependency "node" "node" || return 1
            ;;
        case 'ruby'
            check_dependency "brew" "homebrew" || return 1
            ;;
        case 'rust'
            check_dependency "curl" "curl" || return 1
            ;;
    end

    if test -f "$PROJECT_ROOT/app/$app/init.fish"
        show_info "正在初始化 $app..."
        if fish "$PROJECT_ROOT/app/$app/init.fish"
            show_success "$app 初始化成功"
        else
            set -l exit_code $status
            handle_error "$app" "初始化失败" "$exit_code"
            return 1
        end
    end

    if test -f "$PROJECT_ROOT/app/$app/test.fish"
        show_info "正在测试 $app..."
        if fish "$PROJECT_ROOT/app/$app/test.fish"
            show_success "$app 测试通过"
            mark_app_configured "$app"
            return 0
        else
            set -l exit_code $status
            handle_error "$app" "测试失败" "$exit_code"
            return 1
        end
    else if test -f "$PROJECT_ROOT/app/$app/init.fish"
        # 如果没有测试脚本但有初始化脚本，也标记为已配置
        mark_app_configured "$app"
        return 0
    end

    return 0
end

# 处理应用组的函数
function process_group
    set -l group_var_name $argv[1]
    set -l group_name $argv[2]

    set CURRENT_GROUP (math $CURRENT_GROUP + 1)
    show_progress "处理应用组: $group_name" "$CURRENT_GROUP" "$TOTAL_GROUPS"

    set -l success_count 0
    set -l total_count (count $$group_var_name)

    # 使用 fish 的 $$ 语法进行间接变量访问遍历数组元素
    # $$group_var_name 会展开为变量名对应的值
    for app in $$group_var_name
        show_info "处理应用: $app"
        if process_app "$app"
            set success_count (math $success_count + 1)
        end
    end

    show_info "$group_name 组完成: $success_count/$total_count 个应用配置成功"
end

# 创建回滚脚本
function create_rollback_script
    set -l rollback_script "$HOME/.dotfiles_rollback.fish"

    set -l content "#!/usr/bin/env fish\n# 回滚脚本 - 用于清理失败的安装\n\necho \"开始回滚 dotfiles 安装...\"\n\n# 删除配置标记文件\nrm -f $HOME/.dotfiles_configured_*\n\n# 恢复原始配置文件（如果有备份）\nif test -d \"$HOME/.dotfiles_backup\"\n    echo \"恢复备份的配置文件...\"\n    cp -r $HOME/.dotfiles_backup/* $HOME/\nend\n\necho \"回滚完成。您可能需要重新启动系统以完全清理环境。\"\n"
    printf '%b' "$content" > "$rollback_script"

    chmod +x "$rollback_script"
    show_info "已创建回滚脚本: $rollback_script"
end

# 备份现有配置
function backup_configs
    set -l backup_dir "$HOME/.dotfiles_backup"
    mkdir -p "$backup_dir"

    # 备份关键配置文件
    for file in .config/fish/config.fish .bashrc .gitconfig .vimrc .tmux.conf
        if test -f "$HOME/$file"
            cp "$HOME/$file" "$backup_dir/"
        end
    end

    show_info "已备份现有配置到: $backup_dir"
end

# 主执行流程
function control_c
    show_error "安装中断"
    exit 1
end

trap control_c INT TERM

# 备份现有配置
backup_configs

# 创建回滚脚本
create_rollback_script

# 按组处理应用
process_group group1 "基础工具"
process_group group2 "语言环境"
process_group group3 "开发工具"

show_success "所有应用程序配置完成"
