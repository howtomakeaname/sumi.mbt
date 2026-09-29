# Attachment Strip

A row of 48px attachment tiles — cover-fit image thumbnails and slate-gradient document placeholders — followed by an add tile. Hovering a tile reveals its 8px remove badge. Past `max_visible` items the row clips, a right-edge fade appears, and the add tile pins over it.

## Examples

### Add & remove

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

| Name | Type | Default | Description |
|---|---|---|---|
| items **\*** | `Array[AttachmentItem]` | — | Attachments to render, in order |
| on_add | `Cmd` | — | Adds the trailing add tile; in overflow it pins to the right edge |
| on_remove | `Emit[Int]` | — | Emitted with the item index from the hover badge |
| max_visible | `Int` | 10 | Visible tile cap before the fade + pinned add (default 10) |
| aria_label | `String` | "Attachments" | Strip label (defaults to "Attachments") |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

### AttachmentItem::image

An image attachment.

| Name | Type | Default | Description |
|---|---|---|---|
| src | `String` | — |  |
| label | `String` | "Image attachment" | Alt text (defaults to "Image attachment") |

### AttachmentItem::document

A non-image attachment, rendered as a gradient placeholder.

| Name | Type | Default | Description |
|---|---|---|---|
| label | `String` | — |  |

### AttachmentKind

| Variant | Description |
|---|---|
| `Image` | Cover-fit thumbnail tile |
| `Document` | Slate-gradient placeholder with a document glyph |

\* required (labelled) parameter — everything else is optional.
