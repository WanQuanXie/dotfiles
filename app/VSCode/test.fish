#!/usr/bin/env fish

# VSCode 测试脚本
# CI 环境中可能不安装 VSCode，跳过此测试

if test "$CI" = "true"
    echo "CI 环境检测到，跳过 VSCode 测试"
    exit 0
end

test -s /opt/homebrew/bin/code
