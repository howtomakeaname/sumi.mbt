# Input 输入框

单行文本框，支持前后缀装饰、清除按钮与错误展示。

## 示例

### 基础用法

<SumiDemo name="input-basic">

```moonbit
@sumi.input(
  value=current,
  placeholder="Search projects",
  prefix=@sumi.icon_search(size=14),
  clearable=true,
  on_input=set_name.map(v => _ => v),
)
```

</SumiDemo>

### 状态

<SumiDemo name="input-states">

```moonbit
@sumi.input(value="Read only field", read_only=true)
@sumi.input(value="Disabled field", disabled=true)
@sumi.input(
  value="Untitled/:",
  error=true,
  error_text="Project name contains invalid characters",
)
```

</SumiDemo>

## API

### input

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| value **\*** | `String` | — | 当前文本（受控） |
| placeholder | `String` | "" | 占位文本 |
| input_type | `InputType` | Text | 原生输入类型（`Text`、`Password` 等） |
| on_input | `Emit[String]` | — | 每次输入时调用 |
| on_change | `Emit[String]` | — | 值变化时调用 |
| on_clear | `Cmd` | — | `clearable` 的自定义清除行为 |
| clearable | `Bool` | false | 非空时显示清除按钮 |
| prefix | `Html` | — | 前置装饰（图标） |
| suffix | `Html` | — | 后置装饰 |
| error | `Bool` | false | 错误边框 + `aria-invalid` |
| error_text | `String` | — | 在输入框下方渲染错误行 |
| disabled | `Bool` | false | 禁用交互并降低不透明度 |
| read_only | `Bool` | false | 只读 |
| name | `String` | — | 表单字段名 |
| maxlength | `Int` | — | 最大字符数 |
| autofocus | `Bool` | — | 挂载后自动聚焦 |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| title | `String` | — | 原生 tooltip 标题 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

\* 必填（标签）参数——其余均为可选。
