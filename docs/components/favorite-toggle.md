# Favorite Toggle

A chrome-less star button that toggles a favorite on or off. Unlike `icon_button` it carries no hover plate; state shows through the glyph alone — outline star at rest, filled amber when on.

## Examples

### Basic usage

<SumiDemo name="favorite-toggle">

```moonbit
@sumi.favorite_toggle(checked=fav, on_change=set_fav.map(v => _ => v))
@sumi.favorite_toggle(checked=true, disabled=true)
```

</SumiDemo>

## API

### favorite_toggle

| Name | Type | Default | Description |
|---|---|---|---|
| checked **\*** | `Bool` | — | Current on/off state (controlled) |
| on_change | `Emit[Bool]` | — | Emitted with the flipped value on click |
| disabled | `Bool` | false | Faded and inert |
| aria_label | `String` | — | Override the accessible label (defaults flip with state) |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

\* required (labelled) parameter — everything else is optional.
