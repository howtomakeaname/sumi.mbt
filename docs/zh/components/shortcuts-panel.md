# Shortcuts Panel 快捷键面板

快捷键速查面板：264px 的浮起面板，带标题栏与关闭按钮，下方是带小标题的标签 + 键位芯片行；内容过长时在体内滚动。

## 示例

### 三个分组

<SumiDemo name="shortcuts-panel">

```moonbit
@sumi.shortcuts_panel(
  sections=[
    @sumi.ShortcutSection::new("General", [
      @sumi.ShortcutItem::new("Toggle sidebar", "Cmd /"),
      @sumi.ShortcutItem::new("Send message", "Enter"),
    ]),
    @sumi.ShortcutSection::new("Editing", [
      @sumi.ShortcutItem::new("Select all", "⌘ A"),
      @sumi.ShortcutItem::new("Undo", "⌘ Z"),
    ]),
  ],
  on_close=close_panel,
)
```

</SumiDemo>

## API

### shortcuts_panel

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| sections **\*** | `Array[ShortcutSection]` | — | 带标题的快捷键分组 |
| title | `String` | "Shortcuts" | 标题栏文字（默认 "Shortcuts"） |
| on_close | `Cmd` | — | 关闭按钮命令 |
| width | `Int` | 264 | 面板宽度 px（默认 264） |
| max_height | `Int` | 660 | 面板最大高度 px（默认 660） |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

### ShortcutSection::new

一个带标题的分组。

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| title | `String` | — | 原生 tooltip 标题 |
| items | `Array[ShortcutItem]` | — |  |

### ShortcutItem::new

一行。

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| label | `String` | — |  |
| keys | `String` | — |  |

\* 必填（标签）参数——其余均为可选。
