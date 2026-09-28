# Card

`card` is the bare bordered surface; `card_section` adds the header/content split and is the default choice for panels.

## Examples

### Bare card

<SumiDemo name="card-basic">

```moonbit
@sumi.card(style=["width:280px;padding:16px"], [
  @html.text("Bring your own padding and layout."),
])
```

</SumiDemo>

### Section card

<SumiDemo name="card-section">

```moonbit
@sumi.card_section(header=@html.text("Settings"), [
  @sumi.checkbox(checked=true, label="Auto-save"),
  @sumi.divider(),
  ...
])
```

</SumiDemo>

## API

### card

| Name | Type | Default | Description |
|---|---|---|---|
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| title | `String` | — | Native tooltip title |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |
| children | `C` | — | Content |

### card_section

| Name | Type | Default | Description |
|---|---|---|---|
| header **\*** | `Html` | — | Header row content |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |
| children | `C` | — | Content |

### divider

A 1px rule for stacking inside card content.

| Name | Type | Default | Description |
|---|---|---|---|
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

\* required (labelled) parameter — everything else is optional.
