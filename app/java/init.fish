#!/usr/bin/env fish

include lib/init

if test -x (which sdk)
    if sdk install java 17.0.12-oracle
        show_success "Oracal JDK 设置完成!"
    end
end
