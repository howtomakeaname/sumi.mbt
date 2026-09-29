import { defineConfig } from 'vitepress'
import moonbitGrammar from './grammars/moonbit.tmLanguage.json' with { type: 'json' }

const componentsSidebar = [
  {
    text: 'Actions',
    items: [
      { text: 'Button', link: '/components/button' },
      { text: 'Icon Button', link: '/components/icon-button' },
      { text: 'Favorite Toggle', link: '/components/favorite-toggle' },
      { text: 'Add Tile', link: '/components/add-tile' },
      { text: 'Toolbar', link: '/components/toolbar' },
    ],
  },
  {
    text: 'Forms',
    items: [
      { text: 'Input', link: '/components/input' },
      { text: 'Textarea', link: '/components/textarea' },
      { text: 'Select', link: '/components/select' },
      { text: 'Stepper', link: '/components/stepper' },
      { text: 'Switch', link: '/components/switch' },
      { text: 'Checkbox', link: '/components/checkbox' },
      { text: 'Slider', link: '/components/slider' },
      { text: 'Slider Field', link: '/components/slider-field' },
      { text: 'Chip', link: '/components/chip' },
      { text: 'Attachment Strip', link: '/components/attachment-strip' },
      { text: 'Segmented', link: '/components/segmented' },
      { text: 'Prompt Box', link: '/components/prompt-box' },
      { text: 'Editable Text', link: '/components/editable-text' },
    ],
  },
  {
    text: 'Overlays',
    items: [
      { text: 'Dropdown Menu', link: '/components/dropdown-menu' },
      { text: 'Checkbox Menu', link: '/components/checkbox-menu' },
      { text: 'Context Menu', link: '/components/context-menu' },
      { text: 'Popover', link: '/components/popover' },
      { text: 'Tooltip', link: '/components/tooltip' },
      { text: 'Dialog', link: '/components/dialog' },
      { text: 'Toast', link: '/components/toast' },
    ],
  },
  {
    text: 'Feedback',
    items: [
      { text: 'Spinner', link: '/components/spinner' },
      { text: 'Status Badge', link: '/components/status-badge' },
      { text: 'Progress', link: '/components/progress' },
      { text: 'Skeleton', link: '/components/skeleton' },
      { text: 'Badge', link: '/components/badge' },
      { text: 'Empty State', link: '/components/empty-state' },
      { text: 'Alert', link: '/components/alert' },
    ],
  },
  {
    text: 'Display',
    items: [
      { text: 'Avatar', link: '/components/avatar' },
      { text: 'Tag', link: '/components/tag' },
      { text: 'Kbd', link: '/components/kbd' },
      { text: 'Card', link: '/components/card' },
      { text: 'Tabs', link: '/components/tabs' },
      { text: 'Pagination', link: '/components/pagination' },
      { text: 'Shortcuts Panel', link: '/components/shortcuts-panel' },
      { text: 'Credits', link: '/components/credits' },
      { text: 'Icons', link: '/components/icons' },
    ],
  },
]

const componentsSidebarZh = [
  { text: '操作', items: [
    { text: 'Button 按钮', link: '/zh/components/button' },
    { text: 'Icon Button 图标按钮', link: '/zh/components/icon-button' },
    { text: 'Favorite Toggle 收藏切换', link: '/zh/components/favorite-toggle' },
    { text: 'Add Tile 添加磁贴', link: '/zh/components/add-tile' },
    { text: 'Toolbar 工具栏', link: '/zh/components/toolbar' },
  ]},
  { text: '表单', items: [
    { text: 'Input 输入框', link: '/zh/components/input' },
    { text: 'Textarea 多行文本', link: '/zh/components/textarea' },
    { text: 'Select 选择器', link: '/zh/components/select' },
    { text: 'Stepper 步进器', link: '/zh/components/stepper' },
    { text: 'Switch 开关', link: '/zh/components/switch' },
    { text: 'Checkbox 复选框', link: '/zh/components/checkbox' },
    { text: 'Slider 滑块', link: '/zh/components/slider' },
    { text: 'Slider Field 滑杆字段', link: '/zh/components/slider-field' },
    { text: 'Chip 选项片', link: '/zh/components/chip' },
    { text: 'Attachment Strip 附件条', link: '/zh/components/attachment-strip' },
    { text: 'Segmented 分段选择器', link: '/zh/components/segmented' },
    { text: 'Prompt Box 提示输入框', link: '/zh/components/prompt-box' },
    { text: 'Editable Text 可编辑文本', link: '/zh/components/editable-text' },
  ]},
  { text: '浮层', items: [
    { text: 'Dropdown Menu 下拉菜单', link: '/zh/components/dropdown-menu' },
    { text: 'Checkbox Menu 多选菜单', link: '/zh/components/checkbox-menu' },
    { text: 'Context Menu 上下文菜单', link: '/zh/components/context-menu' },
    { text: 'Popover 气泡卡片', link: '/zh/components/popover' },
    { text: 'Tooltip 文字提示', link: '/zh/components/tooltip' },
    { text: 'Dialog 对话框', link: '/zh/components/dialog' },
    { text: 'Toast 轻提示', link: '/zh/components/toast' },
  ]},
  { text: '反馈', items: [
    { text: 'Spinner 加载指示器', link: '/zh/components/spinner' },
    { text: 'Status Badge 状态徽标', link: '/zh/components/status-badge' },
    { text: 'Progress 进度条', link: '/zh/components/progress' },
    { text: 'Skeleton 骨架屏', link: '/zh/components/skeleton' },
    { text: 'Badge 徽标', link: '/zh/components/badge' },
    { text: 'Empty State 空状态', link: '/zh/components/empty-state' },
    { text: 'Alert 提示', link: '/zh/components/alert' },
  ]},
  { text: '展示', items: [
    { text: 'Avatar 头像', link: '/zh/components/avatar' },
    { text: 'Tag 标签', link: '/zh/components/tag' },
    { text: 'Kbd 键盘按键', link: '/zh/components/kbd' },
    { text: 'Card 卡片', link: '/zh/components/card' },
    { text: 'Tabs 标签页', link: '/zh/components/tabs' },
    { text: 'Pagination 分页', link: '/zh/components/pagination' },
    { text: 'Shortcuts Panel 快捷键面板', link: '/zh/components/shortcuts-panel' },
    { text: 'Credits 额度', link: '/zh/components/credits' },
    { text: 'Icons 图标', link: '/zh/components/icons' },
  ]},
]

