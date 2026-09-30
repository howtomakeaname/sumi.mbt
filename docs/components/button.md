# Button

Triggers an action with a click. Three variants, two text sizes, and built-in disabled, pressed and loading states.

## Examples

### Variants & states

<SumiDemo name="button-basic">

```moonbit
@sumi.button(variant=@sumi.Primary, "Generate")
@sumi.button(variant=@sumi.Secondary, "Export")
@sumi.button(variant=@sumi.Ghost, [
  @sumi.icon_sparkle(),
  @html.text("AI Edit"),
])
@sumi.button(variant=@sumi.Primary, disabled=true, "Generate")
@sumi.button(variant=@sumi.Primary, loading=true, "Generate")
```

</SumiDemo>

### Sizes

<SumiDemo name="button-sizes">

```moonbit
@sumi.button(variant=@sumi.Primary, "Apply")
@sumi.button(variant=@sumi.Primary, size=@sumi.Sm, "Apply")
@sumi.button(variant=@sumi.Secondary, size=@sumi.Sm, "Apply")
@sumi.button(variant=@sumi.Ghost, size=@sumi.Sm, "Options")
```

</SumiDemo>

## API

### button

| Name | Type | Default | Description |
|---|---|---|---|
| variant | `ButtonVariant` | Primary | Visual style |
| size | `ButtonSize` | Default | Control size |
| disabled | `Bool` | false | Blocks clicks; primary keeps a tinted fill |
| pressed | `Bool` | false | Selected fill + `aria-pressed`, for tool toggles |
| loading | `Bool` | false | Keeps width, hides content, centers a 16px spinner |
| type_ | `String` | "button" | Native `type` attribute |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| title | `String` | — | Native tooltip title |
| name | `String` | — | Form field name |
| value | `String` | — | Native `value` attribute |
| autofocus | `Bool` | — | Focus the control on mount |
| on_click | `Cmd` | — | Click command |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |
| children | `C` | — | Content |

### ButtonVariant

| Variant | Description |
|---|---|
| `Primary` | Filled accent surface for the main action |
| `Secondary` | Neutral filled surface (default) |
| `Ghost` | Transparent until hovered, for toolbars and menus |

### ButtonSize

| Variant | Description |
|---|---|
| `Default` | 32px height, 16px horizontal padding |
| `Sm` | 28px height; ghost-sm is the menu-trigger size |
| `Icon` | 32×32 square (icon_button) |
| `IconSm` | 28×28 square (icon_button) |

\* required (labelled) parameter — everything else is optional.
