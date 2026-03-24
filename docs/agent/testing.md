# 测试指南

## 测试层次

### 1. 语法检查 (`./check`)

使用 `shellcheck -x` 检查所有脚本语法：
- 入口脚本：bootstrap, test, check, app/bootstrap
- 应用脚本：app/*/init, app/*/test, app/*/cleanup
- RC 文件：rc/bash_profile
- 系统脚本：macOS/settings

输出统计：总脚本数、通过数、失败数。

### 2. 系统测试 (`./test`)

验证基础系统配置：
- 主机名是否正确（期望 `xiewq-macbookpro`）
- 必要软件已安装（git, nvim）
- 工作目录已创建（~/workspace/dev, ~/workspace/work）
- rcm 符号链接正确（~/.config/fish/config.fish, ~/.gitconfig）

### 3. 集成测试 (`./integration_test`)

完整测试套件：
- 系统配置测试（调用 `./test`）
- 应用测试（遍历所有 app/*/test）
- 集成功能测试（Git+GPG、FZF+Fish 等工具联动）
- 性能测试（Fish 启动时间，<1000ms 为良好）

### 4. 单个应用测试

```bash
bash ./app/fish/test  # 测试 fish 配置
bash ./app/git/test   # 测试 git 配置
bash ./app/gpg/test    # 测试 gpg 配置
# ... 其他应用同理
```

## 有测试的应用

bash, fish, fzf, git, go, gpg, java, MavenDaemon, node, nvim, ruby, rust, sdkman, ssh, tmux, vim, VSCode

## 测试框架

测试使用 `lib/testing.sh` 提供的函数：
- `init_test_env "<suite_name>"` - 初始化测试环境
- `show_test "<description>"` - 显示测试项
- `show_success "<message>"` / `show_error "<message>"` - 结果输出

## CI 测试

GitHub Actions 在 push 到 `self` 分支时自动触发：
- **lint job**: ubuntu-latest 上运行 `./check`
- **macos-test job**: macos-latest 上运行完整 bootstrap + test + 验证
