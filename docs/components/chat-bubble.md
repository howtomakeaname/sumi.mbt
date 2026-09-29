# Chat Bubble

The right-aligned bubble of a sent message. Plain text, or rich content with inline media tags; long messages clamp behind a fade with an Expand/Collapse toggle, and a copy action appears below on hover.

## Examples

### Plain, rich & collapsible

<SumiDemo name="chat-bubble">

```moonbit
@sumi.chat_bubble(text="Continue")
@sumi.chat_bubble(children=[
  @sumi.media_tag(kind=@sumi.Image, variant=@sumi.Inline, thumbnail=thumb),
  @html.text("Add more detail"),
])
@sumi.chat_bubble(
  text=long,
  collapsible=true,
  collapsed=c,
  on_toggle=set_c.map(v => _ => !v),
  on_copy=copy_it,
)
```

</SumiDemo>

## API

### chat_bubble

| Name | Type | Default | Description |
|---|---|---|---|
| text | `String` | — | Plain-text content (mutually exclusive with children) |
| children | `Array[Html]` | — | Rich content row: inline media tags + text spans |
| collapsible | `Bool` | false | Enables the clamp + Expand/Collapse toggle |
| collapsed | `Bool` | true | Controlled clamp state |
| on_toggle | `Cmd` | — | Expand/Collapse click command |
| collapse_lines | `Int` | 9 | Lines kept when collapsed (default 9) |
| on_copy | `Cmd` | — | Copy action revealed below the bubble on hover |
| aria_label | `String` | — |  |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

\* required (labelled) parameter — everything else is optional.
