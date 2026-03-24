# 命令参考

## 主入口脚本

| 命令 | 说明 |
|------|------|
| `./bootstrap` | 完整安装：Homebrew → brew bundle → 工作目录 → rcm 符号链接 → 应用配置 → 测试 |
| `./bootstrap --force` | 清除 `~/.dotfiles_bootstrapped` 标记后重新执行 |
| `./app/bootstrap` | 仅运行应用配置（分 3 组顺序执行） |
| `./check` | shellcheck 语法检查所有脚本 |
| `./test` | 系统级测试（主机名、软件包、目录、符号链接） |
| `./integration_test` | 集成测试（系统 + 应用 + 兼容性 + 性能） |

## 单个应用操作

```bash
# 初始化（部分应用有 init 脚本）
bash ./app/<app>/init

# 测试
bash ./app/<app>/test

# 清理（目前仅 gpg 有）
bash ./app/gpg/cleanup
```

## 应用分组

**第 1 组 - 基础工具**（快速）: fish, git, ssh, gpg, starship

**第 2 组 - 语言环境**（耗时）: go, rust, ruby, java, node

**第 3 组 - 开发工具**（依赖前两组）: vim, nvim, tmux, fzf, VSCode

## Homebrew 管理

```bash
# 安装 Brewfile 中所有包
brew bundle

# 查看 Brewfile（CI 模式跳过非基础包）
cat Brewfile
```

## rcm dotfiles 管理

```bash
# 安装符号链接（从 rc/ 目录）
rcup -d ./rc -f

# 查看已管理的文件
lsrc -d ./rc
```

## macOS 系统设置

```bash
bash ./macOS/settings
```
