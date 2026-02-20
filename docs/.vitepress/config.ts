import { defineConfig } from 'vitepress'
import { withMermaid } from 'vitepress-plugin-mermaid'

export default withMermaid({
  title: 'macOS 开发环境迁移指南',
  description: '系统化、可复现的 macOS 开发环境迁移解决方案',
  lang: 'zh-CN',
  base: '/macos-migrate/',
  head: [
    // Google Fonts - 异步加载，带 font-display: swap
    ['link', {
      rel: 'preload',
      as: 'style',
      onload: "this.onload=null;this.rel='stylesheet'",
      href: 'https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@400;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap'
    }],
    ['noscript', {}, [
      ['link', {
        rel: 'stylesheet',
        href: 'https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@400;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap'
      }]
    ]],
    ['meta', { name: 'theme-color', content: '#f8f6f3' }],
    ['meta', { name: 'og:type', content: 'website' }],
    ['meta', { name: 'og:locale', content: 'zh_CN' }]
  ],

  themeConfig: {
    nav: [
      { text: '首页', link: '/' },
      { text: '快速开始', link: '/quick-start' },
      { text: '官方工具', link: '/official-tools' },
      { text: '脚本', link: '/scripts' }
    ],

    sidebar: [
      {
        text: '开始使用',
        items: [
          { text: '概述', link: '/' },
          { text: '快速开始', link: '/quick-start' }
        ]
      },
      {
        text: '迁移方法',
        items: [
          { text: '官方迁移工具', link: '/official-tools' },
          { text: '迁移策略选择', link: '/strategies' }
        ]
      },
      {
        text: '开发环境',
        items: [
          { text: 'Homebrew', link: '/dev-env/homebrew' },
          { text: 'Node.js / nvm', link: '/dev-env/nodejs' },
          { text: 'Python / pyenv', link: '/dev-env/python' },
          { text: '全局包管理', link: '/dev-env/global-packages' }
        ]
      },
      {
        text: '配置与数据',
        items: [
          { text: '配置文件备份', link: '/config/dotfiles' },
          { text: 'VS Code 设置', link: '/config/vscode' },
          { text: '数据迁移清单', link: '/config/data-checklist' }
        ]
      },
      {
        text: '自动化脚本',
        items: [
          { text: '备份脚本', link: '/scripts' },
          { text: '恢复脚本', link: '/scripts#恢复脚本' }
        ]
      },
      {
        text: '收尾工作',
        items: [
          { text: '迁移后检查', link: '/post-migration/checklist' },
          { text: '实用技巧', link: '/post-migration/tips' }
        ]
      }
    ],

    socialLinks: [
      { icon: 'github', link: 'https://github.com/yourusername/macos-migrate' }
    ],

    footer: {
      message: '基于 MIT 许可发布',
      copyright: '© 2024-present macOS Migrate Guide'
    },

    search: {
      provider: 'local',
      options: {
        locales: {
          zh: {
            translations: {
              button: '搜索文档',
              placeholder: '搜索文档...'
            }
          }
        }
      }
    },

    outline: {
      level: [2, 3],
      label: '页面导航'
    },

    docFooter: {
      prev: '上一页',
      next: '下一页'
    },

    returnToTopLabel: '返回顶部',
    sidebarMenuLabel: '菜单',
    darkModeSwitchLabel: '外观',
    lightModeSwitchTitle: '浅色',
    darkModeSwitchTitle: '深色'
  },

  markdown: {
    lineNumbers: true
  },

  // Mermaid 插件配置
  mermaidPlugin: {
    startOnLoad: false
  },

  mermaid: {
    theme: 'neutral',
    themeVariables: {
      dark: {
        primaryColor: '#2d2b28',
        primaryTextColor: '#f5f3f0',
        primaryBorderColor: '#7fc9a8',
        lineColor: '#7fc9a8',
        secondaryColor: '#1f3d2e',
        tertiaryColor: '#3a3835',
        background: '#1a1917',
        mainBkg: '#242220',
        nodeBorder: '#7fc9a8',
        clusterBkg: '#1f3d2e',
        clusterBorder: '#7fc9a8'
      },
      light: {
        primaryColor: '#f8f6f3',
        primaryTextColor: '#2d2a26',
        primaryBorderColor: '#1a5f3f',
        lineColor: '#1a5f3f',
        secondaryColor: '#e8f0ea',
        tertiaryColor: '#f0ede8',
        background: '#ffffff',
        mainBkg: '#f8f6f3',
        nodeBorder: '#1a5f3f',
        clusterBkg: '#e8f0ea',
        clusterBorder: '#1a5f3f'
      }
    }
  },

  vite: {
    // 优化构建配置
    build: {
      cssCodeSplit: false
    },
    css: {
      preprocessorOptions: {
        scss: {
          // 移除可能导致问题的 SCSS 导入
          // additionalData: `@use "@theme/styles/variables" as *;`
        }
      }
    }
  }
})
