# Agent Input 输入框

Agent 会话输入坞：磨砂容器，输入区自动限高；工具行左侧为操作原子，右侧为圆形发送按钮，生成中切换为停止按钮。

## 示例

### 会话输入坞

<SumiDemo name="agent-input">

```moonbit
@sumi.agent_input(
  value=current,
  placeholder="Describe your idea, or type / to use a skill",
  on_input=set_prompt.map(v => _ => v),
  on_send=set_prompt(_ => ""),
  send_disabled=current.is_empty(),
  actions=[
    @sumi.icon_button(@sumi.icon_plus_fill(size=14), aria_label="Add attachment"),
    @sumi.agent_tool_button(@sumi.icon_skill(), label="Use Skill"),
    @sumi.icon_button(@sumi.icon_at(), aria_label="Mention a reference"),
  ],
)
```

</SumiDemo>

## API

### agent_input

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| value | `String` | "" | 当前文本（受控） |
| placeholder | `String` | "" | 占位文本 |
| rows | `Int` | 3 | 输入区可见行数 |
| on_input | `Emit[String]` | — | 每次输入时调用 |
| on_send | `Cmd` | — | 发送命令 |
| on_stop | `Cmd` | — | `generating` 时的停止命令 |
| send_disabled | `Bool` | false | 禁用发送按钮 |
| send_loading | `Bool` | false | 将图标替换为加载圈 |
| generating | `Bool` | false | 将发送按钮切换为停止方块 |
| disabled | `Bool` | false | 禁用交互并降低不透明度 |
| autofocus | `Bool` | — | 挂载后自动聚焦 |
| actions | `Array[Html]` | [] | 左侧工具原子（图标按钮、工具 pill） |
| children | `Array[Html]` | — | 替换输入区的富文本内容 |
| aria_label | `String` | — |  |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

### agent_tool_button

图标前置的工具 pill。

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| icon | `Html` | — |  |
| label **\*** | `String` | — | 12/20 标签文本 |
| disabled | `Bool` | false | 禁用交互并降低不透明度 |
| on_click | `Cmd` | — | 点击时发送的命令 |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| title | `String` | — | 原生 tooltip 标题 |
| aria_label | `String` | — |  |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

\* 必填（标签）参数——其余均为可选。
