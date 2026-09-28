# Credits

A compact balance readout with an optional strikethrough original price.

## Examples

### Basic usage

<SumiDemo name="credits-basic">

```moonbit
@sumi.credits(value=24)
@sumi.credits(value=24, original_value=48)
@sumi.credits(value=8, muted=true)
```

</SumiDemo>

## API

### credits

| Name | Type | Default | Description |
|---|---|---|---|
| value **\*** | `Int` | — | Current balance |
| original_value | `Int` | — | Struck-through original when discounted |
| muted | `Bool` | false | Drops to the placeholder tone for frosted docks |
| on_click | `Cmd` | — | Click command |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| title | `String` | — | Native tooltip title |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

\* required (labelled) parameter — everything else is optional.
