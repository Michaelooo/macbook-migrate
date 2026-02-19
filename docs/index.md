---
layout: home

hero:
  name: macOS 开发环境迁移指南
  text: 系统化、可复现的开发环境迁移解决方案
  tagline: 从旧 Mac 到新 Mac，保留你的开发环境与配置
  actions:
    - theme: brand
      text: 快速开始
      link: /quick-start
    - theme: alt
      text: 迁移策略
      link: /strategies

features:
  - title: 🍎 官方工具
    details: 使用 Apple 迁移助理进行完整系统迁移，适合换机场景
  - title: ⚡ 轻量方案
    details: 选择性迁移开发环境，Homebrew、nvm、pyenv 等工具配置
  - title: 📋 配置备份
    details: 系统化备份 dotfiles、SSH 密钥、VS Code 设置等核心配置
  - title: 🔄 自动化脚本
    details: 一键备份和恢复脚本，让迁移过程高效可重复
  - title: 📊 清单管理
    details: 详细的迁移后检查项，确保环境完整可用
  - title: 💡 实用技巧
    details: 外接 SSD 备份、iCloud 同步、定期备份等最佳实践
---

<style scoped>
.VPFeature {
  border-radius: 12px;
  border: 1px solid var(--vp-c-border);
  transition: all 0.3s ease;
}

.VPFeature:hover {
  border-color: var(--vp-c-brand);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  transform: translateY(-2px);
}

.VPFeature .icon {
  font-size: 2rem;
  margin-bottom: 0.5rem;
}

.VPFeature .title {
  font-family: 'Noto Serif SC', serif;
  font-weight: 600;
}

.VPFeature .details {
  color: var(--vp-c-text-2);
  line-height: 1.6;
}
</style>

## 概述

换新 Mac 是一件开心的事，但重新配置开发环境却往往耗费大量时间。本指南提供了一套**系统化、可复现**的 macOS 开发环境迁移解决方案，帮助你快速在新机器上恢复工作环境。

## 为什么需要这份指南？

::: tip 核心价值
- **节省时间**：从数天配置缩短到数小时完成
- **避免遗漏**：清单式检查确保环境完整
- **可重复性**：脚本化操作让下次迁移更简单
- **最佳实践**：融合官方工具和开发者经验
:::

## 适用场景

| 场景 | 推荐方案 |
|------|---------|
| 换新 Mac，想完整迁移所有数据 | [Apple 迁移助理](/official-tools) |
| 开发者，只想迁移开发环境 | [轻量级迁移方案](/quick-start) |
| 定期备份开发配置 | [自动化脚本](/scripts) |
| 多台 Mac 同步开发环境 | [配置文件管理](/config/dotfiles) |

## 迁移流程概览

```mermaid
graph LR
    A[评估迁移需求] --> B{选择迁移方案}
    B -->|完整迁移| C[Apple 运移助理]
    B -->|开发环境| D[轻量级方案]
    C --> E[补充开发配置]
    D --> F[运行备份脚本]
    F --> G[新机器恢复]
    E --> G
    G --> H[迁移后检查]
    H --> I[完成]
```

## 开始使用

选择你需要的迁移方式：

<div class="action-cards">

**[🚀 快速开始](/quick-start)** - 5 分钟了解迁移流程

**[🛠️ 官方工具](/official-tools)** - 使用 Apple 迁移助理

**[⚙️ 开发环境](/dev-env/homebrew)** - Homebrew、Node.js、Python

**[📝 配置文件](/config/dotfiles)** - dotfiles 和 SSH 备份

**[🔄 自动化](/scripts)** - 备份和恢复脚本

**[✅ 检查清单](/post-migration/checklist)** - 迁移后验证

</div>

<style>
.action-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1rem;
  margin: 2rem 0;
}

.action-cards a {
  display: block;
  padding: 1.5rem;
  background: var(--vp-c-bg-soft);
  border: 1px solid var(--vp-c-border);
  border-radius: 12px;
  text-decoration: none;
  color: var(--vp-c-text-1);
  transition: all 0.3s ease;
}

.action-cards a:hover {
  border-color: var(--vp-c-brand);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  transform: translateY(-2px);
}
</style>
