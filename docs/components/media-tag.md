# Media Tag

An inline reference to a piece of content — the chip that prefixes a conversation bubble or sits inside the composer input.

## Examples

### Kinds, states & inline

<SumiDemo name="media-tag">

```moonbit
@sumi.media_tag(kind=@sumi.Image, thumbnail=thumb_url)
@sumi.media_tag(kind=@sumi.Video, state=@sumi.Generating)
@sumi.media_tag(kind=@sumi.Audio, variant=@sumi.Inline)
```

</SumiDemo>

## API

### media_tag

| Name | Type | Default | Description |
|---|---|---|---|
| kind **\*** | `MediaTagKind` | — | What the tag references |
| label | `String` | — | Text; defaults to the kind name |
| state | `MediaTagState` | Ready | Lifecycle of the referenced content |
| variant | `MediaTagVariant` | Block | Filled block chip or transparent inline form |
| thumbnail | `String` | — | 16px square preview for Image/Video |
| on_click | `Cmd` | — | Renders as a button and brightens on hover |
| aria_label | `String` | — |  |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

### MediaTagKind

| Variant | Description |
|---|---|
| `Image` | Picture reference; can carry a thumbnail |
| `Video` | Clip reference; can carry a thumbnail |
| `Audio` | Waveform-glyph sound reference |
| `Text` | Plain-text reference |
| `Group` | Reference to several elements grouped together |
| `Timeline` | Sequence reference |
| `Element` | Single-element reference |

### MediaTagState

| Variant | Description |
|---|---|
| `Ready` | Default look |
| `Candidate` | Half-transparent suggestion |
| `Uploading` | Thumbnail dimmed under a centered spinner |
| `Generating` | Spinner replaces the visual |
| `Failed` | Warning disc replaces the visual |
| `Empty` | Placeholder glyph even when a thumbnail exists |

### MediaTagVariant

| Variant | Description |
|---|---|
| `Block` | Filled chip, used inside conversation bubbles |
| `Inline` | Transparent, sits inside the composer input |

\* required (labelled) parameter — everything else is optional.
