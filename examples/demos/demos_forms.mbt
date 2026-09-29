///|
fn demo_input_basic(mode : @sumi.ThemeMode?) -> Val[Html] {
  let (name, set_name) = @rabbita.create_variable("")
  name.view(fn(current) {
    stage_mode(mode, [
      column("12px", [
        @sumi.input(
          value=current,
          placeholder="Search projects",
          prefix=@sumi.icon_search(size=14),
          clearable=true,
          on_input=set_name.map(v => _ => v),
        ),
        @sumi.input(
          value=current,
          placeholder="With suffix",
          suffix=@sumi.kbd("⌘K"),
          on_input=set_name.map(v => _ => v),
        ),
      ]),
    ])
  })
}

///|
fn demo_input_states(mode : @sumi.ThemeMode?) -> Val[Html] {
  Val::constant(
    stage_mode(mode, [
      column("12px", [
        @sumi.input(value="Read only field", read_only=true),
        @sumi.input(value="Disabled field", disabled=true),
        @sumi.input(
          value="Untitled/:",
          error=true,
          error_text="Project name contains invalid characters",
        ),
      ]),
    ]),
  )
}

///|
fn demo_textarea_basic(mode : @sumi.ThemeMode?) -> Val[Html] {
  let (notes, set_notes) = @rabbita.create_variable("")
  notes.view(fn(current) {
    stage_mode(mode, [
      column("12px", [
        @sumi.textarea(
          value=current,
          placeholder="Add release notes",
          rows=4,
          on_input=set_notes.map(v => _ => v),
        ),
      ]),
    ])
  })
}

///|
fn demo_select_basic(mode : @sumi.ThemeMode?) -> Val[Html] {
  let (format_open, set_format_open) = @rabbita.create_variable(false)
  let (format, set_format) = @rabbita.create_variable("png")
  format_open.view2(format, fn(is_open, current) {
    stage_mode(mode, [
      column("12px", [
        @sumi.select(
          options=[
            @sumi.MenuItem::new("png", "PNG"),
            @sumi.MenuItem::new("jpg", "JPG"),
            @sumi.MenuItem::new("webp", "WebP"),
          ],
          value=current,
          placeholder="Export format",
          open=is_open,
          on_open_change=set_format_open.map(v => _ => v),
          on_select=set_format.map(v => _ => v),
        ),
      ]),
    ])
  })
}

///|
fn demo_select_filter(mode : @sumi.ThemeMode?) -> Val[Html] {
  let (team_open, set_team_open) = @rabbita.create_variable(false)
  let (team, set_team) = @rabbita.create_variable("")
  team_open.view2(team, fn(is_open, current) {
    stage_mode(mode, [
      row([
        @sumi.select(
          options=[
            @sumi.MenuItem::new("design", "Design"),
            @sumi.MenuItem::new("engineering", "Engineering"),
            @sumi.MenuItem::new("marketing", "Marketing"),
          ],
          value=current,
          placeholder="Team",
          open=is_open,
          on_open_change=set_team_open.map(v => _ => v),
          on_select=set_team.map(v => _ => v),
          variant=Filter,
          on_clear=set_team(_ => ""),
        ),
        @sumi.select(
          options=[@sumi.MenuItem::new("mine", "Mine")],
          value="",
          placeholder="Owner",
          open=false,
          variant=Filter,
          disabled=true,
        ),
      ]),
    ])
  })
}

///|
fn demo_stepper_basic(mode : @sumi.ThemeMode?) -> Val[Html] {
  let (count, set_count) = @rabbita.create_variable(4)
  count.view(fn(current) {
    stage_mode(mode, [
      @sumi.stepper(
        value=current,
        min=1,
        max=8,
        on_change=set_count.map(v => _ => v),
      ),
      hint("Batch count"),
      @sumi.stepper(value=3, disabled=true),
    ])
  })
}

///|
fn demo_switch_basic(mode : @sumi.ThemeMode?) -> Val[Html] {
  let (enabled, set_enabled) = @rabbita.create_variable(true)
  enabled.view(fn(is_on) {
    stage_mode(mode, [
      @sumi.switch(checked=is_on, on_change=set_enabled.map(v => _ => v)),
      @sumi.switch(checked=is_on, disabled=true),
    ])
  })
}

///|
fn demo_checkbox_basic(mode : @sumi.ThemeMode?) -> Val[Html] {
  let (checked, set_checked) = @rabbita.create_variable(true)
  checked.view(fn(is_checked) {
    stage_mode(mode, [
      @sumi.checkbox(
        checked=is_checked,
        label="Keep original size",
        on_change=set_checked.map(v => _ => v),
      ),
      @sumi.checkbox(
        checked=false,
        indeterminate=true,
        label="Select all",
        on_change=set_checked.map(v => _ => v),
      ),
      @sumi.checkbox(checked=is_checked, disabled=true, label="Disabled"),
    ])
  })
}

