# Avatar

A round identity image with an initials fallback.

## Examples

### Fallback initials

<SumiDemo name="avatar-basic">

```moonbit
@sumi.avatar(fallback="Sumi")
@sumi.avatar(fallback="墨", size=40)
```

</SumiDemo>

## API

### avatar

| Name | Type | Default | Description |
|---|---|---|---|
| src | `String` | — | Image URL; falls back when missing or failed |
| fallback | `String` | "" | Text rendered when no image is available |
| size | `Int` | 32 | Diameter in px |
| alt | `String` | "" | Image alt text |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

\* required (labelled) parameter — everything else is optional.
