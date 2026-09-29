# Sumi · 墨

A UI component library for MoonBit web apps. Dark & light themes, tuned
overlay motion, and zero build configuration — components are plain
functions returning HTML, styled through design tokens on CSS custom
properties.

## Features

- **40+ components** — actions, forms, overlays, feedback, display
- **Dark & light palettes** — one token set, two themes; `System` follows
  the OS setting live via `prefers-color-scheme`
- **Overlay motion built in** — menus, tooltips, dialogs and toasts animate
  on enter *and* exit, from one always-mounted stylesheet
- **Keyboard navigation** — roving focus and arrow/Home/End in menus,
  Escape dismissal, context-menu positioning handled by a tiny event layer
- **Zero config** — no CSS pipeline; `theme()` injects everything the
  components need

## Install

```bash
moon add howtomakeaname/sumi
```

## Quick start

```moonbit
using @rabbita {type Val, type Html}

///|
fn app() -> Val[Html] {
  Val::constant(
    @sumi.theme(mode=@sumi.System, [
      @sumi.button(variant=@sumi.Primary, "Generate"),
      @sumi.tag(variant=@sumi.Brand, "AI"),
    ]),
  )
}

///|
fn main {
  @rabbita.new(app).mount("app")
}
```

Components are **controlled**: the caller owns state and passes it in.
A menu, for example:

```moonbit
let (open, set_open) = @rabbita.create_variable(false)
open.view(fn(is_open) {
  @sumi.dropdown_menu(
    items=@sumi.MenuEntry::items([
      @sumi.MenuItem::new("png", "PNG"),
      @sumi.MenuItem::new("webp", "WebP"),
    ]),
    trigger=@sumi.button(variant=@sumi.Secondary, "Export"),
    open=is_open,
    on_open_change=set_open.map(v => _ => v),
  )
})
```

## Theming

Wrap the app root once with `theme(mode=…)`:

| Mode | Behavior |
|---|---|
| `Dark` (default) | dark palette |
| `Light` | light palette |
| `System` | follows `prefers-color-scheme`, live |

- Override any token through the wrapper's inline style:
  `theme(style=["--sumi-brand:#7c3aed"], […])`.
- Nested themes with different modes compose — tokens ride on the
  `[data-sumi-theme]` attribute, not global rules.
- Components carry dark fallbacks, so they still render (dark) without a
  `theme()` wrapper.

## Components

| Group | Components |
|---|---|
| Actions | `button` · `icon_button` · `favorite_toggle` · `add_tile` · `toolbar` |
| Forms | `input` · `textarea` · `select` · `stepper` · `switch` · `checkbox` · `chip` · `attachment_strip` · `slider` · `segmented` · `prompt_box` · `editable_text` · `send_button` |
| Overlays | `dropdown_menu` · `checkbox_menu` · `context_menu` · `popover` · `tooltip` · `dialog` · `toast` |
| Feedback | `spinner` · `status_badge` · `progress` · `skeleton` · `badge` · `empty_state` · `alert` |
| Display | `avatar` · `tag` · `kbd` · `card` · `tabs` · `pagination` · `shortcuts_panel` · `credits` · icon set |

## Documentation

**[howtomakeaname.github.io/sumi.mbt](https://howtomakeaname.github.io/sumi.mbt/)**
(中文：[/zh/](https://howtomakeaname.github.io/sumi.mbt/zh/)) — live
interactive demos, usage examples and API tables for every component,
rebuilt from this repo on every version tag.

[DESIGN.md](./DESIGN.md) is the source of truth for visuals and
interaction behavior: motion tiers, token palettes and light-mode mapping
rules, focus-ring policy, layering, and per-component specs.

## Repository layout

```
src/                    the library module (howtomakeaname/sumi)
├── theme.mbt           theme() — the only required wrapper
├── tokens.mbt          ThemeMode + dark/light token palettes
├── alias.mbt           public façade: re-exports every component so
│                       callers keep a single flat `@sumi.*` import
├── internal/           shared style helpers + static interaction/event layers
├── primitives/         icons · button · favorite_toggle · add_tile · tag ·
│                       badge · kbd · avatar · credits · spinner
├── feedback/           alert · progress · skeleton · status_badge · empty_state
├── layout/             card · toolbar · tabs · pagination · shortcuts_panel
├── forms/              input · textarea · switch · checkbox · chip · slider ·
│                       attachment_strip · segmented · stepper · select ·
│                       prompt_box · editable_text · send_button
└── overlays/           dropdown_menu · checkbox_menu · context_menu ·
                        popover · tooltip · dialog · toast
examples/gallery/       the demo app
```

Dependencies flow one way: `internal ← primitives ← overlays ← forms`,
with `feedback`/`layout` on the side and the root façade on top — no
cycles. Contributing a component means adding it to its category package
*and* to the matching `pub using` block in `src/alias.mbt` (the committed
interface snapshot flags a missing entry).

## Development

```bash
moon check              # type-check the workspace
moon test               # run unit tests
moon build --target js  # build the gallery bundle
```

The gallery demo lives in `examples/gallery`. To preview it, serve any
static page that mounts the built bundle:

```html
<div id="app"></div>
<script type="module">import('./main.js');</script>
```

with `main.js` copied from
`_build/js/debug/build/example/gallery/main/main.js`.

## License

[Apache-2.0](./LICENSE)
