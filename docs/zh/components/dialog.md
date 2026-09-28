# Dialog 对话框

基于原生 `<dialog>` 的模态框，入场带轻微回弹，配纯暗遮罩。使用框架的 dialog 命令打开。

## 示例

### 确认破坏性操作

<SumiDemo name="dialog-basic">

```moonbit
@sumi.button(
  variant=@sumi.Secondary,
  on_click=@dialog.show("my-dialog"),
  "Open Dialog",
)
@sumi.dialog(
  id="my-dialog",
  title_text="Delete project",
  description="This action cannot be undone.",
  [
    @html.form(method_="dialog", [
      @sumi.button(variant=@sumi.Primary, type_="submit", "Delete"),
    ]),
  ],
)
```

</SumiDemo>

## API

### dialog

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| id **\*** | `String` | — | 元素 id——命令以其为目标 |
| title_text | `String` | — | 标题行 |
| description | `String` | — | 标题下的辅助文本 |
| show_close | `Bool` | true | 右上角关闭按钮 |
| spacious | `Bool` | false | 内容宽度从 480px 加宽到 616px |
| closedby | `String` | "any" | 原生 `closedby` 行为 |
| on_close | `Emit[String]` | — | 以对话框返回值调用 |
| on_cancel | `Cmd` | — | Esc 取消时调用 |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |
| children | `C` | — | 内容 |

\* 必填（标签）参数——其余均为可选。
