# 语言环境
set -gx LANG en_US.UTF-8

# 编辑器
set -gx EDITOR nvim

# bat 主题
set -gx BAT_THEME Nord

# GPG
set -gx GPG_TTY (tty)

# Electron 镜像
set -gx ELECTRON_MIRROR "https://npmmirror.com/mirrors/electron/"

# Flutter 镜像
set -gx PUB_HOSTED_URL "https://pub.flutter-io.cn"
set -gx FLUTTER_STORAGE_BASE_URL "https://storage.flutter-io.cn"
set -gx NO_PROXY "localhost,127.0.0.1,::1"

# Ollama
set -gx OLLAMA_MAX_LOADED_MODELS 0
set -gx OLLAMA_NUM_PARALLEL 0
