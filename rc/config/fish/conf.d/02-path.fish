# Homebrew (兼容 Intel / Apple Silicon)
if test -d /opt/homebrew
    fish_add_path /opt/homebrew/bin /opt/homebrew/sbin
else if test -d /usr/local/Homebrew
    fish_add_path /usr/local/bin
end

# Python (动态检测)
if test -d /opt/homebrew/opt/python@3.13/libexec/bin
    fish_add_path /opt/homebrew/opt/python@3.13/libexec/bin
else if test -d /opt/homebrew/opt/python/libexec/bin
    fish_add_path /opt/homebrew/opt/python/libexec/bin
end

# curl (brew)
if test -d /opt/homebrew/opt/curl/bin
    fish_add_path /opt/homebrew/opt/curl/bin
    set -gx LDFLAGS "-L/opt/homebrew/opt/curl/lib"
    set -gx CPPFLAGS "-I/opt/homebrew/opt/curl/include"
end

# Ruby (brew)
if test -d /opt/homebrew/opt/ruby/bin
    fish_add_path /opt/homebrew/opt/ruby/bin
    # Ruby 编译参数（追加到已有的 LDFLAGS/CPPFLAGS）
    if set -q LDFLAGS
        set -gx LDFLAGS "$LDFLAGS -L/opt/homebrew/opt/ruby/lib"
    else
        set -gx LDFLAGS "-L/opt/homebrew/opt/ruby/lib"
    end
    if set -q CPPFLAGS
        set -gx CPPFLAGS "$CPPFLAGS -I/opt/homebrew/opt/ruby/include"
    else
        set -gx CPPFLAGS "-I/opt/homebrew/opt/ruby/include"
    end
end

# Gem
set -gx GEM_HOME $HOME/.gem
fish_add_path $GEM_HOME/bin

# Cargo (Rust)
fish_add_path $HOME/.cargo/bin

# Pyenv
set -gx PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin

# Global NPM
fish_add_path $HOME/npmbin/node_modules/.bin

# Flutter
fish_add_path $HOME/Workspace/tools/flutter/bin

# Antigravity
fish_add_path $HOME/.antigravity/antigravity/bin

# gcloud
fish_add_path /opt/homebrew/share/google-cloud-sdk/bin

# 用户本地路径
fish_add_path $HOME/bin $HOME/.local/bin
