# Sumi Design & Interaction Spec

Internal spec for component visuals and interaction behavior. Values here
are the source of truth when contributing components.

## Package layout

- The module (`howtomakeaname/sumi`) keeps components in category
  packages: `primitives`, `feedback`, `layout`, `forms`, `overlays`, with
  shared style helpers and the static interaction/event layers in
  `internal`. Dependency flow is one-way:
  `internal ← primitives ← overlays ← forms`, plus `feedback` and `layout`
  on the side — no cycles.
- The root package holds `theme()`, the token palettes, and the public
  façade (`alias.mbt`): every component is re-exported via `pub using` so
  callers keep one flat `@sumi.*` import.
- **Adding a component**: implement it in its category package, then add
  it to the matching block in `src/alias.mbt`. The committed
  `pkg.generated.mbti` snapshot (run `moon info`) flags a missing entry.

## Theming & tokens
- All color tokens live in `sumi/tokens.mbt` as two palettes —
  `SumiTokensDark` and `SumiTokensLight` — one `--sumi-*:value;` declaration
  per line. Token names are identical across palettes.
- `theme(mode=…)` accepts `Dark` (default), `Light`, or `System` (follows
  the viewer's `prefers-color-scheme` via media queries, live-updating).
- Tokens ship in a `<style>` sheet keyed by `[data-sumi-theme="<mode>"]` on
  the theme wrapper — not inline style — so nested themes with different
  modes compose, and caller overrides via `theme(style=["--sumi-x:…"])`
  still win (inline style beats the sheet on the same element).
- Components reference tokens as `var(--sumi-x, <dark value>)`: the dark
  fallback keeps un-themed usage rendering dark, so `theme()` stays
  recommended but optional.
- Unless stated otherwise, every color value in this document is the **dark
  palette** value; the light counterpart is defined in `tokens.mbt`.
- Light palette mapping rules:
  - Surfaces invert to a `#f0f0f2 → #ffffff` elevation ramp; overlay fills
    (`block*`) flip from white-on-dark to black-on-light alphas at roughly
    60% strength (0.08 → 0.05, 0.12 → 0.08, 0.16 → 0.12).
  - The primary button **inverts**: dark fill `#1c1c1e` + light text
    (hover `#3a3a3e`, press `#55555a` — it lightens, mirroring how dark
    mode's light fill dims). Disabled keeps the blue-tinted pair, re-alfa'd.
  - Tooltip and toast **stay dark** (`#26262a` bubble, `#fafafa` text) for
    contrast; their text uses `--sumi-tooltip-fg`, never `--sumi-text`.
  - Slider thumb inverts to `#1c1c1e`; switch thumb stays white but gains a
    hairline shadow (`--sumi-switch-thumb-shadow`) to read on pale tracks.
  - Brand stays `#009efa`; hover deepens to `#008ee1`. Error deepens to
    `#e02040` to keep ~4.5:1 contrast for 12px text on white.
  - Backdrop softens to `rgba(0,0,0,0.45)`; shadows drop to 0.12 black.


## Motion

| Token | Value | Used by |
|---|---|---|
| instant | 100ms `cubic-bezier(0.4,0,0.2,1)` | control hover/press feedback, switch track & thumb |
| element | 200ms `cubic-bezier(0.4,0,0.2,1)` | progress fill, menu-chevron rotate |
| tooltip | 100ms `cubic-bezier(0.4,0,0.2,1)` | tooltip scale/opacity |
| overlay | 200ms `cubic-bezier(0.4,0,0.2,1)` | menu enter & exit (same curve both ways) |
| dialog | 400ms `cubic-bezier(0.3,1.3,0.3,1)` | dialog enter (slight overshoot) |
| toast | 200ms `cubic-bezier(0.4,0,0.2,1)` | toast fade |

- Overlay enter/exit: `opacity 0↔1` + `scale(0.5)↔scale(1)`. Transform
  origin follows the anchor: menus use the trigger corner
  (`top left` when opening downward, `bottom left` when opening upward),
  tooltips use the edge center of the side they sit on.
- Toast is fade-only (no translate) and renders in a fixed top-center
  viewport (`top:32px`).
- Dialog enters via `sumi-dialog-in` keyframes (`opacity 0→1`,
  `scale(0.5)→1`) on `[open]`; backdrop fades in over 200ms. Backdrop is
  `var(--sumi-backdrop)` (dark `rgba(0,0,0,0.8)`) with **no blur**.
- Overlays stay mounted and toggle `hidden`, so `display ... allow-discrete`
  transitions animate the exit too (no abrupt cut); `@starting-style`
  supplies the enter's first frame.
- No press-scale on any control — feedback is background/opacity only.
- `prefers-reduced-motion: reduce` disables every transition/animation
  listed on `data-slot` surfaces.

## Buttons

- Feedback is background-color change only — no scale/transform on press.
- `Primary`: bg `#fafafa`, text `#1a1a1a`; hover `#d9d9d9`; press
  `#b2b2b2` (the fill dims, it does not brighten).
- `Primary` `loading=true`: keeps the default fill and the button's width —
  content stays rendered but invisible under an absolutely centered 16px
  spinner — sets `aria-busy`, blocks clicks.
- `Secondary`: `rgba(255,255,255,0.08)`; hover `0.12`; press `0.16`.
- `Ghost` (toolbar/menu trigger): transparent; hover `0.08`; press `0.12`.
- Disabled: `Primary` uses the blue-tinted pair
  `rgba(204,221,255,0.16)` bg + `rgba(224,245,255,0.2)` text;
  `Secondary`/`Ghost` keep their fill and drop text to `0.2`.
- Min-width 80px on `Primary`/`Secondary` at `Default` and `Sm` sizes;
  `Ghost` and icon sizes hug content.
- Tool selection uses `pressed=true` → `aria-pressed` + selected fill at
  the same tone as hover (0.08).
- Sizes: default 32px h / px-16 (`Primary`/`Secondary`) or px-8 (`Ghost`);
  sm 28px (ghost-sm keeps px-8 and is the menu-trigger size); icon
  32×32 / icon-sm 28×28. Radius 8px. Font 13px/22 Medium; numeric labels
  (2K/4K) render in Montserrat 13/22 Medium.

## Slider

- Track 12px visual bar, radius 4px, base `rgba(255,255,255,0.08)`, fill
  `rgba(255,255,255,0.2)` (the muted-text token, not a brighter white).
- Thumb is a 4×16px white capsule (radius 11px) centered on the fill
  edge. No halo, no drop shadow.
- Value bubble: `value_tooltip=true` renders the tooltip-style bubble
  (10px 16px padding, `#333`, Montserrat 12/20 Medium, shadow
  `0 8px 28px rgba(0,0,0,0.24)`) directly above the thumb, following
  `percent%`; visible on track hover and `:focus-within` (drag/keyboard).
- Show value in Montserrat 12 Medium with `tabular-nums`, right-aligned.
- `on_input` fires per tick for local state only; `on_commit` fires once
  on release so expensive reactions don't fan out per tick.

## Menus / popovers

- Panel `#262626`, radius 12px, padding 4px, item gap 2px, min-width 240px,
  `sideOffset` 6px, drop shadow `0 8px 56px rgba(0,0,0,0.24)`.
- Compact items: 36px tall, 9px 12px padding, 8px gap, radius 8px, 16px
  icon slot. Rich items (title + description): 64px min-height,
  `8px 16px 8px 12px` padding, radius 12px, 40×40 leading media box
  (radius 8px, `stroke-secondary` border), title Montserrat Regular
  14/22, description 12/20 placeholder tone.
- Menu content is `Array[MenuEntry]`: `Item`, `Separator` (1px
  `stroke-secondary` line, `4px 2px` margin), `SectionLabel` (11/16
  placeholder tone). `MenuEntry::items` wraps plain item lists. Items may
  carry a right-aligned `shortcut` hint (12/20 placeholder tone,
  `padding-left:16px`).
- Item hover `rgba(255,255,255,0.08)`; the selected item carries the same
  8% fill plus a trailing 16px check; item highlight is `transition-none`
  in spirit — no motion on selection.
- Trigger chevrons use `menu_chevron()`: the interaction sheet rotates it
  180° over 200ms while the parent dropdown is `data-state="open"`.
- `side=Top` opens the panel above the trigger (input docks); the enter
  animation's transform origin follows the side.
- Outside click closes via a fixed transparent overlay (z-40, panel z-50).
- `dropdown_menu(trigger_style=…)` styles the trigger wrapper; `select`
  uses it to go full-width.

## Select & stepper

- Select = input-look trigger (32px, block fill, stroke border) over a
  compact menu pinned to trigger width (`menu_style width:100%`); label
  falls back to `placeholder` tone when no option matches. Keyboard and
  dismissal behave exactly like dropdown menus.
- Stepper: 32px-high segmented `− value +` control, block fill +
  `stroke-secondary` border; 28×26 transparent buttons (secondary tone,
  block-hover on hover), value in Montserrat 13 `tabular-nums` with
  `aria-live="polite"`; clamps at `min`/`max`, disabled halves opacity.

## Cards

- `card` is the bare surface (frame fill, `stroke-secondary` border, radius
  12px, no padding); `card_section` adds the header/content split and is
  the default choice for panels.
- Header: `12px 16px` padding, bottom border, **13px/22 Medium** in
  `--sumi-text`; content: `16px` padding, 13px/22 Regular in `--sumi-text`.
  Both pin the base text style so plain text children land on-token —
  callers never set font-size on card titles.
- `divider` is a 1px `stroke-secondary` rule for stacking inside content.

## Context menu
- `context_menu` wraps any target (`display:contents` root); the panel is
  `position:fixed` at the recorded pointer coordinates and shares the
  compact menu styling/entries.
- The event layer (below) suppresses the native menu, records the pointer
  into `--sumi-ctx-x/y` on `documentElement` before the component's own
  `contextmenu` handler opens the panel, and auto-focuses the first item
  so arrow keys and Escape work immediately.
- Overlay click, Escape, and selection all close; the last action in the
  demo confirms the full path.

## Event layer (static script)

- Cross-target MoonBit cannot `preventDefault` or manage DOM focus, so
  `theme()` emits one tiny static script (`event_guard_js.mbt`, closed
  constant, singleton-guarded) covering exactly what pseudo-CSS cannot:
  - capture-phase `contextmenu` suppression + pointer recording over
    `[data-slot="context-menu-root"]`;
  - capture-phase `keydown`: ArrowUp/Down (wraparound, skips
    `aria-disabled` items and non-item entries), Home/End roving focus
    among `[data-slot="menu-item"]` of the open menu; Escape closes by
    clicking the component's own overlay, reusing its close command.
  - Keyboard events arriving with focus on `<body>` (the state after a
    right-click) are still routed to the open menu; events targeted
    elsewhere (inputs, textareas) are never hijacked.
- Emitted as a **text child** of the `<script>` element: a script filled
  through the `innerHTML` property is marked "already started" by the
  HTML spec and never runs. The constant avoids `<` so SSR text escaping
  cannot corrupt it. The interaction stylesheet keeps `inner_html`
  (`<style>` applies normally either way).

## Switch & checkbox

- Switch track 24×16px, padding 2px; thumb 12px white, travel 8px;
  100ms soft on both track color and thumb transform; no thumb shadow.
- Off: `rgba(255,255,255,0.08)`, hover `0.12`. On: brand `#009efa`,
  hover `#0099f2`.
- Checkbox `indeterminate=true` renders the brand box with a minus dash
  and `aria-checked="mixed"`; clicking resolves to checked.
- Disabled switch/checkbox/slider: `opacity 0.5` + `cursor:not-allowed`.

## Inputs

- Field: 32px, radius 8px, `rgba(255,255,255,0.08)` fill, focus border
  `#009efa`, placeholder `rgba(255,255,255,0.35)`, caret brand blue.
- `prefix`/`suffix` slot absolutely-positioned adornments (placeholder
  tone, pointer-events none) with matching text padding (32px per side,
  52px for two trailing slots). `clearable=true` shows a 20px ✕ button
  while non-empty (clears via `on_clear` or `on_input("")`).
- `error=true` swaps the border to `#ff3355` + `aria-invalid`;
  `error_text` renders a 12/20 error line 6px below the field.
- Prompt dock: radius 16px, `rgba(34,34,34,0.72)` + backdrop blur 60px,
  float shadow; textarea 14px/22.
- Send button: 32px circle, `#fafafa` (hover `#d9d9d9`, press `#b2b2b2`),
  disabled `rgba(204,221,255,0.16)` with `rgba(224,245,255,0.2)` glyph.
  `loading=true` keeps the muted fill and swaps the arrow for a 20px
  spinner in the disabled tone.
- Prompt textarea scrolls with the 2px thin scrollbar token.
- `show_count=true` renders `n / max` in Montserrat 12 beside the send
  button; it flips to error red once over `maxlength`.

## Segmented

- Default row mode (32px items); `stacked=true` renders tall ratio-picker
  items (56px min-height, column, 12/16 label) with proportional artwork
  from `icon_ratio(width~, height~)` — a rounded rectangle drawn to the
  aspect inside a 16px box.

## Dialog

- Native `<dialog>`; content width 480px (`spacious=true` → 616px),
  radius 16px, padding 32px, bg `#1a1a1a`, `stroke-secondary` border,
  menu-level shadow.
- Backdrop `rgba(0,0,0,0.8)`, no blur. Enter motion per Motion table.

## Toast

- Viewport fixed top-center (`top:32px`, `left:50%`), z-60.
- Surface: min-height 44px, `10px 16px 10px 14px` padding, radius 12px,
  bg `#333`, 13px/20 primary text, shadow `0 8px 56px rgba(0,0,0,0.24)`.
- Status icons: success = 16px brand circle with a 10px `#333` check;
  error = `#ff3355` glyph; info = `text-secondary` glyph.
- Enter/exit is fade-only (see Motion).

## Tooltip

- `10px 16px` padding, radius 8px, bg `#333`, 12px/20 text, shadow
  `0 8px 28px rgba(0,0,0,0.24)`.
- Four sides. top/bottom anchor at the trigger's horizontal center and
  center with `translateX(-50%)`; left/right anchor at the vertical
  center and center with `translateY(-50%)`; 8px offset from the trigger.
- Reveal on trigger hover/focus: `scale(0.5)→1` + fade at 100ms soft,
  origin on the anchored edge center. z-50.

## Focus

- Pointer-first product: shared controls (button, icon-button, switch,
  checkbox) render **no** focus ring.
- Keyboard-navigable option lists keep a minimal ring for orientation:
  `segmented-item` and `menu-item` get `1px solid #ffffff` with
  `outline-offset:-1px` on `:focus-visible`.

## Credits slot

- Icon 12px + value in Montserrat 12 Medium, `tabular-nums`; default tone
  `rgba(255,255,255,0.7)`; `muted=true` drops to the 0.35 placeholder tone
  for frosted input docks. Strikethrough original when discounted; sits
  inline before the primary submit in a fixed 32px-high slot.

## Layering

- tooltip z-50 · menu z-50 over overlay z-40 · dialog native top layer ·
  toast viewport z-60.
