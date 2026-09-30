///|
/// The generation state shown next to session titles and task cards.
///
/// - `Generating` — a spinner while a run is in flight
/// - `Count(n)` — a white square with the number of queued/finished tasks
/// - `Done` — a brand-blue tick circle
/// - `Dot` — a small brand-blue unread dot
/// - `Pending(label)` — an orange pill while a run awaits review
/// - `Partial` — an orange info circle for partial failures
pub(all) enum SessionStatus {
  Generating
  Count(Int)
  Done
  Dot
  Pending(String)
  Partial
} derive(Eq)

///|
pub extend SessionStatus with Eq::{equal, not_equal}

///|
const SessionStatusCellStyle : String = "display:inline-flex;flex:none;align-items:center;justify-content:center;width:20px;height:20px"

///|
const SessionStatusNumStyle : String = "font-size:10px;line-height:1;font-weight:500"

///|
/// The 20px generation-status indicator of session rows, titles, and task
/// cards. `Pending` sizes to its label; every other kind is a fixed 20px
/// cell.
///
/// ```moonbit nocheck
/// session_status(kind=Generating)
/// session_status(kind=Count(5))
/// session_status(kind=Pending("Review"))
/// ```
pub fn session_status(
  kind~ : SessionStatus,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs)
    .data_set("slot", "session-status")
    .data_set(
      "kind",
      match kind {
        Generating => "generating"
        Count(_) => "count"
        Done => "done"
        Dot => "dot"
        Pending(_) => "pending"
        Partial => "partial"
      },
    )
  let (root_style, content) : (String, @html.Html) = match kind {
    Generating =>
      (
        SessionStatusCellStyle +
        ";color:var(--sumi-primary-fg-disabled,rgba(224,245,255,0.2))",
        @primitives.spinner(size=20),
      )
    Count(n) =>
      (
        SessionStatusCellStyle +
        ";border-radius:10px;background:var(--sumi-primary-bg,#fafafa);color:var(--sumi-primary-fg,#1a1a1a)",
        @html.span(
          style=[@internal.SumiFontNum, SessionStatusNumStyle],
          n.to_string(),
        ),
      )
    Done =>
      (
        SessionStatusCellStyle + ";color:var(--sumi-brand,#009efa)",
        @primitives.icon_tick_circle_fill(size=17),
      )
    Dot =>
      (
        SessionStatusCellStyle,
        @html.span(
          style=[
            "width:8px;height:8px;border-radius:9999px;background:var(--sumi-brand,#009efa)",
          ],
          ([] : Array[@html.Html]),
        ),
      )
    Pending(label) =>
      (
        "display:inline-flex;flex:none;align-items:center;justify-content:center;padding:5px 8px;border-radius:10px;background:var(--sumi-orange-block,rgba(255,146,48,0.16));color:var(--sumi-orange,#ff9230);white-space:nowrap",
        @html.span(style=[@internal.SumiFontNum, SessionStatusNumStyle], [
          @html.text(label),
        ]),
      )
    Partial =>
      (
        SessionStatusCellStyle + ";color:var(--sumi-favorite,#ffa21e)",
        @primitives.icon_info_circle_fill(size=17),
      )
  }
  @html.span(
    style=@internal.sumi_styles([root_style], style),
    id?,
    class?,
    attrs=element_attrs,
    [content],
  )
}

///|
const SessionItemStyle : String = "display:flex;align-items:center;gap:8px;width:100%;padding:8px 10px;border-radius:8px;font-size:13px;line-height:22px;color:var(--sumi-text,#ffffff);user-select:none"

///|
const SessionItemDisabledStyle : String = "color:var(--sumi-text-disabled,rgba(255,255,255,0.2));cursor:not-allowed"

///|
const SessionItemActionStyle : String = "display:inline-flex;flex:none;align-items:center;justify-content:center;width:20px;height:20px;margin:0;padding:0;border:none;border-radius:4px;background:transparent;color:var(--sumi-text-secondary,rgba(255,255,255,0.7));cursor:pointer;appearance:none;-webkit-appearance:none;outline:none"

///|
/// One hover-revealed row action (rename / delete) of a `session_item`.
/// Clicks are stop-propagationed so they never trigger the row's own
/// `on_click`.
fn session_action(
  icon : @html.Html,
  label : String,
  cmd : @cmd.Cmd,
) -> @html.Html {
  @html.button(
    style=[
      @internal.SumiBoxSizing,
      @internal.SumiTextRendering,
      @internal.SumiTransition,
      SessionItemActionStyle,
    ],
    type_="button",
    title=label,
    attrs=@html.Attrs::build()
      .data_set("slot", "session-item-action")
      .aria_label(label)
      .on_click(fn(ev) {
        ev.stop_propagation()
        cmd
      }),
    [icon],
  )
}

