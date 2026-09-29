# Chip

A single selectable pill — the quality-option look from the design. Text stays full-white in both states; selection shows through the block fill alone. Group several chips under one value for a radio-like row.

## Examples

### Quality row

<SumiDemo name="chip-row">

```moonbit
@sumi.chip("720P", selected=quality == "720P",
  on_click=set_quality(_ => "720P"))
@sumi.chip("8K", disabled=true)
```

</SumiDemo>

## API

### chip

| Name | Type | Default | Description |
|---|---|---|---|
| label | `String` | — |  |
| selected | `Bool` | false | Filled on-state (controlled) |
| on_click | `Cmd` | — | Click command (wire to your state) |
| disabled | `Bool` | false | Faded and inert |
| aria_label | `String` | — |  |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

\* required (labelled) parameter — everything else is optional.
