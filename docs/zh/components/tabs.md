# Tabs 标签页

下划线样式的标签行，用于切换视图。

## 示例

### 基础用法

<SumiDemo name="tabs-basic">

```moonbit
@sumi.tabs(
  items=[
    @sumi.TabEntry::new("all", "All"),
    @sumi.TabEntry::new("mine", "Mine"),
    @sumi.TabEntry::new("shared", "Shared"),
  ],
  selected=current,
  on_select=set_tab.map(v => _ => v),
)
```

</SumiDemo>

## API

### tabs

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| items **\*** | `Array[TabEntry]` | — | 标签列表 |
| selected **\*** | `String` | — | 激活标签的值（受控） |
| on_select | `Emit[String]` | — | 选中某项时以其值调用 |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

### TabEntry::new

一个标签。

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| value | `String` | — |  |
| label | `String` | — |  |
| icon | `Html` | — | 前置图标 |

\* 必填（标签）参数——其余均为可选。
