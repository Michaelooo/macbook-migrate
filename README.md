# macOS 开发环境迁移指南

> 系统化、可复现的 macOS 开发环境迁移解决方案

一份现代化的 macOS 开发环境迁移文档网站，帮助开发者快速在新机器上恢复工作环境。

## 特点

- **系统化** - 完整的迁移流程和检查清单
- **可复现** - 自动化脚本支持一键备份和恢复
- **美观** - 基于 VitePress 的现代化文档界面
- **响应式** - 完美支持桌面和移动设备
- **深色模式** - 内置深浅色主题切换
- **轻量化** - 快速构建，优化加载速度
- **字体优化** - 即使 Google Fonts 被屏蔽也能正常显示

## 在线预览

完整文档：**[https://your-username.github.io/macos-migrate/](https://your-username.github.io/macos-migrate/)**

## 使用脚本

### 备份当前环境

```bash
# 克隆仓库
git clone https://github.com/your-username/macos-migrate.git
cd macos-migrate

# 运行备份脚本
./scripts/backup.sh
```

### 恢复到新电脑

```bash
# 将项目复制到新 Mac 后
./scripts/restore.sh
```

## 本地开发

### 安装依赖

```bash
npm install
```

### 启动开发服务器

```bash
npm run dev
```

访问 [http://localhost:5173](http://localhost:5173) 查看文档

### 构建和预览

```bash
# 构建静态文件
npm run build

# 预览构建结果
npm run preview
```

## GitHub Pages 部署

项目已配置 GitHub Actions 自动部署，推送代码到 `main` 分支即可自动部署。

### 首次部署配置

1. **仓库设置**
   - 进入仓库 **Settings → Pages**
   - Source 选择 **GitHub Actions**

2. **推送代码**
   ```bash
   git add .
   git commit -m "Initial commit"
   git push origin main
   ```

3. **查看部署状态**
   - 进入仓库 **Actions** 标签页
   - 等待部署完成（约 1-2 分钟）
   - 访问 `https://your-username.github.io/macos-migrate/`

### 使用自定义域名

1. **修改配置**

   将 `docs/.vitepress/config.ts` 中的 `base` 改为根路径：
   ```typescript
   base: '/', // 自定义域名使用根路径
   ```

2. **创建 CNAME 文件**
   ```bash   # 取消注释并修改 CNAME.example
   mv CNAME.example CNAME

   # 编辑 CNAME 文件，填入你的域名
   # 例如：yourdomain.com 或 www.yourdomain.com
   ```

3. **更新 DNS**
   - 在你的域名提供商添加 DNS 记录
   - 类型：CNAME
   - 主机记录：@ 或 www
   - 目标：`your-username.github.io`

## 常见问题排查

### CSS/字体无法加载

**问题**：部署后样式显示异常，字体没有加载

**解决方案**：

1. **检查 base 路径配置**
   - 确认 `docs/.vitepress/config.ts` 中的 `base` 配置正确
   - GitHub Pages 项目：`base: '/macos-migrate/'`
   - 自定义域名：`base: '/'`

2. **字体已配置降级策略**
   - 即使 Google Fonts 无法访问，会自动使用系统字体
   - 中文字体：`Songti SC`、`PingFang SC`、`Microsoft YaHei`
   - 等宽字体：`SF Mono`、`Menlo`、`Monaco`

3. **清除浏览器缓存**
   - 按 `Cmd+Shift+R` (Mac) 或 `Ctrl+Shift+R` (Windows)
   - 或打开开发者工具，勾选 "Disable cache"

### 图片资源无法加载

**解决方案**：

1. 确保图片路径使用相对路径
2. 避免使用绝对路径（如 `/images/logo.png`）
3. 使用相对路径（如 `./images/logo.png`）

### Mermaid 图表不显示

**解决方案**：

1. 检查浏览器控制台是否有 JavaScript 错误
2. 确认 `vitepress-plugin-mermaid` 插件已安装
3. 重新构建并推送代码

### 部署后 404 错误

**解决方案**：

1. 确认 GitHub Pages 设置中 Source 选择的是 **GitHub Actions**
2. 等待 Actions 部署完成（通常需要 1-2 分钟）
3. 检查 `base` 路径配置是否正确
4. 查看仓库 Settings → Pages 中的部署日志

## 项目结构

```
macos-migrate/
├── .github/workflows/         # GitHub Actions 工作流
│   └── deploy.yml             # 自动部署配置
├── docs/                      # 文档源文件
│   ├── .vitepress/           # VitePress 配置
│   │   ├── config.ts         # 站点配置
│   │   └── theme/            # 自定义主题
│   ├── .nojekyll             # 禁用 Jekyll 处理
│   ├── index.md              # 首页
│   ├── quick-start.md        # 快速开始
│   ├── official-tools.md     # 官方工具
│   ├── strategies.md         # 迁移策略
│   ├── dev-env/              # 开发环境
│   ├── config/               # 配置文件
│   ├── scripts.md            # 脚本文档
│   └── post-migration/       # 迁移后
├── scripts/                   # 备份和恢复脚本
│   ├── backup.sh             # 备份脚本
│   └── restore.sh            # 恢复脚本
├── CNAME.example             # 自定义域名模板
├── package.json
├── tsconfig.json
└── README.md
```

## 关键说明

1. **SSH 密钥需手动复制**，请妥善保管私钥
2. **大型项目需手动同步**，建议用时间机器或外接硬盘
3. 首次运行恢复脚本后**需要重启终端**才能生效

## 技术栈

- **VitePress** - Vue 驱动的静态站点生成器
- **TypeScript** - 类型安全
- **Vite** - 快速的构建工具
- **GitHub Actions** - 自动化部署
- **Mermaid** - 流程图支持
- **自定义 CSS** - 独特的视觉设计

## 浏览器支持

- Chrome (最新版)
- Firefox (最新版)
- Safari (最新版)
- Edge (最新版)

## 许可证

MIT License

## 贡献

欢迎提交 Issue 和 Pull Request！
