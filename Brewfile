# primitives
brew 'git'
brew 'rcm'
# lua 包管理器, 安装 vim 的 lua 插件模块需要
brew 'luarocks'
brew 'neovim'
brew 'zsh'
brew 'zsh-completions'
brew 'zsh-syntax-highlighting'
# 终端主题
brew 'starship'
brew 'tmux'
# 命令行版的 finder
brew 'fzf'

# [brew] dev
brew 'ruby'
brew 'go'
brew 'shellcheck' # for CI checks
# dev: CI testing
if ENV.key? 'CI'
  puts 'In CI mode, skip non-primitive brews'
else
  # [brew] dev
  brew 'cmake'
  brew 'pnpm'
  tap 'oven-sh/bun'
  brew 'oven-sh/bun/bun'
  # JDK 版本管理
  brew 'jenv'
  brew 'maven'
  brew 'watchman'
  brew 'nginx'
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
  brew 'mas'
  # 带语法高亮的 cat 指令
  brew 'bat'
  # 带语法高亮的 ls 指令
  brew 'eza'
  # 高级版 cd 指令，会记住你最常使用的目录
  brew 'zoxide'
  brew 'htop'
  # Terminal JSON viewer & processor
  # brew 'fx'
  # brew 'pandoc'
  # 密码管理工具命令行
  brew 'bitwarden-cli'

  # [brew] for AI&AIGC
  brew 'ollama'

  # [font] for code editor
  cask 'font-menlo-for-powerline'
  cask 'font-iosevka-nerd-font'
  cask 'font-meslo-lg-nerd-font'
  cask 'font-monaspace'
  cask 'font-jetbrains-mono-nerd-font'
  cask 'font-fira-code-nerd-font'
  cask 'font-fira-mono-nerd-font'
  cask 'font-fira-code'
  cask 'font-maple-mono-nf-cn'
  cask 'font-maple-mono-normal-nf-cn'

  # [cask] dev
  cask 'iterm2'
  cask 'visual-studio-code'
  cask 'cursor'
  cask 'oracle-jdk@17'
  # 命令行智能提示
  cask 'amazon-q'
  # HTTP 请求调试工具
  cask 'charles'
  cask 'postman'
  # git 图形化工具
  cask 'fork'
  # docker 容器管理器
  cask 'orbstack'
  cask 'intellij-idea'

  # [cask] productivity
  #cask 'alfred'
  cask 'google-chrome'
  cask 'arc'
  cask 'microsoft-edge@dev'
  # cask 'hiddenbar'
  # 键盘映射
  cask 'karabiner-elements'
  cask 'google-trends'
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
  cask 'feishu'
  cask 'tencent-meeting'

  # [cask] AI & AIGC
  cask 'cherry-studio'
  cask 'comfyui'


  # [cask] entertainment
  cask 'iina'
  cask 'qqmusic'

  # mas app
  mas 'Pages', id: 409201541
  mas 'Numbers', id: 409203825
  mas 'Keynote', id: 409183694
  mas 'Microsoft Word', id: 462054704
  mas 'Microsoft Excel', id: 462058435
  mas 'Microsoft PowerPoint', id: 462062816
  mas 'Microsoft Outlook', id: 985367838
  mas 'WPS', id: 1443749478
  mas 'WeChat', id: 836500024
  mas 'QQ', id: 451108668
  mas '剪映专业版', id: 1529999940
  # 局域网文件传输
  mas 'LocalSend', id: 1661733229
  # 密码管理工具
  mas 'Bitwarden', id: 1352778147
  # Swift官网文档翻译插件
  mas 'Twine', id: 6451390893
  # PDF阅读器
  mas 'PDFgear', id: 6469021132
  # 壁纸软件
  mas 'APTV', id: 1639052102
  mas 'iMazing Profile Editor', id: 1487860882
  # mas 'Xcode', id: 497799835
end
