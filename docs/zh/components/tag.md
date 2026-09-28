# Tag 标签

紧凑的状态与元数据标签，可选移除按钮。

## 示例

### 变体

<SumiDemo name="tag-basic">

```moonbit
@sumi.tag("Draft")
@sumi.tag(variant=@sumi.Brand, [
  @sumi.icon_sparkle(size=12),
  @html.text("AI"),
])
@sumi.tag(variant=@sumi.Outline, "16:9")
@sumi.tag(on_remove=@cmd.none, "Removable")
```

</SumiDemo>

## API

### tag

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| variant | `TagVariant` | Default | 视觉风格 |
| on_remove | `Cmd` | — | 渲染触发该命令的 ✕ 按钮 |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |
| children | `C` | — | 内容 |

### TagVariant

| Variant | 说明 |
|---|---|
| `Default` | 中性实心 |
| `Brand` | 品牌色，用于高级或 AI 标识 |
| `Outline` | 描边无填充 |

\* 必填（标签）参数——其余均为可选。
