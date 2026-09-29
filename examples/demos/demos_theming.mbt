///|
/// A light-mode stage so the theming guide can show the light palette.
fn demo_theme_light(_mode : @sumi.ThemeMode) -> Val[Html] {
  let (on, set_on) = @rabbita.create_variable(true)
  on.view(fn(is_on) {
    stage_mode(@sumi.Light, [
      @sumi.button(variant=Primary, "Generate"),
      @sumi.button(variant=Secondary, "HD Enhance"),
      @sumi.switch(checked=is_on, on_change=set_on.map(v => _ => v)),
      @sumi.tag(variant=Brand, [@sumi.icon_sparkle(size=12), @html.text("AI")]),
      @sumi.badge(value=5),
    ])
  })
}

///|
/// Overriding a token through the theme wrapper's inline style.
fn demo_theme_tokens(mode : @sumi.ThemeMode) -> Val[Html] {
  let (on, set_on) = @rabbita.create_variable(true)
  on.view(fn(is_on) {
    @sumi.theme(mode~, style=["--sumi-brand:#7c3aed;--sumi-brand-hover:#6d28d9"], [
      @html.div(
        style=[
          "padding:28px 24px;display:flex;flex-wrap:wrap;align-items:center;gap:16px;background:var(--sumi-canvas,#0d0d0d)",
        ],
        [
          @sumi.switch(checked=is_on, on_change=set_on.map(v => _ => v)),
          @sumi.tag(variant=Brand, [
            @sumi.icon_sparkle(size=12),
            @html.text("AI"),
          ]),
          @sumi.checkbox(
            checked=is_on,
            label="Brand-tinted",
            on_change=set_on.map(v => _ => v),
          ),
        ],
      ),
    ])
  })
}
