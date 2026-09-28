# Skeleton 骨架屏

内容加载期间的微光占位形状。

## 示例

### 形状

<SumiDemo name="skeleton-basic">

```moonbit
@sumi.skeleton_tile(width="160px", height="90px")
@sumi.skeleton_lines(count=3)
@sumi.skeleton(width="64px", height="64px", radius="50%")
```

</SumiDemo>

## API

### skeleton

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| width | `String` | "100%" | CSS 宽度 |
| height | `String` | "14px" | CSS 高度 |
| radius | `String` | "4px" | 圆角（圆形用 50%） |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

### skeleton_lines

一组文本行。

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| count | `Int` | 2 | 行数 |
| style | `Array[String]` | [] | 附加内联样式 |

### skeleton_tile

圆角媒体块。

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| width | `String` | "200px" | CSS 宽度 |
| height | `String` | "200px" | CSS 高度 |
| style | `Array[String]` | [] | 附加内联样式 |

\* 必填（标签）参数——其余均为可选。
