# Task Card 任务卡片

已提交任务的气泡卡片与滚动列表：磨砂卡片含 Medium 标题、可选生成状态与两行摘要（或工具调用行等富文本正文）；列表底部渐隐，配细蓝色滚动条。

## 示例

### 任务流

<SumiDemo name="task-list">

```moonbit
@sumi.task_list(height=400, children=[
  @sumi.task_card(title="Weekly Sync Notes", status=@sumi.Pending("Review"), summary=text),
  @sumi.task_card(title="API Migration Draft", status=@sumi.Generating, summary=text),
  @sumi.task_card(title="Orbital Station Flythrough", status=@sumi.Generating, children=[
    @sumi.tool_call_row(label="Working on the canvas", icon=@sumi.icon_draw(size=16), expandable=true),
  ]),
  @sumi.task_card(title="City Rain Loop", status=@sumi.Done, summary=long_text),
])
```

</SumiDemo>

## API

### task_card

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| title **\*** | `String` | — | 14/24 Medium 标题（溢出省略） |
| status | `SessionStatus` | — | 标题后的可选 `SessionStatus` 状态 |
| summary | `String` | "" | 两行截断的正文（14/24 次要色） |
| children | `Array[Html]` | — | 替代摘要的富文本正文 |
| on_click | `Cmd` | — | 卡片点击命令 |
| aria_label | `String` | — |  |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

### task_list

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| children **\*** | `Array[Html]` | — | `task_card` 气泡 |
| height | `Int` | 400 | 列表高度 px（默认 400） |
| fade | `Int` | 44 | 底部渐隐高度 px（默认 44；0 关闭） |
| aria_label | `String` | — |  |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

\* 必填（标签）参数——其余均为可选。
