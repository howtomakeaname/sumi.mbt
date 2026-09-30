# HITL Card

A human-in-the-loop confirm card: a titled list of generation options with checkable rows and credit costs, a Cancel / confirm footer carrying the checked total, and a read-only receipt state once confirmed.

## Examples

### Confirm and receipt

<SumiDemo name="hitl-card">

```moonbit
@sumi.hitl_card(
  title="Generate the following 5 shots",
  items=plan,
  on_toggle=set_plan.map(i => c => flip_at(c, i)),
  on_cancel=emit(Dismiss),
  on_confirm=emit(ConfirmAll),
)
@sumi.hitl_card(title="Generated the following 3 shots", items=done, confirmed=true)
```

</SumiDemo>

## API

### hitl_card

| Name | Type | Default | Description |
|---|---|---|---|
| title **\*** | `String` | — | Header text (14/22 Medium) |
| items **\*** | `Array[HitlItem]` | — | `HitlItem` rows (controlled) |
| on_toggle | `Emit[Int]` | — | Row click, emits the row index |
| confirmed | `Bool` | false | Read-only receipt: no checkboxes or footer |
| on_cancel | `Cmd` | — |  |
| on_confirm | `Cmd` | — | Primary button carrying the checked total |
| cancel_label | `String` | "Cancel" |  |
| confirm_label | `String` | "Generate All" |  |
| max_height | `Int` | 190 | List scroll cap in px (default 190) |
| aria_label | `String` | — |  |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

### HitlItem::new

One generation option.

| Name | Type | Default | Description |
|---|---|---|---|
| label | `String` | — |  |
| cost | `Int` | 0 | Credit cost; shown when > 0 |
| thumbnails | `Array[String]` | [] | Reference thumbnails (one per modality) |
| checked | `Bool` | true | Checked for the confirm run; unchecked rows sink (0.2 label, faded thumbs, hidden cost) |

\* required (labelled) parameter — everything else is optional.
