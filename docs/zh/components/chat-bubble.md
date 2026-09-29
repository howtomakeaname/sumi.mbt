# Chat Bubble 对话气泡

发送消息的右对齐气泡：支持纯文本或内嵌媒体标签的富文本；长文可在渐变遮罩后折叠并提供展开/收起开关，悬停时下方出现复制按钮。

## 示例

### 纯文本、富文本与折叠

<SumiDemo name="chat-bubble">

```moonbit
@sumi.chat_bubble(text="Continue")
@sumi.chat_bubble(children=[
  @sumi.media_tag(kind=@sumi.Image, variant=@sumi.Inline, thumbnail=thumb),
  @html.text("Add more detail"),
])
@sumi.chat_bubble(
  text=long,
  collapsible=true,
  collapsed=c,
  on_toggle=set_c.map(v => _ => !v),
  on_copy=copy_it,
)
```

</SumiDemo>

## API

### chat_bubble

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| text | `String` | — | 纯文本内容（与 children 互斥） |
| children | `Array[Html]` | — | 富文本行：行内媒体标签与文本 |
| collapsible | `Bool` | false | 启用折叠与展开/收起开关 |
| collapsed | `Bool` | true | 受控折叠状态 |
| on_toggle | `Cmd` | — | 展开/收起点击命令 |
| collapse_lines | `Int` | 9 | 折叠时保留的行数（默认 9） |
| on_copy | `Cmd` | — | 悬停时在气泡下方显示的复制按钮 |
| aria_label | `String` | — |  |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

\* 必填（标签）参数——其余均为可选。
