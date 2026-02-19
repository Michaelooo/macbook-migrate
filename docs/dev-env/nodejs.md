# Node.js / nvm

Node.js 版本管理推荐使用 nvm（Node Version Manager），支持多版本共存。

## 备份已安装的 Node 版本

### 导出版本列表

```bash
# 查看已安装的版本
nvm ls

# 导出版本列表到文件
nvm ls > ~/macos-migrate/pkg/nvm-versions.txt

# 备份 nvm 配置
cp ~/.nvmrc ~/macos-migrate/config/ 2>/dev/null || true
```

### nvm-versions.txt 示例

```
->      v18.19.0
        v20.11.0
default -> v18.19.0
```

### 备份全局 npm 包

```bash
# 导出全局包列表
npm list -g --depth=0 > ~/macos-migrate/pkg/npm-global.txt

# 更详细的信息（包含版本号）
npm list -g --depth=0 --json > ~/macos-migrate/pkg/npm-global.json
```

## 新机器恢复

### 安装 nvm

```bash
# 安装 nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# 或使用 Homebrew 安装
brew install nvm

# 配置环境变量
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc
echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.zshrc

# 重新加载配置
source ~/.zshrc
```

### 安装 Node 版本

```bash
# 自动安装所有记录的版本
# 方法一：使用 nvm-versions.txt
grep -E 'v[0-9]+\.[0-9]+\.[0-9]+' ~/macos-migrate/pkg/nvm-versions.txt | xargs -I {} nvm install {}

# 方法二：手动指定版本
nvm install 18.19.0
nvm install 20.11.0

# 设置默认版本
nvm alias default 18.19.0
nvm use default
```

### 恢复全局 npm 包

```bash
# 方法一：使用 npm list 输出
# 先清理格式
cat ~/macos-migrate/pkg/npm-global.txt | grep -v 'empty' | grep -v '/.nvm' | awk '{print $2}' | tr -d '`' | xargs npm install -g

# 方法二：使用 npm rebuild
# 更简单但可能不完整
npm rebuild

# 方法三：逐个安装主要包
npm install -g yarn pnpm typescript @vue/cli create-react-app
```

## 高级配置

### 配置 npm 镜像

```bash
# 设置淘宝镜像（中国大陆）
npm config set registry https://registry.npmmirror.com

# 验证
npm config get registry

# 备份 npm 配置
npm config list > ~/macos-migrate/config/npm-config.txt
```

### 项目级别的 .nvmrc

```bash
# 在项目根目录创建 .nvmrc
echo "18.19.0" > ~/your-project/.nvmrc

# 自动切换到项目指定的版本
# 添加到 .zshrc
cdnvm() {
    cd "$@";
    nvm=$(nvm version);
    nvmrc=$(cat .nvmrc 2>/dev/null);
    if [ "$nvm" != "$nvmrc" ]; then
        nvm use;
    fi
}
alias cd='cdnvm'
```

## 版本管理最佳实践

### LTS 版本策略

```bash
# 使用 LTS（长期支持）版本
nvm install --lts
nvm alias default lts/*

# 查看所有可用版本
nvm ls-remote

# 查看 LTS 版本
nvm ls-remote --lts
```

### 常用命令

```bash
# 列出已安装版本
nvm ls

# 切换版本
nvm use 20.11.0

# 设置默认版本
nvm alias default 20.11.0

# 卸载版本
nvm uninstall 16.20.0

# 查看当前版本
node -v
npm -v
```

## 常见问题

### Q: nvm 命令找不到？

```bash
# 确认 nvm 安装路径
ls -la ~/.nvm

# 手动加载 nvm
source ~/.nvm/nvm.sh

# 检查 .zshrc 配置
cat ~/.zshrc | grep nvm
```

### Q: 全局包权限问题？

```bash
# 修复 npm 全局目录权限
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.zshrc
```

### Q: Node 版本切换后包丢失？

```bash
# 不同 Node 版本的全局包是分开的
# 使用 npm-reinstall-auto 工具自动迁移
npm install -g npm-reinstall-auto

# 在新版本中重新安装旧版本的全局包
npm-reinstall-auto
```

## 相关文档

- [Python / pyenv 迁移](/dev-env/python)
- [全局包管理](/dev-env/global-packages)
- [Homebrew 迁移](/dev-env/homebrew)
