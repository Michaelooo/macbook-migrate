# 数据迁移清单

除了开发环境配置，还有一些重要数据需要迁移。这个清单帮助你系统地处理所有数据。

## 数据迁移总览表

| 数据类型 | 位置/方式 | 迁移方式 | 优先级 |
|---------|----------|---------|-------|
| 开发项目 | ~/Documents/code/ 或 ~/projects/ | 外接硬盘 / Git | ⭐⭐⭐ |
| SSH 密钥 | ~/.ssh/ | 手动复制（加密） | ⭐⭐⭐ |
| GPG 密钥 | ~/.gnupg/ | 手动复制（加密） | ⭐⭐⭐ |
| Git 凭证 | Keychain / .git-credentials | 手动重新配置 | ⭐⭐⭐ |
| AWS/Azure/Kube 配置 | ~/.aws/, ~/.kube/ | 手动复制 | ⭐⭐⭐ |
| 数据库数据 | /usr/local/var/mysql 等 | 导出 SQL | ⭐⭐ |
| Docker 镜像 | Docker | 导出/重新拉取 | ⭐⭐ |
| 浏览器数据 | Chrome/Safari 浏览器 | 账号同步 | ⭐⭐ |
| VS Code 扩展 | ~/Library/Application Support/ | 扩展列表 + 同步 | ⭐⭐ |
| 应用数据 | ~/Library/Application Support/ | 仅必要应用 | ⭐ |

## 高优先级数据

### 开发项目

```bash
# 备份开发项目目录
# 方法一：rsync 到外接硬盘（推荐）
rsync -av ~/Documents/code/ /Volumes/DevDrive/code-backup/

# 方法二：使用 Git（已托管项目）
# 确保所有更改已推送
cd ~/Documents/code/
find . -name ".git" -type d -execdir git push \;

# 方法三：压缩备份
tar -czf code-backup.tar.gz ~/Documents/code/
```

### SSH 密钥

```bash
# 备份 SSH 目录
cp -r ~/.ssh ~/macos-migrate/config/

# 验证重要密钥
ls -la ~/.ssh/
# id_rsa 或 id_ed25519 (私钥)
# id_rsa.pub 或 id_ed25519.pub (公钥)
# config (SSH 配置)

# 新机器恢复
cp -r ~/macos-migrate/config/.ssh ~/
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_*
```

### GPG 密钥（用于 Git 签名）

```bash
# 导出 GPG 密钥
gpg --list-secret-keys

# 导出私钥（重要！妥善保管）
gpg --export-secret-keys YOUR_KEY_ID > ~/macos-migrate/config/gpg-private-key.asc

# 导出公钥
gpg --export YOUR_KEY_ID > ~/macos-migrate/config/gpg-public-key.asc

# 导出信任数据库
gpg --export-ownertrust > ~/macos-migrate/config/gpg-trust.txt

# 新机器恢复
gpg --import ~/macos-migrate/config/gpg-private-key.asc
gpg --import ~/macos-migrate/config/gpg-public-key.asc
gpg --import-ownertrust ~/macos-migrate/config/gpg-trust.txt
```

### 云服务凭证

```bash
# AWS CLI
cp -r ~/.aws ~/macos-migrate/config/

# Azure CLI
cp -r ~/.azure ~/macos-migrate/config/

# Kubernetes
cp -r ~/.kube ~/macos-migrate/config/

# Terraform
cp -r ~/.terraform.d ~/macos-migrate/config/ 2>/dev/null || true
```

## 中优先级数据

### 数据库

```bash
# MySQL
mysqldump --all-databases > ~/macos-migrate/data/mysql-backup.sql

# PostgreSQL
pg_dumpall > ~/macos-migrate/data/postgresql-backup.sql

# MongoDB
mongodump --out ~/macos-migrate/data/mongodb-backup

# Redis（如果有数据）
redis-cli SAVE
cp /usr/local/var/db/dump.rdb ~/macos-migrate/data/
```

### Docker

```bash
# 导出镜像列表
docker images --format "{{.Repository}}:{{.Tag}}" > ~/macos-migrate/data/docker-images.txt

# 导出特定镜像（重要镜像）
docker save -o ~/macos-migrate/data/node-image.tar node:18-alpine

# 新机器恢复
# 建议重新拉取镜像，而非导入
docker load -i ~/macos-migrate/data/node-image.tar
```

