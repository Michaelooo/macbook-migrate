# Python / pyenv

Python 版本管理推荐使用 pyenv，支持多版本共存和项目隔离。

## 备份已安装的 Python 版本

### 导出版本列表

```bash
# 查看已安装的版本
pyenv versions

# 导出版本列表
pyenv versions > ~/macos-migrate/pkg/python-versions.txt

# 导出全局和项目配置
pyenv global | cat > ~/macos-migrate/config/pyenv-global.txt
cat ~/.pyenv/version > ~/macos-migrate/config/pyenv-version.txt 2>/dev/null || true
```

### python-versions.txt 示例

```
* 3.11.7 (set by /Users/username/.pyenv/version)
  3.10.13
  3.9.18
  3.12.1
```

### 备份 pip 包

```bash
# 备份全局 pip 包（针对每个 Python 版本）
for version in $(pyenv versions --bare); do
    pyenv shell $version
    pip list --format=freeze > ~/macos-migrate/pkg/pip-global-$version.txt 2>/dev/null || true
done

# 或者使用 pip freeze
pip freeze > ~/macos-migrate/pkg/pip-requirements.txt
```

### 备份虚拟环境

```bash
# 列出所有虚拟环境
lsvirtualenv -b

# 导出虚拟环境列表
lsvirtualenv -b > ~/macos-migrate/pkg/venv-list.txt

# 导出每个虚拟环境的包
for venv in $(lsvirtualenv -b); do
    workon $venv
    pip freeze > ~/macos-migrate/pkg/venv-$venv-requirements.txt
done
```

## 新机器恢复

### 安装 pyenv

```bash
# 方法一：使用 Homebrew（推荐）
brew install pyenv

# 配置环境变量
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc

# 重新加载配置
source ~/.zshrc

# 方法二：使用 curl 安装
curl https://pyenv.run | bash
```

### 安装 Python 依赖

```bash
# 安装 Python 构建依赖（macOS）
brew install openssl readline sqlite3 xz zlib tcl-tk

# 安装所有记录的 Python 版本
while read version; do
    version=$(echo $version | sed 's/[^0-9.]//g')
    [ ! -z "$version" ] && pyenv install $version
done < ~/macos-migrate/pkg/python-versions.txt

# 设置全局版本
pyenv global 3.11.7

# 验证安装
python --version
```

### 恢复 pip 包

```bash
# 恢复全局包
pip install -r ~/macos-migrate/pkg/pip-requirements.txt

# 或针对特定版本
pip install -r ~/macos-migrate/pkg/pip-global-3.11.7.txt
```

### 恢复虚拟环境

```bash
# 安装 virtualenvwrapper
pip install virtualenvwrapper

# 配置 virtualenvwrapper
echo 'export WORKON_HOME=$HOME/.virtualenvs' >> ~/.zshrc
echo 'export VIRTUALENVWRAPPER_PYTHON=/Users/username/.pyenv/versions/3.11.7/bin/python' >> ~/.zshrc
echo 'source /usr/local/bin/virtualenvwrapper.sh' >> ~/.zshrc
source ~/.zshrc

# 重新创建虚拟环境
for venv in $(cat ~/macos-migrate/pkg/venv-list.txt); do
    mkvirtualenv $venv
    pip install -r ~/macos-migrate/pkg/venv-$venv-requirements.txt
    deactivate
done
```

## 高级配置

### 项目级别版本管理

```bash
# 在项目目录设置特定 Python 版本
cd ~/your-project
pyenv local 3.11.7

# 创建 .python-version 文件
echo "3.11.7" > .python-version
```

### pip 配置优化

```bash
# 使用清华镜像（中国大陆）
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# 备份 pip 配置
pip config list > ~/macos-migrate/config/pip-config.txt
```

### Poetry 用户

```bash
# 导出 Poetry 项目
poetry export -f requirements.txt > ~/macos-migrate/pkg/poetry-requirements.txt

# 备份 Poetry 配置
cp ~/.poetry/config.toml ~/macos-migrate/config/

# 新机器恢复
poetry install
```

## 版本管理最佳实践

### 版本选择策略

```bash
# 使用最新稳定版
pyenv install 3.12.1
pyenv global 3.12.1

# 或使用特定 LTS 版本
pyenv install 3.11.7
pyenv global 3.11.7

# 保留一个旧版本兼容老项目
pyenv install 3.9.18
```

### 常用命令

```bash
# 列出可安装版本
pyenv install --list

# 列出已安装版本
pyenv versions

# 切换版本
pyenv global 3.11.7    # 全局
pyenv local 3.11.7     # 当前目录
pyenv shell 3.11.7     # 当前会话

# 卸载版本
pyenv uninstall 3.9.18

# 查看当前版本
python --version
```

## 常见问题

### Q: pyenv install 失败？

```bash
# 先安装构建依赖
brew install openssl readline sqlite3 xz zlib tcl-tk

# 使用 CFLAGS 参数
CFLAGS="-I$(brew --prefix openssl)/include -I$(brew --prefix bzip2)/include -I$(brew --prefix readline)/include -I$(xcrun --show-sdk-path)/usr/include" \
LDFLAGS="-L$(brew --prefix openssl)/lib -L$(brew --prefix readline)/lib -L$(brew --prefix zlib)/lib -L$(brew --prefix bzip2)/lib" \
pyenv install --verbose 3.11.7
```

### Q: pip install 权限问题？

```bash
# 使用用户安装
pip install --user package-name

# 或使用虚拟环境（推荐）
python -m venv myenv
source myenv/bin/activate
pip install package-name
```

### Q: 命令行工具找不到？

```bash
# 确保 pyenv shims 在 PATH 前面
echo $PATH | grep pyenv

# 重新初始化 pyenv
eval "$(pyenv init -)"
```

## 相关文档

- [Node.js / nvm 迁移](/dev-env/nodejs)
- [全局包管理](/dev-env/global-packages)
- [Homebrew 迁移](/dev-env/homebrew)
