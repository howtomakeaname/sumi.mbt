///|
const AgentToolButtonStyle : String = "display:inline-flex;flex:none;align-items:center;justify-content:center;gap:4px;height:32px;margin:0;padding:0 12px 0 10px;border:none;border-radius:8px;background:transparent;font-size:12px;line-height:20px;color:var(--sumi-text,#ffffff);cursor:pointer;user-select:none;white-space:nowrap;appearance:none;-webkit-appearance:none;outline:none"

///|
const AgentToolButtonDisabledStyle : String = "color:rgba(255,255,255,0.2);cursor:not-allowed"

///|
/// The icon-leading pill of the agent input toolbar (e.g. "Use Skill") —
/// a 32px-high ghost button with a 16px icon and a 12/20 label. Square
/// icon-only toolbar atoms are plain `icon_button` instead.
///
/// ```moonbit nocheck
/// agent_tool_button(icon=icon_skill(), label="Use Skill", on_click=pick_skill)
/// ```
pub fn agent_tool_button(
  icon : @html.Html,
  label~ : String,
  disabled? : Bool = false,
  on_click? : @cmd.Cmd,
  id? : String,
  class? : String,
  title? : String,
  aria_label? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs).data_set(
    "slot", "agent-tool-button",
  )
  if aria_label is Some(label_text) {
    ignore(element_attrs.aria_label(label_text))
  }
  @html.button(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        @internal.SumiTransition,
        AgentToolButtonStyle,
        if disabled {
          AgentToolButtonDisabledStyle
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
    title?,
    on_click?,
    attrs=element_attrs,
    [
      @html.span(style=["display:inline-flex;flex:none"], [icon]),
      @html.span([@html.text(label)]),
    ],
  )
}

///|
const AgentInputStyle : String = "display:flex;flex-direction:column;gap:16px;width:100%;padding:14px 16px 16px;border:0.5px solid var(--sumi-agent-dock-border,rgba(204,221,255,0.08));border-radius:24px;background:var(--sumi-agent-dock-bg,rgba(16,16,16,0.7));backdrop-filter:blur(60px);-webkit-backdrop-filter:blur(60px);box-shadow:var(--sumi-agent-dock-shadow,0px 4px 8px 0px rgba(0,0,0,0.03),0px 2px 4px 0px rgba(0,0,0,0.02))"

///|
const AgentTextareaStyle : String = "display:block;width:100%;min-height:86px;max-height:252px;margin:0;padding:0;border:none;background:transparent;resize:none;font-size:14px;line-height:24px;color:var(--sumi-text,#ffffff);outline:none;overflow-y:auto;appearance:none;-webkit-appearance:none"

///|
const AgentContentStyle : String = "display:flex;flex-wrap:wrap;align-items:center;min-height:86px;overflow:clip;font-size:14px;line-height:24px;color:var(--sumi-text,#ffffff)"

///|
const AgentToolbarStyle : String = "display:flex;align-items:center;justify-content:space-between;width:100%"

///|
const AgentActionsStyle : String = "display:flex;align-items:center;gap:4px;min-width:0"

///|
/// The agent chat dock: a frosted 24px-radius container holding an input
/// region and a toolbar row (left action atoms + circular send button).
/// Controlled: the caller owns `value`.
///
/// By default the input region is an auto-clamped textarea (86px min,
/// 252px max, thin scrollbar). Pass `children` instead to compose rich
/// content — inline media tags and text spans share the same baseline
/// flow; the caller then owns the editing surface.
///
/// `generating=true` swaps the send arrow for the stop square and routes
/// the click to `on_stop`; `send_disabled` only gates the send state.
///
/// ```moonbit nocheck
/// agent_input(
///   value=prompt,
///   placeholder="Describe your idea, or type / to use a skill",
///   on_input=emit.map(PromptChanged),
///   on_send=emit(Submit),
///   send_disabled=prompt.is_empty(),
///   actions=[
///     icon_button(icon_plus_fill(size=14), aria_label="Add attachment"),
///     agent_tool_button(icon=icon_skill(), label="Use Skill"),
///     icon_button(icon_at(), aria_label="Mention a reference"),
///   ],
/// )
/// ```
pub fn agent_input(
  value? : String = "",
  placeholder? : String = "",
  rows? : Int = 3,
  on_input? : @internal.Emit[String],
  on_send? : @cmd.Cmd,
  on_stop? : @cmd.Cmd,
  send_disabled? : Bool = false,
  send_loading? : Bool = false,
  generating? : Bool = false,
  disabled? : Bool = false,
  autofocus? : Bool,
  actions? : Array[@html.Html] = [],
  children? : Array[@html.Html],
  aria_label? : String,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs).data_set(
    "slot", "agent-input",
  )
  if generating {
    ignore(element_attrs.data_set("state", "generating"))
  }
  if aria_label is Some(label_text) {
    ignore(element_attrs.aria_label(label_text))
  }
  let region : @html.Html = match children {
    Some(rich) =>
      @html.div(
        style=[AgentContentStyle],
        attrs=@html.Attrs::build().data_set("slot", "agent-input-content"),
        rich,
      )
    None =>
      @html.textarea(
        value~,
        placeholder~,
        rows~,
        on_input?,
        disabled~,
        autofocus?,
        style=[
          @internal.SumiBoxSizing,
          @internal.SumiFontSans,
          @internal.SumiTextRendering,
          AgentTextareaStyle,
        ],
        attrs=@html.Attrs::build().data_set("slot", "agent-input-textarea"),
        "",
      )
  }
  let submit : @html.Html = if generating {
    send_button(stop=true, on_click?=on_stop)
  } else {
    send_button(disabled=send_disabled, loading=send_loading, on_click?=on_send)
  }
  @html.div(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        AgentInputStyle,
      ],
      style,
    ),
    id?,
    class?,
    attrs=element_attrs,
    [
      region,
      @html.div(style=[AgentToolbarStyle], [
        @html.div(
          style=[AgentActionsStyle],
          attrs=@html.Attrs::build().data_set("slot", "agent-input-actions"),
          actions,
        ),
        submit,
      ]),
    ],
  )
}
