# Tool Call Row

One line of agent progress: a 16px tool icon, a label that shimmers while the work streams and settles when done, and an optional expandable chevron that reveals sub-steps under a thread line.

## Examples

### States & expandable

<SumiDemo name="tool-call-row">

```moonbit
@sumi.tool_call_row(icon=@sumi.icon_image(), label="(0/1) Image generating…")
@sumi.tool_call_row(icon=@sumi.icon_image(), state=@sumi.Done,
  label="(1/1) Image generation completed")
@sumi.tool_call_row(
  icon=@sumi.icon_adjust(), label="2 commands executed",
  expandable=true, expanded=e, on_toggle=set_e.map(v => _ => !v),
  steps=["List file directories", "Search for related content"],
)
```

</SumiDemo>

## API

### tool_call_row

| Name | Type | Default | Description |
|---|---|---|---|
| label **\*** | `String` | — | Status text; counts and failure notes are part of the copy |
| icon | `Html` | — | 16px tool glyph (omit for icon-less rows) |
| state | `ToolCallState` | Doing | Doing shimmers, Done settles to static tertiary |
| expandable | `Bool` | false | Adds a right/down chevron and enables steps |
| expanded | `Bool` | false | Controlled expand state |
| on_toggle | `Cmd` | — | Whole-row click command |
| steps | `Array[String]` | [] | Sub-step lines shown when expanded |
| truncate | `Bool` | true | Single-line ellipsis (default) or wrapping |
| aria_label | `String` | — |  |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

### ToolCallState

| Variant | Description |
|---|---|
| `Doing` | Label keeps shimmering while work streams |
| `Done` | Static tertiary label |

\* required (labelled) parameter — everything else is optional.
