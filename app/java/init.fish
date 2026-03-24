#!/usr/bin/env fish

source lib/init.fish

if test -x (which sdk)
    if sdk install java 17.0.12-oracle
        show_success "Oracal JDK 设置完成!"
    end
end
