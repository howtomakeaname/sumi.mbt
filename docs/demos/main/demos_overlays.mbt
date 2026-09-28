///|
fn demo_dropdown_menu_basic() -> Val[Html] {
  let (open, set_open) = @rabbita.create_variable(false)
  let (choice, set_choice) = @rabbita.create_variable("standard")
  open.view2(choice, fn(is_open, current) {
    stage([
      @sumi.dropdown_menu(
        trigger=@sumi.button(variant=Secondary, [
          @html.text("Enhance"),
          @sumi.menu_chevron(),
        ]),
        items=[
          SectionLabel("QUALITY"),
          Item(
            @sumi.MenuItem::new(
              "standard",
              "Standard",
              description="Balanced clarity for everyday images",
              icon=@sumi.icon_sparkle(size=16),
            ),
          ),
          Item(
            @sumi.MenuItem::new(
              "fidelity",
              "High Fidelity",
              description="Maximum detail for final renders",
              icon=@sumi.icon_sparkle(size=16),
            ),
          ),
        ],
        open=is_open,
        on_open_change=set_open.map(v => _ => v),
        selected=current,
        on_select=set_choice.map(v => _ => v),
      ),
    ])
  })
}

///|
fn demo_dropdown_menu_compact() -> Val[Html] {
  let (open, set_open) = @rabbita.create_variable(false)
  let (choice, set_choice) = @rabbita.create_variable("")
  open.view2(choice, fn(is_open, current) {
    stage([
      @sumi.dropdown_menu(
        trigger=@sumi.button(variant=Secondary, [
          @html.text("Actions"),
          @sumi.menu_chevron(),
        ]),
        items=[
          Item(@sumi.MenuItem::new("rename", "Rename", shortcut="R")),
          Item(
            @sumi.MenuItem::new(
              "duplicate",
              "Duplicate",
              icon=@sumi.icon_layers(size=14),
              shortcut="⌘D",
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
        on_open_change=set_open.map(v => _ => v),
        selected=current,
        on_select=set_choice.map(v => _ => v),
      ),
      if current.is_empty() {
        @html.nothing
      } else {
        hint("Selected: " + current)
      },
    ])
  })
}

///|
fn demo_context_menu_basic() -> Val[Html] {
  let (open, set_open) = @rabbita.create_variable(false)
  let (action, set_action) = @rabbita.create_variable("")
  open.view2(action, fn(is_open, last_action) {
    stage([
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
        on_open_change=set_open.map(v => _ => v),
        on_select=set_action.map(v => _ => v),
        @html.div(
          style=[
            "display:flex;flex-direction:column;align-items:center;justify-content:center;gap:8px;width:100%;max-width:320px;height:120px;border:1px dashed var(--sumi-stroke,rgba(204,221,255,0.1));border-radius:var(--sumi-radius-lg,12px);color:var(--sumi-text-placeholder,rgba(255,255,255,0.35));font-size:12px;line-height:20px;user-select:none",
          ],
          [
            @sumi.icon_grid(size=20),
            @html.text("Right-click this tile"),
            hint(
              if last_action.is_empty() {
                ""
              } else {
                "Last action: " + last_action
              },
            ),
          ],
        ),
      ),
    ])
  })
}

///|
fn demo_popover_basic() -> Val[Html] {
  let (open, set_open) = @rabbita.create_variable(false)
  let (strength, set_strength) = @rabbita.create_variable(35)
  open.view2(strength, fn(is_open, value) {
    stage([
      @sumi.popover(
        trigger=@sumi.button(variant=Secondary, [
          @sumi.icon_adjust(size=14),
          @html.text("Adjust"),
        ]),
        open=is_open,
        on_open_change=set_open.map(v => _ => v),
        @html.div(
          style=[
            "display:flex;flex-direction:column;gap:12px;padding:16px;width:240px",
          ],
          [
            @html.div(
              style=["font-size:13px;line-height:22px;font-weight:500"],
              "Strength",
            ),
            @sumi.slider(
              value~,
              show_value=true,
              on_input=set_strength.map(v => _ => v),
            ),
          ],
        ),
      ),
    ])
  })
}

///|
fn demo_tooltip_basic() -> Val[Html] {
  Val::constant(
    stage([
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
    ]),
  )
}

///|
fn demo_dialog_basic() -> Val[Html] {
  Val::constant(
    stage([
      @sumi.button(
        variant=Secondary,
        on_click=@dialog.show("docs-dialog-basic"),
        "Open Dialog",
      ),
      @sumi.dialog(
        id="docs-dialog-basic",
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
  )
}

///|
fn demo_toast_basic() -> Val[Html] {
  let (state, set_state) = @rabbita.create_variable("")
  state.view(fn(current) {
    stage([
      @sumi.button(
        variant=Secondary,
        on_click=set_state(_ => "success"),
        "Success",
      ),
      @sumi.button(variant=Secondary, on_click=set_state(_ => "error"), "Error"),
      @sumi.button(variant=Secondary, on_click=set_state(_ => "info"), "Info"),
      @sumi.toast(
        message="Export started — 3 files queued",
        open=current == "success",
        variant=Success,
        on_close=set_state(_ => ""),
      ),
      @sumi.toast(
        message="Export failed — check the file format",
        open=current == "error",
        variant=Error,
        on_close=set_state(_ => ""),
      ),
      @sumi.toast(
        message="A new version is available",
        open=current == "info",
        variant=Info,
        on_close=set_state(_ => ""),
      ),
    ])
  })
}
