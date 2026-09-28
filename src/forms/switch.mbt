///|
const SwitchBaseStyle : String = "position:relative;display:inline-flex;flex:none;align-items:center;width:24px;height:16px;margin:0;padding:2px;border:none;border-radius:9999px;cursor:pointer;user-select:none;appearance:none;-webkit-appearance:none;outline:none;transition:background-color 100ms cubic-bezier(0.4,0,0.2,1)"

///|
const SwitchOnStyle : String = "background:var(--sumi-brand,#009efa)"

///|
const SwitchOffStyle : String = "background:var(--sumi-block,rgba(255,255,255,0.08))"

///|
const SwitchThumbStyle : String = "display:block;width:12px;height:12px;border-radius:9999px;background:var(--sumi-switch-thumb,#ffffff);box-shadow:var(--sumi-switch-thumb-shadow,0 0 0 0 rgba(0,0,0,0));transition:transform 100ms cubic-bezier(0.4,0,0.2,1)"

///|
/// A toggle switch. Controlled: the caller owns `checked`.
pub fn switch(
  checked~ : Bool,
  on_change? : @internal.Emit[Bool],
  disabled? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs)
    .data_set("slot", "switch")
    .data_set("state", if checked { "on" } else { "off" })
    .role("switch")
    .aria_checked(@internal.sumi_bool(checked))
  @html.button(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        SwitchBaseStyle,
        if checked {
          SwitchOnStyle
        } else {
          SwitchOffStyle
        },
        @internal.sumi_disabled_style(disabled),
      ],
      style,
    ),
    type_="button",
    disabled~,
    id?,
    class?,
    title?,
    on_click?=on_change.map(emit => emit(!checked)),
    attrs=element_attrs,
    [
      @html.span(
        style=[
          SwitchThumbStyle,
          if checked {
            "transform:translateX(8px)"
          } else {
            "transform:translateX(0)"
          },
        ],
        attrs=@html.Attrs::build()
          .data_set("slot", "switch-thumb")
          .aria_hidden("true"),
        "",
      ),
    ],
  )
}
