# 实用技巧

这些技巧可以让你的迁移过程更顺利，也能帮助你在未来的迁移中节省时间。

## 备份策略

### 使用外接 SSD

```bash
# 推荐使用外接 SSD 存放备份
# 优点：
# - 速度快，迁移方便
# - 即插即用
# - 可以多台 Mac 共享

# 创建备份分区
diskutil list
diskutil partitionDisk /dev/disk2 1 GPT JHFS+ "MacOS-Backup" 0
```

### iCloud Drive 同步

```bash
# 将配置文件放在 iCloud Drive
# 优点：
# - 自动同步到云端
# - 多台 Mac 自动保持一致
# - 版本历史

# 移动配置到 iCloud
mv ~/macos-migrate ~/Library/Mobile\ Documents/com~apple~CloudDocs/macos-migrate

# 创建符号链接（可选）
ln -s ~/Library/Mobile\ Documents/com~apple~CloudDocs/macos-migrate ~/macos-migrate
```

### GitHub Gist 存储小型配置

```bash
# 对于小型配置文件，可以使用 GitHub Gist
# 适合：.gitconfig、.vimrc 等单个文件

# 安装 gist CLI
gem install gist

# 上传配置到 Gist
gist ~/.gitconfig
gist ~/.vimrc

# 记录 Gist URL，方便随时恢复
```

### 定期自动备份

```bash
# 使用 launchd 创建定期备份任务
cat > ~/Library/LaunchAgents/com.user.macos-backup.plist <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.macos-backup</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/zsh</string>
        <string>-c</string>
        <string>~/macos-migrate/scripts/backup.sh</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Day</key>
        <integer>0</integer>
        <key>Hour</key>
        <integer>2</integer>
    </dict>
</dict>
</plist>
EOF

# 加载任务
launchctl load ~/Library/LaunchAgents/com.user.macos-backup.plist
```

## 多台 Mac 同步

### 使用 Git 管理配置

```bash
# 创建私有仓库存储配置
mkdir -p ~/dotfiles
cd ~/dotfiles

# 使用 bare repository 方法
git init --bare $HOME/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no

# 添加配置文件
dotfiles add .zshrc .gitconfig .vimrc
dotfiles commit -m "Initial commit"
dotfiles remote add origin https://github.com/yourusername/dotfiles.git
dotfiles push -u origin main
```

### 多台 Mac 恢复

```bash
# 在新 Mac 上
git clone --bare https://github.com/yourusername/dotfiles.git $HOME/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles checkout
dotfiles config --local status.showUntrackedFiles no
```

## 文档化你的配置

### 记录独有配置

```bash
# 创建 ~/macos-migrate/README.md 记录独有配置
cat > ~/macos-migrate/README.md <<EOF
# 我的 macOS 开发环境配置

## 特殊配置

### 公司内部工具
- 安装路径：/opt/company-tools
- 配置文件：~/.companyrc

### 自定义脚本
- 位置：~/scripts/
- 添加到 PATH：在 .zshrc 中

### 独特快捷键
- Cmd+Shift+D: 快速打开项目目录
- Cmd+Shift+R: 运行测试

## 注意事项

1. 某些配置包含敏感信息，已单独加密存储
2. 公司项目配置参考内部文档
EOF
```

### 使用注释说明

在配置文件中使用详细注释：

```bash
# ~/.zshrc

# === Node.js 配置 ===
# 使用 nvm 管理 Node 版本
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# === Python 配置 ===
# 使用 pyenv 管理 Python 版本
export PYENV_ROOT="$HOME/.pyenv"
eval "$(pyenv init -)"

# === 自定义别名 ===
# 项目快速切换
alias pwork='cd ~/Documents/code/work'
alias ppersonal='cd ~/Documents/code/personal'
```

## 性能优化

### 清理旧版本

```bash
# Homebrew 清理
brew cleanup
brew autoremove

# nvm 清理旧版本
nvm ls
nvm uninstall <old-version>

# pyenv 清理旧版本
pyenv versions
pyenv uninstall <old-version>

# Docker 清理
docker system prune -a
```

### 优化 Shell 启动速度

```bash
# 测试 .zshrc 加载时间
time zsh -i -c exit

# 如果太慢，考虑：
# 1. 延迟加载某些工具（nvm、pyenv）
# 2. 使用 lazy loading 插件
# 3. 减少不必要的插件

# 示例：nvm lazy loading
export NVM_LAZY_LOAD=true
```

## 安全建议

### 加密敏感配置

```bash
# 使用 GPG 加密敏感文件
gpg -c ~/.aws/credentials
# 输入密码，生成 ~/.aws/credentials.gpg

# 删除明文文件
shred -u ~/.aws/credentials

# 解密
gpg -d ~/.aws/credentials.gpg > ~/.aws/credentials
```

### 分离敏感信息

```bash
# 使用 include 指令分离敏感配置
cat >> ~/.gitconfig <<EOF
[include]
    path = ~/.gitconfig.local
EOF

# ~/.gitconfig.local 放在 .gitignore
cat >> .gitignore <<EOF
.gitconfig.local
.aws/
.company/
EOF
```

## 故障恢复

### 创建可启动 U 盘

```bash
# 创建 macOS 安装 U 盘
# 用于系统崩溃时恢复

# 1. 下载 macOS 安装器
# 2. 插入 8GB+ U 盘
# 3. 运行以下命令（根据 macOS 版本调整）
sudo /Applications/Install\ macOS\ Ventura.app/Contents/Resources/createinstallmedia \
  --volume /Volumes/MyVolume
```

### Time Machine 定期备份

```bash
# 配置 Time Machine 自动备份
# 系统设置 → 通用 → 时间机器

# 查看备份状态
tmutil listlocalsnapshots /
```

## 社区资源

### 参考别人的 dotfiles

- GitHub 搜索 "dotfiles" 学习最佳实践
- 但不要直接复制，要理解每个配置的作用

### 参与讨论

- r/MacOS Reddit 社区
- macOS 开发者微信群
- Stack Overflow macOS 标签

## 持续改进

### 定期审查配置

```bash
# 每半年审查一次
# - 删除不再使用的工具
# - 更新过时的配置
# - 记录新发现的技巧
```

### 分享你的经验

```bash
# 将你的配置开源（注意移除敏感信息）
# 帮助其他开发者
```

## 相关文档

- [迁移后检查清单](/post-migration/checklist)
- [自动化脚本](/scripts)
- [配置文件备份](/config/dotfiles)

---

**总结**：迁移不是一次性任务，而是持续优化的过程。定期备份、记录配置、分享经验，让未来的迁移更加轻松。
