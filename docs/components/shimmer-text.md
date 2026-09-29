# Shimmer Text

Loading text with a dim band sweeping endlessly across the glyphs — the agent status line's in-progress state. The gradient is clipped to the letterforms (`background-clip:text`); reduced motion freezes the sweep.

## Examples

### Status lines

<SumiDemo name="shimmer-text">

```moonbit
@sumi.shimmer_text("Working on it…")
@sumi.shimmer_text("Generating the image…")
@sumi.shimmer_text("Reading the canvas…")
```

</SumiDemo>

## API

### shimmer_text

| Name | Type | Default | Description |
|---|---|---|---|
| text | `String` | — |  |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

\* required (labelled) parameter — everything else is optional.
