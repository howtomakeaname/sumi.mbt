# Tooltip 文字提示

悬停或聚焦时出现在任意触发器旁的气泡，从锚定边缘缩放进入。四个方向。

## 示例

### 四个方向

<SumiDemo name="tooltip-basic">

```moonbit
@sumi.tooltip(content="Export the current project",
  @sumi.icon_button(@sumi.icon_upload(), aria_label="Export"))
@sumi.tooltip(content="More actions", side=@sumi.Bottom,
  @sumi.icon_button(@sumi.icon_more(), aria_label="More"))
```

</SumiDemo>

## API

### tooltip

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| content **\*** | `String` | — | 气泡文本 |
| side | `TooltipSide` | Top | 位于触发器的哪一侧 |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |
| children | `C` | — | 内容 |

### TooltipSide

`Top` · `Bottom` · `Left` · `Right`

\* 必填（标签）参数——其余均为可选。
