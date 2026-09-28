# Textarea

Multi-line plain-text field.

## Examples

### Basic usage

<SumiDemo name="textarea-basic">

```moonbit
@sumi.textarea(
  value=current,
  placeholder="Add release notes",
  rows=4,
  on_input=set_notes.map(v => _ => v),
)
```

</SumiDemo>

## API

### textarea

| Name | Type | Default | Description |
|---|---|---|---|
| value **\*** | `String` | — | Current text (controlled) |
| placeholder | `String` | "" | Placeholder text |
| rows | `Int` | 3 | Visible row count |
| on_input | `Emit[String]` | — | Called on every input |
| on_change | `Emit[String]` | — | Called when the value changes |
| disabled | `Bool` | false | Blocks interaction and dims the control |
| read_only | `Bool` | false | Read-only field |
| name | `String` | — | Form field name |
| maxlength | `Int` | — | Maximum character count |
| autofocus | `Bool` | — | Focus the control on mount |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| title | `String` | — | Native tooltip title |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

\* required (labelled) parameter — everything else is optional.
