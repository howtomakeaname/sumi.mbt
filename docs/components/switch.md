# Switch

A binary on/off toggle. Brand-blue when on.

## Examples

### Basic usage

<SumiDemo name="switch-basic">

```moonbit
@sumi.switch(checked=is_on, on_change=set_enabled.map(v => _ => v))
@sumi.switch(checked=is_on, disabled=true)
```

</SumiDemo>

## API

### switch

| Name | Type | Default | Description |
|---|---|---|---|
| checked **\*** | `Bool` | — | Whether the control is checked (controlled) |
| on_change | `Emit[Bool]` | — | Called when the value changes |
| disabled | `Bool` | false | Blocks interaction and dims the control |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| title | `String` | — | Native tooltip title |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

\* required (labelled) parameter — everything else is optional.
