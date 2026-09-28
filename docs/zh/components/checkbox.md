# Checkbox 复选框

带标签的复选框，支持表示部分选中的不定状态。

## 示例

### 基础用法

<SumiDemo name="checkbox-basic">

```moonbit
@sumi.checkbox(
  checked=is_checked,
  label="Keep original size",
  on_change=set_checked.map(v => _ => v),
)
@sumi.checkbox(
  checked=false,
  indeterminate=true,
  label="Select all",
  on_change=set_checked.map(v => _ => v),
)
```

</SumiDemo>

## API

### checkbox

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| checked **\*** | `Bool` | — | 是否选中（受控） |
| label | `String` | — | 复选框旁的标签文本 |
| indeterminate | `Bool` | false | 不定状态；点击后变为选中 |
| on_change | `Emit[Bool]` | — | 值变化时调用 |
| disabled | `Bool` | false | 禁用交互并降低不透明度 |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

\* 必填（标签）参数——其余均为可选。
