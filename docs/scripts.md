# 自动化脚本

使用自动化脚本可以一键完成备份和恢复，让迁移过程高效可重复。

## 备份脚本

### 完整备份脚本

```bash
#!/bin/bash
# scripts/backup.sh
# macOS 开发环境一键备份脚本

set -e

# 配置
BACKUP_DIR="$HOME/macos-migrate"
DATE=$(date +%Y%m%d)
BACKUP_NAME="macos-backup-$DATE"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 打印函数
print_step() {
    echo -e "${GREEN}▶ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

# 创建备份目录
mkdir -p $BACKUP_DIR/{config,pkg,data}

echo "🍎 macOS 开发环境备份"
echo "========================"

# Step 1: Homebrew
print_step "备份 Homebrew 包..."
if command -v brew &> /dev/null; then
    brew bundle dump --file=$BACKUP_DIR/pkg/Brewfile --describe --force
    print_info "✓ Brewfile 已生成"
else
    print_info "✗ Homebrew 未安装"
fi

# Step 2: Node.js / nvm
print_step "备份 Node.js 版本..."
if command -v nvm &> /dev/null || [ -d "$NVM_DIR" ]; then
    source $(brew --prefix nvm)/nvm.sh 2>/dev/null || true
    nvm ls > $BACKUP_DIR/pkg/nvm-versions.txt 2>/dev/null || true
    print_info "✓ Node 版本列表已生成"
else
    print_info "✗ nvm 未安装"
fi

# Step 3: 全局 npm 包
print_step "备份全局 npm 包..."
if command -v npm &> /dev/null; then
    npm list -g --depth=0 > $BACKUP_DIR/pkg/npm-global.txt 2>/dev/null || true
    print_info "✓ npm 全局包列表已生成"
fi

# Step 4: Python / pyenv
print_step "备份 Python 版本..."
if command -v pyenv &> /dev/null; then
    pyenv versions > $BACKUP_DIR/pkg/python-versions.txt 2>/dev/null || true
    print_info "✓ Python 版本列表已生成"
else
    print_info "✗ pyenv 未安装"
fi

# Step 5: pip 包
print_step "备份 pip 包..."
if command -v pip &> /dev/null; then
    pip list --local > $BACKUP_DIR/pkg/pip-list.txt 2>/dev/null || true
    print_info "✓ pip 包列表已生成"
fi

# Step 6: Go modules
print_step "备份 Go 工具..."
if [ -d "$GOPATH/bin" ] || [ -d "$HOME/go/bin" ]; then
    ls -1 ${GOPATH:-$HOME/go}/bin > $BACKUP_DIR/pkg/go-binaries.txt 2>/dev/null || true
    print_info "✓ Go 工具列表已生成"
fi

# Step 7: 配置文件
print_step "备份配置文件..."
cp ~/.zshrc ~/.zprofile $BACKUP_DIR/config/ 2>/dev/null || true
cp ~/.gitconfig ~/.gitignore_global $BACKUP_DIR/config/ 2>/dev/null || true
cp ~/.npmrc $BACKUP_DIR/config/ 2>/dev/null || true
cp ~/.vimrc $BACKUP_DIR/config/ 2>/dev/null || true
cp -r ~/.ssh $BACKUP_DIR/config/ 2>/dev/null || true
cp -r ~/.vim $BACKUP_DIR/config/ 2>/dev/null || true
print_info "✓ 配置文件已复制"

# Step 8: VS Code
print_step "备份 VS Code 设置..."
if command -v code &> /dev/null; then
    code --list-extensions > $BACKUP_DIR/config/vscode-extensions.txt 2>/dev/null || true
    cp ~/Library/Application\ Support/Code/User/settings.json $BACKUP_DIR/config/ 2>/dev/null || true
    cp ~/Library/Application\ Support/Code/User/keybindings.json $BACKUP_DIR/config/ 2>/dev/null || true
    print_info "✓ VS Code 配置已备份"
fi

# Step 9: 云服务凭证
print_step "备份云服务凭证..."
cp -r ~/.aws $BACKUP_DIR/config/ 2>/dev/null || true
cp -r ~/.kube $BACKUP_DIR/config/ 2>/dev/null || true
cp -r ~/.terraform.d $BACKUP_DIR/config/ 2>/dev/null || true
print_info "✓ 云服务凭证已备份"

# Step 10: 数据库
print_step "备份数据库..."
if command -v mysqldump &> /dev/null; then
    mysqldump --all-databases > $BACKUP_DIR/data/mysql-backup.sql 2>/dev/null || true
    print_info "✓ MySQL 已备份"
fi
if command -v pg_dump &> /dev/null; then
    pg_dumpall > $BACKUP_DIR/data/postgresql-backup.sql 2>/dev/null || true
    print_info "✓ PostgreSQL 已备份"
fi
if command -v redis-cli &> /dev/null; then
    redis-cli BGSAVE 2>/dev/null || true
    print_info "✓ Redis 已保存"
fi

# Step 11: Docker 镜像列表
print_step "备份 Docker 镜像列表..."
if command -v docker &> /dev/null; then
    docker images --format "{{.Repository}}:{{.Tag}}" > $BACKUP_DIR/data/docker-images.txt 2>/dev/null || true
    print_info "✓ Docker 镜像列表已生成"
fi

# Step 12: 创建压缩包（可选）
read -p "是否创建压缩包? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_step "创建压缩包..."
    tar -czf $HOME/$BACKUP_NAME.tar.gz -C $HOME macos-migrate
    print_info "✓ 压缩包已创建: ~/$BACKUP_NAME.tar.gz"
fi

echo ""
echo -e "${GREEN}✅ 备份完成！${NC}"
echo "备份位置: $BACKUP_DIR"
echo ""
echo "下一步："
echo "1. 将 macos-migrate 文件夹复制到新 Mac"
echo "2. 在新 Mac 上运行 ./scripts/restore.sh"
echo "3. 参考 /post-migration/checklist 验证环境"
```

