#!/usr/bin/env bash

# 测试工具函数 - 使用共享库重构
# 兼容 POSIX shell (bash 4+/zsh 5+) 和 macOS (Intel/Apple Silicon)

# 加载共享库
# shellcheck source=../lib/common.sh
source "../lib/common.sh"

# 初始化测试环境
init_test_env "$(basename "$(dirname "$0")")"

# 为了向后兼容，保留原有的 TEST_LOG 变量
TEST_LOG="$TEST_LOG_FILE"

# 导出兼容性变量
export TEST_LOG