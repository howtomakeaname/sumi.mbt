# Progress 进度条

确定进度的进度条，可选数值显示。

## 示例

### 基础用法

<SumiDemo name="progress-basic">

```moonbit
@sumi.progress(value=72, show_value=true)
@sumi.progress(value=30)
```

</SumiDemo>

## API

### progress

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| value **\*** | `Int` | — | 当前值（受控） |
| max | `Int` | 100 | 满量程值 |
| show_value | `Bool` | false | 右侧数值显示 |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

\* 必填（标签）参数——其余均为可选。
