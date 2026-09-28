# Icons

A stroke icon set drawn as inline SVG. Every icon takes an optional `size` (default 16).

## Examples

### The set

<SumiDemo name="icons-basic">

```moonbit
@sumi.icon_search(size=16)
@sumi.icon_sparkle(size=16)
@sumi.icon_download(size=16)
// …25 icons in total
```

</SumiDemo>

## API

### icon

Renders an icon by name from the set.

| Name | Type | Default | Description |
|---|---|---|---|
| path | `String` | — |  |
| size | `Int` | 16 | Size in px |
| stroke_width | `Int` | 2 | Stroke width |
| style | `Array[String]` | [] | Extra inline styles |

### icon_ratio

Proportional artwork for the ratio picker.

| Name | Type | Default | Description |
|---|---|---|---|
| width **\*** | `Int` | — | Aspect width |
| height **\*** | `Int` | — | Aspect height |
| size | `Int` | 16 | Bounding box in px |

Available names: `adjust`, `arrow-down`, `arrow-up`, `check`, `chevron-down`, `chevron-left`, `chevron-right`, `chevron-up`, `clock`, `crop`, `download`, `expand`, `grid`, `image`, `layers`, `minus`, `more`, `play`, `plus`, `reset`, `scissors`, `search`, `sparkle`, `upload`, `x` — each also has a dedicated `icon_<name>()` function.

\* required (labelled) parameter — everything else is optional.
