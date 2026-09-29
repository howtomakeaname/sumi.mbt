# Checkbox Menu

A multi-select menu panel: grouped rows carrying an outline checkbox that toggle independently, an optional per-group clear action, and a pinned footer row. The body scrolls past the max height.

## Examples

### Grouped multi-select

<SumiDemo name="checkbox-menu">

```moonbit
@sumi.checkbox_menu(
  groups=[
    @sumi.CheckboxMenuGroup::new([
      @sumi.CheckboxMenuItem::new("text", "Text", checked=true),
      @sumi.CheckboxMenuItem::new("date", "Date"),
    ], title="Fields", clear_label="Clear", on_clear=clear_fields),
  ],
  on_toggle=set_selected.map(v => fn(c) { toggle(c, v) }),
  footer_label="Show all",
  on_footer=show_all,
)
```

</SumiDemo>

## API

### checkbox_menu

| Name | Type | Default | Description |
|---|---|---|---|
| groups **\*** | `Array[CheckboxMenuGroup]` | — | Titled sections of rows; a hairline sits between groups |
| on_toggle | `Emit[String]` | — | Emits the clicked row's `value` |
| width | `Int` | 200 | Panel width — the design's steps are 160/200/240/320 |
| max_height | `Int` | 480 | Scroll threshold for the body |
| footer_label | `String` | — | Pinned row below the scroll area |
| footer_icon | `Html` | — | Leading icon of the footer row |
| on_footer | `Cmd` | — | Footer row activation |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

### CheckboxMenuGroup::new

One titled section.

| Name | Type | Default | Description |
|---|---|---|---|
| items | `Array[CheckboxMenuItem]` | — |  |
| title | `String` | — | Section caption |
| clear_label | `String` | — | Text action at the title's right edge |
| on_clear | `Cmd` | — | Clear action command |

### CheckboxMenuItem::new

One toggleable row.

| Name | Type | Default | Description |
|---|---|---|---|
| value | `String` | — |  |
| label | `String` | — |  |
| icon | `Html` | — | Leading icon |
| checked | `Bool` | false | Controlled checked flag |
| disabled | `Bool` | false | Dims and deactivates the row |

\* required (labelled) parameter — everything else is optional.
