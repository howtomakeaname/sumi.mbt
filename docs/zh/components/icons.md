# Icons 图标

以内联 SVG 绘制的线性图标集。每个图标接受可选 `size`（默认 16）。

## 示例

### 图标全集

<SumiDemo name="icons-basic">

```moonbit
@sumi.icon_search(size=16)
@sumi.icon_sparkle(size=16)
@sumi.icon_download(size=16)
// …25 icons in total
```

</SumiDemo>

## API

### icon

按名称渲染图标集中的图标。

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| path | `String` | — |  |
| size | `Int` | 16 | 尺寸（px） |
| stroke_width | `Int` | 2 | 描边宽度 |
| style | `Array[String]` | [] | 附加内联样式 |

### icon_ratio

为比例选择器绘制按比例缩放的图形。

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| width **\*** | `Int` | — | 比例宽 |
| height **\*** | `Int` | — | 比例高 |
| size | `Int` | 16 | 外框尺寸（px） |

可用名称：`adjust`、`arrow-down`、`arrow-up`、`check`、`chevron-down`、`chevron-left`、`chevron-right`、`chevron-up`、`clock`、`crop`、`download`、`expand`、`grid`、`image`、`layers`、`minus`、`more`、`play`、`plus`、`reset`、`scissors`、`search`、`sparkle`、`upload`、`x`——每个名称同时有对应的 `icon_<name>()` 函数。

\* 必填（标签）参数——其余均为可选。
