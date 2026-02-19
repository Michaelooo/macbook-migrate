#!/bin/bash
# macOS 开发环境一键备份脚本
# 用途：备份开发环境配置和包列表

set -e

# 配置
BACKUP_DIR="$HOME/macos-migrate"
DATE=$(date +%Y%m%d)

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

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
if [ -d "$NVM_DIR" ] || [ -d "$HOME/.nvm" ]; then
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

# Step 6: 配置文件
print_step "备份配置文件..."
cp ~/.zshrc ~/.zprofile $BACKUP_DIR/config/ 2>/dev/null || true
cp ~/.gitconfig ~/.gitignore_global $BACKUP_DIR/config/ 2>/dev/null || true
cp ~/.npmrc $BACKUP_DIR/config/ 2>/dev/null || true
cp ~/.vimrc $BACKUP_DIR/config/ 2>/dev/null || true
print_info "✓ 配置文件已复制"

# Step 7: VS Code
print_step "备份 VS Code 设置..."
if command -v code &> /dev/null; then
    code --list-extensions > $BACKUP_DIR/config/vscode-extensions.txt 2>/dev/null || true
    cp ~/Library/Application\ Support/Code/User/settings.json $BACKUP_DIR/config/ 2>/dev/null || true
    cp ~/Library/Application\ Support/Code/User/keybindings.json $BACKUP_DIR/config/ 2>/dev/null || true
    print_info "✓ VS Code 配置已备份"
fi

echo ""
echo -e "${GREEN}✅ 备份完成！${NC}"
echo "备份位置: $BACKUP_DIR"
echo ""
echo "下一步："
echo "1. 将 $BACKUP_DIR 文件夹复制到新 Mac"
echo "2. 在新 Mac 上运行 ./scripts/restore.sh"
echo "3. 参考 https://your-username.github.io/macos-migrate/post-migration/checklist 验证环境"
