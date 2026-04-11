function brew --description 'Run brew with pyenv shims removed from PATH when pyenv is available'
    set -l clean_path $PATH
    if command -q pyenv
        set clean_path
        set -l shims_path (pyenv root)/shims
        for p in $PATH
            if test "$p" != "$shims_path"
                set -a clean_path $p
            end
        end
    end
    env PATH=(string join : $clean_path) command brew $argv
end
