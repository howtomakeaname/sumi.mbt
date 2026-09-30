# Task Card

A submitted-task bubble and its scrollable feed: a frosted card with a Medium title, an optional generation status, and a two-line summary (or a rich body such as a tool call row), stacked in a list that fades out at the bottom under the thin blue scrollbar.

## Examples

### The feed

<SumiDemo name="task-list">

```moonbit
@sumi.task_list(height=400, children=[
  @sumi.task_card(title="Autumn Forest Drone Shot", status=@sumi.Pending("Review"), summary=text),
  @sumi.task_card(title="Neon Harbor Nights", status=@sumi.Generating, summary=text),
  @sumi.task_card(title="Orbital Station Flythrough", status=@sumi.Generating, children=[
    @sumi.tool_call_row(label="Working on the canvas", icon=@sumi.icon_draw(size=16), expandable=true),
  ]),
  @sumi.task_card(title="City Rain Loop", status=@sumi.Done, summary=long_text),
])
```

</SumiDemo>

## API

### task_card

| Name | Type | Default | Description |
|---|---|---|---|
| title **\*** | `String` | — | 14/24 Medium title (ellipsized) |
| status | `SessionStatus` | — | Optional `SessionStatus` after the title |
| summary | `String` | "" | Two-line clamped body text (14/24 secondary) |
| children | `Array[Html]` | — | Rich body replacing the summary |
| on_click | `Cmd` | — | Card click command |
| aria_label | `String` | — |  |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

### task_list

| Name | Type | Default | Description |
|---|---|---|---|
| children **\*** | `Array[Html]` | — | `task_card` bubbles |
| height | `Int` | 400 | Feed height in px (default 400) |
| fade | `Int` | 44 | Bottom fade height in px (default 44; 0 disables) |
| aria_label | `String` | — |  |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

\* required (labelled) parameter — everything else is optional.
