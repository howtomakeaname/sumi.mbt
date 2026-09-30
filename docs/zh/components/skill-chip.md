# Skill Chip 技能标签

Agent 选择器的技能胶囊：36px 圆角 40 描边芯片，可选前导图标与 New/Hot 标记，含 More 触发变体；另有磨砂换行面板，将技能芯片或快捷操作按钮浮于输入区上方。

## 示例

### 选择行与面板

<SumiDemo name="skill-chips">

```moonbit
@sumi.skill_chip(label="Storyboard", icon=@sumi.icon_draw(size=16), mark=@sumi.New)
@sumi.skill_chip(label="Style Frame", mark=@sumi.Hot)
@sumi.skill_chip(label="More", more=true)

@sumi.chip_panel(children=[
  @sumi.action_chip(label="Storyboard"),
  @sumi.action_chip(label="Shot List"),
])

@sumi.chip_panel(children=[
  @sumi.skill_chip(label="Storyboard", mark=@sumi.Hot),
  @sumi.skill_chip(label="Quick Cut"),
])
```

</SumiDemo>

## API

### skill_chip

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| label **\*** | `String` | — | 12/20 芯片标签 |
| icon | `Html` | — | 可选 16px 前导图标 |
| mark | `SkillMark` | — | 可选 `SkillMark` 角标（`New` / `Hot`） |
| mark_label | `String` | — | 覆盖角标文案 |
| more | `Bool` | false | More 触发器：间距 4、右 padding 12、尾部箭头 |
| on_click | `Cmd` | — | 点击命令 |
| disabled | `Bool` | false | 禁用交互并降低不透明度 |
| aria_label | `String` | — |  |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

### action_chip

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| label **\*** | `String` | — | 13/22 Regular 居中标签 |
| on_click | `Cmd` | — | 点击命令 |
| disabled | `Bool` | false | 禁用交互并降低不透明度 |
| aria_label | `String` | — |  |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

### chip_panel

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| children **\*** | `Array[Html]` | — | `skill_chip` / `action_chip` 子项 |
| width | `Int` | 338 | 面板宽度 px（默认 338） |
| aria_label | `String` | — |  |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

### SkillMark

`New` · `Hot`

\* 必填（标签）参数——其余均为可选。
