# 架构概览

## 执行流程

```
bootstrap (入口)
├── lib/common.sh (加载共享库)
├── Homebrew 安装/更新
├── brew bundle (Brewfile)
├── 工作目录创建
├── rcup (rc/ → ~/.*) 符号链接
├── app/bootstrap (应用配置)
│   ├── group1: zsh, git, ssh, gpg, starship
│   ├── group2: go, rust, ruby, java, node
│   └── group3: vim, nvim, tmux, fzf, VSCode
└── test (验证)
```

## 共享库 (lib/)

`lib/common.sh` 是主加载器，按顺序加载以下模块：

| 模块 | 职责 |
|------|------|
| `colors.sh` | ANSI 颜色变量定义 |
| `display.sh` | 显示函数：show_info/success/error/warning/progress/group/check/test |
| `system.sh` | 系统检测（macOS 版本/架构）、环境变量设置、日志记录 |
| `testing.sh` | 测试框架：init_test_env、兼容性测试、POSIX 测试 |

通过 `DOTFILES_COMMON_LOADED` 环境变量防止重复加载。

## 应用目录约定 (app/)

每个应用目录 `app/<name>/` 可包含：

- `init` - 初始化脚本（安装和配置）
- `test` - 验证脚本（检查安装是否成功）
- `cleanup` - 清理脚本（可选，用于卸载）

应用通过 `~/.dotfiles_configured_<app>` 标记文件实现幂等。

## RC 文件 (rc/)

由 rcm 管理，`rcup -d ./rc -f` 会将 `rc/` 下的文件链接到 `~/` 对应的 dotfile：

- `rc/zshrc` → `~/.zshrc`
- `rc/vimrc` → `~/.vimrc`
- `rc/tmux.conf` → `~/.tmux.conf`
- `rc/gitconfig` → `~/.gitconfig`
- `rc/config/nvim/` → `~/.config/nvim/`
- `rc/config/karabiner/` → `~/.config/karabiner/`

## CI 流程

`.github/workflows/ci.yml` 定义两个 Job：

1. **lint** (ubuntu-latest) - shellcheck 检查所有脚本
2. **macos-test** (macos-latest) - 完整 bootstrap + 测试 + 验证

触发条件：push 到 `self` 分支或 PR。
