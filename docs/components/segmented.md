# Segmented

A row of mutually exclusive options. `stacked` renders tall ratio-picker items with proportional artwork.

## Examples

### Row mode

<SumiDemo name="segmented-basic">

```moonbit
@sumi.segmented(
  items=[
    @sumi.SegmentedItem::new("2k", "2K", numeric=true),
    @sumi.SegmentedItem::new("4k", "4K", numeric=true, trailing=sparkle),
    @sumi.SegmentedItem::new("8k", "8K", numeric=true, trailing=sparkle),
  ],
  selected=current,
  on_select=set_res.map(v => _ => v),
)
```

</SumiDemo>

### Stacked ratio picker

<SumiDemo name="segmented-stacked">

```moonbit
@sumi.segmented(
  stacked=true,
  items=[
    @sumi.SegmentedItem::new("16:9", "16:9", numeric=true,
      icon=@sumi.icon_ratio(width=16, height=9)),
    @sumi.SegmentedItem::new("1:1", "1:1", numeric=true,
      icon=@sumi.icon_ratio(width=1, height=1)),
  ],
  selected=current,
  on_select=set_ratio.map(v => _ => v),
)
```

</SumiDemo>

## API

### segmented

| Name | Type | Default | Description |
|---|---|---|---|
| items **\*** | `Array[SegmentedItem]` | — | Option list |
| selected **\*** | `String` | — | Value of the selected option (controlled) |
| stacked | `Bool` | false | Tall icon-over-label layout |
| on_select | `Emit[String]` | — | Called with the value of the picked item |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

### SegmentedItem::new

One option.

| Name | Type | Default | Description |
|---|---|---|---|
| value | `String` | — |  |
| label | `String` | — |  |
| icon | `Html` | — | Leading artwork (stacked mode) |
| trailing | `Html` | — | Trailing marker (e.g. a premium sparkle) |
| numeric | `Bool` | false | Numeric font rendering |
| disabled | `Bool` | false | Blocks interaction and dims the control |

\* required (labelled) parameter — everything else is optional.
