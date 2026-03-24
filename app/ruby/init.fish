#!/usr/bin/env fish

include lib/init

# 获取 brew 前缀路径
set -l BREW_PREFIX (brew --prefix)

set -gx PATH "$BREW_PREFIX/opt/ruby/bin" $PATH
set -gx LDFLAGS "-L$BREW_PREFIX/opt/ruby/lib"
set -gx CPPFLAGS "-I$BREW_PREFIX/opt/ruby/include"

gem install bundler
bundle config mirror.https://rubygems.org https://gems.ruby-china.com
