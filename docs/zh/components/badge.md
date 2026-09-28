# Badge 徽标

数字计数或状态点。

## 示例

### 基础用法

<SumiDemo name="badge-basic">

```moonbit
@sumi.badge(value=5)
@sumi.badge(value=120)
@sumi.badge(dot=true)
```

</SumiDemo>

## API

### badge

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| value | `Int` | — | 显示的数字（超过 99 截断显示） |
| dot | `Bool` | false | 渲染为纯圆点而非数字 |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

\* 必填（标签）参数——其余均为可选。
