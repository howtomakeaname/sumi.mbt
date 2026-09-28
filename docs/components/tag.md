# Tag

A compact label for status and metadata, optionally removable.

## Examples

### Variants

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

| Name | Type | Default | Description |
|---|---|---|---|
| variant | `TagVariant` | Default | Visual style |
| on_remove | `Cmd` | — | Renders a ✕ that fires this command |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |
| children | `C` | — | Content |

### TagVariant

| Variant | Description |
|---|---|
| `Default` | Filled neutral chip |
| `Brand` | Brand-tinted, for premium or AI marks |
| `Outline` | Bordered, no fill |

\* required (labelled) parameter — everything else is optional.
