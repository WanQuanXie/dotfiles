#!/usr/bin/env fish

# CI 环境下跳过 MavenDaemon 测试（MavenDaemon 可能未安装）
if test "$CI" = "true"
    echo "CI 环境检测到，跳过 MavenDaemon 测试"
    exit 0
end

test -x (which mvnd)
mvnd --version
