# Popover

A trigger-anchored free-content panel for small forms and inspectors.

## Examples

### With a slider inside

<SumiDemo name="popover-basic">

```moonbit
@sumi.popover(
  trigger=@sumi.button(variant=@sumi.Secondary, [
    @sumi.icon_adjust(size=14),
    @html.text("Adjust"),
  ]),
  open=is_open,
  on_open_change=set_open.map(v => _ => v),
  panel_content,
)
```

</SumiDemo>

## API

### popover

| Name | Type | Default | Description |
|---|---|---|---|
| trigger **\*** | `Html` | — | The anchor element |
| open **\*** | `Bool` | — | Whether the overlay is open (controlled) |
| on_open_change | `Emit[Bool]` | — | Called when the open state should change |
| align | `MenuAlign` | Start | Horizontal alignment against the trigger |
| side | `MenuSide` | Bottom | Open above or below the trigger |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |
| panel_style | `Array[String]` | [] | Styles for the floating panel |
| children | `C` | — | Content |

### MenuAlign

`Start` · `End`

### MenuSide

`Bottom` · `Top`

\* required (labelled) parameter — everything else is optional.
