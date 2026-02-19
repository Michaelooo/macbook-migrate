#!/bin/bash
# macOS 开发环境一键恢复脚本
# 用途：从备份恢复开发环境

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

# Step 7: 恢复配置文件
print_step "恢复配置文件..."
cp $BACKUP_DIR/config/.zshrc $BACKUP_DIR/config/.zprofile ~/. 2>/dev/null || true
cp $BACKUP_DIR/config/.gitconfig ~/. 2>/dev/null || true
cp $BACKUP_DIR/config/.gitignore_global ~/. 2>/dev/null || true
cp $BACKUP_DIR/config/.npmrc ~/. 2>/dev/null || true
cp $BACKUP_DIR/config/.vimrc ~/. 2>/dev/null || true
print_info "✓ 配置文件已恢复"

# Step 8: 恢复 VS Code
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

echo ""
echo -e "${GREEN}✅ 恢复完成！${NC}"
echo ""
echo "请执行以下操作完成迁移："
echo "1. 重启终端以加载新配置"
echo "2. 运行: source ~/.zshrc"
echo "3. 访问 https://your-username.github.io/macos-migrate/post-migration/checklist 完成验证"
