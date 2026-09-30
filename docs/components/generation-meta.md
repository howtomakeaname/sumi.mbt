# Generation Meta

The info-and-actions block under a generation result: a 14/22 tertiary disclaimer line (the content notice, the credits spent) with a bare copy action below.

## Examples

### With copy action

<SumiDemo name="generation-meta">

```moonbit
@sumi.generation_meta(
  text="AI-generated content | 0 credits used",
  on_copy=emit(CopyResult),
)
```

</SumiDemo>

## API

### generation_meta

| Name | Type | Default | Description |
|---|---|---|---|
| text **\*** | `String` | — | 14/22 tertiary disclaimer line |
| on_copy | `Cmd` | — | Renders the copy action when given |
| copy_label | `String` | "Copy" | Action aria label / title (default "Copy") |
| aria_label | `String` | — |  |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

\* required (labelled) parameter — everything else is optional.
