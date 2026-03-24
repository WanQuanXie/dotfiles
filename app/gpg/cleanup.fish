#!/usr/bin/env fish

echo "===== GPG 密钥清理工具 ====="
echo "此脚本将删除 GPG 密钥并重置 Git GPG 签名设置"
echo ""

# 检查是否存在 GPG 密钥
if ! command -v gpg &> /dev/null
    echo "错误：未找到 GPG 命令"
    exit 1
end

# 获取当前配置的 Git 签名密钥
set -l CURRENT_KEY_ID (git config --global user.signingkey)

if test -z "$CURRENT_KEY_ID"
    echo "未找到已配置的 Git GPG 签名密钥"

    # 检查是否有任何 GPG 密钥
    set -l GPG_KEYS (gpg --list-secret-keys --keyid-format=long 2>/dev/null)

    if test -z "$GPG_KEYS"
        echo "未找到任何 GPG 密钥"
        echo "无需执行清理操作"
        exit 0
    else
        echo "找到以下 GPG 密钥："
        gpg --list-secret-keys --keyid-format=long

        echo ""
        echo "请输入要删除的 GPG 密钥 ID（长格式，例如：3B1C6D0A9D0A9D0A）："
        read -l KEY_ID

        if test -z "$KEY_ID"
            echo "未提供密钥 ID，操作取消"
            exit 1
        end
    end
else
    set -l KEY_ID "$CURRENT_KEY_ID"
    echo "找到已配置的 Git GPG 签名密钥：$KEY_ID"
end

# 显示密钥详情
echo ""
echo "将删除以下 GPG 密钥："
if ! gpg --list-secret-keys --keyid-format=long "$KEY_ID" 2>/dev/null
    echo "错误：无法找到指定的 GPG 密钥 $KEY_ID"
    exit 1
end

# 确认删除
echo ""
echo "警告：此操作将删除 GPG 密钥并重置 Git GPG 签名设置"
echo "请确认是否继续 (y/n)："
read -l CONFIRM

if test "$CONFIRM" != "y"; and test "$CONFIRM" != "Y"
    echo "操作已取消"
    exit 0
end

echo ""
echo "正在执行清理操作..."

# 1. 删除 GPG 密钥（公钥和私钥）
echo "1. 删除 GPG 密钥..."

# 创建临时文件存储错误信息
set -l ERROR_LOG (mktemp)

# 检查密钥是否存在并获取完整指纹
echo "   检查密钥 $KEY_ID 是否存在..."

# 获取完整的指纹
set -l FINGERPRINT (gpg --list-keys --with-colons "$KEY_ID" 2>/dev/null | grep "^fpr" | head -n 1 | cut -d: -f10)

if test -z "$FINGERPRINT"
    echo "   警告: 公钥不存在，无需删除"
    set -l PUBLIC_KEY_EXISTS 0
else
    set -l PUBLIC_KEY_EXISTS 1
    echo "   找到公钥，指纹: $FINGERPRINT"
end

# 检查私钥是否存在
if ! gpg --list-secret-keys "$KEY_ID" > /dev/null 2>&1
    echo "   警告: 私钥不存在，无需删除"
    set -l SECRET_KEY_EXISTS 0
else
    set -l SECRET_KEY_EXISTS 1
    echo "   找到私钥"
end

# 如果两种密钥都不存在，则直接继续
if test $PUBLIC_KEY_EXISTS -eq 0; and test $SECRET_KEY_EXISTS -eq 0
    echo "   信息: 没有找到需要删除的密钥"
    rm -f "$ERROR_LOG"
    echo "   继续执行其他清理操作..."
end

# 正确的删除顺序：先尝试删除公钥，如果失败且存在私钥，则先删除私钥再删除公钥
set -l PUBLIC_KEY_DELETED 0
set -l SECRET_KEY_DELETED 0

# 如果存在公钥，尝试直接删除
if test $PUBLIC_KEY_EXISTS -eq 1
    echo "   尝试删除公钥..."
    gpg --batch --yes --delete-keys "$KEY_ID" 2> "$ERROR_LOG"
    set -l PUBLIC_KEY_DELETED $status

    if test $PUBLIC_KEY_DELETED -ne 0
        echo "   警告: 直接删除公钥失败，可能需要先删除私钥"
        echo "   错误信息: "(cat "$ERROR_LOG")
    else
        echo "   公钥删除成功"
    end
end

# 如果公钥删除失败且存在私钥，则先删除私钥
if test $PUBLIC_KEY_DELETED -ne 0; and test $SECRET_KEY_EXISTS -eq 1
    echo "   尝试使用指纹删除私钥..."

    if test -z "$FINGERPRINT"
        echo "   错误: 无法获取密钥指纹，无法删除私钥"
        set -l SECRET_KEY_DELETED 1
    else
        echo "   使用指纹: $FINGERPRINT"
        gpg --batch --yes --delete-secret-keys "$FINGERPRINT" 2> "$ERROR_LOG"
        set -l SECRET_KEY_DELETED $status

        if test $SECRET_KEY_DELETED -ne 0
            echo "   错误: 私钥删除失败"
            echo "   错误信息: "(cat "$ERROR_LOG")

            # 尝试使用另一种方式删除私钥
            echo "   尝试使用替代方法删除私钥..."
            gpg --batch --yes --delete-secret-key "$FINGERPRINT!" 2> "$ERROR_LOG"
            set -l SECRET_KEY_DELETED $status

            if test $SECRET_KEY_DELETED -ne 0
                echo "   错误: 替代方法也失败了"
                echo "   错误信息: "(cat "$ERROR_LOG")
            else
                echo "   使用替代方法成功删除私钥"
            end
        else
            echo "   私钥删除成功"
        end

        # 私钥删除成功后，再次尝试删除公钥
        if test $SECRET_KEY_DELETED -eq 0; and test $PUBLIC_KEY_EXISTS -eq 1
            echo "   再次尝试删除公钥..."
            gpg --batch --yes --delete-keys "$FINGERPRINT" 2> "$ERROR_LOG"
            set -l PUBLIC_KEY_DELETED $status

            if test $PUBLIC_KEY_DELETED -ne 0
                echo "   错误: 公钥删除失败"
                echo "   错误信息: "(cat "$ERROR_LOG")
            else
                echo "   公钥删除成功"
            end
        end
    end
