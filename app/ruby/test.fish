#!/usr/bin/env fish

# 获取项目根目录的绝对路径
set -g APP_TEST_DIR (cd (dirname (status --current-filename)); and pwd)
set -g APP_TEST_PROJECT_ROOT (dirname (dirname "$APP_TEST_DIR"))

# 加载测试库 (使用绝对路径)
source "$APP_TEST_PROJECT_ROOT/lib/test.fish"

set -l GEM_SOURCE (gem sources | tail -n 1)
test "$GEM_SOURCE" = "https://gems.ruby-china.com/"
