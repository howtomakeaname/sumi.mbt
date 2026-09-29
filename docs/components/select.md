# Select

An input-look trigger over a compact menu pinned to the trigger width. Shares `MenuItem` with dropdown menus.

## Examples

### Basic usage

<SumiDemo name="select-basic">

```moonbit
@sumi.select(
  options=[
    @sumi.MenuItem::new("png", "PNG"),
    @sumi.MenuItem::new("jpg", "JPG"),
    @sumi.MenuItem::new("webp", "WebP"),
  ],
  value=current,
  placeholder="Export format",
  open=is_open,
  on_open_change=set_open.map(v => _ => v),
  on_select=set_format.map(v => _ => v),
)
```

</SumiDemo>

### Filter trigger

<SumiDemo name="select-filter">

```moonbit
@sumi.select(
  options=[
    @sumi.MenuItem::new("design", "Design"),
    @sumi.MenuItem::new("engineering", "Engineering"),
    @sumi.MenuItem::new("marketing", "Marketing"),
  ],
  value=current,
  placeholder="Team",
  open=is_open,
  on_open_change=set_open.map(v => _ => v),
  on_select=set_team.map(v => _ => v),
  variant=Filter,
  on_clear=set_team(_ => ""),
)
```

</SumiDemo>

## API

### select

| Name | Type | Default | Description |
|---|---|---|---|
| options **\*** | `Array[MenuItem]` | — | Option list |
| value **\*** | `String` | — | Selected value (controlled) |
| placeholder | `String` | "Select" | Placeholder text |
| open **\*** | `Bool` | — | Whether the overlay is open (controlled) |
| on_open_change | `Emit[Bool]` | — | Called when the open state should change |
| on_select | `Emit[String]` | — | Called with the value of the picked item |
| variant | `SelectVariant` | Form | `Form` input look, `Filter` compact toolbar trigger |
| on_clear | `Cmd` | — | Filter variant: emitted by the clear affordance |
| disabled | `Bool` | false | Blocks interaction and dims the control |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

### MenuItem::new

One menu option.

### SelectVariant

| Variant | Description |
|---|---|
| `Form` | Input-look trigger pinned to full width (default) |
| `Filter` | Compact trigger naming the filter until a value is set |

\* required (labelled) parameter — everything else is optional.
