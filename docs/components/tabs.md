# Tabs

An underline tab row for switching views.

## Examples

### Basic usage

<SumiDemo name="tabs-basic">

```moonbit
@sumi.tabs(
  items=[
    @sumi.TabEntry::new("all", "All"),
    @sumi.TabEntry::new("mine", "Mine"),
    @sumi.TabEntry::new("shared", "Shared"),
  ],
  selected=current,
  on_select=set_tab.map(v => _ => v),
)
```

</SumiDemo>

## API

### tabs

| Name | Type | Default | Description |
|---|---|---|---|
| items **\*** | `Array[TabEntry]` | — | Tab list |
| selected **\*** | `String` | — | Value of the active tab (controlled) |
| on_select | `Emit[String]` | — | Called with the value of the picked item |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

### TabEntry::new

One tab.

| Name | Type | Default | Description |
|---|---|---|---|
| value | `String` | — |  |
| label | `String` | — |  |
| icon | `Html` | — | Leading icon |

\* required (labelled) parameter — everything else is optional.
