# Homebrew environment
# 统一注入 Homebrew 的环境变量与 PATH / INFOPATH 规则。
if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv fish | source
end
