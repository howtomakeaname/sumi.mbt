# Badge

A numeric counter or status dot.

## Examples

### Basic usage

<SumiDemo name="badge-basic">

```moonbit
@sumi.badge(value=5)
@sumi.badge(value=120)
@sumi.badge(dot=true)
```

</SumiDemo>

## API

### badge

| Name | Type | Default | Description |
|---|---|---|---|
| value | `Int` | — | Number to display (clamped display over 99) |
| dot | `Bool` | false | Renders a plain dot instead of a number |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

\* required (labelled) parameter — everything else is optional.
