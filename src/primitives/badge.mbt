///|
const BadgeBaseStyle : String = "display:inline-flex;flex:none;align-items:center;justify-content:center;min-width:16px;height:16px;padding:0 4px;border-radius:9999px;font-size:10px;line-height:18px;font-weight:500;color:#ffffff;background:var(--sumi-brand,#009efa);white-space:nowrap;user-select:none"

///|
const BadgeDotStyle : String = "width:6px;height:6px;min-width:6px;padding:0"

///|
/// A numeric notification badge. Values above `99` render as `99+`; pass
/// `dot=true` for a plain dot.
pub fn badge(
  value? : Int,
  dot? : Bool = false,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs).data_set("slot", "badge")
  let content = if dot {
    ""
  } else {
    let v = value.unwrap_or(0)
    if v > 99 {
      "99+"
    } else {
      v.to_string()
    }
  }
  @html.span(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontNum,
        BadgeBaseStyle,
        if dot {
          BadgeDotStyle
        } else {
          ""
        },
      ],
      style,
    ),
    id?,
    class?,
    attrs=element_attrs,
    content,
  )
}
