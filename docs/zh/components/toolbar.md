# Toolbar 工具栏

磨砂质感的动作栏，将菜单、分段选择器、额度与主提交按钮编组，分组之间用分隔线区隔。

## 示例

### 组合工具栏

<SumiDemo name="toolbar-basic">

```moonbit
@sumi.toolbar([
  @sumi.dropdown_menu(trigger=..., items=..., ...),
  @sumi.toolbar_divider(),
  @sumi.segmented(items=..., selected=..., on_select=...),
  @sumi.toolbar_divider(),
  @sumi.credits(value=24),
  @sumi.button(variant=@sumi.Primary, [
    @sumi.icon_sparkle(size=14),
    @html.text("Generate"),
  ]),
])
```

</SumiDemo>

## API

### toolbar

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| title | `String` | — | 原生 tooltip 标题 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |
| children | `C` | — | 内容 |

### toolbar_divider

工具栏分组之间的 1px 竖线。

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| style | `Array[String]` | [] | 附加内联样式 |

\* 必填（标签）参数——其余均为可选。
