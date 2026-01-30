# primitives
brew 'git'
brew "gh"
brew "cmake"
brew 'rcm'
brew 'mas'
# lua 包管理器, 安装 vim 的 lua 插件模块需要
brew 'luarocks'
brew 'neovim'
brew 'zsh'
brew 'zsh-completions'
brew 'zsh-syntax-highlighting'
# 终端主题
brew 'starship'
# Terminal multiplexer
brew "tmux"
# 命令行版的 finder
brew 'fzf'
# 带语法高亮的 cat 指令
brew 'bat'
# 带语法高亮的 ls 指令
brew 'eza'
# 带语法高亮的 tail 指令
brew "tailspin"
# 高级版 cd 指令，会记住你最常使用的目录
brew 'zoxide'
# 进程监控
brew 'htop'
brew "gnupg"
# Official tldr client written in Rust
brew "tlrc"
# Display directories as trees (with optional color/HTML output)
brew "tree"

# [brew] dev
brew 'shellcheck' # for CI checks

brew 'ruby'

brew 'go'

brew "pyenv"
brew "pyright"
# Extremely fast Python package installer and resolver, written in Rust
brew "uv"

brew 'cmake'

brew 'pnpm'
tap 'oven-sh/bun'
brew 'oven-sh/bun/bun'
# brew 'watchman'

brew 'nginx'

# Internet file retriever
brew "wget"

# dev: CI testing
if ENV.key? 'CI'
  puts 'In CI mode, skip non-primitive brews'
else
  # [brew] dev
  # brew 'mysql'
  # brew 'sqlite'
  # brew 'postgresql'
  # https://github.com/denisidoro/navi
  # brew 'navi'
  # https://github.com/XAMPPRocky/tokei
  # brew 'tokei'

  # [brew] productivity
  # brew 'wget'
  # brew 'p7zip'
  # Terminal JSON viewer & processor
  # brew 'fx'
  # brew 'pandoc'
  # 密码管理工具命令行
  brew 'bitwarden-cli'
  # Continuation of Clash Verge - A Clash Meta GUI based on Tauri
  cask "clash-verge-rev"

  # [brew] AI & AIGC
  brew 'ollama'
  brew "gemini-cli"
  brew "opencode"

  # [cask] AI & AIGC
  cask "codex"
  cask "claude-code"
  cask 'cherry-studio'
  # Configuration manager for Claude Code, Codex, Gemini and OpenCode
  tap "farion1231/ccswitch"
  cask "farion1231/ccswitch/cc-switch"
  # cask 'comfyui'

  # [font] for code editor
  cask "font-fira-code"
  cask "font-fira-code-nerd-font"
  cask "font-fira-mono-nerd-font"
  cask "font-iosevka-nerd-font"
  cask "font-jetbrains-mono-nerd-font"
  cask "font-maple-mono"
  cask "font-maple-mono-cn"
  cask "font-maple-mono-nf"
  cask "font-maple-mono-nf-cn"
  cask "font-maple-mono-normal"
  cask "font-maple-mono-normal-cn"
  cask "font-maple-mono-normal-nf"
  cask "font-maple-mono-normal-nf-cn"
  cask "font-menlo-for-powerline"
  cask "font-meslo-lg-nerd-font"
  cask "font-monaspace"

  # [cask] dev
  cask 'iterm2'
  cask 'visual-studio-code'
  cask 'cursor'
  cask 'kiro-cli'
  # HTTP 请求调试工具
  cask 'charles'
  cask 'postman'
  # git 图形化工具
  cask 'fork'
  # docker 容器管理器
  cask 'orbstack'
  # cask 'intellij-idea'

  # [cask] productivity
  #cask 'alfred'
  cask 'google-chrome'
  cask 'arc'
  cask 'microsoft-edge@dev'
  
  # cask 'hiddenbar'
  # 键盘映射
  # cask 'karabiner-elements'
  # 压缩解压
  cask 'keka'
  # 软件清理
  cask 'pearcleaner'
  # 图片压缩
  cask 'tinypng4mac'
  # NTFS卷挂载
  cask 'mounty'
  # 快捷键
  cask 'raycast'
  # 笔记
  cask 'obsidian'
  # 博客
  cask 'gridea'
  # 翻译词典
  cask 'easydict'
  # 文件管理器
  cask 'marta'
  # 客制化键盘键盘映射编辑器
  cask 'via'
  # 窗口管理工具
  cask 'loop'

  # [cask] entertainment
  cask 'iina'

  # mas app
  # 插件
  mas "AdGuard for Safari", id: 1440147259
  mas "Octotree", id: 1457450145
  mas "Twine", id: 6451390893
  mas "沉浸式翻译", id: 6447957425
  # 工具
  mas "Bitwarden", id: 1352778147
  mas "iMazing Profile Editor", id: 1487860882
  mas "LocalSend", id: 1661733229
  mas "pap.er", id: 1639052102
  # 办公
  mas "Keynote讲演", id: 409183694
  mas "Numbers表格", id: 409203825
  mas "Pages文稿", id: 409201541
  mas "Microsoft Excel", id: 462058435
  mas "Microsoft Outlook", id: 985367838
  mas "Microsoft PowerPoint", id: 462062816
  mas "Microsoft Word", id: 462054704
  mas "WPS Office", id: 1443749478
  mas "PDFgear", id: 6469021132
  mas "Xmind", id: 1327661892
  # 沟通
  mas "腾讯会议", id: 1484048379
  mas "QQ", id: 451108668
  mas "微信", id: 836500024
  mas "企业微信", id: 1189898970
  mas "飞书", id: 1551632588
  # 网盘
  mas "百度网盘", id: 547166701
  mas "OneDrive", id: 823766827
  # 娱乐
  mas "QQ音乐", id: 595615424
end
