# Pagination

A minimal `‹ page / total ›` pager with clamped arrow buttons.

## Examples

### Current / total

<SumiDemo name="pagination-basic">

```moonbit
@sumi.pagination(
  page=current,
  total=4,
  on_change=set_page.map(v => _ => v),
)
```

</SumiDemo>

## API

### pagination

| Name | Type | Default | Description |
|---|---|---|---|
| page **\*** | `Int` | — | Current page, 1-based (controlled) |
| total **\*** | `Int` | — | Total page count |
| on_change | `Emit[Int]` | — | Called with the clamped target page |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

\* required (labelled) parameter — everything else is optional.
