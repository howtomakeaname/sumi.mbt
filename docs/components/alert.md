# Alert

An inline icon + message note for validation and status inside a panel.

## Examples

### Solid & subtle

<SumiDemo name="alert-basic">

```moonbit
@sumi.alert(
  message="Prompt exceeds the 800-word limit — shorten it before generating",
)
@sumi.alert(
  variant=@sumi.Subtle,
  message="Check the highlighted section before sending",
)
```

</SumiDemo>

## API

### alert

| Name | Type | Default | Description |
|---|---|---|---|
| message **\*** | `String` | — | Note text; wraps to multiple lines |
| variant | `AlertVariant` | Solid | `Solid` on the canvas, `Subtle` on a filled surface |
| icon | `Html` | — | Leading glyph (defaults to `icon_important`) |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

### AlertVariant

| Variant | Description |
|---|---|
| `Solid` | Tooltip-dark fill for notes sitting on the canvas |
| `Subtle` | Barely-there fill for notes on an already-filled surface |

\* required (labelled) parameter — everything else is optional.
