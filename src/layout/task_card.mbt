///|
const TaskCardStyle : String = "display:flex;flex-direction:column;gap:4px;width:100%;max-width:640px;padding:12px 16px;border-radius:16px;background:var(--sumi-frame-80,rgba(32,32,34,0.8));backdrop-filter:blur(40px);-webkit-backdrop-filter:blur(40px)"

///|
const TaskCardTitleStyle : String = "margin:0;min-width:0;font-size:14px;line-height:24px;font-weight:500;color:var(--sumi-text,#ffffff);overflow:hidden;text-overflow:ellipsis;white-space:nowrap"

///|
const TaskCardSummaryStyle : String = "margin:0;font-size:14px;line-height:24px;color:var(--sumi-text-secondary,rgba(255,255,255,0.7));overflow:hidden;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical"

///|
/// A submitted-task bubble of the task list: a frosted 16px-radius card
/// with a 14/24 Medium title, an optional generation status, and a
/// two-line summary. Pass `children` instead of `summary` for a rich body
/// (e.g. a `tool_call_row`).
///
/// ```moonbit nocheck
/// task_card(
///   title="API Migration Draft",
///   status=Generating,
///   summary="I will first break down the brief into its core elements.",
/// )
/// ```
pub fn task_card(
  title~ : String,
  status? : SessionStatus,
  summary? : String = "",
  children? : Array[@html.Html],
  on_click? : @cmd.Cmd,
  aria_label? : String,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs).data_set("slot", "task-card")
  if aria_label is Some(label_text) {
    ignore(element_attrs.aria_label(label_text))
  }
  let status_view : @html.Html = match status {
    Some(kind) => session_status(kind~)
    None => @html.nothing
  }
  let body : @html.Html = match children {
    Some(rich) =>
      @html.div(
        style=["width:100%;min-width:0"],
        attrs=@html.Attrs::build().data_set("slot", "task-card-body"),
        rich,
      )
    None => @html.p(style=[TaskCardSummaryStyle], [@html.text(summary)])
  }
  @html.div(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        TaskCardStyle,
        if on_click is Some(_) {
          "cursor:pointer"
        } else {
          ""
        },
      ],
      style,
    ),
    id?,
    class?,
    on_click?,
    attrs=element_attrs,
    [
      @html.div(style=["display:flex;align-items:center;gap:4px;width:100%"], [
        @html.p(style=[TaskCardTitleStyle], [@html.text(title)]),
        status_view,
      ]),
      body,
    ],
  )
}

///|
/// The scrollable task-card feed ("bubble list"): 8px padding and gaps, a
/// bottom fade mask (`fade` px, default 44), and the blue-tinted thin
/// scrollbar. Children are usually `task_card` bubbles.
///
/// ```moonbit nocheck
/// task_list(height=400, children=cards)
/// ```
pub fn task_list(
  children~ : Array[@html.Html],
  height? : Int = 400,
  fade? : Int = 44,
  aria_label? : String,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs).data_set("slot", "task-list")
  if aria_label is Some(label_text) {
    ignore(element_attrs.aria_label(label_text))
  }
  @html.div(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        "display:flex;flex-direction:column;gap:8px;width:100%;height:\{height}px;padding:8px;overflow-x:clip;overflow-y:auto;--sumi-scrollbar:rgba(204,221,255,0.12)",
        if fade > 0 {
          "-webkit-mask-image:linear-gradient(to bottom,#000 0px,#000 calc(100% - \{fade}px),transparent 100%);mask-image:linear-gradient(to bottom,#000 0px,#000 calc(100% - \{fade}px),transparent 100%)"
        } else {
          ""
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
