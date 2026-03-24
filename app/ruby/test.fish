#!/usr/bin/env fish

# 获取项目根目录的绝对路径
# 使用 status -f 获取脚本的绝对路径，然后取其目录 (app/xxx 的父目录的父目录)
set -g APP_TEST_PROJECT_ROOT (cd (dirname (dirname (status -f))); and pwd)

# 加载测试库 (使用绝对路径)
source "$APP_TEST_PROJECT_ROOT/lib/test.fish"

set -l GEM_SOURCE (gem sources | tail -n 1)
test "$GEM_SOURCE" = "https://gems.ruby-china.com/"
