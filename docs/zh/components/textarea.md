# Textarea 多行文本

多行纯文本输入框。

## 示例

### 基础用法

<SumiDemo name="textarea-basic">

```moonbit
@sumi.textarea(
  value=current,
  placeholder="Add release notes",
  rows=4,
  on_input=set_notes.map(v => _ => v),
)
```

</SumiDemo>

## API

### textarea

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| value **\*** | `String` | — | 当前文本（受控） |
| placeholder | `String` | "" | 占位文本 |
| rows | `Int` | 3 | 可见行数 |
| on_input | `Emit[String]` | — | 每次输入时调用 |
| on_change | `Emit[String]` | — | 值变化时调用 |
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
