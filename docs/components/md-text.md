# Markdown Text

The MD 基础组件 type scale for answer bodies: semantic H2–H4 headings and body paragraphs in the design's sizes — H2 16/24 Medium, H3/H4 14/22 Medium with 12px vertical padding, body 14/22 Regular — all at the primary text tone.

## Examples

### The scale

<SumiDemo name="md-text">

```moonbit
@sumi.md_text(kind=@sumi.H2, text="Story beats")
@sumi.md_text(kind=@sumi.Body, text=sample)
@sumi.md_text(kind=@sumi.H3, text="Opening shot")
@sumi.md_text(kind=@sumi.Body, text=sample)
```

</SumiDemo>

## API

### md_text

| Name | Type | Default | Description |
|---|---|---|---|
| text **\*** | `String` | — | Block text content |
| kind | `MdTextKind` | Body | `H2` / `H3` / `H4` heading or `Body` paragraph |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

### MdTextKind

| Variant | Description |
|---|---|
| `H2` | ('16/24 Medium section head, py 12', '16/24 Medium 章节标题，上下留白 12') |
| `H3` | ('14/22 Medium sub-head, py 12', '14/22 Medium 次级标题，上下留白 12') |
| `H4` | ('14/22 Medium minor head, py 12', '14/22 Medium 小标题，上下留白 12') |
| `Body` | ('14/22 Regular paragraph, no padding', '14/22 Regular 正文段落，无留白') |

\* required (labelled) parameter — everything else is optional.