### 浏览器数据

推荐使用浏览器内置同步功能：

- **Chrome**: 登录 Google 账户 → 设置 → 同步
- **Safari**: iCloud 同步
- **Firefox**: Firefox 账户同步

手动备份（可选）：

```bash
# Chrome 书签
cp ~/Library/Application\ Support/Google/Chrome/Default/Bookmarks ~/macos-migrate/data/

# Safari 书记
cp ~/Library/Safari/Bookmarks.plist ~/macos-migrate/data/
```

## 低优先级数据

### 应用数据

```bash
# 仅备份重要应用的数据
cp -r ~/Library/Application\ Support/TablePlus ~/macos-migrate/data/
cp -r ~/Library/Application\ Support/Postman ~/macos-migrate/data/

# 其他应用根据需要选择性备份
```

### 桌面和文档

```bash
# 建议使用 iCloud 同步
# 或手动选择性备份
```

## 迁移脚本

```bash
#!/bin/bash
# scripts/backup-data.sh

BACKUP_DIR="$HOME/macos-migrate"
mkdir -p $BACKUP_DIR/{config,data}

echo "🔄 开始备份开发数据..."

# 开发项目（如果有外接硬盘）
if [ -d "/Volumes/DevDrive" ]; then
    echo "📁 同步开发项目到外接硬盘..."
    rsync -av --progress ~/Documents/code/ /Volumes/DevDrive/code-backup/
fi

# SSH 密钥
echo "🔑 备份 SSH 密钥..."
cp -r ~/.ssh $BACKUP_DIR/config/

# GPG 密钥
echo "🔐 备份 GPG 密钥..."
gpg --export-secret-keys $(gpg --list-secret-keys --keyid-format LONG | grep sec | awk '{print $2}' | cut -d'/' -f2 | head -1) > $BACKUP_DIR/config/gpg-private-key.asc 2>/dev/null || true

# 云服务凭证
echo "☁️ 备份云服务凭证..."
cp -r ~/.aws $BACKUP_DIR/config/ 2>/dev/null || true
cp -r ~/.kube $BACKUP_DIR/config/ 2>/dev/null || true

# 数据库
echo "💾 备份数据库..."
mysqldump --all-databases > $BACKUP_DIR/data/mysql-backup.sql 2>/dev/null || true
pg_dumpall > $BACKUP_DIR/data/postgresql-backup.sql 2>/dev/null || true

# Docker 镜像列表
echo "🐳 备份 Docker 镜像列表..."
docker images --format "{{.Repository}}:{{.Tag}}" > $BACKUP_DIR/data/docker-images.txt 2>/dev/null || true

echo "✅ 数据备份完成: $BACKUP_DIR"
```

## 新机器恢复

```bash
#!/bin/bash
# scripts/restore-data.sh

BACKUP_DIR="$HOME/macos-migrate"

echo "🔄 开始恢复开发数据..."

# SSH 密钥
echo "🔑 恢复 SSH 密钥..."
cp -r $BACKUP_DIR/config/.ssh ~/
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_*

# 测试 SSH
ssh -T git@github.com

# GPG 密钥
echo "🔐 恢复 GPG 密钥..."
gpg --import $BACKUP_DIR/config/gpg-private-key.asc 2>/dev/null || true

# 云服务凭证
echo "☁️ 恢复云服务凭证..."
cp -r $BACKUP_DIR/config/.aws ~/
cp -r $BACKUP_DIR/config/.kube ~/

# 数据库
echo "💾 恢复数据库..."
mysql < $BACKUP_DIR/data/mysql-backup.sql 2>/dev/null || true
psql -d postgres < $BACKUP_DIR/data/postgresql-backup.sql 2>/dev/null || true

# 开发项目
if [ -d "/Volumes/DevDrive/code-backup" ]; then
    echo "📁 恢复开发项目..."
    rsync -av --progress /Volumes/DevDrive/code-backup/ ~/Documents/code/
fi

echo "✅ 数据恢复完成"
```

## 迁移后验证

参考 [迁移后检查清单](/post-migration/checklist) 验证所有数据。

## 相关文档

- [配置文件备份](/config/dotfiles)
- [VS Code 设置](/config/vscode)
- [迁移后检查](/post-migration/checklist)
