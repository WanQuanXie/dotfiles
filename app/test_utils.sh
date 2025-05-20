#!/usr/bin/env bash

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志目录
LOG_DIR="$HOME/.dotfiles_logs"
mkdir -p "$LOG_DIR"
TEST_LOG="$LOG_DIR/test_$(basename $(dirname $0))_$(date +%Y%m%d_%H%M%S).log"

# 显示测试项目
show_test() {
    echo -e "${BLUE}测试: $1${NC}" | tee -a "$TEST_LOG"
}

# 显示成功消息
show_success() {
    echo -e "${GREEN}✓ $1${NC}" | tee -a "$TEST_LOG"
}

# 显示错误消息
show_error() {
    echo -e "${RED}✗ $1${NC}" | tee -a "$TEST_LOG"
    echo "详细日志: $TEST_LOG"
    exit 1
}

# 显示警告消息
show_warning() {
    echo -e "${YELLOW}! $1${NC}" | tee -a "$TEST_LOG"
}

# 测试命令并提供反馈
test_command() {
    local cmd="$1"
    local msg="$2"
    local err_msg="${3:-$msg 失败}"
    
    show_test "$msg"
    if eval "$cmd" >> "$TEST_LOG" 2>&1; then
        show_success "$msg 通过"
        return 0
    else
        show_error "$err_msg (错误代码: $?)"
        return 1
    fi
}