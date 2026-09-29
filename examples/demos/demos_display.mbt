///|
fn demo_avatar_basic(mode : @sumi.ThemeMode?) -> Val[Html] {
  Val::constant(
    stage_mode(mode, [@sumi.avatar(fallback="Sumi"), @sumi.avatar(fallback="墨", size=40)]),
  )
}

///|
fn demo_tag_basic(mode : @sumi.ThemeMode?) -> Val[Html] {
  Val::constant(
    stage_mode(mode, [
      @sumi.tag("Draft"),
      @sumi.tag(variant=Brand, [@sumi.icon_sparkle(size=12), @html.text("AI")]),
      @sumi.tag(variant=Outline, "16:9"),
      @sumi.tag(on_remove=@cmd.none, "Removable"),
    ]),
  )
}

///|
fn demo_kbd_basic(mode : @sumi.ThemeMode?) -> Val[Html] {
  Val::constant(
    stage_mode(mode, [
      @sumi.kbd("⌘"),
      @sumi.kbd("K"),
      hint("combine:"),
      row([@sumi.kbd("⌘"), @html.text("+"), @sumi.kbd("⇧"), @html.text("+"), @sumi.kbd("P")]),
    ]),
  )
}

///|
fn demo_card_basic(mode : @sumi.ThemeMode?) -> Val[Html] {
  Val::constant(
    stage_mode(mode, [
      @sumi.card(style=["width:280px;padding:16px"], [
        @html.div(
          style=["font-size:13px;line-height:22px"],
          "A bare card surface — bring your own padding and layout.",
        ),
      ]),
    ]),
  )
}

///|
fn demo_card_section(mode : @sumi.ThemeMode?) -> Val[Html] {
  Val::constant(
    stage_mode(mode, [
      @sumi.card_section(header=@html.text("Settings"), style=["width:280px"], [
        @html.div(style=["display:flex;flex-direction:column;gap:12px"], [
          row([@sumi.checkbox(checked=true, label="Auto-save")]),
          @sumi.divider(),
          @html.div(
            style=[
              "display:flex;align-items:center;justify-content:space-between",
            ],
            [
              @html.span(
                style=[
                  "color:var(--sumi-text-secondary,rgba(255,255,255,0.7))",
                ],
                "Export format",
              ),
              @sumi.tag("PNG"),
            ],
          ),
        ]),
      ]),
    ]),
  )
}

///|
fn demo_tabs_basic(mode : @sumi.ThemeMode?) -> Val[Html] {
  let (tab, set_tab) = @rabbita.create_variable("all")
  tab.view(fn(current) {
    stage_mode(mode, [
      row([
        @sumi.tabs(
          items=[
            @sumi.TabEntry::new("all", "All"),
            @sumi.TabEntry::new("mine", "Mine"),
            @sumi.TabEntry::new("shared", "Shared"),
          ],
          selected=current,
          on_select=set_tab.map(v => _ => v),
        ),
        hint("Current: " + current),
      ]),
    ])
  })
}

///|
/// Stepping through a small result set.
fn demo_pagination_basic(mode : @sumi.ThemeMode?) -> Val[Html] {
  let (page, set_page) = @rabbita.create_variable(2)
  page.view(fn(current) {
    stage_mode(mode, [
      @sumi.pagination(
        page=current,
        total=4,
        on_change=set_page.map(v => _ => v),
      ),
    ])
  })
}

///|
fn demo_credits_basic(mode : @sumi.ThemeMode?) -> Val[Html] {
  Val::constant(
    stage_mode(mode, [
      @sumi.credits(value=24),
      @sumi.credits(value=24, original_value=48),
      @sumi.credits(value=8, muted=true),
    ]),
  )
}

///|
fn icon_tile(name : String, icon : Html) -> Html {
  @html.div(
    style=[
      "display:flex;flex-direction:column;align-items:center;justify-content:center;gap:6px;width:76px;height:64px;border-radius:8px;background:var(--sumi-block,rgba(255,255,255,0.08));color:var(--sumi-text-secondary,rgba(255,255,255,0.7))",
    ],
    [
      icon,
      @html.span(
        style=[
          "font-size:10px;line-height:14px;color:var(--sumi-text-placeholder,rgba(255,255,255,0.35))",
        ],
        name,
      ),
    ],
  )
}

///|
fn demo_icons_basic(mode : @sumi.ThemeMode?) -> Val[Html] {
  let s = 16
  Val::constant(
    stage_mode(mode, [
      icon_tile("adjust", @sumi.icon_adjust(size=s)),
      icon_tile("caret-down", @sumi.icon_caret_down(size=s)),
      icon_tile("arrow-down", @sumi.icon_arrow_down(size=s)),
      icon_tile("arrow-up", @sumi.icon_arrow_up(size=s)),
      icon_tile("check", @sumi.icon_check(size=s)),
      icon_tile("chevron-down", @sumi.icon_chevron_down(size=s)),
      icon_tile("chevron-left", @sumi.icon_chevron_left(size=s)),
      icon_tile("chevron-right", @sumi.icon_chevron_right(size=s)),
      icon_tile("chevron-up", @sumi.icon_chevron_up(size=s)),
      icon_tile("clock", @sumi.icon_clock(size=s)),
      icon_tile("close-circle", @sumi.icon_close_circle(size=s)),
      icon_tile("crop", @sumi.icon_crop(size=s)),
      icon_tile("download", @sumi.icon_download(size=s)),
      icon_tile("expand", @sumi.icon_expand(size=s)),
      icon_tile("grid", @sumi.icon_grid(size=s)),
      icon_tile("image", @sumi.icon_image(size=s)),
      icon_tile("layers", @sumi.icon_layers(size=s)),
      icon_tile("minus", @sumi.icon_minus(size=s)),
      icon_tile("more", @sumi.icon_more(size=s)),
      icon_tile("play", @sumi.icon_play(size=s)),
      icon_tile("plus", @sumi.icon_plus(size=s)),
      icon_tile("reset", @sumi.icon_reset(size=s)),
      icon_tile("scissors", @sumi.icon_scissors(size=s)),
      icon_tile("important", @sumi.icon_important(size=s)),
      icon_tile("slash", @sumi.icon_slash(size=s)),
      icon_tile("search", @sumi.icon_search(size=s)),
      icon_tile("sparkle", @sumi.icon_sparkle(size=s)),
      icon_tile("upload", @sumi.icon_upload(size=s)),
      icon_tile("x", @sumi.icon_x(size=s)),
    ]),
  )
}
