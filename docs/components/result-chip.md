# Result Chip

A 24px rich-text reference tag of generation results: a rounded block fill holding a 16px thumbnail and a short label. The Small size blurs its backdrop to float over generated imagery; Medium steps the label up to 14/24 secondary for inline chat result rows.

## Examples

### Two sizes

<SumiDemo name="result-chips">

```moonbit
// Small — floating over generated imagery (backdrop blur 6)
@sumi.result_chip(label="Harbor Dusk", thumbnail=ref_url)

// Medium — inline chat result row (14/24 secondary)
@sumi.result_chip(label="Image", thumbnail=ref_url, size=@sumi.Medium)
```

</SumiDemo>

## API

### result_chip

| Name | Type | Default | Description |
|---|---|---|---|
| label **\*** | `String` | — | Short chip label |
| thumbnail | `String` | — | Optional 16px rounded reference image URL |
| size | `ResultChipSize` | Small | `Small` (13/19.5 tertiary + blur) or `Medium` (14/24 secondary) |
| aria_label | `String` | — |  |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

### ResultChipSize

| Variant | Description |
|---|---|
| `Small` | ('13/19.5 tertiary label over a 6px backdrop blur', '13/19.5 三级色标签，6px 背景模糊') |
| `Medium` | ('14/24 secondary label without blur', '14/24 次要色标签，无模糊') |

\* required (labelled) parameter — everything else is optional.
