# Stepper

Segmented − value + control that clamps at min/max.

## Examples

### Basic usage

<SumiDemo name="stepper-basic">

```moonbit
@sumi.stepper(
  value=current,
  min=1,
  max=8,
  on_change=set_count.map(v => _ => v),
)
```

</SumiDemo>

## API

### stepper

| Name | Type | Default | Description |
|---|---|---|---|
| value **\*** | `Int` | — | Current number (controlled) |
| min | `Int` | 1 | Lower clamp |
| max | `Int` | 8 | Upper clamp |
| step | `Int` | 1 | Increment per click |
| on_change | `Emit[Int]` | — | Called when the value changes |
| disabled | `Bool` | false | Blocks interaction and dims the control |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

\* required (labelled) parameter — everything else is optional.
