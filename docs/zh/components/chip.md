# Chip 选项片

单个可选药丸片。两种状态下文字均为全白，选中态仅通过块填充体现。将多个 chip 绑定到同一个值即可组成单选行。

## 示例

### 质量选项行

<SumiDemo name="chip-row">

```moonbit
@sumi.chip("M", selected=size == "m",
  on_click=set_size(_ => "m"))
@sumi.chip("8K", disabled=true)
```

</SumiDemo>

## API

### chip

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| label | `String` | — |  |
| selected | `Bool` | false | 填充选中态（受控） |
| on_click | `Cmd` | — | 点击命令（接到你的状态） |
| disabled | `Bool` | false | 置灰且不可交互 |
| aria_label | `String` | — |  |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

\* 必填（标签）参数——其余均为可选。
