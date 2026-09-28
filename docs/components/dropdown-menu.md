# Dropdown Menu

A trigger-anchored menu with compact or rich items, section labels, separators and shortcut hints. Keyboard navigation and dismissal are handled by the theme's event layer.

## Examples

### Rich items

<SumiDemo name="dropdown-menu-basic">

```moonbit
@sumi.dropdown_menu(
  trigger=@sumi.button(variant=@sumi.Secondary, [
    @html.text("Enhance"),
    @sumi.menu_chevron(),
  ]),
  items=[
    @sumi.SectionLabel("QUALITY"),
    @sumi.Item(@sumi.MenuItem::new(
      "standard", "Standard",
      description="Balanced clarity for everyday images",
      icon=@sumi.icon_sparkle(size=16),
    )),
  ],
  open=is_open,
  on_open_change=set_open.map(v => _ => v),
  selected=current,
  on_select=set_choice.map(v => _ => v),
)
```

</SumiDemo>

### Compact with shortcuts

<SumiDemo name="dropdown-menu-compact">

```moonbit
items=[
  @sumi.Item(@sumi.MenuItem::new("rename", "Rename", shortcut="R")),
  @sumi.Item(@sumi.MenuItem::new("duplicate", "Duplicate",
    icon=@sumi.icon_layers(size=14), shortcut="⌘D")),
  @sumi.Separator,
  @sumi.Item(@sumi.MenuItem::new("delete", "Delete",
    icon=@sumi.icon_x(size=14), shortcut="⌫")),
]
```

</SumiDemo>

## API

### dropdown_menu

| Name | Type | Default | Description |
|---|---|---|---|
| items **\*** | `Array[MenuEntry]` | — | Menu content — `Item`, `Separator`, `SectionLabel` |
| trigger **\*** | `Html` | — | The anchor element |
| open **\*** | `Bool` | — | Whether the overlay is open (controlled) |
| on_open_change | `Emit[Bool]` | — | Called when the open state should change |
| selected | `String` | — | Value of the currently selected item |
| on_select | `Emit[String]` | — | Called with the value of the picked item |
| align | `MenuAlign` | Start | Horizontal alignment against the trigger |
| side | `MenuSide` | Bottom | Open above or below the trigger |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |
| trigger_style | `Array[String]` | [] | Styles for the trigger wrapper |
| menu_style | `Array[String]` | [] | Styles for the floating panel |

### menu_chevron

The rotating trigger chevron (180° while open).

| Name | Type | Default | Description |
|---|---|---|---|
| size | `Int` | 12 |  |

### MenuItem::new

One menu item.

| Name | Type | Default | Description |
|---|---|---|---|
| value | `String` | — |  |
| label | `String` | — |  |
| description | `String` | — | Secondary line (rich layout) |
| icon | `Html` | — | Leading icon |
| shortcut | `String` | — | Right-aligned shortcut hint |
| disabled | `Bool` | false | Blocks interaction and dims the control |

### MenuAlign

| Variant | Description |
|---|---|
| `Start` | Align the panel's left edge to the trigger |
| `End` | Align the panel's right edge to the trigger |

### MenuSide

| Variant | Description |
|---|---|
| `Bottom` | Open below the trigger (default) |
| `Top` | Open above the trigger (input docks) |

\* required (labelled) parameter — everything else is optional.
