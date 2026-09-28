# Input

Single-line text field with prefix/suffix adornments, clear button, and error presentation.

## Examples

### Basic usage

<SumiDemo name="input-basic">

```moonbit
@sumi.input(
  value=current,
  placeholder="Search projects",
  prefix=@sumi.icon_search(size=14),
  clearable=true,
  on_input=set_name.map(v => _ => v),
)
```

</SumiDemo>

### States

<SumiDemo name="input-states">

```moonbit
@sumi.input(value="Read only field", read_only=true)
@sumi.input(value="Disabled field", disabled=true)
@sumi.input(
  value="Untitled/:",
  error=true,
  error_text="Project name contains invalid characters",
)
```

</SumiDemo>

## API

### input

| Name | Type | Default | Description |
|---|---|---|---|
| value **\*** | `String` | — | Current text (controlled) |
| placeholder | `String` | "" | Placeholder text |
| input_type | `InputType` | Text | Native input type (`Text`, `Password`, …) |
| on_input | `Emit[String]` | — | Called on every input |
| on_change | `Emit[String]` | — | Called when the value changes |
| on_clear | `Cmd` | — | Custom clear behavior for `clearable` |
| clearable | `Bool` | false | Shows a ✕ button while non-empty |
| prefix | `Html` | — | Leading adornment (icon) |
| suffix | `Html` | — | Trailing adornment |
| error | `Bool` | false | Error border + `aria-invalid` |
| error_text | `String` | — | Error line rendered below the field |
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