///|
fn demo_slider_basic(mode : @sumi.ThemeMode?) -> Val[Html] {
  let (strength, set_strength) = @rabbita.create_variable(35)
  strength.view(fn(value) {
    stage_mode(mode, [
      column("24px", [
        @sumi.slider(
          value~,
          show_value=true,
          suffix="°",
          on_input=set_strength.map(v => _ => v),
        ),
        @sumi.slider(value=60, disabled=true),
      ]),
    ])
  })
}

///|
fn demo_slider_tooltip(mode : @sumi.ThemeMode?) -> Val[Html] {
  let (amount, set_amount) = @rabbita.create_variable(35)
  amount.view(fn(value) {
    stage_mode(mode, [
      column("24px", [
        @sumi.slider(
          value~,
          value_tooltip=true,
          on_input=set_amount.map(v => _ => v),
        ),
      ]),
    ])
  })
}

///|
fn demo_slider_field(mode : @sumi.ThemeMode?) -> Val[Html] {
  let (length, set_length) = @rabbita.create_variable(30)
  let (auto, set_auto) = @rabbita.create_variable(false)
  length.view2(auto, fn(current, is_auto) {
    stage_mode(mode, [
      column("24px", [
        @sumi.slider_field(
          value=current,
          min=0,
          max=180,
          label="Clip length",
          unit="s",
          ticks=[0, 30, 60, 90, 120, 150, 180],
          auto=is_auto,
          on_auto_change=set_auto.map(v => _ => v),
          on_input=set_length.map(v => _ => v),
        ),
        @sumi.slider_field(
          value=current,
          min=0,
          max=180,
          label="Clip length",
          unit="s",
          ticks=[0, 30, 60, 90, 120, 150, 180],
          on_input=set_length.map(v => _ => v),
        ),
      ]),
    ])
  })
}

///|
fn demo_chip_row(mode : @sumi.ThemeMode?) -> Val[Html] {
  let (quality, set_quality) = @rabbita.create_variable("720P")
  quality.view(fn(current) {
    let options = ["360P", "720P", "1080P", "4K"]
    let chips : Array[Html] = options.map(opt => {
      @sumi.chip(opt, selected=current == opt, on_click=set_quality(_ => opt))
    })
    chips.push(@sumi.chip("8K", disabled=true))
    stage_mode(mode, chips)
  })
}

///|
/// A tiny gradient plate standing in for an uploaded photo — a self-contained
/// data URI so the gallery and docs render offline.
fn attachment_thumb(seed : Int) -> String {
  let hue = (seed * 47 + 210) % 360
  let hue2 = (hue + 40) % 360
  "data:image/svg+xml,%3Csvg xmlns=%27http://www.w3.org/2000/svg%27 viewBox=%270 0 48 48%27%3E%3Cdefs%3E%3ClinearGradient id=%27g%27 x1=%270%27 y1=%270%27 x2=%271%27 y2=%271%27%3E%3Cstop offset=%270%27 stop-color=%27hsl(\{hue},62%25,56%25)%27/%3E%3Cstop offset=%271%27 stop-color=%27hsl(\{hue2},58%25,32%25)%27/%3E%3C/linearGradient%3E%3C/defs%3E%3Crect width=%2748%27 height=%2748%27 fill=%27url(%23g)%27/%3E%3Ccircle cx=%2736%27 cy=%2712%27 r=%276%27 fill=%27rgba(255,255,255,0.35)%27/%3E%3C/svg%3E"
}

///|
fn attachment_photo(seed : Int) -> @sumi.AttachmentItem {
  @sumi.AttachmentItem::image(attachment_thumb(seed), label="Photo \{seed + 1}")
}

///|
fn attachment_remove_at(
  items : Array[@sumi.AttachmentItem],
  index : Int,
) -> Array[@sumi.AttachmentItem] {
  let out = []
  for i, item in items {
    if i != index {
      out.push(item)
    }
  }
  out
}

///|
fn demo_attachment_strip(mode : @sumi.ThemeMode?) -> Val[Html] {
  let (items, set_items) = @rabbita.create_variable([
    attachment_photo(0),
    attachment_photo(1),
    attachment_photo(2),
    @sumi.AttachmentItem::document("Brief.pdf"),
    attachment_photo(3),
  ])
  let (full, set_full) = @rabbita.create_variable([
    attachment_photo(0),
    attachment_photo(1),
    attachment_photo(2),
    attachment_photo(3),
    attachment_photo(4),
    attachment_photo(5),
    attachment_photo(6),
    attachment_photo(7),
    @sumi.AttachmentItem::document("Brief.pdf"),
    @sumi.AttachmentItem::document("Notes.txt"),
    @sumi.AttachmentItem::document("Sketches.zip"),
  ])
  items.view2(full, fn(current, overflowing) {
    stage_mode(mode, [
      @sumi.attachment_strip(
        items=current,
        on_add=set_items(fn(c) { [..c, attachment_photo(c.length())] }),
        on_remove=set_items.map(idx => c => attachment_remove_at(c, idx)),
      ),
      hint("Past 10 attachments the row clips and the add tile pins right:"),
      @sumi.attachment_strip(
        items=overflowing,
        on_add=set_full(fn(c) { [..c, attachment_photo(c.length())] }),
        on_remove=set_full.map(idx => c => attachment_remove_at(c, idx)),
      ),
    ])
  })
}

