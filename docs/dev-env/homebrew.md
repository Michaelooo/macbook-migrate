# Homebrew

Homebrew 是 macOS 上最流行的包管理器，管理开发工具和应用程序。

## 备份已安装的包

### 导出 Brewfile

```bash
# 导出所有已安装的包和 cask
brew bundle dump --file=~/macos-migrate/pkg/Brewfile --describe --force

# 查看生成的 Brewfile
cat ~/macos-migrate/pkg/Brewfile
```

### Brewfile 示例

```ruby
# Brewfile 示例
tap "homebrew/cask-fonts"
tap "homebrew/services"

# 命令行工具
brew "git"
brew "vim"
brew "wget"
brew "curl"
brew "ffmpeg"

# 开发工具
brew "node"
brew "python"
brew "go"
brew "rust"

# 数据库
brew "mysql"
brew "postgresql"
brew "redis"
brew "mongodb"

# 实用工具
brew "jq"
brew "tree"
brew "htop"
brew "ripgrep"
brew "fd"

# 图形应用
cask "visual-studio-code"
cask "iterm2"
cask "docker"
cask "postman"
cask "tableplus"
cask "figma"
```

## 新机器恢复

### 安装 Homebrew

```bash
# 在新 Mac 上安装 Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 安装完成后，配置环境变量（Apple Silicon Mac）
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### 从 Brewfile 恢复

```bash
# 从 Brewfile 一键安装所有包
brew bundle --file=~/macos-migrate/pkg/Brewfile

# 只安装 brew 命令行工具（不安装 cask）
brew bundle --file=~/macos-migrate/pkg/Brewfile --no-vscode

# 验证安装
brew list
brew list --cask
```

## 高级用法

### 分类管理

如果你有大量包，可以创建多个 Brewfile：

```bash
# 目录结构
~/macos-migrate/pkg/brew/
├── Brewfile              # 全部包
├── Brewfile.cli          # 命令行工具
├── Brewfile.dev          # 开发工具
├── Brewfile.gui          # 图形应用
└── Brewfile.languages    # 编程语言

# 分别导出
brew bundle dump --file=~/macos-migrate/pkg/brew/Brewfile --describe
# 手动编辑分类文件...

# 分批安装
brew bundle --file=~/macos-migrate/pkg/brew/Brewfile.cli
brew bundle --file=~/macos-migrate/pkg/brew/Brewfile.dev
```

### 定期同步

```bash
# 创建 cron 任务定期更新 Brewfile
# 编辑 crontab
crontab -e

# 添加每周日凌晨 2 点自动更新
0 2 * * 0 brew bundle dump --file=~/macos-migrate/pkg/Brewfile --describe --force
```

## 常见问题

### Q: 迁移后某些应用无法启动？

::: tip 解决方案
某些应用（如 Docker、MySQL）首次启动需要额外配置：

```bash
# Docker Desktop
open -a Docker

# MySQL
brew services start mysql
mysql_secure_installation
```
:::

### Q: cask 应用安装失败？

```bash
# 某些 cask 可能需要从 App Store 安装
# 检查 cask 是否仍然可用
brew info --cask <app-name>

# 手动从 App Store 搜索安装
```

### Q: Apple Silicon 兼容性？

```bash
# 检查哪些包是原生支持
brew info --arch arm64 <formula>

# 某些包可能需要通过 Rosetta 2 运行
# 安装 Rosetta 2
softwareupdate --install-rosetta
```

## 最佳实践

1. **定期清理不再使用的包**
   ```bash
   brew cleanup
   brew autoremove
   ```

2. **保持 Brewfile 版本控制**
   ```bash
   cd ~/macos-migrate
   git add pkg/Brewfile
   git commit -m "Update Brewfile"
   ```

3. **使用 Brewfile 描述功能**
   ```ruby
   # 添加注释说明每个包的用途
   brew "ffmpeg", desc: "视频处理工具"
   brew "imagemagick", desc: "图像处理库"
   ```

## 相关文档

- [Node.js / nvm 迁移](/dev-env/nodejs)
- [Python / pyenv 迁移](/dev-env/python)
- [全局包管理](/dev-env/global-packages)
