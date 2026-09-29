# Shortcuts Panel

The keyboard-shortcuts reference sheet: an elevated 264px panel with a titled header and close button, then titled sections of label + key-chip rows. Long lists scroll inside the body.

## Examples

### Three sections

<SumiDemo name="shortcuts-panel">

```moonbit
@sumi.shortcuts_panel(
  sections=[
    @sumi.ShortcutSection::new("General", [
      @sumi.ShortcutItem::new("Toggle sidebar", "Cmd /"),
      @sumi.ShortcutItem::new("Send message", "Enter"),
    ]),
    @sumi.ShortcutSection::new("Editing", [
      @sumi.ShortcutItem::new("Select all", "⌘ A"),
      @sumi.ShortcutItem::new("Undo", "⌘ Z"),
    ]),
  ],
  on_close=close_panel,
)
```

</SumiDemo>

## API

### shortcuts_panel

| Name | Type | Default | Description |
|---|---|---|---|
| sections **\*** | `Array[ShortcutSection]` | — | Titled shortcut clusters |
| title | `String` | "Shortcuts" | Header text (defaults to "Shortcuts") |
| on_close | `Cmd` | — | Close button command; omit to hide the button's action |
| width | `Int` | 264 | Panel width in px (default 264) |
| max_height | `Int` | 660 | Panel max height in px (default 660) |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

### ShortcutSection::new

A titled cluster.

| Name | Type | Default | Description |
|---|---|---|---|
| title | `String` | — | Native tooltip title |
| items | `Array[ShortcutItem]` | — |  |

### ShortcutItem::new

One row.

| Name | Type | Default | Description |
|---|---|---|---|
| label | `String` | — |  |
| keys | `String` | — |  |

\* required (labelled) parameter — everything else is optional.
