# Introduction

**Sumi · 墨** is a UI component library for [MoonBit](https://www.moonbitlang.com) web apps, built on the rabbita TEA framework. Components are plain functions returning HTML — no CSS pipeline, no build configuration.

## What's inside

- **30+ components** across actions, forms, overlays, feedback and display
- **Dark & light palettes** driven by one token set on CSS custom properties; `System` mode follows the OS preference live
- **Overlay motion built in** — menus, tooltips, dialogs and toasts animate on enter *and* exit from one always-mounted stylesheet
- **Keyboard navigation** — roving focus and arrow/Home/End in menus, Escape dismissal, context-menu pointer tracking, all from a tiny event layer injected by `theme()`

## Design principles

**Controlled components.** The caller owns all state and passes it in. A menu doesn't open itself; you render it from your `open` variable and update that variable in `on_open_change`. This maps directly onto the TEA update loop — no hidden component state, ever.

**Tokens, not constants.** Every color, radius and shadow resolves through a `var(--sumi-*)` custom property, so one `theme()` wrapper re-skins the whole tree — and you can override any token with plain inline style.

**Dark fallbacks.** Components carry dark-mode fallback values for every token, so they still render (dark) when used without a `theme()` wrapper. The wrapper is recommended, not required.

## Package layout

The module keeps components in category packages with a one-way dependency flow — `internal ← primitives ← overlays ← forms`, with `feedback` and `layout` on the side — and re-exports everything through the root facade, so callers keep a single flat `@sumi.*` import.
