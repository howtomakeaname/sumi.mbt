# Attachment Strip 附件条

一排 48px 附件块：裁切填充的图片缩略图与石板渐变文档占位块，末尾跟随添加块。悬停附件块会显现 8px 移除角标。超过 `max_visible` 时行被裁断，右缘出现渐隐遮罩，添加块固定在遮罩之上。

## 示例

### 添加与移除

<SumiDemo name="attachment-strip">

```moonbit
@sumi.attachment_strip(
  items=[
    @sumi.AttachmentItem::image("cover.png", label="Cover"),
    @sumi.AttachmentItem::document("Brief.pdf"),
  ],
  on_add=pick_files,
  on_remove=set_items.map(i => c => remove_at(c, i)),
)
```

</SumiDemo>

## API

### attachment_strip

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| items **\*** | `Array[AttachmentItem]` | — | 按顺序渲染的附件 |
| on_add | `Cmd` | — | 提供则渲染末尾添加块；溢出时固定在右缘 |
| on_remove | `Emit[Int]` | — | 悬停角标触发，携带附件下标 |
| max_visible | `Int` | 10 | 超出该数量后出现渐隐遮罩与固定添加块（默认 10） |
| aria_label | `String` | "Attachments" | 整条的无障碍标签（默认 "Attachments"） |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

### AttachmentItem::image

一个图片附件。

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| src | `String` | — |  |
| label | `String` | "Image attachment" | 替代文本（默认 "Image attachment"） |

### AttachmentItem::document

非图片附件，渲染为渐变占位块。

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| label | `String` | — |  |

### AttachmentKind

| Variant | 说明 |
|---|---|
| `Image` | 裁切填充的缩略图块 |
| `Document` | 石板渐变占位块，带文档图标 |

\* 必填（标签）参数——其余均为可选。
