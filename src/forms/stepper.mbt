///|
const StepperStyle : String = "display:inline-flex;align-items:center;gap:2px;height:32px;padding:2px;border:1px solid var(--sumi-stroke-secondary,rgba(255,255,255,0.04));border-radius:var(--sumi-radius,8px);background:var(--sumi-block,rgba(255,255,255,0.08))"

///|
const StepperButtonStyle : String = "display:inline-flex;flex:none;align-items:center;justify-content:center;width:28px;height:26px;margin:0;padding:0;border:none;border-radius:6px;background:transparent;color:var(--sumi-text-secondary,rgba(255,255,255,0.7));cursor:pointer;user-select:none;appearance:none;-webkit-appearance:none;outline:none"

///|
const StepperValueStyle : String = "min-width:24px;text-align:center;font-size:13px;line-height:22px;font-weight:500;font-variant-numeric:tabular-nums;color:var(--sumi-text,#ffffff);user-select:none"

///|
fn stepper_button(
  icon : @html.Html,
  enabled : Bool,
  on_click : @cmd.Cmd?,
  aria_label : String,
) -> @html.Html {
  @html.button(
    style=[
      @internal.SumiBoxSizing,
      @internal.SumiTextRendering,
      @internal.SumiTransition,
      StepperButtonStyle,
      @internal.sumi_disabled_style(!enabled),
    ],
    type_="button",
    disabled=!enabled,
    on_click?=if enabled { on_click } else { None },
    attrs=@html.Attrs::build()
      .data_set("slot", "stepper-button")
      .aria_label(aria_label),
    [icon],
  )
}

///|
/// A numeric stepper (e.g. the batch-count picker). Controlled: the caller
/// owns `value`; the buttons clamp to `min`/`max` and disable at the bounds.
pub fn stepper(
  value~ : Int,
  min? : Int = 1,
  max? : Int = 8,
  step? : Int = 1,
  on_change? : @internal.Emit[Int],
  disabled? : Bool = false,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs).data_set("slot", "stepper")
  let can_dec = !disabled && value - step >= min
  let can_inc = !disabled && value + step <= max
  let dec = on_change.map(emit => emit(@cmp.maximum(min, value - step)))
  let inc = on_change.map(emit => emit(@cmp.minimum(max, value + step)))
  @html.div(
    style=@internal.sumi_styles(
      [@internal.SumiBoxSizing, @internal.SumiFontNum, StepperStyle],
      style,
    ),
    id?,
    class?,
    attrs=element_attrs,
    [
      stepper_button(@primitives.icon_minus(size=14), can_dec, dec, "Decrease"),
      @html.span(
        style=[StepperValueStyle],
        attrs=@html.Attrs::build()
          .data_set("slot", "stepper-value")
          .aria_live("polite"),
        value.to_string(),
      ),
      stepper_button(@primitives.icon_plus(size=14), can_inc, inc, "Increase"),
    ],
  )
}
