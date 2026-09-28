# Dropdown Menu 下拉菜单

锚定触发器的菜单，支持紧凑或富文本项、分组标签、分隔线与快捷键提示。键盘导航与关闭行为由主题的事件层处理。

## 示例

### 富文本项

<SumiDemo name="dropdown-menu-basic">

```moonbit
@sumi.dropdown_menu(
  trigger=@sumi.button(variant=@sumi.Secondary, [
    @html.text("Enhance"),
    @sumi.menu_chevron(),
  ]),
  items=[
    @sumi.SectionLabel("QUALITY"),
    @sumi.Item(@sumi.MenuItem::new(
      "standard", "Standard",
      description="Balanced clarity for everyday images",
      icon=@sumi.icon_sparkle(size=16),
    )),
  ],
  open=is_open,
  on_open_change=set_open.map(v => _ => v),
  selected=current,
  on_select=set_choice.map(v => _ => v),
)
```

</SumiDemo>

### 紧凑项与快捷键

<SumiDemo name="dropdown-menu-compact">

```moonbit
items=[
  @sumi.Item(@sumi.MenuItem::new("rename", "Rename", shortcut="R")),
  @sumi.Item(@sumi.MenuItem::new("duplicate", "Duplicate",
    icon=@sumi.icon_layers(size=14), shortcut="⌘D")),
  @sumi.Separator,
  @sumi.Item(@sumi.MenuItem::new("delete", "Delete",
    icon=@sumi.icon_x(size=14), shortcut="⌫")),
]
```

</SumiDemo>

## API

### dropdown_menu

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| items **\*** | `Array[MenuEntry]` | — | 菜单内容——`Item`、`Separator`、`SectionLabel` |
| trigger **\*** | `Html` | — | 锚点元素 |
| open **\*** | `Bool` | — | 浮层是否打开（受控） |
| on_open_change | `Emit[Bool]` | — | 打开状态应变化时调用 |
| selected | `String` | — | 当前选中项的值 |
| on_select | `Emit[String]` | — | 选中某项时以其值调用 |
| align | `MenuAlign` | Start | 相对触发器的水平对齐 |
| side | `MenuSide` | Bottom | 在触发器上方或下方展开 |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |
| trigger_style | `Array[String]` | [] | 触发器包裹层的样式 |
| menu_style | `Array[String]` | [] | 浮层面板的样式 |

### menu_chevron

随菜单开合旋转 180° 的触发器箭头。

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| size | `Int` | 12 |  |

### MenuItem::new

一个菜单项。

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| value | `String` | — |  |
| label | `String` | — |  |
| description | `String` | — | 次级描述行（富文本布局） |
| icon | `Html` | — | 前置图标 |
| shortcut | `String` | — | 右对齐快捷键提示 |
| disabled | `Bool` | false | 禁用交互并降低不透明度 |

### MenuAlign

| Variant | 说明 |
|---|---|
| `Start` | 面板左缘对齐触发器 |
| `End` | 面板右缘对齐触发器 |

### MenuSide

| Variant | 说明 |
|---|---|
| `Bottom` | 在触发器下方展开（默认） |
| `Top` | 在触发器上方展开（输入坞） |

\* 必填（标签）参数——其余均为可选。
