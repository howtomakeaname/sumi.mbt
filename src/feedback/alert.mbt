///|
pub(all) enum AlertVariant {
  Solid
  Subtle
}

///|
const AlertStyle : String = "display:flex;align-items:flex-start;gap:6px;padding:8px 12px;border-radius:var(--sumi-radius,8px);width:100%"

///|
const AlertSolidStyle : String = "background:var(--sumi-tooltip-bg,#333333)"

///|
const AlertSubtleStyle : String = "background:var(--sumi-block-secondary,rgba(255,255,255,0.04))"

///|
const AlertIconStyle : String = "display:inline-flex;align-items:center;height:20px;flex:none;color:var(--sumi-text-placeholder,rgba(255,255,255,0.35))"

///|
const AlertTextStyle : String = "flex:1 1 0;min-width:0;font-size:12px;line-height:20px;word-break:break-word;color:var(--sumi-text-placeholder,rgba(255,255,255,0.35))"

///|
/// An inline note for validation and status messages inside a panel or a
/// node — an icon followed by wrapping copy. `Solid` sits over media backdrops,
/// `Subtle` on an already-filled surface. The default icon is
/// `icon_important`; pass `icon=` to replace it.
pub fn alert(
  message~ : String,
  variant? : AlertVariant = Solid,
  icon? : @html.Html,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs).data_set("slot", "alert")
  let variant_style = match variant {
    Solid => AlertSolidStyle
    Subtle => AlertSubtleStyle
  }
  let icon_view = match icon {
    Some(icon) => icon
    None => @primitives.icon_important(size=16)
  }
  @html.div(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        AlertStyle,
        variant_style,
      ],
      style,
    ),
    id?,
    class?,
    attrs=element_attrs,
    [
      @html.span(
        style=[@internal.SumiBoxSizing, AlertIconStyle],
        attrs=@html.Attrs::build()
          .aria_hidden("true")
          .data_set("slot", "alert-icon"),
        [icon_view],
      ),
      @html.p(
        style=[@internal.SumiFontSans, AlertTextStyle],
        attrs=@html.Attrs::build().data_set("slot", "alert-message"),
        message,
      ),
    ],
  )
}
