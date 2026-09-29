///|
/// Whether the work is still streaming (shimmering label) or settled
/// (static tertiary label). Failure copy is written into the label
/// itself, e.g. `"(1/1) Image generation completed, 1 item failed"`.
pub(all) enum ToolCallState {
  Doing
  Done
} derive(Eq)

///|
pub extend ToolCallState with Eq::{equal, not_equal}

///|
const ToolCallLabelStyle : String = "display:inline-block;min-width:0;max-width:100%;font-size:14px;line-height:22px;font-weight:500;color:var(--sumi-text-tertiary,rgba(255,255,255,0.6))"

///|
const ToolCallTruncateStyle : String = "overflow:hidden;text-overflow:ellipsis;white-space:nowrap"

///|
fn tool_call_label(
  label : String,
  state : ToolCallState,
  truncate : Bool,
) -> @html.Html {
  if state is Doing {
    shimmer_text(
      label,
      style=if truncate {
        ["max-width:100%;min-width:0", ToolCallTruncateStyle]
      } else {
        []
      },
    )
  } else {
    @html.span(
      style=[
        ToolCallLabelStyle,
        if truncate {
          ToolCallTruncateStyle
        } else {
          "word-break:break-word"
        },
      ],
      [@html.text(label)],
    )
  }
}

///|
/// One line of agent progress: a 16px tool icon, a shimmering or settled
/// label, and — when `expandable` — a chevron that flips between right
/// (collapsed) and down (expanded). Expanding reveals `steps` under a
/// thread line. The whole row is the toggle hit area when `on_toggle`
/// is given; omit `icon` for icon-less rows like "Thinking".
///
/// ```moonbit nocheck
/// tool_call_row(icon=icon_image(), label="(0/1) Image generating…")
/// tool_call_row(icon=icon_image(), state=Done, label="(1/1) Image generation completed")
/// tool_call_row(
///   icon=icon_adjust(), label="2 commands executed",
///   expandable=true, expanded=e, on_toggle=set_e.map(v => _ => !v),
///   steps=["List file directories", "Search for related content"],
/// )
/// ```
pub fn tool_call_row(
  label~ : String,
  icon? : @html.Html,
  state? : ToolCallState = Doing,
  expandable? : Bool = false,
  expanded? : Bool = false,
  on_toggle? : @cmd.Cmd,
  steps? : Array[String] = [],
  truncate? : Bool = true,
  aria_label? : String,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs)
    .data_set("slot", "tool-call-row")
    .data_set("state", if state is Doing { "doing" } else { "done" })
  if expandable {
    ignore(
      element_attrs.data_set(
        "expanded",
        if expanded {
          "true"
        } else {
          "false"
        },
      ),
    )
  }
  if aria_label is Some(label_text) {
    ignore(element_attrs.aria_label(label_text))
  }
  let title_children : Array[@html.Html] = []
  if icon is Some(tool_icon) {
    title_children.push(
      @html.span(
        style=[
          "display:flex;align-self:stretch;align-items:flex-start;padding-top:3px;flex:none",
        ],
        attrs=@html.Attrs::build().data_set("slot", "tool-call-icon"),
        [tool_icon],
      ),
    )
  }
  let text_children : Array[@html.Html] = [
    tool_call_label(label, state, truncate),
  ]
  if expandable {
    text_children.push(
      @html.span(style=["display:inline-flex;flex:none"], [
        if expanded {
          @primitives.icon_chevron_down_fill(size=14)
        } else {
          @primitives.icon_chevron_right_fill(size=14)
        },
      ]),
    )
  }
  title_children.push(
    @html.span(
      style=["display:flex;flex:1;min-width:0;align-items:center;gap:4px"],
      text_children,
    ),
  )
  let root_children : Array[@html.Html] = [
    @html.span(
      style=["display:flex;align-items:center;gap:8px;width:100%"],
      attrs=@html.Attrs::build().data_set("slot", "tool-call-row-title"),
      title_children,
    ),
  ]
  if expandable && expanded && steps.length() > 0 {
    let step_children : Array[@html.Html] = [
      @html.span(
        style=[
          "position:absolute;left:12px;top:-2px;bottom:-7px;width:1px;background:var(--sumi-stroke-primary,rgba(255,255,255,0.08))",
        ],
        attrs=@html.Attrs::build()
          .data_set("slot", "tool-call-thread")
          .aria_hidden("true"),
        ([] : Array[@html.Html]),
      ),
    ]
    for step in steps {
      step_children.push(
        @html.p(
          style=[
            "margin:0;font-size:14px;line-height:22px;color:var(--sumi-text-tertiary,rgba(255,255,255,0.6));word-break:break-word",
          ],
          [@html.text(step)],
        ),
      )
    }
    root_children.push(
      @html.span(
        style=[
          "position:relative;display:block;width:100%;padding-left:28px;padding-right:4px",
        ],
        attrs=@html.Attrs::build().data_set("slot", "tool-call-steps"),
        step_children,
      ),
    )
  }
  let base = [
    @internal.SumiBoxSizing,
    @internal.SumiFontSans,
    @internal.SumiTextRendering,
    "display:flex;flex-direction:column;align-items:flex-start;justify-content:center;gap:8px;width:100%;margin:0;padding:0;border:none;background:transparent;text-align:left;color:var(--sumi-text-tertiary,rgba(255,255,255,0.6));appearance:none;-webkit-appearance:none;outline:none",
  ]
  if on_toggle is Some(toggle) {
    @html.button(
      style=@internal.sumi_styles([..base, "cursor:pointer"], style),
      type_="button",
      on_click=toggle,
      id?,
      class?,
      attrs=element_attrs,
      root_children,
    )
  } else {
    @html.div(
      style=@internal.sumi_styles(base, style),
      id?,
      class?,
      attrs=element_attrs,
      root_children,
    )
  }
}
