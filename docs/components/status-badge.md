# Status Badge

A 20px badge reporting an async job's state: frosted determinate ring while running, a white circle with the queue depth (capped at 99), a blue tick disc on completion, an amber info disc for partial failure. Rendered over dark imagery, so the palette is pinned dark.

## Examples

### All states

<SumiDemo name="status-badge">

```moonbit
@sumi.status_badge(state=Running(45))
@sumi.status_badge(state=Count(3))
@sumi.status_badge(state=Count(99))
@sumi.status_badge(state=Complete)
@sumi.status_badge(state=Warning)
```

</SumiDemo>

## API

### status_badge

| Name | Type | Default | Description |
|---|---|---|---|
| state **\*** | `StatusBadgeState` | — | `StatusBadgeState` — `Running(pct)` / `Count(n)` / `Complete` / `Warning` |
| aria_label | `String` | — | Override the state description read to assistive tech |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

\* required (labelled) parameter — everything else is optional.
