import Theme from 'vitepress/theme-without-fonts'
import type { EnhanceAppContext } from 'vitepress'
import './custom.css'

export default {
  extends: Theme,
  enhanceApp({ app, router }: EnhanceAppContext) {
    // 可以在这里添加全局组件或插件
  }
}
