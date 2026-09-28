# Slider

Draggable value track. `on_input` fires per tick; `on_commit` fires once on release so expensive reactions don't fan out.

## Examples

### With value

<SumiDemo name="slider-basic">

```moonbit
@sumi.slider(
  value=current,
  show_value=true,
  suffix="°",
  on_input=set_strength.map(v => _ => v),
)
```

</SumiDemo>

### Value bubble

<SumiDemo name="slider-tooltip">

```moonbit
@sumi.slider(
  value=current,
  value_tooltip=true,
  on_input=set_amount.map(v => _ => v),
)
```

</SumiDemo>

## API

### slider

| Name | Type | Default | Description |
|---|---|---|---|
| value **\*** | `Int` | — | Current value (controlled) |
| min | `Int` | 0 | Lower bound |
| max | `Int` | 100 | Upper bound |
| step | `Int` | 1 | Tick size |
| on_input | `Emit[Int]` | — | Called on every input |
| on_commit | `Emit[Int]` | — | Called once on release |
| disabled | `Bool` | false | Blocks interaction and dims the control |
| show_value | `Bool` | false | Right-aligned numeric readout |
| value_tooltip | `Bool` | false | Bubble above the thumb while interacting |
| suffix | `String` | "" | Unit appended to the readout |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

\* required (labelled) parameter — everything else is optional.
