# Prompt Box 提示输入框

磨砂多行输入坞，带圆形发送按钮、可选字符计数，以及放置选择器等操作的动作槽。

## 示例

### 带操作选择器

<SumiDemo name="prompt-box-basic">

```moonbit
@sumi.prompt_box(
  value=current_prompt,
  placeholder="Describe what to create",
  on_input=set_prompt.map(v => _ => v),
  on_send=set_prompt(_ => ""),
  send_disabled=current_prompt.is_empty(),
  actions=@sumi.dropdown_menu(...),
)
```

</SumiDemo>

### 字符计数

<SumiDemo name="prompt-box-count">

```moonbit
@sumi.prompt_box(
  value=current,
  rows=3,
  maxlength=120,
  show_count=true,
  on_input=set_prompt.map(v => _ => v),
)
```

</SumiDemo>

### 发送按钮

<SumiDemo name="send-button-basic">

```moonbit
@sumi.send_button(aria_label="Send")
@sumi.send_button(disabled=true, aria_label="Send (disabled)")
@sumi.send_button(loading=true, aria_label="Sending")
```

</SumiDemo>

## API

### prompt_box

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| value **\*** | `String` | — | 当前文本（受控） |
| placeholder | `String` | "" | 占位文本 |
| rows | `Int` | 1 | 可见行数 |
| on_input | `Emit[String]` | — | 每次输入时调用 |
| on_send | `Cmd` | — | 发送命令（按钮或 ⌘Enter） |
| send_disabled | `Bool` | false | 禁用发送按钮 |
| send_loading | `Bool` | false | 将箭头替换为加载圈 |
| disabled | `Bool` | false | 禁用交互并降低不透明度 |
| maxlength | `Int` | — | 最大字符数 |
| show_count | `Bool` | false | 显示 `n / max`，超出时变红 |
| autofocus | `Bool` | — | 挂载后自动聚焦 |
| actions | `Html` | — | 放置选择器与工具的前置槽位 |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

### send_button

独立的圆形发送按钮。

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| disabled | `Bool` | false | 禁用交互并降低不透明度 |
| loading | `Bool` | false | 以禁用色调显示加载圈 |
| on_click | `Cmd` | — | 点击时发送的命令 |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| title | `String` | — | 原生 tooltip 标题 |
| aria_label | `String` | "Send" |  |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

\* 必填（标签）参数——其余均为可选。
