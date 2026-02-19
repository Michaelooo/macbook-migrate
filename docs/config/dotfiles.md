# 配置文件备份

dotfiles（以点开头的配置文件）是 Unix/Linux 系统中存储用户配置的地方，备份这些文件可以快速恢复你的工作环境。

## 核心配置文件

### 必须备份的配置

```bash
# 创建备份目录
mkdir -p ~/macos-migrate/config

# Shell 配置
cp ~/.zshrc ~/macos-migrate/config/
cp ~/.zprofile ~/macos-migrate/config/
cp ~/.bash_profile ~/macos-migrate/config/ 2>/dev/null || true
cp ~/.bashrc ~/macos-migrate/config/ 2>/dev/null || true

# Git 配置
cp ~/.gitconfig ~/macos-migrate/config/
cp ~/.gitignore_global ~/macos-migrate/config/ 2>/dev/null || true

# SSH 密钥（重要！）
cp -r ~/.ssh ~/macos-migrate/config/

# NPM 配置
cp ~/.npmrc ~/macos-migrate/config/ 2>/dev/null || true

# Vim/Neovim 配置
cp ~/.vimrc ~/macos-migrate/config/ 2>/dev/null || true
cp -r ~/.vim ~/macos-migrate/config/ 2>/dev/null || true
cp -r ~/.config/nvim ~/macos-migrate/config/nvim-config 2>/dev/null || true

# Tmux 配置
cp ~/.tmux.conf ~/macos-migrate/config/ 2>/dev/null || true
```

## SSH 密钥备份

::: warning 安全提醒
SSH 私钥非常敏感，备份时请确保：
1. 不要上传到公开仓库
2. 使用加密存储
3. 传输时使用加密方式
:::

### 备份 SSH 密钥

```bash
# 备份整个 .ssh 目录
cp -r ~/.ssh ~/macos-migrate/config/

# 检查权限
ls -la ~/macos-migrate/config/.ssh/

# 应该包含：
# id_rsa / id_ed25519 - 私钥
# id_rsa.pub / id_ed25519.pub - 公钥
# config - SSH 配置
# known_hosts - 已知主机
```

### 新机器恢复

```bash
# 复制 SSH 配置
cp -r ~/macos-migrate/config/.ssh ~/

# 设置正确权限（重要！）
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub
chmod 600 ~/.ssh/config

# 测试 SSH 连接
ssh -T git@github.com
```

## Git 配置

### 备份 Git 配置

```bash
# 备份 .gitconfig
cp ~/.gitconfig ~/macos-migrate/config/

# 查看配置内容
cat ~/.gitconfig
```

### .gitconfig 示例

```ini
[user]
    name = Your Name
    email = your.email@example.com

[github]
    user = username

[gitlab]
    user = username

[credential]
    helper = osxkeychain
    # 或
    # helper = store

[alias]
    st = status
    co = checkout
    br = branch
    ci = commit
    unstage = reset HEAD --
    last = log -1 HEAD

[core]
    excludesfile = ~/.gitignore_global
    editor = vim

[init]
    defaultBranch = main
```

### 新机器恢复

```bash
# 复制配置
cp ~/macos-migrate/config/.gitconfig ~/

# 重新配置 GPG 签名（如果有）
git config --global user.signingkey YOUR_GPG_KEY_ID
git config --global commit.gpgsign true

# 重新配置 Personal Access Token
# 需要手动在 GitHub/GitLab 生成并更新
```

## Shell 配置

### .zshrc 关键内容

```bash
# ~/.zshrc 关键配置示例

# Homebrew
if [[ "$(uname -m)" == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# 自定义别名
alias ll='ls -la'
alias gs='git status'
alias gp='git push'

# 环境变量
export EDITOR=vim
export LANG=zh_CN.UTF-8

# 自定义函数
mkcd() {
    mkdir -p "$1" && cd "$1"
}
```

## 使用 Git 管理 dotfiles

推荐使用 GitHub 私有仓库或 bare repository 方法管理 dotfiles。

### 方法一：直接仓库

```bash
# 创建 dotfiles 仓库
mkdir -p ~/dotfiles
cd ~/dotfiles
git init

# 添加配置文件
cp ~/.zshrc .
cp ~/.gitconfig .
cp -r ~/.ssh .
cp ~/.vimrc .

git add .
git commit -m "Initial dotfiles"
git remote add origin https://github.com/yourusername/dotfiles.git
git push -u origin main
```

### 方法二：Bare Repository（推荐）

```bash
# 创建 bare repository
git init --bare $HOME/.dotfiles

# 创建 alias 管理配置
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# 配置忽略文件
dotfiles config --local status.showUntrackedFiles no

# 添加配置文件
dotfiles status
dotfiles add .zshrc .gitconfig .vimrc
dotfiles commit -m "Initial"
dotfiles remote add origin https://github.com/yourusername/dotfiles.git
dotfiles push
```

### 新机器恢复

```bash
# 克隆 bare repository
git clone --bare https://github.com/yourusername/dotfiles.git $HOME/.dotfiles

# 定义 alias
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# 恢复配置
dotfiles checkout
dotfiles config --local status.showUntrackedFiles no
```

## 高级技巧

### 条件配置

在 .zshrc 中根据机器加载不同配置：

```bash
# 检测机器类型
if [[ "$(hostname)" == "work-mac" ]]; then
    source ~/.zshrc.work
else
    source ~/.zshrc.personal
fi
```

### 敏感信息分离

```bash
# .gitconfig 不要包含敏感信息
# 使用 include 指令

[include]
    path = ~/.gitconfig.local

# ~/.gitconfig.local 放在 .gitignore 中
# 包含敏感信息如公司邮箱、token 等
```

### 使用 GNU Stow

```bash
# 安装 Stow
brew install stow

# 目录结构
~/dotfiles/
├── zsh/
│   └── .zshrc
├── vim/
│   └── .vimrc
└── git/
    └── .gitconfig

# 使用 Stow 创建符号链接
cd ~/dotfiles
stow zsh
stow vim
stow git

# 新机器恢复
git clone https://github.com/yourusername/dotfiles.git
cd dotfiles
stow zsh vim git
```

## 相关文档

- [VS Code 设置](/config/vscode)
- [数据迁移清单](/config/data-checklist)
- [自动化脚本](/scripts)
