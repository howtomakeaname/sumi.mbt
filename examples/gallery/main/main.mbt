///|
using @rabbita {type Val, type Html}

///|
/// Compose independent section graphs into one page graph.
fn stack(sections : Array[Val[Html]]) -> Val[Html] {
  sections.fold(init=Val::constant(@html.nothing), fn(acc, section) {
    acc.view2(section, (a, b) => @html.fragment([a, b]))
  })
}

///|
fn section(id : String, title : String, content : Html) -> Html {
  @html.div(
    style=["display:flex;flex-direction:column;gap:12px;max-width:720px"],
    attrs=@html.Attrs::build().id(id),
    [
      @html.div(
        style=[
          "font-size:12px;line-height:20px;letter-spacing:0.08em;color:var(--sumi-text-tertiary,rgba(255,255,255,0.6))",
        ],
        title,
      ),
      content,
    ],
  )
}

///|
fn row(children : Array[Html]) -> Html {
  @html.div(
    style=["display:flex;flex-wrap:wrap;align-items:center;gap:12px"],
    children,
  )
}

///|
fn buttons_section() -> Val[Html] {
  Val::constant(
    section(
      "sec-buttons",
      "BUTTONS",
      row([
        @sumi.button(variant=Primary, "Generate"),
        @sumi.button(variant=Secondary, "HD Enhance"),
        @sumi.button(variant=Ghost, [
          @sumi.icon_sparkle(),
          @html.text("AI Edit"),
        ]),
        @sumi.button(variant=Primary, size=Sm, "Apply"),
        @sumi.button(variant=Primary, disabled=true, "Generate"),
        @sumi.button(variant=Primary, loading=true, "Generate"),
        @sumi.button(variant=Secondary, disabled=true, "HD Enhance"),
        @sumi.icon_button(@sumi.icon_download(), aria_label="Download"),
        @sumi.icon_button(
          @sumi.icon_crop(),
          pressed=true,
          aria_label="Crop (active tool)",
        ),
        @sumi.icon_button(@sumi.icon_x(), size=IconSm, aria_label="Close"),
      ]),
    ),
  )
}

///|
/// The small brand sparkle marking premium options in segmented controls.
fn sparkle_marker() -> Html {
  @html.span(
    style=["display:inline-flex;flex:none;color:var(--sumi-brand,#009efa)"],
    [@sumi.icon_sparkle(size=12)],
  )
}

///|
fn toolbar_section() -> Val[Html] {
  let (enhance_open, set_enhance_open) = @rabbita.create_variable(false)
  let (enhance, set_enhance) = @rabbita.create_variable("standard")
  let (detail_open, set_detail_open) = @rabbita.create_variable(false)
  let (detail, set_detail) = @rabbita.create_variable("moderate")
  let (res, set_res) = @rabbita.create_variable("4k")
  let (ratio, set_ratio) = @rabbita.create_variable("16:9")
  enhance_open.view6(enhance, detail_open, detail, res, ratio, fn(
    enhance_is_open,
    current_enhance,
    detail_is_open,
    current_detail,
    current_res,
    current_ratio,
  ) {
    section(
      "sec-toolbar",
      "TOOLBAR",
      @html.div(style=["display:flex;flex-direction:column;gap:16px"], [
        row([
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
        ]),
        row([
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
            selected=current_ratio,
            on_select=set_ratio.map(v => _ => v),
          ),
        ]),
      ]),
    )
  })
}

///|
fn sliders_section() -> Val[Html] {
  let (strength, set_strength) = @rabbita.create_variable(35)
  strength.view(fn(value) {
    section(
      "sec-sliders",
      "SLIDERS",
      @html.div(
        style=["display:flex;flex-direction:column;gap:24px;max-width:360px"],
        [
          @sumi.slider(
            value~,
            show_value=true,
            suffix="°",
            on_input=set_strength.map(v => _ => v),
          ),
          @sumi.slider(
            value~,
            value_tooltip=true,
            on_input=set_strength.map(v => _ => v),
          ),
          @sumi.slider(value=60, disabled=true),
        ],
      ),
    )
  })
}

