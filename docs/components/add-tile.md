# Add Tile

The 48px add tile: a quiet bordered square with a centered plus. Compose it as a `dropdown_menu` trigger to open an upload/picker menu above; hover raises the fill to the primary block.

## Examples

### With picker menu

<SumiDemo name="add-tile-basic">

```moonbit
@sumi.dropdown_menu(
  trigger=@sumi.add_tile(aria_label="Add image"),
  items=[
    Item(@sumi.MenuItem::new("upload", "Upload image",
      icon=@sumi.icon_upload_fill())),
    Item(@sumi.MenuItem::new("assets", "Select from assets",
      icon=@sumi.icon_folder())),
    Item(@sumi.MenuItem::new("canvas", "Select from canvas",
      icon=@sumi.icon_target())),
  ],
  open=is_open,
  on_open_change=set_open.map(v => _ => v),
  side=@sumi.Top,
  menu_style=["width:240px"],
)
@sumi.add_tile(disabled=true)
```

</SumiDemo>

## API

### add_tile

| Name | Type | Default | Description |
|---|---|---|---|
| on_click | `Cmd` | — | Click command (usually the menu toggle via composition) |
| disabled | `Bool` | false | Faded plus and inert |
| aria_label | `String` | — | Accessible label (defaults to "Add") |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

\* required (labelled) parameter — everything else is optional.
