# Shimmer Text 扫光文字

一条暗带在文字上往复扫过的加载文案——agent 状态行的进行中态。渐变裁剪到字形上（`background-clip:text`）；减弱动效时扫动冻结。

## 示例

### 状态文案

<SumiDemo name="shimmer-text">

```moonbit
@sumi.shimmer_text("Working on it…")
@sumi.shimmer_text("Generating the image…")
@sumi.shimmer_text("Reading the canvas…")
```

</SumiDemo>

## API

### shimmer_text

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| text | `String` | — |  |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

\* 必填（标签）参数——其余均为可选。
