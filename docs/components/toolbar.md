# Toolbar

A frosted action bar grouping menus, segmented controls, credits and the primary submit. Dividers separate clusters.

## Examples

### Composed toolbar

<SumiDemo name="toolbar-basic">

```moonbit
@sumi.toolbar([
  @sumi.dropdown_menu(trigger=..., items=..., ...),
  @sumi.toolbar_divider(),
  @sumi.segmented(items=..., selected=..., on_select=...),
  @sumi.toolbar_divider(),
  @sumi.credits(value=24),
  @sumi.button(variant=@sumi.Primary, [
    @sumi.icon_sparkle(size=14),
    @html.text("Generate"),
  ]),
])
```

</SumiDemo>

## API

### toolbar

| Name | Type | Default | Description |
|---|---|---|---|
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| title | `String` | — | Native tooltip title |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |
| children | `C` | — | Content |

### toolbar_divider

A 1px vertical rule between toolbar clusters.

| Name | Type | Default | Description |
|---|---|---|---|
| style | `Array[String]` | [] | Extra inline styles |

\* required (labelled) parameter — everything else is optional.