///|
fn inputs_section() -> Val[Html] {
  let (name, set_name) = @rabbita.create_variable("")
  let (prompt, set_prompt) = @rabbita.create_variable("")
  let (model_open, set_model_open) = @rabbita.create_variable(false)
  let (model, set_model) = @rabbita.create_variable("nebula")
  let (res_open, set_res_open) = @rabbita.create_variable(false)
  let (res, set_res) = @rabbita.create_variable("2k")
  name.view6(prompt, model_open, model, res_open, res, fn(
    current_name,
    current_prompt,
    model_is_open,
    current_model,
    res_is_open,
    current_res,
  ) {
    section(
      "sec-inputs",
      "INPUTS",
      @html.div(
        style=["display:flex;flex-direction:column;gap:16px;max-width:480px"],
        [
          @sumi.input(
            value=current_name,
            placeholder="Search projects",
            prefix=@sumi.icon_search(size=14),
            clearable=true,
            on_input=set_name.map(v => _ => v),
          ),
          @sumi.input(value="Read only field", read_only=true),
          @sumi.input(
            value="Untitled/:",
            error=true,
            error_text="Project name contains invalid characters",
          ),
          @sumi.prompt_box(
            value=current_prompt,
            placeholder="Describe what to create",
            on_input=set_prompt.map(v => _ => v),
            on_send=set_prompt(_ => ""),
            send_disabled=current_prompt.is_empty(),
            actions=@html.fragment([
              @sumi.dropdown_menu(
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
              @sumi.dropdown_menu(
                side=Top,
                trigger=@sumi.button(variant=Ghost, size=Sm, [
                  @html.text(
                    if current_res == "1k" {
                      "1K"
                    } else if current_res == "2k" {
                      "2K"
                    } else {
                      "4K"
                    },
                  ),
                  @sumi.menu_chevron(),
                ]),
                items=@sumi.MenuEntry::items([
                  @sumi.MenuItem::new("1k", "1K"),
                  @sumi.MenuItem::new("2k", "2K"),
                  @sumi.MenuItem::new("4k", "4K"),
                ]),
                open=res_is_open,
                on_open_change=set_res_open.map(v => _ => v),
                selected=current_res,
                on_select=set_res.map(v => _ => v),
              ),
            ]),
          ),
          @sumi.prompt_box(
            value="A quiet harbor at dusk, fishing boats with warm lantern light, distant lighthouse in soft fog",
            placeholder="Describe what to create",
            rows=3,
            maxlength=800,
            show_count=true,
            actions=@sumi.button(variant=Ghost, size=Sm, [
              @sumi.icon_image(size=14),
              @html.text("Reference"),
            ]),
          ),
        ],
      ),
    )
  })
}

///|
fn pickers_section() -> Val[Html] {
  let (format_open, set_format_open) = @rabbita.create_variable(false)
  let (format, set_format) = @rabbita.create_variable("png")
  let (count, set_count) = @rabbita.create_variable(4)
  format_open.view3(format, count, fn(is_open, current_format, current_count) {
    section(
      "sec-pickers",
      "PICKERS",
      @html.div(
        style=["display:flex;flex-direction:column;gap:16px;max-width:280px"],
        [
          @sumi.select(
            options=[
              @sumi.MenuItem::new("png", "PNG"),
              @sumi.MenuItem::new("jpg", "JPG"),
              @sumi.MenuItem::new("webp", "WebP"),
            ],
            value=current_format,
            placeholder="Export format",
            open=is_open,
            on_open_change=set_format_open.map(v => _ => v),
            on_select=set_format.map(v => _ => v),
          ),
          row([
            @sumi.stepper(
              value=current_count,
              min=1,
              max=8,
              on_change=set_count.map(v => _ => v),
            ),
            @html.span(
              style=[
                "font-size:12px;line-height:20px;color:var(--sumi-text-placeholder,rgba(255,255,255,0.35))",
              ],
              "Batch count",
            ),
          ]),
        ],
      ),
    )
  })
}

///|
fn toggles_section() -> Val[Html] {
  let (enabled, set_enabled) = @rabbita.create_variable(true)
  let (checked, set_checked) = @rabbita.create_variable(true)
  enabled.view2(checked, fn(is_on, is_checked) {
    section(
      "sec-toggles",
      "SWITCH & CHECKBOX",
      row([
        @sumi.switch(checked=is_on, on_change=set_enabled.map(v => _ => v)),
        @sumi.switch(checked=is_on, disabled=true),
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
        @sumi.checkbox(checked=is_checked, disabled=true),
      ]),
    )
  })
}

///|
fn display_section() -> Val[Html] {
  Val::constant(
    section(
      "sec-display",
      "TAG, TOOLTIP & AVATAR",
      row([
        @sumi.tag("Draft"),
        @sumi.tag(variant=Brand, [@sumi.icon_sparkle(size=12), @html.text("AI")]),
        @sumi.tag(variant=Outline, "16:9"),
        @sumi.tag(on_remove=@cmd.none, "Removable"),
        @sumi.tooltip(
          content="Export the current canvas",
          @sumi.icon_button(@sumi.icon_upload(), aria_label="Export"),
        ),
        @sumi.tooltip(
          content="More actions",
          side=Bottom,
          @sumi.icon_button(@sumi.icon_more(), aria_label="More"),
        ),
        @sumi.tooltip(
          content="Adjust colors",
          side=Left,
          @sumi.icon_button(@sumi.icon_adjust(), aria_label="Adjust"),
        ),
        @sumi.tooltip(
          content="Reset changes",
          side=Right,
          @sumi.icon_button(@sumi.icon_reset(), aria_label="Reset"),
        ),
        @sumi.avatar(fallback="Sumi"),
        @sumi.avatar(fallback="墨", size=40),
      ]),
    ),
  )
}

///|
fn dialog_section() -> Val[Html] {
  Val::constant(
    section(
      "sec-dialog",
      "DIALOG",
      @html.fragment([
        row([
          @sumi.button(
            variant=Secondary,
            on_click=@dialog.show("gallery-dialog"),
            "Open Dialog",
          ),
        ]),
        @sumi.dialog(
          id="gallery-dialog",
          title_text="Delete project",
          description="This action cannot be undone. The project and its versions will be removed.",
          [
            @html.div(
              style=[
                "display:flex;justify-content:flex-end;gap:8px;margin-top:20px",
              ],
              [
                @html.form(method_="dialog", style=["display:contents"], [
                  @sumi.button(variant=Ghost, type_="submit", "Cancel"),
                ]),
                @html.form(method_="dialog", style=["display:contents"], [
                  @sumi.button(variant=Primary, type_="submit", "Delete"),
                ]),
              ],
            ),
          ],
        ),
      ]),
    ),
  )
}

///|
fn feedback_section() -> Val[Html] {
  let (tab, set_tab) = @rabbita.create_variable("all")
  let (toast_open, set_toast) = @rabbita.create_variable(false)
  tab.view2(toast_open, fn(current_tab, toast_is_open) {
    section(
      "sec-feedback",
      "FEEDBACK & NAVIGATION",
      @html.div(style=["display:flex;flex-direction:column;gap:16px"], [
        row([
          @sumi.spinner(),
          @sumi.spinner(size=24),
          @sumi.badge(value=5),
          @sumi.badge(value=120),
          @sumi.badge(dot=true),
        ]),
        row([
          @html.div(
            style=["width:280px;display:flex;flex-direction:column;gap:8px"],
            [
              @sumi.progress(value=72, show_value=true),
              @sumi.progress(value=30),
            ],
          ),
        ]),
        row([
          @html.div(style=["width:280px"], [
            @sumi.skeleton_tile(width="280px", height="80px"),
          ]),
          @html.div(style=["width:280px"], [@sumi.skeleton_lines(count=3)]),
        ]),
        row([
          @sumi.tabs(
            items=[
              @sumi.TabEntry::new("all", "All"),
              @sumi.TabEntry::new("mine", "Mine"),
              @sumi.TabEntry::new("shared", "Shared"),
            ],
            selected=current_tab,
            on_select=set_tab.map(v => _ => v),
          ),
          @html.div(
            style=[
              "font-size:12px;color:var(--sumi-text-placeholder,rgba(255,255,255,0.35))",
            ],
            [@html.text("Current: "), @html.text(current_tab)],
          ),
        ]),
        row([
          @sumi.button(
            variant=Secondary,
            on_click=set_toast(v => !v),
            "Toggle Toast",
          ),
          @sumi.kbd("⌘"),
          @sumi.kbd("K"),
        ]),
        @sumi.toast(
          message="Export started — 3 files queued",
          open=toast_is_open,
          variant=Success,
          on_close=set_toast(_ => false),
        ),
      ]),
    )
  })
}

///|
fn surfaces_section() -> Val[Html] {
  let (ctx_open, set_ctx_open) = @rabbita.create_variable(false)
  let (ctx_action, set_ctx_action) = @rabbita.create_variable("")
  ctx_open.view2(ctx_action, fn(is_open, last_action) {
    section(
      "sec-surfaces",
      "SURFACES",
      @html.div(
        style=["display:flex;gap:16px;flex-wrap:wrap;align-items:flex-start"],
        [
          @sumi.card_section(
            header=@html.div(
              style=["display:flex;align-items:center;gap:8px"],
              [
                @sumi.icon_layers(size=16),
                @html.text("Project"),
                @html.span(style=["margin-left:auto"], [@sumi.badge(value=3)]),
              ],
            ),
            [
              @sumi.empty_state(
                title_text="No versions yet",
                description="Generated results will appear here.",
                icon=@sumi.icon_image(size=24),
                action=@sumi.button(variant=Secondary, size=Sm, "New Version"),
              ),
            ],
          ),
          @sumi.card_section(
            header=@html.text("Settings"),
            style=["width:280px"],
            [
              @html.div(style=["display:flex;flex-direction:column;gap:12px"], [
                row([@sumi.checkbox(checked=true, label="Auto-save")]),
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
            ],
          ),
          @sumi.context_menu(
            entries=[
              Item(@sumi.MenuItem::new("rename", "Rename", shortcut="R")),
              Item(
                @sumi.MenuItem::new(
                  "duplicate",
                  "Duplicate",
                  icon=@sumi.icon_layers(size=14),
                  shortcut="⌘D",
                ),
              ),
              Item(
                @sumi.MenuItem::new(
                  "download",
                  "Download",
                  icon=@sumi.icon_download(size=14),
                  shortcut="⌘S",
                ),
              ),
              Separator,
              Item(
                @sumi.MenuItem::new(
                  "delete",
                  "Delete",
                  icon=@sumi.icon_x(size=14),
                  shortcut="⌫",
                ),
              ),
            ],
            open=is_open,
            on_open_change=set_ctx_open.map(v => _ => v),
            on_select=set_ctx_action.map(v => _ => v),
            @html.div(
              style=[
                "display:flex;flex-direction:column;align-items:center;justify-content:center;gap:8px;width:280px;height:120px;border:1px dashed var(--sumi-stroke,rgba(204,221,255,0.1));border-radius:var(--sumi-radius-lg,12px);color:var(--sumi-text-placeholder,rgba(255,255,255,0.35));font-size:12px;line-height:20px;user-select:none",
              ],
              [
                @sumi.icon_grid(size=20),
                @html.text("Right-click this tile"),
                @html.span(
                  style=[
                    "color:var(--sumi-text-secondary,rgba(255,255,255,0.7))",
                  ],
                  if last_action.is_empty() {
                    ""
                  } else {
                    "Last action: \{last_action}"
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    )
  })
}

///|
fn app() -> Val[Html] {
  let (mode, set_mode) = @rabbita.create_variable("dark")
  let content = stack([
    buttons_section(),
    toolbar_section(),
    sliders_section(),
    inputs_section(),
    pickers_section(),
    toggles_section(),
    display_section(),
    feedback_section(),
    surfaces_section(),
    dialog_section(),
  ])
  mode.view2(content, fn(current_mode, c) {
    // Page backdrop outside the themed tree (overscroll, first paint):
    // styles.css pins the dark default; this rule overrides it in light.
    let page_bg = if current_mode == "light" { "#f0f0f2" } else { "#0d0d0d" }
    @sumi.theme(
      mode=if current_mode == "light" { @sumi.Light } else { @sumi.Dark },
      [
        @html.style_tag(attrs=@html.Attrs::build(), [
          @html.text("body{background:" + page_bg + "}"),
        ]),
        @html.div(
          style=["position:fixed;top:16px;right:16px;z-index:70"],
          @sumi.segmented(
            items=[
              @sumi.SegmentedItem::new("dark", "Dark"),
              @sumi.SegmentedItem::new("light", "Light"),
            ],
            selected=current_mode,
            on_select=set_mode.map(v => _ => v),
          ),
        ),
        @html.div(
          style=[
            "min-height:100vh;padding:48px;display:flex;flex-direction:column;gap:40px;background:var(--sumi-canvas,#0d0d0d);background-image:radial-gradient(circle,var(--sumi-stroke-secondary,rgba(255,255,255,0.04)) 1px,transparent 1px);background-size:24px 24px",
          ],
          [c],
        ),
      ],
    )
  })
}

///|
fn main {
  @rabbita.new(app).mount("app")
}
