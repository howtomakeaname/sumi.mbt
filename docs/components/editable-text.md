# Editable Text

A title that reads as plain text and becomes an input on click; Enter or blur commits, Escape reverts.

## Examples

### Click to rename

<SumiDemo name="editable-text-basic">

```moonbit
@sumi.editable_text(
  value=current,
  placeholder="Enter a project name",
  on_change=set_title.map(v => _ => v),
)
@sumi.editable_text(value="", placeholder="Enter a project name")
```

</SumiDemo>

## API

### editable_text

\* required (labelled) parameter — everything else is optional.