// Tokenize ASCII words normally; split CJK runs into overlapping bigrams so
// Chinese queries match without word segmentation.
function tokenize(text: string): string[] {
  const tokens: string[] = []
  const re = /[a-z0-9_@./-]+|[一-鿿㐀-䶿]+/gi
  let m: RegExpExecArray | null
  while ((m = re.exec(text))) {
    const t = m[0]
    if (/^[一-鿿㐀-䶿]+$/.test(t)) {
      if (t.length === 1) {
        tokens.push(t)
      } else {
        for (let i = 0; i < t.length - 1; i++) tokens.push(t.slice(i, i + 2))
        tokens.push(t)
      }
    } else {
      tokens.push(t)
    }
  }
  return tokens
}

export default defineConfig({
  base: '/sumi.mbt/',
  title: 'Sumi',
  description: 'A UI component library for MoonBit web apps',
  cleanUrls: true,

  markdown: {
    // Shiki has no bundled MoonBit grammar; load the official TextMate one.
    languages: [moonbitGrammar as any],
  },

  themeConfig: {
    socialLinks: [
      { icon: 'github', link: 'https://github.com/howtomakeaname/sumi.mbt' },
    ],
    search: {
      provider: 'local',
      options: {
        miniSearch: {
          options: { tokenize },
        },
        locales: {
          zh: {
            translations: {
              button: { buttonText: '搜索', buttonAriaLabel: '搜索' },
              modal: {
                displayDetails: '显示详细列表',
                resetButtonTitle: '清除搜索',
                backButtonTitle: '关闭搜索',
                noResultsText: '没有找到相关结果',
                footer: {
                  selectText: '选择',
                  selectKeyAriaLabel: '回车',
                  navigateText: '切换',
                  navigateUpKeyAriaLabel: '上箭头',
                  navigateDownKeyAriaLabel: '下箭头',
                  closeText: '关闭',
                  closeKeyAriaLabel: 'Esc',
                },
              },
            },
          },
        },
      },
    },
  },

  locales: {
    root: {
      label: 'English',
      lang: 'en',
      themeConfig: {
        nav: [
          { text: 'Guide', link: '/guide/introduction' },
          { text: 'Components', link: '/components/button' },
        ],
        sidebar: {
          '/guide/': [
            {
              text: 'Guide',
              items: [
                { text: 'Introduction', link: '/guide/introduction' },
                { text: 'Getting Started', link: '/guide/getting-started' },
                { text: 'Theming', link: '/guide/theming' },
              ],
            },
          ],
          '/components/': componentsSidebar,
        },
        outline: { level: [2, 3] },
      },
    },
    zh: {
      label: '简体中文',
      lang: 'zh-CN',
      link: '/zh/',
      themeConfig: {
        nav: [
          { text: '指南', link: '/zh/guide/introduction' },
          { text: '组件', link: '/zh/components/button' },
        ],
        sidebar: {
          '/zh/guide/': [
            {
              text: '指南',
              items: [
                { text: '介绍', link: '/zh/guide/introduction' },
                { text: '快速开始', link: '/zh/guide/getting-started' },
                { text: '主题', link: '/zh/guide/theming' },
              ],
            },
          ],
          '/zh/components/': componentsSidebarZh,
        },
        outline: { level: [2, 3], label: '本页目录' },
        docFooter: { prev: '上一页', next: '下一页' },
        darkModeSwitchLabel: '外观',
        sidebarMenuLabel: '菜单',
        returnToTopLabel: '回到顶部',
        langMenuLabel: '语言',
      },
    },
  },
})
