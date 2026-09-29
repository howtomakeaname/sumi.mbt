# Tool Call Row 工具调用行

一行 agent 进度：16px 工具图标 + 进行中扫光、完成后静止的标签；可展开的行带箭头，展开后在线索连接线下显示子步骤。

## 示例

### 状态与展开

<SumiDemo name="tool-call-row">

```moonbit
@sumi.tool_call_row(icon=@sumi.icon_image(), label="(0/1) Image generating…")
@sumi.tool_call_row(icon=@sumi.icon_image(), state=@sumi.Done,
  label="(1/1) Image generation completed")
@sumi.tool_call_row(
  icon=@sumi.icon_adjust(), label="2 commands executed",
  expandable=true, expanded=e, on_toggle=set_e.map(v => _ => !v),
  steps=["List file directories", "Search for related content"],
)
```

</SumiDemo>

## API

### tool_call_row

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| label **\*** | `String` | — | 状态文案；计数与失败说明直接写入文案 |
| icon | `Html` | — | 16px 工具图标（省略则无图标） |
| state | `ToolCallState` | Doing | Doing 扫光，Done 静止为三级文字 |
| expandable | `Bool` | false | 显示右/下箭头并启用子步骤 |
| expanded | `Bool` | false | 受控展开状态 |
| on_toggle | `Cmd` | — | 整行点击命令 |
| steps | `Array[String]` | [] | 展开时显示的子步骤行 |
| truncate | `Bool` | true | 单行省略（默认）或换行 |
| aria_label | `String` | — |  |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

### ToolCallState

| Variant | 说明 |
|---|---|
| `Doing` | 工作进行时标签持续扫光 |
| `Done` | 静止的三级文字标签 |

\* 必填（标签）参数——其余均为可选。
