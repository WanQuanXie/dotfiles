if status is-interactive
    # 常用工具缩写
    abbr --add hf 'history | fzf'
    abbr --add bc 'bc -q -l'
    abbr --add nvimconf 'nvim ~/.config/nvim/init.lua'
    abbr --add fishconf 'nvim ~/.config/fish/config.fish'
    abbr --add chromeDebug '/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --remote-debugging-port=9222 --user-data-dir=dev-debug-profile'
    abbr --add claude-yolo 'ENABLE_LSP_TOOL=1 claude --dangerously-skip-permissions'

    # eza 替代 ls
    alias ls 'eza --time-style "+%Y-%m-%d %H:%M:%S"'
end
