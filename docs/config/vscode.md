# VS Code 设置

Visual Studio Code 是最受欢迎的代码编辑器，备份其设置和扩展可以快速恢复你的开发环境。

## 备份 VS Code 配置

### 用户设置

```bash
# VS Code 配置位置
# macOS: ~/Library/Application Support/Code/User/

# 备份设置
cp ~/Library/Application\ Support/Code/User/settings.json ~/macos-migrate/config/
cp ~/Library/Application\ Support/Code/User/keybindings.json ~/macos-migrate/config/ 2>/dev/null || true

# 备份 snippets
cp -r ~/Library/Application\ Support/Code/User/snippets ~/macos-migrate/config/ 2>/dev/null || true
```

### 扩展列表

```bash
# 导出已安装扩展
code --list-extensions > ~/macos-migrate/config/vscode-extensions.txt

# 带版本号导出（可选）
code --list-extensions --show-versions > ~/macos-migrate/config/vscode-extensions-full.txt
```

### 扩展配置

某些扩展有单独的配置文件：

```bash
# 备份 VS Code 全局配置目录
cp -r ~/.vscode ~/macos-migrate/config/ 2>/dev/null || true
```

## 新机器恢复

### 安装 VS Code

```bash
# 使用 Homebrew 安装
brew install --cask visual-studio-code

# 或从官网下载
# https://code.visualstudio.com/
```

### 恢复设置

```bash
# 复制设置文件
cp ~/macos-migrate/config/settings.json ~/Library/Application\ Support/Code/User/
cp ~/macos-migrate/config/keybindings.json ~/Library/Application\ Support/Code/User/ 2>/dev/null || true

# 复制 snippets
cp -r ~/macos-migrate/config/snippets ~/Library/Application\ Support/Code/User/ 2>/dev/null || true
```

### 安装扩展

```bash
# 方法一：使用 shell 循环
cat ~/macos-migrate/config/vscode-extensions.txt | xargs -L 1 code --install-extension

# 方法二：使用 VS Code Extension CLI
code --install-extension ms-python.python
code --install-extension dbaeumer.vscode-eslint
code --install-extension esbenp.prettier-vscode
# ... 逐个安装

# 方法三：使用扩展同步（推荐）
# 安装 "Settings Sync" 扩展
code --install-extension shan.code-settings-sync
# 然后使用 GitHub Gist 同步
```

## 推荐扩展

### 核心扩展

```bash
# 代码编辑
ms-python.python
ms-vscode.vscode-typescript-next
dbaeumer.vscode-eslint
esbenp.prettier-vscode
stylelint.vscode-stylelint

# Git 管理
eamodio.gitlens
github.copilot
github.vscode-pull-request-github

# 主题
pkief.material-icon-theme
zhuangtongfa.material-theme

# 实用工具
ms-vscode.live-server
formulahendry.code-runner
christian-kohler.path-intellisense
streetsidesoftware.code-spell-checker
```

### 开发语言扩展

```bash
# 前端
bradlc.vscode-tailwindcss
vue.volar
vue.vscode-typescript-vue-plugin

# 后端
ms-vscode.cpptools
ms-vscode.cmake-tools
golang.go
rust-lang.rust-analyzer

# DevOps
ms-azuretools.vscode-docker
ms-kubernetes-tools.vscode-kubernetes-tools
```

## settings.json 推荐配置

```json
{
  // 编辑器
  "editor.fontSize": 14,
  "editor.tabSize": 2,
  "editor.insertSpaces": true,
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.wordWrap": "on",
  "editor.minimap.enabled": false,
  "editor.lineNumbers": "relative",

  // 终端
  "terminal.integrated.fontSize": 13,
  "terminal.integrated.fontFamily": "JetBrains Mono",

  // 文件
  "files.autoSave": "afterDelay",
  "files.autoSaveDelay": 1000,
  "files.exclude": {
    "**/.git": true,
    "**/.DS_Store": true,
    "**/node_modules": true
  },

  // 工作区
  "workbench.colorTheme": "Material Theme Ocean",
  "workbench.iconTheme": "material-icon-theme",
  "workbench.startupEditor": "none",

  // Git
  "git.enableSmartCommit": true,
  "git.autofetch": true,
  "git.confirmSync": false,

  // Python
  "python.defaultInterpreterPath": "~/.pyenv/versions/3.11.7/bin/python",
  "python.formatting.provider": "black",

  // JavaScript/TypeScript
  "javascript.format.semicolons": "insert",
  "typescript.format.semicolons": "insert",

  // ESLint
  "eslint.validate": [
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact"
  ],

  // Prettier
  "prettier.semi": true,
  "prettier.singleQuote": true,
  "prettier.tabWidth": 2,

  // 其他
  "telemetry.telemetryLevel": "off",
  "update.mode": "manual"
}
```

## keybindings.json 常用快捷键

```json
[
  {
    "key": "cmd+/",
    "command": "editor.action.commentLine",
    "when": "editorTextFocus"
  },
  {
    "key": "cmd+d",
    "command": "editor.action.duplicateSelection"
  },
  {
    "key": "cmd+shift+k",
    "command": "editor.action.deleteLines"
  },
  {
    "key": "cmd+.",
    "command": "workbench.action.quickOpen"
  },
  {
    "key": "cmd+p",
    "command": "workbench.action.quickOpen"
  },
  {
    "key": "cmd+shift+p",
    "command": "workbench.action.showCommands"
  }
]
```

## 使用 Settings Sync 同步

微软官方的 Settings Sync 是最方便的同步方式：

### 设置步骤

1. **安装扩展**
   ```bash
   code --install-extension ms-vscode.online-services
   ```

2. **登录账户**
   - 点击设置齿轮图标 → "Turn on Settings Sync..."
   - 使用 GitHub 或 Microsoft 账户登录

3. **选择同步内容**
   - Settings
   - Keyboard Shortcuts
   - Extensions
   - User Snippets

4. **开始同步**

### 新机器恢复

```bash
# 安装 VS Code 后
# 1. 登录 GitHub/Microsoft 账户
# 2. 开启 Settings Sync
# 3. 选择 "Turn On" 下载所有配置
```

::: tip 推荐使用 Settings Sync
Settings Sync 是最简单的方式，特别适合：
- 多台 Mac 同步
- 频繁重装系统
- 云端备份配置
:::

## VS Code Insiders

如果你使用 VS Code Insiders（预览版），配置路径不同：

```bash
# Insiders 配置路径
~/Library/Application Support/Code - Insiders/User/

# 备份命令调整
cp ~/Library/Application\ Support/Code\ -\ Insiders/User/settings.json ~/macos-migrate/config/vscode-insiders-settings.json
```

## 相关文档

- [配置文件备份](/config/dotfiles)
- [数据迁移清单](/config/data-checklist)
- [自动化脚本](/scripts)
