# Progress

A determinate progress bar with an optional numeric readout.

## Examples

### Basic usage

<SumiDemo name="progress-basic">

```moonbit
@sumi.progress(value=72, show_value=true)
@sumi.progress(value=30)
```

</SumiDemo>

## API

### progress

| Name | Type | Default | Description |
|---|---|---|---|
| value **\*** | `Int` | — | Current value (controlled) |
| max | `Int` | 100 | Full-scale value |
| show_value | `Bool` | false | Numeric readout on the right |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

\* required (labelled) parameter — everything else is optional.