///|
fn demo_segmented_basic(mode : @sumi.ThemeMode?) -> Val[Html] {
  let (res, set_res) = @rabbita.create_variable("4k")
  res.view(fn(current) {
    stage_mode(mode, [
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
        selected=current,
        on_select=set_res.map(v => _ => v),
      ),
    ])
  })
}

///|
fn demo_segmented_stacked(mode : @sumi.ThemeMode?) -> Val[Html] {
  let (ratio, set_ratio) = @rabbita.create_variable("16:9")
  ratio.view(fn(current) {
    stage_mode(mode, [
      @sumi.segmented(
        stacked=true,
        items=[
          @sumi.SegmentedItem::new(
            "21:9",
            "21:9",
            numeric=true,
            icon=@sumi.icon_ratio(width=21, height=9),
          ),
          @sumi.SegmentedItem::new(
            "16:9",
            "16:9",
            numeric=true,
            icon=@sumi.icon_ratio(width=16, height=9),
          ),
          @sumi.SegmentedItem::new(
            "4:3",
            "4:3",
            numeric=true,
            icon=@sumi.icon_ratio(width=4, height=3),
          ),
          @sumi.SegmentedItem::new(
            "1:1",
            "1:1",
            numeric=true,
            icon=@sumi.icon_ratio(width=1, height=1),
          ),
          @sumi.SegmentedItem::new(
            "9:16",
            "9:16",
            numeric=true,
            icon=@sumi.icon_ratio(width=9, height=16),
          ),
        ],
        selected=current,
        on_select=set_ratio.map(v => _ => v),
      ),
    ])
  })
}

///|
fn demo_prompt_box_basic(mode : @sumi.ThemeMode?) -> Val[Html] {
  let (prompt, set_prompt) = @rabbita.create_variable("")
  let (model_open, set_model_open) = @rabbita.create_variable(false)
  let (model, set_model) = @rabbita.create_variable("nebula")
  prompt.view3(model_open, model, fn(
    current_prompt,
    model_is_open,
    current_model,
  ) {
    stage_mode(mode, [
      column("12px", [
        @sumi.prompt_box(
          value=current_prompt,
          placeholder="Describe what to create",
          on_input=set_prompt.map(v => _ => v),
          on_send=set_prompt(_ => ""),
          send_disabled=current_prompt.is_empty(),
          actions=@sumi.dropdown_menu(
            side=Top,
            trigger=@sumi.button(variant=Ghost, size=Sm, [
              @html.text(
                if current_model == "nebula" {
                  "Nebula 2.0"
                } else {
                  "Nebula 2.0 Pro"
                },
              ),
              @sumi.menu_chevron(),
            ]),
            items=@sumi.MenuEntry::items([
              @sumi.MenuItem::new(
                "nebula",
                "Nebula 2.0",
                description="Fast drafts for daily iterations",
                icon=@sumi.icon_sparkle(size=16),
              ),
              @sumi.MenuItem::new(
                "nebula-pro",
                "Nebula 2.0 Pro",
                description="Higher fidelity for final output",
                icon=@sumi.icon_sparkle(size=16),
              ),
            ]),
            open=model_is_open,
            on_open_change=set_model_open.map(v => _ => v),
            selected=current_model,
            on_select=set_model.map(v => _ => v),
          ),
        ),
      ]),
    ])
  })
}

///|
fn demo_prompt_box_count(mode : @sumi.ThemeMode?) -> Val[Html] {
  let (prompt, set_prompt) = @rabbita.create_variable(
    "A quiet harbor at dusk, fishing boats with warm lantern light",
  )
  prompt.view(fn(current) {
    stage_mode(mode, [
      column("12px", [
        @sumi.prompt_box(
          value=current,
          placeholder="Describe what to create",
          rows=3,
          maxlength=120,
          show_count=true,
          on_input=set_prompt.map(v => _ => v),
          actions=@sumi.button(variant=Ghost, size=Sm, [
            @sumi.icon_image(size=14),
            @html.text("Reference"),
          ]),
        ),
      ]),
    ])
  })
}

///|
/// Click the title to rename it; Enter or clicking away commits, Escape
/// restores.
fn demo_editable_text_basic(mode : @sumi.ThemeMode?) -> Val[Html] {
  let (title, set_title) = @rabbita.create_variable("Untitled")
  title.view(fn(current) {
    stage_mode(mode, [
      column("12px", [
        row([
          @sumi.editable_text(
            value=current,
            placeholder="Enter a canvas name",
            on_change=set_title.map(v => _ => v),
          ),
        ]),
        @sumi.editable_text(value="", placeholder="Enter a canvas name"),
      ]),
    ])
  })
}

///|
fn demo_send_button_basic(mode : @sumi.ThemeMode?) -> Val[Html] {
  Val::constant(
    stage_mode(mode, [
      @sumi.send_button(aria_label="Send"),
      @sumi.send_button(disabled=true, aria_label="Send (disabled)"),
      @sumi.send_button(loading=true, aria_label="Sending"),
    ]),
  )
}
