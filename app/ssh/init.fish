#!/usr/bin/env fish

include lib/init

echo "Setup SSH"
mkdir -p ~/.ssh
cp ./app/ssh/config ~/.ssh/config
chmod 600 ~/.ssh/config

# 检查是否已存在密钥
if not test -f ~/.ssh/id_ed25519
    ssh-keygen -t ed25519 -C "i2cherry941219@gmail.com" -f ~/.ssh/id_ed25519 -N ""
else
    echo "SSH key already exists, skipping generation"
end

# 确保 ssh-agent 正在运行
eval (ssh-agent -s)

# 添加密钥到 ssh-agent 并存储密码到钥匙串
ssh-add --apple-use-keychain ~/.ssh/id_ed25519

# 复制公钥到剪贴板
pbcopy < ~/.ssh/id_ed25519.pub
echo "Public key copied to clipboard. Please add it to your GitHub account." # 请将公钥添加到 GitHub 账号
echo "Visit: https://github.com/settings/keys to add your key" # 访问 https://github.com/settings/keys 添加公钥

# 测试连接到 GitHub (脚本不做测试，待用户配置 ssh key 到 GitHub 账号后再手动测试)
# echo "Testing connection to GitHub..."
# ssh -T git@github.com -o StrictHostKeyChecking=accept-new || true

# 添加到 fish 配置文件以确保 SSH agent 在登录时启动
set -l FISH_CONFIG "$HOME/.config/fish/config.fish"

# 确保 fish 配置目录存在
mkdir -p "$HOME/.config/fish"

if not grep -q "ssh-agent" "$FISH_CONFIG" 2>/dev/null
    echo "Adding SSH agent startup to ~/.config/fish/config.fish"
    # 使用 printf 代替 heredoc
    printf '\n# Start SSH agent\nif test -z "$SSH_AUTH_SOCK"\n    eval (ssh-agent -c) > /dev/null\n    ssh-add --apple-use-keychain ~/.ssh/id_ed25519 2>/dev/null\nend\n' >> "$FISH_CONFIG"
end

echo "SSH setup completed"
