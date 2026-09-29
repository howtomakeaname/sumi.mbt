///|
fn demo_input_basic(mode : @sumi.ThemeMode) -> Val[Html] {
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
fn demo_input_states(mode : @sumi.ThemeMode) -> Val[Html] {
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
fn demo_textarea_basic(mode : @sumi.ThemeMode) -> Val[Html] {
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
fn demo_select_basic(mode : @sumi.ThemeMode) -> Val[Html] {
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
fn demo_stepper_basic(mode : @sumi.ThemeMode) -> Val[Html] {
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
fn demo_switch_basic(mode : @sumi.ThemeMode) -> Val[Html] {
  let (enabled, set_enabled) = @rabbita.create_variable(true)
  enabled.view(fn(is_on) {
    stage_mode(mode, [
      @sumi.switch(checked=is_on, on_change=set_enabled.map(v => _ => v)),
      @sumi.switch(checked=is_on, disabled=true),
    ])
  })
}

///|
fn demo_checkbox_basic(mode : @sumi.ThemeMode) -> Val[Html] {
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
fn demo_slider_basic(mode : @sumi.ThemeMode) -> Val[Html] {
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
fn demo_slider_tooltip(mode : @sumi.ThemeMode) -> Val[Html] {
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
fn demo_segmented_basic(mode : @sumi.ThemeMode) -> Val[Html] {
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
fn demo_segmented_stacked(mode : @sumi.ThemeMode) -> Val[Html] {
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
fn demo_prompt_box_basic(mode : @sumi.ThemeMode) -> Val[Html] {
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
fn demo_prompt_box_count(mode : @sumi.ThemeMode) -> Val[Html] {
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
fn demo_send_button_basic(mode : @sumi.ThemeMode) -> Val[Html] {
  Val::constant(
    stage_mode(mode, [
      @sumi.send_button(aria_label="Send"),
      @sumi.send_button(disabled=true, aria_label="Send (disabled)"),
      @sumi.send_button(loading=true, aria_label="Sending"),
    ]),
  )
}
