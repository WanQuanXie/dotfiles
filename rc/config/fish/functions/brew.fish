function brew --description 'Run brew with pyenv shims removed from PATH'
    set -l clean_path
    set -l shims_path (pyenv root)/shims
    for p in $PATH
        if test "$p" != "$shims_path"
            set -a clean_path $p
        end
    end
    env PATH=(string join : $clean_path) command brew $argv
end
