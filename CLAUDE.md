# dotfiles

## WHAT - 技术栈与结构

- **Shell 脚本项目** (Bash 4+/Fish 4+)，面向 macOS 15+ (Apple Silicon)
- 使用 [Homebrew](https://brew.sh) 管理软件包，[rcm](https://github.com/thoughtbot/rcm) 管理 dotfiles 符号链接
- 通过 GitHub Actions CI 在 macOS 上自动化测试

| 目录 | 用途 |
|------|------|
| `app/` | 各应用的 init/test/cleanup 脚本（分组：基础工具、语言环境、开发工具） |
| `rc/` | 由 rcm 管理的 dotfiles（fish config, vimrc, tmux.conf, gitconfig 等） |
| `lib/` | 共享 Shell 库（颜色、显示、系统检测、测试工具） |
| `macOS/` | macOS 系统偏好设置脚本 |

## WHY - 目的

自动化配置全新 macOS 开发环境，包含终端 (fish/tmux/nvim)、开发语言 (Go/Rust/Ruby/Java/Node)、GPG 签名、SSH 等完整工具链。

## HOW - 开发工作流

```bash
# 全新安装（入口）
./bootstrap [--force]

# 仅配置应用（跳过 Homebrew 等基础步骤）
./app/bootstrap

# 语法检查（shellcheck）
./check

# 运行测试
./test                # 基础系统测试
./integration_test    # 完整集成测试（含性能）

# 单个应用测试
bash ./app/<app>/test
```

## 开发约定

- 所有脚本通过 `source lib/common.sh` 加载共享库
- 每个 app 目录结构：`init`（安装）、`test`（验证）、`cleanup`（可选清理）
- 幂等设计：使用 `~/.dotfiles_configured_<app>` 标记文件跳过已配置的应用
- 使用 `shellcheck -x` 做静态检查，CI 分为 lint 和 macos-test 两个 job

## 详细文档

- [命令参考](docs/agent/commands.md)
- [架构概览](docs/agent/architecture.md)
- [测试指南](docs/agent/testing.md)
- [项目约定](docs/agent/conventions.md)
