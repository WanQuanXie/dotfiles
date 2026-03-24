#!/usr/bin/env fish

source lib/init.fish

if test -x (which sdk)
    if sdk install mvnd
        show_success "Maven Daemon 安装完成!"
    end
end