///|
/// One row of a session list: a 13/22 label with an optional trailing
/// generation status (or a check mark while `active`), revealing rename /
/// delete actions on hover. The status cell hides while hovered so the
/// actions take its place.
///
/// ```moonbit nocheck
/// session_item(
///   label="Desert Mirage Expedition",
///   active=current == id,
///   status=Done,
///   on_click=emit.map(Open(id)),
///   on_edit=emit.map(Rename(id)),
///   on_delete=emit.map(Remove(id)),
/// )
/// ```
pub fn session_item(
  label~ : String,
  active? : Bool = false,
  disabled? : Bool = false,
  status? : SessionStatus,
  on_click? : @cmd.Cmd,
  on_edit? : @cmd.Cmd,
  on_delete? : @cmd.Cmd,
  edit_label? : String = "Rename",
  delete_label? : String = "Delete",
  aria_label? : String,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs).data_set(
    "slot", "session-item",
  )
  if active {
    ignore(element_attrs.data_set("active", "true").aria_current("true"))
  }
  let has_actions = !disabled && (on_edit is Some(_) || on_delete is Some(_))
  if has_actions {
    ignore(element_attrs.data_set("actions", "true"))
  }
  if disabled {
    ignore(element_attrs.data_set("disabled", "true").aria_disabled("true"))
  }
  if aria_label is Some(label_text) {
    ignore(element_attrs.aria_label(label_text))
  }
  let status_cell : @html.Html = if active {
    @html.span(
      style=[
        "display:inline-flex;flex:none;align-items:center;justify-content:center;width:20px;height:20px;color:var(--sumi-text,#ffffff)",
      ],
      attrs=@html.Attrs::build().data_set("slot", "session-item-status"),
      [@primitives.icon_check_fill_large(size=16)],
    )
  } else {
    match status {
      Some(kind) =>
        @html.span(
          style=[
            "display:inline-flex;flex:none;align-items:center;justify-content:center;width:20px;height:20px",
          ],
          attrs=@html.Attrs::build().data_set("slot", "session-item-status"),
          [session_status(kind~)],
        )
      None => @html.nothing
    }
  }
  let actions_view : @html.Html = if has_actions {
    let buttons : Array[@html.Html] = []
    if on_edit is Some(cmd) {
      buttons.push(
        session_action(@primitives.icon_edit(size=16), edit_label, cmd),
      )
    }
    if on_delete is Some(cmd) {
      buttons.push(
        session_action(@primitives.icon_delete(size=16), delete_label, cmd),
      )
    }
    @html.span(
      style=["display:none;flex:none;align-items:center;gap:8px"],
      attrs=@html.Attrs::build().data_set("slot", "session-item-actions"),
      buttons,
    )
  } else {
    @html.nothing
  }
  @html.div(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        @internal.SumiTransition,
        SessionItemStyle,
        if disabled {
          SessionItemDisabledStyle
        } else if on_click is Some(_) {
          "cursor:pointer"
        } else {
          ""
        },
      ],
      style,
    ),
    id?,
    class?,
    on_click?=if disabled { None } else { on_click },
    attrs=element_attrs,
    [
      @html.span(
        style=[
          "flex:1;min-width:0;overflow:hidden;text-overflow:ellipsis;white-space:nowrap",
        ],
        [@html.text(label)],
      ),
      status_cell,
      actions_view,
    ],
  )
}

///|
/// The hairline separator of a session list: a 0.5px rule inset 12px on
/// both sides inside a 4px-tall cell.
pub fn session_divider(
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  @html.div(
    style=@internal.sumi_styles(
      ["display:flex;flex:none;align-items:center;height:4px"],
      style,
    ),
    id?,
    class?,
    attrs=@internal.sumi_attrs(attrs)
      .data_set("slot", "session-divider")
      .role("separator")
      .aria_hidden("true"),
    [
      @html.span(
        style=[
          "flex:1;height:0.5px;margin:0 12px;background:var(--sumi-stroke-secondary,rgba(255,255,255,0.04))",
        ],
        ([] : Array[@html.Html]),
      ),
    ],
  )
}

