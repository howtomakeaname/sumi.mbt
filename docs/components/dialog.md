# Dialog

A native `<dialog>` modal with overshoot enter motion and a plain dark backdrop. Open it with the framework's dialog command.

## Examples

### Confirm destructive action

<SumiDemo name="dialog-basic">

```moonbit
@sumi.button(
  variant=@sumi.Secondary,
  on_click=@dialog.show("my-dialog"),
  "Open Dialog",
)
@sumi.dialog(
  id="my-dialog",
  title_text="Delete project",
  description="This action cannot be undone.",
  [
    @html.form(method_="dialog", [
      @sumi.button(variant=@sumi.Primary, type_="submit", "Delete"),
    ]),
  ],
)
```

</SumiDemo>

## API

### dialog

| Name | Type | Default | Description |
|---|---|---|---|
| id **\*** | `String` | — | Element id — commands target this |
| title_text | `String` | — | Heading line |
| description | `String` | — | Supporting text under the title |
| show_close | `Bool` | true | Corner ✕ button |
| spacious | `Bool` | false | Widens content from 480px to 616px |
| closedby | `String` | "any" | Native `closedby` behavior |
| on_close | `Emit[String]` | — | Called with the dialog's return value |
| on_cancel | `Cmd` | — | Called on Esc-cancel |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |
| children | `C` | — | Content |

\* required (labelled) parameter — everything else is optional.
