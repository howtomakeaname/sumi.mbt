# Toast

A fixed top-center transient notice — success, error or info — that fades in and out.

## Examples

### Variants

<SumiDemo name="toast-basic">

```moonbit
@sumi.toast(
  message="Export started — 3 files queued",
  open=show_success,
  variant=@sumi.Success,
  on_close=set_state(_ => ""),
)
```

</SumiDemo>

## API

### toast

| Name | Type | Default | Description |
|---|---|---|---|
| message **\*** | `String` | — | Notice text |
| open **\*** | `Bool` | — | Whether the overlay is open (controlled) |
| variant | `ToastVariant` | Info | Status styling |
| on_close | `Cmd` | — | Called when the toast dismisses |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

### ToastVariant

| Variant | Description |
|---|---|
| `Info` | Neutral glyph |
| `Success` | Brand circle with a check |
| `Error` | Error-red glyph |

\* required (labelled) parameter — everything else is optional.