# 如果不存在公钥但存在私钥，直接删除私钥
else if test $SECRET_KEY_EXISTS -eq 1
    echo "   尝试使用指纹删除私钥..."

    if test -z "$FINGERPRINT"
        echo "   错误: 无法获取密钥指纹，无法删除私钥"
        set -l SECRET_KEY_DELETED 1
    else
        echo "   使用指纹: $FINGERPRINT"
        gpg --batch --yes --delete-secret-keys "$FINGERPRINT" 2> "$ERROR_LOG"
        set -l SECRET_KEY_DELETED $status

        if test $SECRET_KEY_DELETED -ne 0
            echo "   错误: 私钥删除失败"
            echo "   错误信息: "(cat "$ERROR_LOG")

            # 尝试使用另一种方式删除私钥
            echo "   尝试使用替代方法删除私钥..."
            gpg --batch --yes --delete-secret-key "$FINGERPRINT!" 2> "$ERROR_LOG"
            set -l SECRET_KEY_DELETED $status

            if test $SECRET_KEY_DELETED -ne 0
                echo "   错误: 替代方法也失败了"
                echo "   错误信息: "(cat "$ERROR_LOG")
            else
                echo "   使用替代方法成功删除私钥"
            end
        else
            echo "   私钥删除成功"
        end
    end
end

# 清理临时文件
rm -f "$ERROR_LOG"

# 最终结果判断
set -l PUBLIC_SUCCESS 0
set -l SECRET_SUCCESS 0

if test $PUBLIC_KEY_EXISTS -eq 1; and test $PUBLIC_KEY_DELETED -eq 0
    set -l PUBLIC_SUCCESS 1
else if test $PUBLIC_KEY_EXISTS -eq 0; and test $PUBLIC_KEY_DELETED -eq 0
    set -l PUBLIC_SUCCESS 1
end

if test $SECRET_KEY_EXISTS -eq 1; and test $SECRET_KEY_DELETED -eq 0
    set -l SECRET_SUCCESS 1
else if test $SECRET_KEY_EXISTS -eq 0; and test $SECRET_KEY_DELETED -eq 0
    set -l SECRET_SUCCESS 1
end

if test $PUBLIC_SUCCESS -eq 1; and test $SECRET_SUCCESS -eq 1
    echo "GPG 密钥删除成功"
else
    echo "GPG 密钥删除过程中遇到问题，请检查上述错误信息"
end

# 2. 移除 Git 全局配置中的 user.signingkey 设置
echo "2. 移除 Git 全局配置中的 user.signingkey 设置..."
if git config --global --unset user.signingkey
    echo "Git user.signingkey 设置已移除"
else
    echo "Git user.signingkey 设置移除失败"
end

# 3. 将 Git 全局配置中的 commit.gpgsign 设置为 false
echo "3. 将 Git 全局配置中的 commit.gpgsign 设置为 false..."
if git config --global commit.gpgsign false
    echo "Git commit.gpgsign 已设置为 false"
else
    echo "Git commit.gpgsign 设置失败"
end

# 4. 移除 Git 全局配置中的 gpg.program 设置
echo "4. 移除 Git 全局配置中的 gpg.program 设置..."
if git config --global --unset gpg.program
    echo "Git gpg.program 设置已移除"
else
    echo "Git gpg.program 设置移除失败"
end

# 5. 验证 GPG 密钥已成功删除和 Git 配置已成功重置
echo ""
echo "===== 验证清理结果 ====="

# 验证 GPG 密钥是否已删除
echo "验证 GPG 密钥删除状态："

# 使用指纹或密钥 ID 验证
if test -n "$FINGERPRINT"
    if gpg --list-secret-keys --keyid-format=long "$FINGERPRINT" 2>/dev/null
        echo "错误: GPG 密钥仍然存在（通过指纹验证）"
    else
        echo "GPG 密钥已成功删除（通过指纹验证）"
    end
else
    if gpg --list-secret-keys --keyid-format=long "$KEY_ID" 2>/dev/null
        echo "错误: GPG 密钥仍然存在（通过密钥 ID 验证）"
    else
        echo "GPG 密钥已成功删除（通过密钥 ID 验证）"
    end
end

# 验证 Git 配置是否已重置
echo ""
echo "验证 Git 配置重置状态："

set -l SIGNING_KEY (git config --global user.signingkey)
set -l GPG_SIGN (git config --global commit.gpgsign)
set -l GPG_PROGRAM (git config --global gpg.program)

if test -z "$SIGNING_KEY"
    echo "Git user.signingkey 已成功移除"
else
    echo "错误: Git user.signingkey 仍然存在：$SIGNING_KEY"
end

if test "$GPG_SIGN" = "false"
    echo "Git commit.gpgsign 已成功设置为 false"
else
    echo "错误: Git commit.gpgsign 设置不正确：$GPG_SIGN"
end

if test -z "$GPG_PROGRAM"
    echo "Git gpg.program 已成功移除"
else
    echo "错误: Git gpg.program 仍然存在：$GPG_PROGRAM"
end

echo ""
echo "GPG 密钥清理操作已完成"
