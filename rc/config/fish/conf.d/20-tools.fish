if status is-interactive
    # Starship 提示符主题
    command -q starship; and starship init fish | source

    # Zoxide 智能 cd
    command -q zoxide; and zoxide init fish | source

    # fnm (Fast Node Manager)
    command -q fnm; and fnm env --use-on-cd --corepack-enabled --resolve-engines --shell fish | source

    # Pyenv
    command -q pyenv; and pyenv init - fish | source

    # fzf 键绑定和补全
    if command -q fzf
        fzf --fish | source
    end

    # bun 补全
    if test -f $HOME/.bun/_bun.fish
        source $HOME/.bun/_bun.fish
    end

    # kiro-cli 补全
    if command -q kiro-cli
        kiro-cli completion fish | source
    end

    # SDKMAN (通过 bass 桥接，因为 SDKMAN 是纯 bash 脚本)
    if test -s $HOME/.sdkman/bin/sdkman-init.sh
        bass source $HOME/.sdkman/bin/sdkman-init.sh
    end
end
