# dotfiles 项目统一日志格式规范

## 概述

本文档定义了 dotfiles 项目中所有脚本的统一日志输出格式和使用规范。

## 日志格式规范

### 基本格式

```
[时间戳] [级别] 消息内容
```

### 时间戳格式

```
YYYY-MM-DD HH:MM:SS
```

示例：`2025-05-24 17:56:54`

### 日志级别

| 级别 | 图标 | 颜色 | 用途 | 函数 |
|------|------|------|------|------|
| SUCCESS | ✓ | 绿色 | 成功操作 | `show_success()` |
| ERROR | ✗ | 红色 | 错误信息 | `show_error()` |
| WARNING | ! | 黄色 | 警告信息 | `show_warning()` |
| INFO | - | 蓝色 | 一般信息 | `show_info()` |
| TEST | - | 蓝色 | 测试项目 | `show_test()` |
| CHECK | - | 蓝色 | 检查项目 | `show_check()` |
| PROGRESS | - | 蓝色 | 进度信息 | `show_progress()` |
| GROUP | === | 粗体蓝色 | 分组标题 | `show_group()` |

## 配置选项

### 环境变量

```bash
# 启用/禁用日志输出
LOG_ENABLED=true|false          # 默认: true

# 显示时间戳
LOG_SHOW_TIMESTAMP=true|false   # 默认: true

# 显示日志级别
LOG_SHOW_LEVEL=true|false       # 默认: true

# 显示调用者信息（调试用）
LOG_SHOW_CALLER=true|false      # 默认: false
```

### 示例输出

#### 完整格式 (默认)
```
[2025-05-24 17:56:54] [SUCCESS] 应用配置完成
[2025-05-24 17:56:54] [ERROR] 配置文件不存在
[2025-05-24 17:56:54] [WARNING] 版本可能过低
[2025-05-24 17:56:54] [INFO] 正在安装依赖
```

#### 简化格式 (LOG_SHOW_TIMESTAMP=false, LOG_SHOW_LEVEL=false)
```
✓ 应用配置完成
✗ 配置文件不存在
! 版本可能过低
正在安装依赖
```

## 函数使用指南

### 基本日志函数

#### show_success(message)
显示成功消息，绿色 ✓ 图标
```bash
show_success "Git 配置完成"
# 输出: [2025-05-24 17:56:54] [SUCCESS] ✓ Git 配置完成
```

#### show_error(message, [exit_code])
显示错误消息，红色 ✗ 图标
```bash
show_error "文件不存在"        # 不退出
show_error "严重错误" 1        # 退出码 1
# 输出: [2025-05-24 17:56:54] [ERROR] ✗ 文件不存在
```

#### show_warning(message)
显示警告消息，黄色 ! 图标
```bash
show_warning "版本可能过低"
# 输出: [2025-05-24 17:56:54] [WARNING] ! 版本可能过低
```

#### show_info(message)
显示信息消息，蓝色
```bash
show_info "正在下载文件..."
# 输出: [2025-05-24 17:56:54] [INFO] 正在下载文件...
```

### 专用日志函数

#### show_test(message)
显示测试项目
```bash
show_test "检查 Git 配置"
# 输出: [2025-05-24 17:56:54] [TEST] 测试: 检查 Git 配置
```

#### show_check(message)
显示检查项目
```bash
show_check "验证语法"
# 输出: [2025-05-24 17:56:54] [CHECK] 检查: 验证语法
```

#### show_progress(message, [current], [total])
显示进度信息
```bash
show_progress "安装应用" 3 10
# 输出: [2025-05-24 17:56:54] [PROGRESS] [3/10] 安装应用
```

#### show_group(title)
显示分组标题
```bash
show_group "系统配置"
# 输出: 
# [2025-05-24 17:56:54] [GROUP] === 系统配置 ===
```

## 最佳实践

### 1. 消息内容规范

#### 动作描述
- 使用现在进行时：`正在安装...`、`正在配置...`
- 完成状态用过去时：`安装完成`、`配置成功`

#### 错误消息
- 明确描述问题：`配置文件 ~/.gitconfig 不存在`
- 提供解决建议：`请运行 git config --global user.name "Your Name"`

#### 警告消息
- 说明影响：`版本过低可能导致功能异常`
- 给出建议：`建议升级到 5.0+`

### 2. 日志级别选择

#### SUCCESS
- 操作成功完成
- 测试通过
- 验证成功

#### ERROR
- 操作失败
- 文件不存在
- 命令执行错误

#### WARNING
- 版本兼容性问题
- 配置不完整但不影响运行
- 性能问题提醒

#### INFO
- 操作进度
- 状态信息
- 配置详情

### 3. 代码示例

#### 标准操作流程
```bash
#!/usr/bin/env bash
source "./lib/common.sh"
init_dotfiles_env

show_info "开始配置 Git"

if command -v git >/dev/null 2>&1; then
    show_success "Git 已安装"
else
    show_error "Git 未安装，请先安装 Git"
    exit 1
fi

show_info "配置用户信息..."
if git config --global user.name "User"; then
    show_success "用户名配置完成"
else
    show_warning "用户名配置失败，请手动配置"
fi

show_success "Git 配置完成"
```

#### 测试脚本模板
```bash
#!/usr/bin/env bash
show_test "Git 配置测试开始"

check_executable "git" "检查 Git 是否安装"
check_file "$HOME/.gitconfig" "检查配置文件"

if git config --global --get user.name >/dev/null 2>&1; then
    show_success "用户名已配置"
else
    show_warning "用户名未配置"
fi

test_summary "Git 配置测试"
```

## 迁移指南

### 从文件日志迁移

#### 旧方式 (不推荐)
```bash
echo "操作成功" | tee -a "$LOG_FILE"
echo -e "${GREEN}✓ 成功${NC}" | tee -a "$LOG_FILE"
```

#### 新方式 (推荐)
```bash
show_success "操作成功"
```

### 从自定义格式迁移

#### 旧方式
```bash
echo "[$(date)] INFO: 正在处理..."
echo -e "${BLUE}[INFO]${NC} 正在处理..."
```

#### 新方式
```bash
show_info "正在处理..."
```

## 调试和故障排除

### 启用调试信息
```bash
export LOG_SHOW_CALLER=true
export LOG_SHOW_LEVEL=true
```

### 禁用颜色输出
```bash
export TERM=dumb
# 或
export NO_COLOR=1
```

### 完全禁用日志
```bash
export LOG_ENABLED=false
```

## 兼容性说明

### 终端兼容性
- 自动检测终端颜色支持
- 在不支持颜色的环境中自动降级
- 支持 CI/CD 环境

### Shell 兼容性
- bash 4.0+
- zsh 5.0+
- macOS 默认 shell

### 系统兼容性
- macOS 10.15+ (Intel/Apple Silicon)
- Linux (测试中)
- Windows WSL (测试中)

## 更新历史

- **v2.0** (2025-05-24): 统一日志格式，移除文件日志
- **v1.0** (之前): 混合文件和控制台日志
