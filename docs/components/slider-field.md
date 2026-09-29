# Slider Field

A labelled numeric field composing the slider with tick marks and labels plus a number box with unit suffix; an optional auto row adds a switch.

## Examples

### Ticks & number box

<SumiDemo name="slider-field">

```moonbit
@sumi.slider_field(
  value=current,
  min=0,
  max=180,
  label="Clip length",
  unit="s",
  ticks=[0, 30, 60, 90, 120, 150, 180],
  auto=is_auto,
  on_auto_change=set_auto.map(v => _ => v),
  on_input=set_length.map(v => _ => v),
)
```

</SumiDemo>

## API

### slider_field

| Name | Type | Default | Description |
|---|---|---|---|
| value **\*** | `Int` | — | Current value (controlled) |
| min | `Int` | 0 |  |
| max | `Int` | 100 |  |
| step | `Int` | 1 |  |
| label | `String` | — | Title above the track; also the number-box aria label |
| unit | `String` | "" | Suffix inside the number box |
| ticks | `Array[Int]` | [] | Values getting a track mark and a label |
| auto | `Bool` | — | Shows the auto row with a switch when given |
| auto_label | `String` | "Auto" |  |
| on_auto_change | `Emit[Bool]` | — |  |
| on_input | `Emit[Int]` | — | Per-tick during drags and number commits |
| on_commit | `Emit[Int]` | — | On release and number commits |
| disabled | `Bool` | false | Blocks interaction and dims the control |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

\* required (labelled) parameter — everything else is optional.
