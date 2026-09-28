# Spinner 加载指示器

旋转圆弧，用于局部加载。按钮与发送按钮内部也使用它。

## 示例

### 尺寸

<SumiDemo name="spinner-basic">

```moonbit
@sumi.spinner()
@sumi.spinner(size=24)
```

</SumiDemo>

## API

### spinner

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| size | `Int` | 16 | 直径（px） |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| style | `Array[String]` | [] | 附加内联样式 |

\* 必填（标签）参数——其余均为可选。
