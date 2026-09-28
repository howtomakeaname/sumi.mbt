# Prompt Box

A frosted multi-line prompt dock with a circular send button, optional character count, and an actions slot for pickers.

## Examples

### With action picker

<SumiDemo name="prompt-box-basic">

```moonbit
@sumi.prompt_box(
  value=current_prompt,
  placeholder="Describe what to create",
  on_input=set_prompt.map(v => _ => v),
  on_send=set_prompt(_ => ""),
  send_disabled=current_prompt.is_empty(),
  actions=@sumi.dropdown_menu(...),
)
```

</SumiDemo>

### Character count

<SumiDemo name="prompt-box-count">

```moonbit
@sumi.prompt_box(
  value=current,
  rows=3,
  maxlength=120,
  show_count=true,
  on_input=set_prompt.map(v => _ => v),
)
```

</SumiDemo>

### Send button

<SumiDemo name="send-button-basic">

```moonbit
@sumi.send_button(aria_label="Send")
@sumi.send_button(disabled=true, aria_label="Send (disabled)")
@sumi.send_button(loading=true, aria_label="Sending")
```

</SumiDemo>

## API

### prompt_box

| Name | Type | Default | Description |
|---|---|---|---|
| value **\*** | `String` | — | Current text (controlled) |
| placeholder | `String` | "" | Placeholder text |
| rows | `Int` | 1 | Visible row count |
| on_input | `Emit[String]` | — | Called on every input |
| on_send | `Cmd` | — | Send command (button or ⌘Enter) |
| send_disabled | `Bool` | false | Disables the send button |
| send_loading | `Bool` | false | Swaps the arrow for a spinner |
| disabled | `Bool` | false | Blocks interaction and dims the control |
| maxlength | `Int` | — | Maximum character count |
| show_count | `Bool` | false | Renders `n / max`, red when over |
| autofocus | `Bool` | — | Focus the control on mount |
| actions | `Html` | — | Leading slot for pickers and tools |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

### send_button

The standalone circular send button.

| Name | Type | Default | Description |
|---|---|---|---|
| disabled | `Bool` | false | Blocks interaction and dims the control |
| loading | `Bool` | false | Spinner in the disabled tone |
| on_click | `Cmd` | — | Click command |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| title | `String` | — | Native tooltip title |
| aria_label | `String` | "Send" |  |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

\* required (labelled) parameter — everything else is optional.
