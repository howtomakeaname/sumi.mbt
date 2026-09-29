# Agent Input

The agent chat dock: a frosted container pairing an auto-clamped input region with a toolbar row of action atoms and a circular send button; the send button becomes a stop affordance while generating.

## Examples

### Chat dock

<SumiDemo name="agent-input">

```moonbit
@sumi.agent_input(
  value=current,
  placeholder="Describe your idea, or type / to use a skill",
  on_input=set_prompt.map(v => _ => v),
  on_send=set_prompt(_ => ""),
  send_disabled=current.is_empty(),
  actions=[
    @sumi.icon_button(@sumi.icon_plus_fill(size=14), aria_label="Add attachment"),
    @sumi.agent_tool_button(@sumi.icon_skill(), label="Use Skill"),
    @sumi.icon_button(@sumi.icon_at(), aria_label="Mention a reference"),
  ],
)
```

</SumiDemo>

## API

### agent_input

| Name | Type | Default | Description |
|---|---|---|---|
| value | `String` | "" | Current text (controlled) |
| placeholder | `String` | "" | Placeholder text |
| rows | `Int` | 3 | Visible row count of the textarea |
| on_input | `Emit[String]` | — | Called on every input |
| on_send | `Cmd` | — | Send command |
| on_stop | `Cmd` | — | Stop command while `generating` |
| send_disabled | `Bool` | false | Disables the send button |
| send_loading | `Bool` | false | Swaps the glyph for a spinner |
| generating | `Bool` | false | Swaps send for the stop square |
| disabled | `Bool` | false | Blocks interaction and dims the control |
| autofocus | `Bool` | — | Focus the control on mount |
| actions | `Array[Html]` | [] | Left toolbar atoms (icon buttons, tool pills) |
| children | `Array[Html]` | — | Rich inline content replacing the textarea |
| aria_label | `String` | — |  |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

### agent_tool_button

The icon-leading toolbar pill.

| Name | Type | Default | Description |
|---|---|---|---|
| icon | `Html` | — |  |
| label **\*** | `String` | — | 12/20 label text |
| disabled | `Bool` | false | Blocks interaction and dims the control |
| on_click | `Cmd` | — | Click command |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| title | `String` | — | Native tooltip title |
| aria_label | `String` | — |  |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

\* required (labelled) parameter — everything else is optional.
