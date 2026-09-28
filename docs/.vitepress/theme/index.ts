import DefaultTheme from 'vitepress/theme'
import type { Theme } from 'vitepress'
import SumiDemo from './SumiDemo.vue'
import './custom.css'

export default {
  extends: DefaultTheme,
  enhanceApp({ app }) {
    app.component('SumiDemo', SumiDemo)
  },
} satisfies Theme
