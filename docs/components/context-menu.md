# Context Menu

Right-click menu fixed at the pointer position. The theme's event layer suppresses the native menu, records the pointer, and focuses the first item.

## Examples

### Right-click the tile

<SumiDemo name="context-menu-basic">

```moonbit
@sumi.context_menu(
  entries=[
    @sumi.Item(@sumi.MenuItem::new("rename", "Rename", shortcut="R")),
    @sumi.Separator,
    @sumi.Item(@sumi.MenuItem::new("delete", "Delete", shortcut="⌫")),
  ],
  open=is_open,
  on_open_change=set_open.map(v => _ => v),
  on_select=set_action.map(v => _ => v),
  target_content,
)
```

</SumiDemo>

## API

### context_menu

| Name | Type | Default | Description |
|---|---|---|---|
| entries **\*** | `Array[MenuEntry]` | — | Menu content — `Item`, `Separator`, `SectionLabel` |
| open **\*** | `Bool` | — | Whether the overlay is open (controlled) |
| on_open_change | `Emit[Bool]` | — | Called when the open state should change |
| selected | `String` | — | Value of the currently selected item |
| on_select | `Emit[String]` | — | Called with the value of the picked item |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |
| menu_style | `Array[String]` | [] | Styles for the floating panel |
| children | `C` | — | Content |

\* required (labelled) parameter — everything else is optional.
