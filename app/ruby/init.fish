#!/usr/bin/env fish


# 获取项目根目录
set -l SCRIPT_DIR (cd (dirname (status -f)); and pwd)
set -l PROJECT_ROOT (dirname (dirname "$SCRIPT_DIR"))

# 加载共享库 (使用绝对路径)
source "$PROJECT_ROOT/lib/init.fish"

# 获取 brew 前缀路径
set -l BREW_PREFIX (brew --prefix)

set -gx PATH "$BREW_PREFIX/opt/ruby/bin" $PATH
set -gx LDFLAGS "-L$BREW_PREFIX/opt/ruby/lib"
set -gx CPPFLAGS "-I$BREW_PREFIX/opt/ruby/include"

gem install bundler
bundle config mirror.https://rubygems.org https://gems.ruby-china.com
