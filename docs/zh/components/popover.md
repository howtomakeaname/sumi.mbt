# Popover 气泡卡片

锚定触发器的自由内容面板，适合放置小型表单与检查器。

## 示例

### 内嵌滑块

<SumiDemo name="popover-basic">

```moonbit
@sumi.popover(
  trigger=@sumi.button(variant=@sumi.Secondary, [
    @sumi.icon_adjust(size=14),
    @html.text("Adjust"),
  ]),
  open=is_open,
  on_open_change=set_open.map(v => _ => v),
  panel_content,
)
```

</SumiDemo>

## API

### popover

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| trigger **\*** | `Html` | — | 锚点元素 |
| open **\*** | `Bool` | — | 浮层是否打开（受控） |
| on_open_change | `Emit[Bool]` | — | 打开状态应变化时调用 |
| align | `MenuAlign` | Start | 相对触发器的水平对齐 |
| side | `MenuSide` | Bottom | 在触发器上方或下方展开 |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |
| panel_style | `Array[String]` | [] | 浮层面板的样式 |
| children | `C` | — | 内容 |

### MenuAlign

`Start` · `End`

### MenuSide

`Bottom` · `Top`

\* 必填（标签）参数——其余均为可选。
