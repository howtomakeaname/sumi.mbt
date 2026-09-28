# Theming

## Modes

Wrap the app root once with `theme(mode=…)`:

| Mode | Behavior |
|---|---|
| `Dark` (default) | Dark palette |
| `Light` | Light palette |
| `System` | Follows `prefers-color-scheme`, live |

```moonbit
@sumi.theme(mode=@sumi.System, [content])
```

The same components in the light palette:

<SumiDemo name="theme-light">

```moonbit
@sumi.theme(mode=@sumi.Light, [
  @sumi.button(variant=@sumi.Primary, "Generate"),
  @sumi.switch(checked=is_on, on_change=set_on.map(v => _ => v)),
])
```

</SumiDemo>

## How it works

`theme()` emits a token sheet keyed by the wrapper's `data-sumi-theme` attribute — not inline style — so:

- **Nested themes compose.** A `Light` card inside a `Dark` page just works; tokens resolve to the nearest themed ancestor.
- **Caller overrides win.** Inline style beats the sheet on the same element, so you can re-tint a subtree without touching global CSS.

Components reference tokens as `var(--sumi-x, <dark value>)`, so un-themed usage still renders dark. `theme()` is recommended, not required.

## Overriding tokens

Pass token declarations through the wrapper's `style` parameter. Here the brand color moves from blue to violet — every brand-tinted control in the subtree follows:

<SumiDemo name="theme-tokens">

```moonbit
@sumi.theme(
  style=["--sumi-brand:#7c3aed;--sumi-brand-hover:#6d28d9"],
  [
    @sumi.switch(checked=is_on, on_change=set_on.map(v => _ => v)),
    @sumi.tag(variant=@sumi.Brand, [
      @sumi.icon_sparkle(size=12),
      @html.text("AI"),
    ]),
  ],
)
```

</SumiDemo>

## Token reference

The palettes cover five families — surfaces (`--sumi-canvas` … `--sumi-spotlight`), fills (`--sumi-block*`), strokes (`--sumi-stroke*`), text (`--sumi-text*`) and accents (`--sumi-brand*`, `--sumi-error`, `--sumi-primary*`) — plus radii, shadows and backdrop. The full list with both palettes lives in [`tokens.mbt`](https://github.com/howtomakeaname/sumi.mbt/blob/main/src/tokens.mbt); the light-mode mapping rules are documented in [DESIGN.md](https://github.com/howtomakeaname/sumi.mbt/blob/main/DESIGN.md).
