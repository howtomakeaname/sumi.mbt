///|
/// Color mode for `theme`. `Dark` and `Light` pin the palette; `System`
/// follows the viewer's `prefers-color-scheme` and updates live with it.
pub(all) enum ThemeMode {
  Dark
  Light
  System
}

///|
fn ThemeMode::to_attr(self : ThemeMode) -> String {
  match self {
    Dark => "dark"
    Light => "light"
    System => "system"
  }
}

///|
/// Dark palette: one `--name:value;` declaration per line, emitted as-is
/// into a selector block (newlines are plain whitespace in CSS). Every
/// component references these variables with the dark values as inline
/// fallbacks, so un-themed usage still renders in dark.
const SumiTokensDark : String =
  #|--sumi-canvas:#0d0d0d;
  #|--sumi-frame:#202022;
  #|--sumi-frame-80:rgba(32,32,34,0.8);
  #|--sumi-container:#1e1e1e;
  #|--sumi-surface:#1a1a1a;
  #|--sumi-spotlight:#292929;
  #|--sumi-menu:#262626;
  #|--sumi-elevated:#222222;
  #|--sumi-block-secondary:rgba(255,255,255,0.04);
  #|--sumi-block:rgba(255,255,255,0.08);
  #|--sumi-block-strong:rgba(255,255,255,0.14);
  #|--sumi-block-hover:rgba(255,255,255,0.12);
  #|--sumi-block-pressed:rgba(255,255,255,0.16);
  #|--sumi-stroke-divider:rgba(255,255,255,0.12);
  #|--sumi-stroke:rgba(204,221,255,0.1);
  #|--sumi-stroke-primary:rgba(255,255,255,0.08);
  #|--sumi-stroke-secondary:rgba(255,255,255,0.04);
  #|--sumi-text:#ffffff;
  #|--sumi-text-secondary:rgba(255,255,255,0.7);
  #|--sumi-text-tertiary:rgba(255,255,255,0.6);
  #|--sumi-text-caption:rgba(255,255,255,0.5);
  #|--sumi-text-faint:rgba(255,255,255,0.4);
  #|--sumi-text-placeholder:rgba(255,255,255,0.35);
  #|--sumi-text-disabled:rgba(255,255,255,0.2);
  #|--sumi-brand:#009efa;
  #|--sumi-brand-hover:#0099f2;
  #|--sumi-error:#ff3355;
  #|--sumi-favorite:#ffa21e;
  #|--sumi-primary-bg:#fafafa;
  #|--sumi-primary-fg:#1a1a1a;
  #|--sumi-primary-bg-hover:#d9d9d9;
  #|--sumi-primary-bg-pressed:#b2b2b2;
  #|--sumi-primary-bg-disabled:rgba(204,221,255,0.16);
  #|--sumi-primary-fg-disabled:rgba(224,245,255,0.2);
  #|--sumi-tooltip-bg:#333333;
  #|--sumi-tooltip-fg:#ffffff;
  #|--sumi-input-bg:rgba(34,34,34,0.72);
  #|--sumi-scrollbar:rgba(255,255,255,0.08);
  #|--sumi-scrollbar-hover:rgba(255,255,255,0.12);
  #|--sumi-scrollbar-pressed:rgba(255,255,255,0.16);
  #|--sumi-shadow:rgba(0,0,0,0.24);
  #|--sumi-shadow-float:0px 2px 6px 0px rgba(0,0,0,0.02),0px 4px 12px 0px rgba(0,0,0,0.06);
  #|--sumi-shadow-menu:0px 8px 56px 0px rgba(0,0,0,0.24);
  #|--sumi-shadow-tooltip:0px 8px 28px 0px rgba(0,0,0,0.24);
  #|--sumi-backdrop:rgba(0,0,0,0.8);
  #|--sumi-selection-bg:rgba(0,158,250,0.35);
  #|--sumi-selection-fg:#ffffff;
  #|--sumi-slider-thumb:#ffffff;
  #|--sumi-switch-thumb:#ffffff;
  #|--sumi-switch-thumb-shadow:0 0 0 0 rgba(0,0,0,0);
  #|--sumi-shimmer:rgba(255,255,255,0.06);
  #|--sumi-radius:8px;
  #|--sumi-radius-lg:12px;
  #|--sumi-radius-xl:16px;