///|
/// The session-list panel: a floating menu surface (`--sumi-menu`, 12px
/// radius, 4px padding) holding `session_item` rows and `session_divider`
/// separators. With `max_height` the panel scrolls with the library's thin
/// scrollbar, tinted to the design's blue.
///
/// ```moonbit nocheck
/// session_list(max_height=320, [
///   session_item(label="Weekly Sync Notes", active=true),
///   session_item(label="API Migration Draft", status=Generating),
///   session_divider(),
///   session_item(label="Archived Threads", disabled=true),
/// ])
/// ```
pub fn session_list(
  children~ : Array[@html.Html],
  width? : Int = 280,
  max_height? : Int,
  aria_label? : String,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs).data_set(
    "slot", "session-list",
  )
  if aria_label is Some(label_text) {
    ignore(element_attrs.aria_label(label_text))
  }
  @html.div(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        "display:flex;flex-direction:column;gap:2px;width:\{width}px;padding:4px;border:0.5px solid var(--sumi-stroke-secondary,rgba(255,255,255,0.04));border-radius:12px;background:var(--sumi-menu,#262626);box-shadow:0px 8px 28px 0px var(--sumi-shadow,rgba(0,0,0,0.24));--sumi-scrollbar:rgba(204,221,255,0.12)",
        match max_height {
          Some(h) => "max-height:\{h}px;overflow-x:clip;overflow-y:auto"
          None => ""
        },
      ],
      style,
    ),
    id?,
    class?,
    attrs=element_attrs,
    children,
  )
}

///|
const SessionTitleStyle : String = "display:inline-flex;align-items:center;gap:8px;max-width:100%;margin:0;padding:4px 8px;border:none;border-radius:8px;background:transparent;font-size:14px;line-height:22px;color:var(--sumi-text,#ffffff);cursor:pointer;user-select:none;appearance:none;-webkit-appearance:none;outline:none"

///|
/// The current-session pill of a chat window header: a 14/22 label, an
/// optional generation status, and a 12px chevron, with the design's
/// ghost hover/press fills. Typically the trigger of a `session_list`
/// dropdown.
pub fn session_title(
  label~ : String,
  status? : SessionStatus,
  on_click? : @cmd.Cmd,
  disabled? : Bool = false,
  aria_label? : String,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs).data_set(
    "slot", "session-title",
  )
  if aria_label is Some(label_text) {
    ignore(element_attrs.aria_label(label_text))
  }
  let status_view : @html.Html = match status {
    Some(kind) => session_status(kind~)
    None => @html.nothing
  }
  @html.button(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        @internal.SumiTransition,
        SessionTitleStyle,
        if disabled {
          "color:var(--sumi-text-disabled,rgba(255,255,255,0.2));cursor:not-allowed"
        } else {
          ""
        },
      ],
      style,
    ),
    type_="button",
    disabled~,
    id?,
    class?,
    on_click?,
    attrs=element_attrs,
    [
      @html.span(
        style=[
          "margin:0;min-width:0;overflow:hidden;text-overflow:ellipsis;white-space:nowrap",
        ],
        [@html.text(label)],
      ),
      status_view,
      @html.span(
        style=["display:inline-flex;flex:none"],
        attrs=@html.Attrs::build().aria_hidden("true"),
        [@primitives.icon_chevron_down_fill(size=12)],
      ),
    ],
  )
}

///|
/// The header row of a chat window: the current-session `session_title`
/// on the left and new-conversation / collapse icon buttons on the right
/// (gap 4).
///
/// ```moonbit nocheck
/// session_header(
///   title="Desert Mirage Expedition",
///   status=Done,
///   on_title=emit(ToggleSessionMenu),
///   on_new=emit(NewConversation),
///   on_collapse=emit(CollapsePanel),
/// )
/// ```
pub fn session_header(
  title~ : String,
  status? : SessionStatus,
  on_title? : @cmd.Cmd,
  on_new? : @cmd.Cmd,
  on_collapse? : @cmd.Cmd,
  new_label? : String = "New conversation",
  collapse_label? : String = "Collapse",
  aria_label? : String,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs).data_set(
    "slot", "session-header",
  )
  if aria_label is Some(label_text) {
    ignore(element_attrs.aria_label(label_text))
  }
  @html.div(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        "display:flex;align-items:center;justify-content:space-between;gap:8px;width:100%",
      ],
      style,
    ),
    id?,
    class?,
    attrs=element_attrs,
    [
      session_title(label=title, status?, on_click?=on_title),
      @html.div(style=["display:flex;flex:none;align-items:center;gap:4px"], [
        @primitives.icon_button(
          @primitives.icon_new_conversation(size=16),
          aria_label=new_label,
          on_click?=on_new,
        ),
        @primitives.icon_button(
          @primitives.icon_fullscreen_alt(size=16),
          aria_label=collapse_label,
          on_click?=on_collapse,
        ),
      ]),
    ],
  )
}
