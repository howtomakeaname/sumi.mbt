# Checkbox

A labeled checkbox with an indeterminate state for partial selection.

## Examples

### Basic usage

<SumiDemo name="checkbox-basic">

```moonbit
@sumi.checkbox(
  checked=is_checked,
  label="Keep original size",
  on_change=set_checked.map(v => _ => v),
)
@sumi.checkbox(
  checked=false,
  indeterminate=true,
  label="Select all",
  on_change=set_checked.map(v => _ => v),
)
```

</SumiDemo>

## API

### checkbox

| Name | Type | Default | Description |
|---|---|---|---|
| checked **\*** | `Bool` | — | Whether the control is checked (controlled) |
| label | `String` | — | Label text next to the box |
| indeterminate | `Bool` | false | Mixed state; clicking resolves to checked |
| on_change | `Emit[Bool]` | — | Called when the value changes |
| disabled | `Bool` | false | Blocks interaction and dims the control |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

\* required (labelled) parameter — everything else is optional.
