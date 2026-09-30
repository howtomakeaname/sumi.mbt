# Session Menu

The chat-window session chrome: a header with the current-session pill plus new/collapse actions, and the floating session-list panel whose rows show generation statuses and reveal rename/delete actions on hover.

## Examples

### Header & list panel

<SumiDemo name="session-menu">

```moonbit
@sumi.session_header(
  title="Desert Mirage Expedition",
  status=@sumi.Done,
  on_title=toggle_menu,
  on_new=new_chat,
  on_collapse=collapse,
)
@sumi.session_list(max_height=280, children=[
  @sumi.session_item(label="Desert Mirage Expedition", active=true),
  @sumi.session_item(label="Neon Harbor Nights", status=@sumi.Generating),
  @sumi.session_item(label="Alpine Sunrise Timelapse", status=@sumi.Done),
  @sumi.session_divider(),
  @sumi.session_item(label="Archived Storyboards", disabled=true),
])
```

</SumiDemo>

## API

### session_header

| Name | Type | Default | Description |
|---|---|---|---|
| title **\*** | `String` | — | Current session name (14/22, ellipsized) |
| status | `SessionStatus` | — | Optional `SessionStatus` next to the title |
| on_title | `Cmd` | — | Title pill click (usually toggles the list) |
| on_new | `Cmd` | — | New-conversation icon button |
| on_collapse | `Cmd` | — | Collapse icon button |
| new_label | `String` | "New conversation" | Aria label of the new button |
| collapse_label | `String` | "Collapse" | Aria label of the collapse button |
| aria_label | `String` | — |  |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

### session_list

| Name | Type | Default | Description |
|---|---|---|---|
| children **\*** | `Array[Html]` | — | `session_item` rows and `session_divider` separators |
| width | `Int` | 280 | Panel width in px (default 280) |
| max_height | `Int` | — | Scroll cap in px; enables the thin scrollbar |
| aria_label | `String` | — |  |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

### session_item

| Name | Type | Default | Description |
|---|---|---|---|
| label **\*** | `String` | — | 13/22 row text (ellipsized) |
| active | `Bool` | false | Shows the trailing check + `aria-current` |
| disabled | `Bool` | false | Blocks interaction and dims the control |
| status | `SessionStatus` | — | Trailing generation status (hidden on hover) |
| on_click | `Cmd` | — | Click command |
| on_edit | `Cmd` | — | Reveals the rename action on hover |
| on_delete | `Cmd` | — | Reveals the delete action on hover |
| edit_label | `String` | "Rename" | Rename action aria/tooltip (default "Rename") |
| delete_label | `String` | "Delete" | Delete action aria/tooltip (default "Delete") |
| aria_label | `String` | — |  |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

### session_status

| Name | Type | Default | Description |
|---|---|---|---|
| kind **\*** | `SessionStatus` | — | `Generating | Count(Int) | Done | Dot | Pending(String) | Partial` |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

### session_title

| Name | Type | Default | Description |
|---|---|---|---|
| label **\*** | `String` | — | 14/22 pill text (ellipsized) |
| status | `SessionStatus` | — | Optional status before the chevron |
| on_click | `Cmd` | — | Click command |
| disabled | `Bool` | false | Blocks interaction and dims the control |
| aria_label | `String` | — |  |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

### session_divider

The 4px-tall hairline separator between row groups.

| Name | Type | Default | Description |
|---|---|---|---|
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

\* required (labelled) parameter — everything else is optional.
