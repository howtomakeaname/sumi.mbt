///|
fn demo_button_basic(mode : @sumi.ThemeMode?) -> Val[Html] {
  Val::constant(
    stage_mode(mode, [
      @sumi.button(variant=Primary, "Generate"),
      @sumi.button(variant=Secondary, "HD Enhance"),
      @sumi.button(variant=Ghost, [@sumi.icon_sparkle(), @html.text("AI Edit")]),
      @sumi.button(variant=Primary, disabled=true, "Generate"),
      @sumi.button(variant=Primary, loading=true, "Generate"),
    ]),
  )
}

///|
fn demo_button_sizes(mode : @sumi.ThemeMode?) -> Val[Html] {
  Val::constant(
    stage_mode(mode, [
      @sumi.button(variant=Primary, "Apply"),
      @sumi.button(variant=Primary, size=Sm, "Apply"),
      @sumi.button(variant=Secondary, size=Sm, "Apply"),
      @sumi.button(variant=Ghost, size=Sm, "Options"),
    ]),
  )
}

///|
fn demo_icon_button_basic(mode : @sumi.ThemeMode?) -> Val[Html] {
  Val::constant(
    stage_mode(mode, [
      @sumi.icon_button(@sumi.icon_download(), aria_label="Download"),
      @sumi.icon_button(
        @sumi.icon_crop(),
        pressed=true,
        aria_label="Crop (active tool)",
      ),
      @sumi.icon_button(@sumi.icon_x(), size=IconSm, aria_label="Close"),
      @sumi.icon_button(@sumi.icon_upload(), disabled=true, aria_label="Export"),
    ]),
  )
}

///|
fn demo_favorite_toggle_basic(mode : @sumi.ThemeMode?) -> Val[Html] {
  let (fav_a, set_fav_a) = @rabbita.create_variable(true)
  let (fav_b, set_fav_b) = @rabbita.create_variable(false)
  fav_a.view2(fav_b, fn(a, b) {
    stage_mode(mode, [
      @sumi.favorite_toggle(checked=a, on_change=set_fav_a.map(v => _ => v)),
      @sumi.favorite_toggle(checked=b, on_change=set_fav_b.map(v => _ => v)),
      @sumi.favorite_toggle(checked=true, disabled=true),
    ])
  })
}

///|
fn demo_toolbar_basic(mode : @sumi.ThemeMode?) -> Val[Html] {
  let (enhance_open, set_enhance_open) = @rabbita.create_variable(false)
  let (enhance, set_enhance) = @rabbita.create_variable("standard")
  let (detail_open, set_detail_open) = @rabbita.create_variable(false)
  let (detail, set_detail) = @rabbita.create_variable("moderate")
  let (res, set_res) = @rabbita.create_variable("4k")
  enhance_open.view5(enhance, detail_open, detail, res, fn(
    enhance_is_open,
    current_enhance,
    detail_is_open,
    current_detail,
    current_res,
  ) {
    stage_mode(mode, [
      @sumi.toolbar([
        @sumi.dropdown_menu(
          trigger=@sumi.button(variant=Ghost, [
            @sumi.icon_sparkle(),
            @html.text("Enhance"),
            @sumi.menu_chevron(),
          ]),
          items=@sumi.MenuEntry::items([
            @sumi.MenuItem::new(
              "standard",
              "Standard",
              description="Balanced clarity for everyday images",
            ),
            @sumi.MenuItem::new(
              "fidelity",
              "High Fidelity",
              description="Maximum detail for final renders",
            ),
          ]),
          open=enhance_is_open,
          on_open_change=set_enhance_open.map(v => _ => v),
          selected=current_enhance,
          on_select=set_enhance.map(v => _ => v),
        ),
        @sumi.toolbar_divider(),
        @sumi.dropdown_menu(
          trigger=@sumi.button(variant=Ghost, [
            @html.text("Detail"),
            @sumi.menu_chevron(),
          ]),
          items=@sumi.MenuEntry::items([
            @sumi.MenuItem::new("subtle", "Subtle"),
            @sumi.MenuItem::new("moderate", "Moderate"),
            @sumi.MenuItem::new("strong", "Strong"),
          ]),
          open=detail_is_open,
          on_open_change=set_detail_open.map(v => _ => v),
          selected=current_detail,
          on_select=set_detail.map(v => _ => v),
        ),
        @sumi.toolbar_divider(),
        @sumi.segmented(
          items=[
            @sumi.SegmentedItem::new("2k", "2K", numeric=true),
            @sumi.SegmentedItem::new(
              "4k",
              "4K",
              numeric=true,
              trailing=sparkle_marker(),
            ),
            @sumi.SegmentedItem::new(
              "8k",
              "8K",
              numeric=true,
              trailing=sparkle_marker(),
            ),
          ],
          selected=current_res,
          on_select=set_res.map(v => _ => v),
        ),
        @sumi.toolbar_divider(),
        @sumi.credits(value=24),
        @sumi.button(variant=Primary, [
          @sumi.icon_sparkle(size=14),
          @html.text("Generate"),
        ]),
      ]),
    ])
  })
}
