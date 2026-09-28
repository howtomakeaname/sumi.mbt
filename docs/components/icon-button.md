# Icon Button

A square button for a single icon, with an accessible label. `pressed` turns it into a tool toggle.

## Examples

### Basic usage

<SumiDemo name="icon-button-basic">

```moonbit
@sumi.icon_button(@sumi.icon_download(), aria_label="Download")
@sumi.icon_button(@sumi.icon_crop(), pressed=true, aria_label="Crop (active tool)")
@sumi.icon_button(@sumi.icon_x(), size=@sumi.IconSm, aria_label="Close")
@sumi.icon_button(@sumi.icon_upload(), disabled=true, aria_label="Export")
```

</SumiDemo>

## API

### icon_button

| Name | Type | Default | Description |
|---|---|---|---|
| icon | `Html` | — |  |
| variant | `ButtonVariant` | Ghost | Visual style |
| size | `ButtonSize` | Icon | `Icon` 32×32 or `IconSm` 28×28 |
| disabled | `Bool` | false | Blocks interaction and dims the control |
| pressed | `Bool` | false | Selected fill + `aria-pressed` |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| title | `String` | — | Native tooltip title |
| aria_label | `String` | — | Accessible label (required for icon-only buttons) |
| on_click | `Cmd` | — | Click command |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

### ButtonVariant

`Primary` · `Secondary` · `Ghost`

### ButtonSize

`Default` · `Sm` · `Icon` · `IconSm`

\* required (labelled) parameter — everything else is optional.
