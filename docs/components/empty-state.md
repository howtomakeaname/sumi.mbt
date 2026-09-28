# Empty State

An icon + title + description placeholder with an optional action, for empty panels.

## Examples

### Inside a card

<SumiDemo name="empty-state-basic">

```moonbit
@sumi.empty_state(
  title_text="No versions yet",
  description="Generated results will appear here.",
  icon=@sumi.icon_image(size=24),
  action=@sumi.button(variant=@sumi.Secondary, size=@sumi.Sm, "New Version"),
)
```

</SumiDemo>

## API

### empty_state

| Name | Type | Default | Description |
|---|---|---|---|
| title_text **\*** | `String` | — | Heading line |
| description | `String` | — | Supporting text |
| icon | `Html` | — | Artwork above the title |
| action | `Html` | — | Call-to-action below the text |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

\* required (labelled) parameter — everything else is optional.
