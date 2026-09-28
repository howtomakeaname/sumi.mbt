# Skeleton

Shimmering placeholder shapes while content loads.

## Examples

### Shapes

<SumiDemo name="skeleton-basic">

```moonbit
@sumi.skeleton_tile(width="160px", height="90px")
@sumi.skeleton_lines(count=3)
@sumi.skeleton(width="64px", height="64px", radius="50%")
```

</SumiDemo>

## API

### skeleton

| Name | Type | Default | Description |
|---|---|---|---|
| width | `String` | "100%" | CSS width |
| height | `String` | "14px" | CSS height |
| radius | `String` | "4px" | Corner radius (50% for circles) |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

### skeleton_lines

A stack of text-like lines.

| Name | Type | Default | Description |
|---|---|---|---|
| count | `Int` | 2 | Number of lines |
| style | `Array[String]` | [] | Extra inline styles |

### skeleton_tile

A rounded media tile.

| Name | Type | Default | Description |
|---|---|---|---|
| width | `String` | "200px" | CSS width |
| height | `String` | "200px" | CSS height |
| style | `Array[String]` | [] | Extra inline styles |

\* required (labelled) parameter — everything else is optional.
