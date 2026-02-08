# 项目约定

## 脚本编写规范

- Shebang 行统一使用 `#!/usr/bin/env bash`
- 所有脚本通过 `source lib/common.sh` 或 `source "$PROJECT_ROOT/lib/common.sh"` 加载共享库
- 调用 `init_dotfiles_env` 或 `init_test_env` 初始化环境
- 面向 macOS 15+ (Apple Silicon)

## 幂等性设计

- 全局标记：`~/.dotfiles_bootstrapped` 标记 bootstrap 完成
- 应用标记：`~/.dotfiles_configured_<app>` 标记单个应用配置完成
- `--force` 参数清除标记并重新执行
- 所有操作在重复执行时安全跳过

## 应用目录结构

```
app/<name>/
├── init      # 安装脚本（可选）
├── test      # 测试脚本（验证安装结果）
└── cleanup   # 清理脚本（可选）
```

- 脚本无扩展名，通过 `bash ./app/<name>/init` 执行
- init 脚本在 `app/bootstrap` 中按分组顺序调用
- test 脚本既被 `app/bootstrap` 调用，也可独立运行

## 显示输出约定

使用共享库的 `show_*` 函数替代 echo：
- `show_info` - 蓝色信息
- `show_success` - 绿色成功
- `show_error` - 红色错误（第二参数为 0 时不退出）
- `show_warning` - 黄色警告
- `show_progress` - 进度条显示
- `show_group` - 分组标题
- `show_check` / `show_test` - 检查/测试项标题

## shellcheck 集成

- 所有脚本必须通过 `shellcheck -x` 检查
- 使用 `# shellcheck source=./path` 注释提示跨文件 source
- 使用 `# shellcheck disable=SC2034` 等注释抑制已知误报
- CI 中的 lint job 强制执行检查

## Git 约定

- 主分支名为 `self`（非 main/master）
- 提交消息使用 Conventional Commits 风格（如 `docs(vim):`, `refactor(app/gpg):`, `chore(brew):`）
- GPG 签名默认启用（gitconfig 中 `gpgsign = true`）
- CI 跳过标记：提交消息包含 `[ci skip]`
