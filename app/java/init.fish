#!/usr/bin/env fish


# 获取项目根目录
set -l SCRIPT_DIR (cd (dirname (status -f)); and pwd)
set -l PROJECT_ROOT (dirname (dirname "$SCRIPT_DIR"))

# 加载共享库 (使用绝对路径)
source "$PROJECT_ROOT/lib/init.fish"

if type -q sdk
    if sdk install java 17.0.12-oracle
        show_success "Oracal JDK 设置完成!"
    end
end
