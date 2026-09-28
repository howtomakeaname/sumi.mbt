///|
const CheckboxBoxBaseStyle : String = "display:inline-flex;flex:none;align-items:center;justify-content:center;width:16px;height:16px;margin:0;padding:0;border-radius:4px;cursor:pointer;user-select:none;appearance:none;-webkit-appearance:none;outline:none"

///|
const CheckboxOnStyle : String = "border:1px solid var(--sumi-brand,#009efa);background:var(--sumi-brand,#009efa);color:#ffffff"

///|
const CheckboxOffStyle : String = "border:1px solid var(--sumi-stroke,rgba(204,221,255,0.1));background:var(--sumi-block,rgba(255,255,255,0.08));color:transparent"

///|
const CheckboxLabelStyle : String = "font-size:13px;line-height:22px;color:var(--sumi-text,#ffffff);cursor:pointer;user-select:none"

///|
/// A checkbox with an optional text label. Controlled: the caller owns
/// `checked`. `indeterminate=true` renders the mixed dash state and reports
/// `aria-checked="mixed"`; clicking it resolves to checked.
pub fn checkbox(
  checked~ : Bool,
  label? : String,
  indeterminate? : Bool = false,
  on_change? : @internal.Emit[Bool],
  disabled? : Bool = false,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let on = checked || indeterminate
  let toggle : @cmd.Cmd? = on_change.map(emit => {
    emit(if indeterminate { true } else { !checked })
  })
  let state = if indeterminate {
    "mixed"
  } else if checked {
    "on"
  } else {
    "off"
  }
  let box = @html.button(
    style=[
      @internal.SumiBoxSizing,
      @internal.SumiTextRendering,
      @internal.SumiTransition,
      CheckboxBoxBaseStyle,
      if on {
        CheckboxOnStyle
      } else {
        CheckboxOffStyle
      },
      @internal.sumi_disabled_style(disabled),
    ],
    type_="button",
    disabled~,
    on_click?=toggle,
    attrs=@html.Attrs::build()
      .data_set("slot", "checkbox")
      .data_set("state", state)
      .role("checkbox")
      .aria_checked(
        if indeterminate {
          "mixed"
        } else {
          @internal.sumi_bool(checked)
        },
      ),
    [
      if indeterminate {
        @primitives.icon_minus(size=12)
      } else {
        @primitives.icon_check(size=12)
      },
    ],
  )
  match label {
    Some(text) => {
      let element_attrs = @internal.sumi_attrs(attrs).data_set(
        "slot", "checkbox-root",
      )
      let label_attrs = @html.Attrs::build().data_set("slot", "checkbox-label")
      if !disabled && toggle is Some(cmd) {
        ignore(label_attrs.on_click(_ => cmd))
      }
      @html.div(
        style=@internal.sumi_styles(
          [
            @internal.SumiBoxSizing,
            @internal.SumiFontSans,
            @internal.SumiTextRendering,
            "display:inline-flex;align-items:center;gap:8px",
          ],
          style,
        ),
        id?,
        class?,
        attrs=element_attrs,
        [
          box,
          @html.span(
            style=[
              CheckboxLabelStyle,
              if disabled {
                "color:var(--sumi-text-disabled,rgba(255,255,255,0.2))"
              } else {
                ""
              },
            ],
            attrs=label_attrs,
            text,
          ),
        ],
      )
    }
    None => @html.fragment([box])
  }
}