///|
/// Light palette: same token names, re-tuned for light surfaces. Overlay
/// tokens flip from white-on-dark to black-on-light alphas; the primary
/// button inverts to a dark fill (mirroring the dark mode's light fill);
/// tooltips/toasts stay dark for contrast; the switch thumb keeps its
/// white cap but gains a hairline shadow so it reads on pale tracks.
const SumiTokensLight : String =
  #|--sumi-canvas:#f0f0f2;
  #|--sumi-frame:#ffffff;
  #|--sumi-frame-80:rgba(255,255,255,0.8);
  #|--sumi-container:#f6f6f8;
  #|--sumi-surface:#ffffff;
  #|--sumi-spotlight:#ffffff;
  #|--sumi-menu:#ffffff;
  #|--sumi-elevated:#ffffff;
  #|--sumi-block-secondary:rgba(0,0,0,0.03);
  #|--sumi-block:rgba(0,0,0,0.05);
  #|--sumi-block-strong:rgba(0,0,0,0.09);
  #|--sumi-block-hover:rgba(0,0,0,0.08);
  #|--sumi-block-pressed:rgba(0,0,0,0.12);
  #|--sumi-stroke-divider:rgba(0,0,0,0.12);
  #|--sumi-stroke:rgba(0,0,0,0.1);
  #|--sumi-stroke-primary:rgba(0,0,0,0.08);
  #|--sumi-stroke-secondary:rgba(0,0,0,0.05);
  #|--sumi-text:#1a1a1a;
  #|--sumi-text-secondary:rgba(0,0,0,0.64);
  #|--sumi-text-tertiary:rgba(0,0,0,0.52);
  #|--sumi-text-caption:rgba(0,0,0,0.5);
  #|--sumi-text-faint:rgba(0,0,0,0.4);
  #|--sumi-text-placeholder:rgba(0,0,0,0.35);
  #|--sumi-text-disabled:rgba(0,0,0,0.25);
  #|--sumi-brand:#009efa;
  #|--sumi-brand-hover:#008ee1;
  #|--sumi-error:#e02040;
  #|--sumi-favorite:#ffa21e;
  #|--sumi-primary-bg:#1c1c1e;
  #|--sumi-primary-fg:#fafafa;
  #|--sumi-primary-bg-hover:#3a3a3e;
  #|--sumi-primary-bg-pressed:#55555a;
  #|--sumi-primary-bg-disabled:rgba(20,40,80,0.07);
  #|--sumi-primary-fg-disabled:rgba(20,40,80,0.32);
  #|--sumi-tooltip-bg:#26262a;
  #|--sumi-tooltip-fg:#fafafa;
  #|--sumi-input-bg:rgba(255,255,255,0.72);
  #|--sumi-scrollbar:rgba(0,0,0,0.12);
  #|--sumi-scrollbar-hover:rgba(0,0,0,0.16);
  #|--sumi-scrollbar-pressed:rgba(0,0,0,0.22);
  #|--sumi-shadow:rgba(0,0,0,0.12);
  #|--sumi-shadow-float:0px 2px 6px 0px rgba(0,0,0,0.04),0px 4px 12px 0px rgba(0,0,0,0.08);
  #|--sumi-shadow-menu:0px 8px 56px 0px rgba(0,0,0,0.12);
  #|--sumi-shadow-tooltip:0px 8px 28px 0px rgba(0,0,0,0.12);
  #|--sumi-backdrop:rgba(0,0,0,0.45);
  #|--sumi-selection-bg:rgba(0,158,250,0.28);
  #|--sumi-selection-fg:#0a3a5c;
  #|--sumi-slider-thumb:#1c1c1e;
  #|--sumi-switch-thumb:#ffffff;
  #|--sumi-switch-thumb-shadow:0 1px 2px rgba(0,0,0,0.15),0 0 0 1px rgba(0,0,0,0.04);
  #|--sumi-shimmer:rgba(255,255,255,0.55);
  #|--sumi-radius:8px;
  #|--sumi-radius-lg:12px;
  #|--sumi-radius-xl:16px;

///|
/// Render the token sheet for `mode`. Pinned modes emit a single attribute
/// selector block; `System` emits both palettes behind media queries so the
/// page follows the OS setting without a re-render. Tokens ride on the
/// `[data-sumi-theme]` attribute (not inline style) so nested themes with
/// different modes compose, and caller overrides appended through
/// `theme(style=…)` still win via inline style.
fn sumi_token_css(mode : ThemeMode) -> String {
  match mode {
    Dark => "[data-sumi-theme=\"dark\"]{\n" + SumiTokensDark + "}\n"
    Light => "[data-sumi-theme=\"light\"]{\n" + SumiTokensLight + "}\n"
    System =>
      "@media (prefers-color-scheme:dark){\n[data-sumi-theme=\"system\"]{\n" +
      SumiTokensDark +
      "}}\n@media (prefers-color-scheme:light){\n[data-sumi-theme=\"system\"]{\n" +
      SumiTokensLight +
      "}}\n"
  }
}

///|
#warnings("-alert_xss_vulnerable")
fn sumi_token_stylesheet(mode : ThemeMode) -> @html.Html {
  // Closed constant derived from the palettes above; no caller input reaches
  // it. `<style>` applied through innerHTML takes effect normally (only
  // `<script>` has the never-executes rule, see event_guard_js.mbt).
  let attrs = @html.Attrs::build()
    .data_set("sumi-style", "tokens")
    .inner_html(sumi_token_css(mode))
  @html.style_tag(attrs~, ([] : Array[@html.Html]))
}
