///|
const PromptBoxStyle : String = "display:flex;flex-direction:column;gap:8px;padding:12px;border:1px solid transparent;border-radius:var(--sumi-radius-xl,16px);background:var(--sumi-input-bg,rgba(34,34,34,0.72));backdrop-filter:blur(60px);-webkit-backdrop-filter:blur(60px);box-shadow:var(--sumi-shadow-float,0px 2px 6px 0px rgba(0,0,0,0.02),0px 4px 12px 0px rgba(0,0,0,0.06))"

///|
const PromptTextareaStyle : String = "display:block;width:100%;margin:0;padding:0;border:none;background:transparent;resize:none;font-size:14px;line-height:22px;color:var(--sumi-text,#ffffff);outline:none;appearance:none;-webkit-appearance:none"

///|
const PromptFooterStyle : String = "display:flex;align-items:center;justify-content:flex-end;gap:8px;width:100%"

///|
const SendButtonBaseStyle : String = "display:inline-flex;flex:none;align-items:center;justify-content:center;width:32px;height:32px;margin:0;padding:0;border:none;border-radius:9999px;cursor:pointer;user-select:none;appearance:none;-webkit-appearance:none;outline:none"

///|
const SendButtonEnabledStyle : String = "background:var(--sumi-primary-bg,#fafafa);color:var(--sumi-primary-fg,#1a1a1a)"

///|
const SendButtonDisabledStyle : String = "background:var(--sumi-primary-bg-disabled,rgba(204,221,255,0.16));color:var(--sumi-primary-fg-disabled,rgba(224,245,255,0.2))"

///|
/// The circular submit button used by `prompt_box` and `agent_input`.
/// Disabled state uses the design's exact muted fill rather than opacity.
/// `loading=true` keeps the muted fill, swaps the glyph for a 20px spinner
/// in the disabled tone, and blocks clicks while a submission is in
/// flight. `stop=true` swaps the arrow for the stop square — the affordance
/// for halting an in-flight generation; pair it with an enabled click.
pub fn send_button(
  disabled? : Bool = false,
  loading? : Bool = false,
  stop? : Bool = false,
  on_click? : @cmd.Cmd,
  id? : String,
  class? : String,
  title? : String,
  aria_label? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let inactive = disabled || loading
  let element_attrs = @internal.sumi_attrs(attrs)
    .data_set("slot", "send-button")
    .aria_label(aria_label.unwrap_or(if stop { "Stop" } else { "Send" }))
  if stop {
    ignore(element_attrs.data_set("mode", "stop"))
  }
  if loading {
    ignore(element_attrs.aria_busy("true"))
  }
  let content : @html.Html = if loading {
    @primitives.spinner(size=20)
  } else if stop {
    @primitives.icon_stop_fill(size=16)
  } else {
    @primitives.icon_arrow_up_fill(size=16)
  }
  @html.button(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiTextRendering,
        @internal.SumiTransition,
        SendButtonBaseStyle,
        if inactive {
          SendButtonDisabledStyle
        } else {
          SendButtonEnabledStyle
        },
        @internal.sumi_disabled_style(inactive),
      ],
      style,
    ),
    type_="button",
    disabled=inactive,
    id?,
    class?,
    title?,
    on_click?,
    attrs=element_attrs,
    [content],
  )
}

///|
const PromptCountStyle : String = "flex:none;font-size:12px;line-height:20px;font-weight:500;font-variant-numeric:tabular-nums;color:var(--sumi-text-placeholder,rgba(255,255,255,0.35))"

///|
const PromptCountOverStyle : String = "color:var(--sumi-error,#ff3355)"

///|
/// The composite prompt input: a frosted, rounded container holding an
/// auto-sized textarea and a footer row (action slot + circular send
/// button). Controlled: the caller owns `value`.
///
/// `show_count=true` renders a `n / max` counter next to the send button;
/// it turns error-red once the value exceeds `maxlength`. The textarea
/// carries the library's thin-scrollbar styling.
///
/// ```moonbit nocheck
/// prompt_box(
///   value=prompt,
///   placeholder="Describe what to create",
///   on_input=emit.map(PromptChanged),
///   on_send=emit(Submit),
///   send_disabled=prompt.is_empty(),
///   maxlength=800,
///   show_count=true,
/// )
/// ```
pub fn prompt_box(
  value~ : String,
  placeholder? : String = "",
  rows? : Int = 1,
  on_input? : @internal.Emit[String],
  on_send? : @cmd.Cmd,
  send_disabled? : Bool = false,
  send_loading? : Bool = false,
  disabled? : Bool = false,
  maxlength? : Int,
  show_count? : Bool = false,
  autofocus? : Bool,
  actions? : @html.Html,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs).data_set("slot", "prompt-box")
  let textarea = @html.textarea(
    value~,
    placeholder~,
    rows~,
    on_input?,
    disabled~,
    maxlength?,
    autofocus?,
    style=[
      @internal.SumiBoxSizing,
      @internal.SumiFontSans,
      @internal.SumiTextRendering,
      PromptTextareaStyle,
    ],
    attrs=@html.Attrs::build().data_set("slot", "prompt-textarea"),
    "",
  )
  let counter : @html.Html = if show_count {
    let limit = maxlength.unwrap_or(0)
    let over = limit > 0 && value.length() > limit
    @html.span(
      style=[
        @internal.SumiFontNum,
        PromptCountStyle,
        if over {
          PromptCountOverStyle
        } else {
          ""
        },
      ],
      attrs=@html.Attrs::build()
        .data_set("slot", "prompt-count")
        .aria_hidden("true"),
      "\{value.length()}/\{limit}",
    )
  } else {
    @html.nothing
  }
  let footer_left : @html.Html = match actions {
    Some(actions) =>
      @html.div(
        style=["display:flex;align-items:center;gap:4px;margin-right:auto"],
        attrs=@html.Attrs::build().data_set("slot", "prompt-actions"),
        [actions],
      )
    None => @html.nothing
  }
  @html.div(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        PromptBoxStyle,
      ],
      style,
    ),
    id?,
    class?,
    attrs=element_attrs,
    [
      textarea,
      @html.div(style=[@internal.SumiBoxSizing, PromptFooterStyle], [
        footer_left,
        counter,
        send_button(
          disabled=send_disabled,
          loading=send_loading,
          on_click?=on_send,
        ),
      ]),
    ],
  )
}