## 恢复脚本

```bash
#!/bin/bash
# scripts/restore.sh
# macOS 开发环境一键恢复脚本

set -e

# 配置
BACKUP_DIR="$HOME/macos-migrate"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 打印函数
print_step() {
    echo -e "${GREEN}▶ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# 检查备份目录
if [ ! -d "$BACKUP_DIR" ]; then
    print_error "备份目录不存在: $BACKUP_DIR"
    exit 1
fi

echo "🍎 macOS 开发环境恢复"
echo "========================"
echo ""

# Step 1: 安装 Xcode Command Line Tools
print_step "检查 Xcode Command Line Tools..."
if ! command -v xcode-select &> /dev/null; then
    print_info "需要安装 Xcode Command Line Tools"
    xcode-select --install
    read -p "安装完成后按回车继续..."
fi

# Step 2: 安装 Homebrew
print_step "检查 Homebrew..."
if ! command -v brew &> /dev/null; then
    print_info "需要安装 Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Step 3: 恢复 Homebrew 包
print_step "恢复 Homebrew 包..."
if [ -f "$BACKUP_DIR/pkg/Brewfile" ]; then
    brew bundle --file=$BACKUP_DIR/pkg/Brewfile
    print_info "✓ Homebrew 包已安装"
else
    print_info "✗ Brewfile 不存在"
fi

# Step 4: 安装 nvm
print_step "安装 nvm..."
if [ -f "$BACKUP_DIR/pkg/nvm-versions.txt" ]; then
    if ! command -v nvm &> /dev/null; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    fi
fi

# Step 5: 恢复 Node 版本
print_step "恢复 Node.js 版本..."
if [ -f "$BACKUP_DIR/pkg/nvm-versions.txt" ]; then
    grep -E 'v[0-9]+\.[0-9]+\.[0-9]+' $BACKUP_DIR/pkg/nvm-versions.txt | sed 's/[^0-9.]//g' | while read version; do
        if [ ! -z "$version" ]; then
            nvm install "$version" 2>/dev/null || print_info "版本 $version 安装失败"
        fi
    done
    print_info "✓ Node 版本已安装"
fi

# Step 6: 恢复全局 npm 包
print_step "恢复全局 npm 包..."
if [ -f "$BACKUP_DIR/pkg/npm-global.txt" ]; then
    cat $BACKUP_DIR/pkg/npm-global.txt | grep -v empty | awk '{print $2}' | tr -d '\`' | while read pkg; do
        if [ ! -z "$pkg" ]; then
            npm install -g "$pkg" 2>/dev/null || true
        fi
    done
    print_info "✓ npm 全局包已安装"
fi

# Step 7: 安装 pyenv
print_step "安装 pyenv..."
if [ -f "$BACKUP_DIR/pkg/python-versions.txt" ]; then
    if ! command -v pyenv &> /dev/null; then
        brew install pyenv
        echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
        echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
        echo 'eval "$(pyenv init -)"' >> ~/.zshrc
        export PYENV_ROOT="$HOME/.pyenv"
        export PATH="$PYENV_ROOT/bin:$PATH"
        eval "$(pyenv init -)"
    fi
fi

# Step 8: 恢复 Python 版本
print_step "恢复 Python 版本..."
if [ -f "$BACKUP_DIR/pkg/python-versions.txt" ]; then
    grep -E '[0-9]+\.[0-9]+\.[0-9]+' $BACKUP_DIR/pkg/python-versions.txt | sed 's/[^0-9.]//g' | while read version; do
        if [ ! -z "$version" ]; then
            pyenv install "$version" 2>/dev/null || print_info "版本 $version 安装失败"
        fi
    done
    print_info "✓ Python 版本已安装"
fi

# Step 9: 恢复配置文件
print_step "恢复配置文件..."
cp $BACKUP_DIR/config/.zshrc $BACKUP_DIR/config/.zprofile ~/. 2>/dev/null || true
cp $BACKUP_DIR/config/.gitconfig ~/. 2>/dev/null || true
cp $BACKUP_DIR/config/.gitignore_global ~/. 2>/dev/null || true
cp $BACKUP_DIR/config/.npmrc ~/. 2>/dev/null || true
cp $BACKUP_DIR/config/.vimrc ~/. 2>/dev/null || true

# SSH 密钥
if [ -d "$BACKUP_DIR/config/.ssh" ]; then
    cp -r $BACKUP_DIR/config/.ssh ~/
    chmod 700 ~/.ssh
    chmod 600 ~/.ssh/id_* 2>/dev/null || true
fi

# Vim 配置
if [ -d "$BACKUP_DIR/config/.vim" ]; then
    cp -r $BACKUP_DIR/config/.vim ~/
fi

print_info "✓ 配置文件已恢复"

# Step 10: 恢复 VS Code
print_step "恢复 VS Code 配置..."
if [ -f "$BACKUP_DIR/config/vscode-extensions.txt" ]; then
    if command -v code &> /dev/null; then
        cat $BACKUP_DIR/config/vscode-extensions.txt | xargs -L 1 code --install-extension 2>/dev/null || true
        cp $BACKUP_DIR/config/settings.json ~/Library/Application\ Support/Code/User/ 2>/dev/null || true
        cp $BACKUP_DIR/config/keybindings.json ~/Library/Application\ Support/Code/User/ 2>/dev/null || true
        print_info "✓ VS Code 配置已恢复"
    else
        print_info "✗ VS Code 未安装，请先安装: brew install --cask visual-studio-code"
    fi
fi

# Step 11: 恢复云服务凭证
print_step "恢复云服务凭证..."
cp -r $BACKUP_DIR/config/.aws ~/. 2>/dev/null || true
cp -r $BACKUP_DIR/config/.kube ~/. 2>/dev/null || true
cp -r $BACKUP_DIR/config/.terraform.d ~/. 2>/dev/null || true
print_info "✓ 云服务凭证已恢复"

# Step 12: 恢复数据库
print_step "恢复数据库..."
if [ -f "$BACKUP_DIR/data/mysql-backup.sql" ]; then
    if command -v mysql &> /dev/null; then
        mysql < $BACKUP_DIR/data/mysql-backup.sql 2>/dev/null || print_info "MySQL 恢复失败"
    fi
fi
if [ -f "$BACKUP_DIR/data/postgresql-backup.sql" ]; then
    if command -v psql &> /dev/null; then
        psql -d postgres < $BACKUP_DIR/data/postgresql-backup.sql 2>/dev/null || print_info "PostgreSQL 恢复失败"
    fi
fi
print_info "✓ 数据库已恢复"

echo ""
echo -e "${GREEN}✅ 恢复完成！${NC}"
echo ""
echo "请执行以下操作完成迁移："
echo "1. 重启终端以加载新配置"
echo "2. 运行: source ~/.zshrc"
echo "3. 检查 [迁移后检查清单](/post-migration/checklist)"
echo "4. 测试 Git 连接: ssh -T git@github.com"
```

## 使用方法

### 在旧 Mac 上备份

```bash
# 1. 克隆或创建项目目录
mkdir -p ~/macos-migrate/scripts
cd ~/macos-migrate/scripts

# 2. 创建备份脚本（复制上面的内容）
vim backup.sh

# 3. 添加执行权限
chmod +x backup.sh

# 4. 运行备份
./backup.sh

# 5. 将整个 macos-migrate 文件夹复制到新 Mac
```

### 在新 Mac 上恢复

```bash
# 1. 将 macos-migrate 文件夹复制到新 Mac 的用户目录

# 2. 进入脚本目录
cd ~/macos-migrate/scripts

# 3. 创建恢复脚本（复制上面的内容）
vim restore.sh

# 4. 添加执行权限
chmod +x restore.sh

# 5. 运行恢复
./restore.sh
```

## 定期备份

使用 cron 或 launchd 定期自动备份：

```bash
# 编辑 crontab
crontab -e

# 添加每周日凌晨 2 点自动备份
0 2 * * 0 ~/macos-migrate/scripts/backup.sh
```

## 相关文档

- [配置文件备份](/config/dotfiles)
- [数据迁移清单](/config/data-checklist)
- [迁移后检查](/post-migration/checklist)
