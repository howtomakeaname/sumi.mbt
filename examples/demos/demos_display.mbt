///|
fn demo_avatar_basic(mode : @sumi.ThemeMode?) -> Val[Html] {
  Val::constant(
    stage_mode(mode, [
      @sumi.avatar(fallback="Sumi"),
      @sumi.avatar(fallback="墨", size=40),
    ]),
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
/// Every kind in the filled block form, then the lifecycle states, then the
/// transparent inline form (the last one toggles on click).
fn demo_media_tag(mode : @sumi.ThemeMode?) -> Val[Html] {
  let (picked, set_picked) = @rabbita.create_variable(false)
  picked.view(fn(active) {
    stage_mode(mode, [
      @sumi.media_tag(kind=Image, thumbnail=attachment_thumb(0)),
      @sumi.media_tag(kind=Video, thumbnail=attachment_thumb(1)),
      @sumi.media_tag(kind=Audio),
      @sumi.media_tag(kind=Text),
      @sumi.media_tag(kind=Group),
      @sumi.media_tag(kind=Timeline),
      @sumi.media_tag(kind=Element),
      hint("states:"),
      @sumi.media_tag(
        kind=Image,
        thumbnail=attachment_thumb(2),
        state=Candidate,
      ),
      @sumi.media_tag(
        kind=Image,
        thumbnail=attachment_thumb(3),
        state=Uploading,
      ),
      @sumi.media_tag(kind=Video, state=Generating),
      @sumi.media_tag(kind=Image, state=Failed),
      @sumi.media_tag(kind=Image, thumbnail=attachment_thumb(0), state=Empty),
      hint("inline:"),
      @sumi.media_tag(kind=Image, variant=Inline, thumbnail=attachment_thumb(4)),
      @sumi.media_tag(kind=Video, variant=Inline),
      @sumi.media_tag(
        kind=Audio,
        variant=Inline,
        state=if active { Ready } else { Candidate },
        on_click=set_picked(v => !v),
      ),
    ])
  })
}

///|
fn demo_kbd_basic(mode : @sumi.ThemeMode?) -> Val[Html] {
  Val::constant(
    stage_mode(mode, [
      @sumi.kbd("⌘"),
      @sumi.kbd("K"),
      hint("combine:"),
      row([
        @sumi.kbd("⌘"),
        @html.text("+"),
        @sumi.kbd("⇧"),
        @html.text("+"),
        @sumi.kbd("P"),
      ]),
    ]),
  )
}

///|
fn demo_shortcuts_panel(mode : @sumi.ThemeMode?) -> Val[Html] {
  let (visible, set_visible) = @rabbita.create_variable(true)
  visible.view(fn(is_visible) {
    let panel = if is_visible {
      @sumi.shortcuts_panel(
        sections=[
          @sumi.ShortcutSection::new("General", [
            @sumi.ShortcutItem::new("Toggle sidebar", "Cmd /"),
            @sumi.ShortcutItem::new("Send message", "Enter"),
          ]),
          @sumi.ShortcutSection::new("Canvas & objects", [
            @sumi.ShortcutItem::new("Add file", "Cmd O"),
            @sumi.ShortcutItem::new("Add board", "F"),
            @sumi.ShortcutItem::new("Add text", "T"),
            @sumi.ShortcutItem::new("Deselect", "Esc"),
            @sumi.ShortcutItem::new("Zoom in", "⌘ +"),
            @sumi.ShortcutItem::new("Zoom out", "⌘ -"),
            @sumi.ShortcutItem::new("Fit to content", "Cmd 0"),
            @sumi.ShortcutItem::new("Pan canvas", "Space+Drag"),
          ]),
          @sumi.ShortcutSection::new("Editing", [
            @sumi.ShortcutItem::new("Select all", "⌘ A"),
            @sumi.ShortcutItem::new("Copy", "⌘ C"),
            @sumi.ShortcutItem::new("Paste", "⌘ V"),
            @sumi.ShortcutItem::new("Cut", "⌘ X"),
            @sumi.ShortcutItem::new("Duplicate", "⌘ D"),
            @sumi.ShortcutItem::new("Delete", "⌫"),
            @sumi.ShortcutItem::new("Undo", "⌘ Z"),
            @sumi.ShortcutItem::new("Redo", "⌘ ⇧ Z"),
            @sumi.ShortcutItem::new("Bring forward", "⌘ ]"),
            @sumi.ShortcutItem::new("Send backward", "⌘ ["),
            @sumi.ShortcutItem::new("Bring to front", "⌘ ⌥ ]"),
            @sumi.ShortcutItem::new("Send to back", "⌘ ⌥ ["),
          ]),
        ],
        on_close=set_visible(_ => false),
      )
    } else {
      @sumi.button(
        variant=Secondary,
        on_click=set_visible(_ => true),
        "Show shortcuts",
      )
    }
    stage_mode(mode, [panel])
  })
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
                style=["color:var(--sumi-text-secondary,rgba(255,255,255,0.7))"],
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
      icon_tile("align-left", @sumi.icon_align_left(size=s)),
      icon_tile("caret-down", @sumi.icon_caret_down(size=s)),
      icon_tile("arrow-down", @sumi.icon_arrow_down(size=s)),
      icon_tile("arrow-up", @sumi.icon_arrow_up(size=s)),
      icon_tile("check", @sumi.icon_check(size=s)),
      icon_tile("check-fill", @sumi.icon_check_fill(size=s)),
      icon_tile("chevron-down", @sumi.icon_chevron_down(size=s)),
      icon_tile("chevron-left", @sumi.icon_chevron_left(size=s)),
      icon_tile("chevron-right", @sumi.icon_chevron_right(size=s)),
      icon_tile("chevron-up", @sumi.icon_chevron_up(size=s)),
      icon_tile("clock", @sumi.icon_clock(size=s)),
      icon_tile("close-circle", @sumi.icon_close_circle(size=s)),
      icon_tile("crop", @sumi.icon_crop(size=s)),
      icon_tile("download", @sumi.icon_download(size=s)),
      icon_tile("element", @sumi.icon_element(size=s)),
      icon_tile("expand", @sumi.icon_expand(size=s)),
      icon_tile("folder", @sumi.icon_folder(size=s)),
      icon_tile("grid", @sumi.icon_grid(size=s)),
      icon_tile("group", @sumi.icon_group(size=s)),
      icon_tile("image", @sumi.icon_image(size=s)),
      icon_tile("image-fill", @sumi.icon_image_fill(size=s)),
      icon_tile("layers", @sumi.icon_layers(size=s)),
      icon_tile("minus", @sumi.icon_minus(size=s)),
      icon_tile("more", @sumi.icon_more(size=s)),
      icon_tile("play", @sumi.icon_play(size=s)),
      icon_tile("plus", @sumi.icon_plus(size=s)),
      icon_tile("plus-fill", @sumi.icon_plus_fill(size=s)),
      icon_tile("reset", @sumi.icon_reset(size=s)),
      icon_tile("scissors", @sumi.icon_scissors(size=s)),
      icon_tile("important", @sumi.icon_important(size=s)),
      icon_tile("info-circle-fill", @sumi.icon_info_circle_fill(size=s)),
      icon_tile("slash", @sumi.icon_slash(size=s)),
      icon_tile("search", @sumi.icon_search(size=s)),
      icon_tile("sound", @sumi.icon_sound(size=s)),
      icon_tile("sparkle", @sumi.icon_sparkle(size=s)),
      icon_tile("star", @sumi.icon_star(size=s)),
      icon_tile("star-fill", @sumi.icon_star_fill(size=s)),
      icon_tile("target", @sumi.icon_target(size=s)),
      icon_tile("text", @sumi.icon_text(size=s)),
      icon_tile("tick-circle-fill", @sumi.icon_tick_circle_fill(size=s)),
      icon_tile("timeline", @sumi.icon_timeline(size=s)),
      icon_tile("upload", @sumi.icon_upload(size=s)),
      icon_tile("upload-fill", @sumi.icon_upload_fill(size=s)),
      icon_tile("video", @sumi.icon_video(size=s)),
      icon_tile("x", @sumi.icon_x(size=s)),
      icon_tile("x-fill", @sumi.icon_x_fill(size=s)),
    ]),
  )
}
