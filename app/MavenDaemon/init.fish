#!/usr/bin/env fish

include lib/init

if test -x (which sdk)
    if sdk install mvnd
        show_success "Maven Daemon 安装完成!"
    end
end
