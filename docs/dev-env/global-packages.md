# 全局包管理

除了编程语言的包管理器，开发环境还有各种全局工具和 CLI 需要迁移。

## 语言无关的全局工具

### Go 工具

```bash
# 导出已安装的 Go 包
ls -la $GOPATH/bin > ~/macos-migrate/pkg/go-binaries.txt 2>/dev/null || ls -la ~/go/bin > ~/macos-migrate/pkg/go-binaries.txt

# 或通过 go list
go list -m all > ~/macos-migrate/pkg/go-modules.txt

# 新机器恢复
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install github.com/air-verse/air@latest
# ... 其他 Go 工具
```

### Ruby gems

```bash
# 导出全局 gems
gem list > ~/macos-migrate/pkg/gem-list.txt

# 新机器恢复
gem install $(cat ~/macos-migrate/pkg/gem-list.txt | awk '{print $1}')
```

### Rust cargo

```bash
# 导出已安装的 crates
cargo install --list > ~/macos-migrate/pkg/cargo-list.txt

# 新机器恢复（需要手动安装）
cargo install ripgrep fd-find bat exa
# ... 其他 Rust 工具
```

## 开发工具 CLI

### Git 相关

```bash
# GitHub CLI
brew install gh

# Git LFS
brew install git-lfs
git lfs install

# Lazygit（TUI Git 客户端）
brew install lazygit
```

### 云服务 CLI

```bash
# AWS CLI
brew install awscli

# Alibaba Cloud CLI
brew install aliyun-cli

# Tencent Cloud CLI
pip install tencentcloud-sdk-python

# Vercel CLI
npm install -g vercel

# Netlify CLI
npm install -g netlify-cli
```

### 容器与编排

```bash
# Docker Desktop
brew install --cask docker

# Kubernetes CLI
brew install kubectl kubectx

# Docker Compose
brew install docker-compose
```

## 实用工具

### 文本处理

```bash
# ripgrep - 更快的 grep 替代
brew install ripgrep

# fd - 更快的 find 替代
brew install fd

# bat - 更好的 cat 替代
brew install bat

# exa - 更好的 ls 替代
brew install exa

# jq - JSON 处理
brew install jq

# fzf - 模糊查找
brew install fzf
$(brew --prefix)/opt/fzf/install
```

### 开发辅助

```bash
# httpie - 更好的 curl
brew install httpie

# tldr - 简化的 man pages
brew install tldr

# tree - 目录树
brew install tree

# htop - 更好的 top
brew install htop

# ncdu - 磁盘使用分析
brew install ncdu
```

## 配置文件整合

```bash
#!/bin/bash
# scripts/dump-global-tools.sh

BACKUP_DIR="$HOME/macos-migrate/pkg"
mkdir -p $BACKUP_DIR

# Go
[ -d "$GOPATH/bin" ] && ls -1 $GOPATH/bin > $BACKUP_DIR/go-binaries.txt
[ -d "$HOME/go/bin" ] && ls -1 $HOME/go/bin > $BACKUP_DIR/go-binaries.txt

# Ruby
gem list > $BACKUP_DIR/gem-list.txt 2>/dev/null || true

# Rust
cargo install --list > $BACKUP_DIR/cargo-list.txt 2>/dev/null || true

# Python pip
pip list --local > $BACKUP_DIR/pip-list.txt 2>/dev/null || true

# npm
npm list -g --depth=0 > $BACKUP_DIR/npm-global.txt 2>/dev/null || true

# yarn
yarn global list > $BACKUP_DIR/yarn-global.txt 2>/dev/null || true

echo "✅ Global tools exported to $BACKUP_DIR"
```

## 新机器恢复策略

### 分批安装

```bash
#!/bin/bash
# scripts/install-global-tools.sh

# 1. 基础工具
brew install ripgrep fd bat exa jq fzf tree htop

# 2. Git 工具
brew install gh git-lfs lazygit

# 3. 云服务 CLI
brew install awscli kubectl kubectx

# 4. 开发工具
npm install -g vercel netlify-cli serve

# 5. Python 工具
pip install black isort flake8 mypy

echo "✅ Common global tools installed"
```

### 按需安装

不建议一次性安装所有工具，而是根据实际需要安装：

```bash
# 使用时发现缺少工具再安装
# 保持环境精简
```

## 配置管理最佳实践

### 使用 Homebrew Bundle

将全局工具整合到 `Brewfile`：

```ruby
# Brewfile
brew "ripgrep"
brew "fd"
brew "bat"
brew "exa"
brew "jq"
brew "fzf"
brew "gh"
brew "git-lfs"
brew "lazygit"
brew "awscli"
brew "kubectl"
brew "kubectx"
```

### 使用安装脚本

创建 `install-tools.sh` 脚本按类别安装：

```bash
#!/bin/bash
# install-tools.sh

set -e

# 核心工具
core_tools=(ripgrep fd bat exa jq fzf tree htop)

# Git 工具
git_tools=(gh git-lfs lazygit)

# 云服务
cloud_tools=(awscli kubectl kubectx)

# ... 其他分类

install_category() {
    local category=$1
    shift
    local tools=("$@")

    echo "Installing $category tools..."
    for tool in "${tools[@]}"; do
        brew install "$tool" 2>/dev/null || echo "$tool already installed"
    done
}

install_category "Core" "${core_tools[@]}"
install_category "Git" "${git_tools[@]}"
install_category "Cloud" "${cloud_tools[@]}"

echo "✅ All tools installed"
```

## 相关文档

- [Homebrew 迁移](/dev-env/homebrew)
- [配置文件备份](/config/dotfiles)
- [自动化脚本](/scripts)
