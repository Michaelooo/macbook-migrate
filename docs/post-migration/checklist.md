# 迁移后检查清单

完成迁移后，使用这个清单逐一验证环境，确保一切正常运行。

## 检查清单

### 系统基础

- [ ] **系统更新** - 检查并安装系统更新
  ```bash
  softwareupdate --list-all
  sudo softwareupdate --install-all
  ```

- [ ] **Xcode Command Line Tools** - 确认已安装
  ```bash
  xcode-select -p
  # 输出: /Library/Developer/CommandLineTools
  ```

- [ ] **Homebrew** - 确认可用并更新
  ```bash
  brew doctor
  brew update
  brew upgrade
  ```

### Git 配置

- [ ] **Git 版本** - 确认已安装
  ```bash
  git --version
  ```

- [ ] **Git 用户信息** - 确认配置正确
  ```bash
  git config --global user.name
  git config --global user.email
  ```

- [ ] **Git 凭证** - 测试连接
  ```bash
  # GitHub
  ssh -T git@github.com
  # GitLab
  ssh -T git@gitlab.com
  ```

- [ ] **GPG 签名** - 如果使用 commit 签名
  ```bash
  gpg --list-keys
  git config --global commit.gpgsign
  ```

- [ ] **Git LFS** - 如果使用
  ```bash
  git lfs install
  ```

### 开发语言

#### Node.js

- [ ] **nvm 可用** - 确认 nvm 已安装
  ```bash
  command -v nvm
  nvm --version
  ```

- [ ] **Node 版本** - 确认版本已安装
  ```bash
  node --version
  nvm ls
  ```

- [ ] **npm 配置** - 确认镜像源设置
  ```bash
  npm config get registry
  ```

- [ ] **全局包** - 检查常用全局包
  ```bash
  npm list -g --depth=0
  ```

#### Python

- [ ] **pyenv 可用** - 确认 pyenv 已安装
  ```bash
  command -v pyenv
  pyenv --version
  ```

- [ ] **Python 版本** - 确认版本已安装
  ```bash
  python --version
  pyenv versions
  ```

- [ ] **pip 可用** - 确认 pip 正常
  ```bash
  pip --version
  which pip
  ```

#### 其他语言

- [ ] **Go** - 如果使用
  ```bash
  go version
  ```

- [ ] **Ruby** - 如果使用
  ```bash
  ruby --version
  ```

- [ ] **Rust** - 如果使用
  ```bash
  rustc --version
  cargo --version
  ```

### Shell 配置

- [ ] **Shell 版本** - 确认使用 zsh
  ```bash
  echo $SHELL
  # 应该输出: /bin/zsh
  ```

- [ ] **配置加载** - 确认配置文件生效
  ```bash
  cat ~/.zshrc | head -20
  source ~/.zshrc
  ```

- [ ] **别名可用** - 测试常用别名
  ```bash
  alias ll
  alias gs
  # 如果报错，检查 .zshrc 配置
  ```

### 编辑器和 IDE

- [ ] **VS Code** - 确认扩展已安装
  ```bash
  code --list-extensions
  ```

- [ ] **VS Code 设置** - 打开确认设置
  ```bash
  code ~/Library/Application\ Support/Code/User/settings.json
  ```

- [ ] **其他 IDE** - 如 IntelliJ、PyCharm 等配置

### 数据库

- [ ] **MySQL** - 如果使用
  ```bash
  mysql --version
  mysql.server status
  ```

- [ ] **PostgreSQL** - 如果使用
  ```bash
  psql --version
  brew services list | grep postgresql
  ```

- [ ] **MongoDB** - 如果使用
  ```bash
  mongod --version
  brew services list | grep mongodb
  ```

- [ ] **Redis** - 如果使用
  ```bash
  redis-cli ping
  # 应该输出: PONG
  ```

### 容器和虚拟化

- [ ] **Docker** - 确认 Docker 运行
  ```bash
  docker --version
  docker ps
  ```

- [ ] **Docker Compose** - 如果使用
  ```bash
  docker-compose --version
  ```

### 云服务工具

- [ ] **AWS CLI** - 如果使用
  ```bash
  aws --version
  aws configure list
  ```

- [ ] **kubectl** - 如果使用 Kubernetes
  ```bash
  kubectl version --client
  ```

- [ ] **Terraform** - 如果使用
  ```bash
  terraform version
  ```

### 网络和代理

- [ ] **网络连接** - 确认网络正常
  ```bash
  ping -c 3 google.com
  ```

- [ ] **代理设置** - 如果使用代理
  ```bash
  echo $http_proxy
  echo $https_proxy
  ```

### 浏览器

- [ ] **Chrome** - 确认同步状态
  - 检查书签、密码、扩展是否同步

- [ ] **Safari** - 确认 iCloud 同步
  - 检查书签、阅读列表

### 其他检查

- [ ] **SSH 密钥权限** - 确认权限正确
  ```bash
  ls -la ~/.ssh/
  # id_rsa 应该是 600
  # .ssh 目录应该是 700
  ```

- [ ] **环境变量** - 确认必要的环境变量
  ```bash
  echo $PATH
  echo $EDITOR
  echo $LANG
  ```

- [ ] **时间机器** - 配置备份
  - 系统设置 → 通用 → 时间机器
  - 选择备份磁盘

## 常见问题排查

### Git 推送失败

```bash
# 问题：Permission denied (publickey)
# 解决：检查 SSH 密钥
ssh-add -l
ssh-add ~/.ssh/id_rsa
```

### npm install 失败

```bash
# 问题：EACCES 权限错误
# 解决：修复 npm 全局目录
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.zshrc
```

### Docker 无法启动

```bash
# 问题：Docker daemon not running
# 解决：启动 Docker Desktop
open -a Docker
# 等待 Docker 启动完成
```

### Python 导入模块失败

```bash
# 问题：ModuleNotFoundError
# 解决：检查 pip 和 Python 版本匹配
which python
which pip
pip --version
```

## 完成确认

如果所有检查项都通过，恭喜你完成了开发环境迁移！

### 最后一步

```bash
# 重启终端，确保所有配置生效
exec zsh

# 或
exec /bin/zsh
```

### 收藏这份指南

```bash
# 将指南添加到浏览器书签
# https://your-username.github.io/macos-migrate/
```

## 相关文档

- [实用技巧](/post-migration/tips)
- [快速开始](/quick-start)
- [迁移策略](/strategies)
