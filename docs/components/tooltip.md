# Tooltip

A hover/focus bubble on any trigger, scaling in from the anchored edge. Four sides.

## Examples

### Four sides

<SumiDemo name="tooltip-basic">

```moonbit
@sumi.tooltip(content="Export the current project",
  @sumi.icon_button(@sumi.icon_upload(), aria_label="Export"))
@sumi.tooltip(content="More actions", side=@sumi.Bottom,
  @sumi.icon_button(@sumi.icon_more(), aria_label="More"))
```

</SumiDemo>

## API

### tooltip

| Name | Type | Default | Description |
|---|---|---|---|
| content **\*** | `String` | — | Bubble text |
| side | `TooltipSide` | Top | Which side of the trigger to sit on |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |
| children | `C` | — | Content |

### TooltipSide

`Top` · `Bottom` · `Left` · `Right`

\* required (labelled) parameter — everything else is optional.
