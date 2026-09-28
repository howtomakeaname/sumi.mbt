///|
const InputBaseStyle : String = "display:block;width:100%;height:32px;margin:0;padding:4px 12px;border:1px solid var(--sumi-stroke,rgba(204,221,255,0.1));border-radius:var(--sumi-radius,8px);background:var(--sumi-block,rgba(255,255,255,0.08));font-size:13px;line-height:22px;color:var(--sumi-text,#ffffff);outline:none;appearance:none;-webkit-appearance:none"

///|
const InputErrorStyle : String = "border-color:var(--sumi-error,#ff3355)"

///|
const InputAdornmentStyle : String = "position:absolute;top:50%;transform:translateY(-50%);display:inline-flex;align-items:center;justify-content:center;color:var(--sumi-text-placeholder,rgba(255,255,255,0.35));pointer-events:none"

///|
/// A single-line text field. Controlled: the caller owns the value.
///
/// `prefix`/`suffix` slot icons or text inside the field; `clearable=true`
/// shows a small ✕ while the value is non-empty (clears through `on_input`
/// or the explicit `on_clear`). `error`/`error_text` render the design's
/// error border and an optional hint line below the field.
pub fn input(
  value~ : String,
  placeholder? : String = "",
  input_type? : @html.InputType = Text,
  on_input? : @internal.Emit[String],
  on_change? : @internal.Emit[String],
  on_clear? : @cmd.Cmd,
  clearable? : Bool = false,
  prefix? : @html.Html,
  suffix? : @html.Html,
  error? : Bool = false,
  error_text? : String,
  disabled? : Bool = false,
  read_only? : Bool = false,
  name? : String,
  maxlength? : Int,
  autofocus? : Bool,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs).data_set("slot", "input")
  if disabled {
    ignore(element_attrs.disabled(true))
  }
  if error {
    ignore(element_attrs.aria_invalid("true"))
  }
  let has_prefix = prefix is Some(_)
  let trailing_count = (if suffix is Some(_) { 1 } else { 0 }) +
    (if clearable && !value.is_empty() { 1 } else { 0 })
  let padding = (if has_prefix { "padding-left:32px;" } else { "" }) +
    (match trailing_count {
      0 => ""
      1 => "padding-right:32px;"
      _ => "padding-right:52px;"
    })
  let field = @html.input(
    input_type~,
    value~,
    placeholder~,
    on_input?,
    on_change?,
    read_only~,
    name?,
    maxlength?,
    autofocus?,
    id?,
    class?,
    title?,
    style=[
      @internal.SumiBoxSizing,
      @internal.SumiFontSans,
      @internal.SumiTextRendering,
      @internal.SumiTransition,
      InputBaseStyle,
      padding,
      if error {
        InputErrorStyle
      } else {
        ""
      },
      if disabled {
        @internal.SumiDisabled +
        ";color:var(--sumi-text-disabled,rgba(255,255,255,0.2))"
      } else {
        ""
      },
    ],
    attrs=element_attrs,
  )
  let prefix_view : @html.Html = match prefix {
    Some(content) =>
      @html.span(
        style=[InputAdornmentStyle, "left:10px"],
        attrs=@html.Attrs::build().data_set("slot", "input-prefix"),
        [content],
      )
    None => @html.nothing
  }
  let suffix_view : @html.Html = match suffix {
    Some(content) =>
      @html.span(
        style=[InputAdornmentStyle, "right:10px"],
        attrs=@html.Attrs::build().data_set("slot", "input-suffix"),
        [content],
      )
    None => @html.nothing
  }
  let clear_view : @html.Html = if clearable && !value.is_empty() && !disabled {
    let clear_cmd : @cmd.Cmd? = match on_clear {
      Some(cmd) => Some(cmd)
      None => on_input.map(emit => emit(""))
    }
    @html.button(
      style=[
        @internal.SumiBoxSizing,
        @internal.SumiTransition,
        "position:absolute;top:50%;transform:translateY(-50%);display:inline-flex;align-items:center;justify-content:center;width:20px;height:20px;margin:0;padding:0;border:none;background:transparent;color:var(--sumi-text-placeholder,rgba(255,255,255,0.35));cursor:pointer;appearance:none;-webkit-appearance:none;outline:none",
        if suffix is Some(_) {
          "right:32px"
        } else {
          "right:8px"
        },
      ],
      type_="button",
      on_click?=clear_cmd,
      attrs=@html.Attrs::build()
        .data_set("slot", "input-clear")
        .aria_label("Clear"),
      [@primitives.icon_x(size=12)],
    )
  } else {
    @html.nothing
  }
  let error_view : @html.Html = match error_text {
    Some(text) if error =>
      @html.div(
        style=[
          @internal.SumiFontSans,
          "margin-top:6px;font-size:12px;line-height:20px;color:var(--sumi-error,#ff3355)",
        ],
        attrs=@html.Attrs::build().data_set("slot", "input-error"),
        text,
      )
    _ => @html.nothing
  }
  @html.div(
    style=@internal.sumi_styles(
      [@internal.SumiBoxSizing, "position:relative;display:block;width:100%"],
      style,
    ),
    attrs=@html.Attrs::build().data_set("slot", "input-root"),
    [
      @html.div(
        style=["position:relative;display:flex;align-items:center;width:100%"],
        [field, prefix_view, suffix_view, clear_view],
      ),
      error_view,
    ],
  )
}
