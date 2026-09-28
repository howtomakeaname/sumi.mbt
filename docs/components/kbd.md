# Kbd

Renders a keyboard keycap for shortcut hints.

## Examples

### Combo

<SumiDemo name="kbd-basic">

```moonbit
@sumi.kbd("⌘")
@sumi.kbd("K")
```

</SumiDemo>

## API

### kbd

| Name | Type | Default | Description |
|---|---|---|---|
| key | `String` | — |  |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

\* required (labelled) parameter — everything else is optional.
