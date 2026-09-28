///|
const KbdStyle : String = "display:inline-flex;align-items:center;justify-content:center;min-width:20px;height:20px;padding:0 5px;margin:0;border:1px solid var(--sumi-stroke,rgba(204,221,255,0.1));border-bottom-width:2px;border-radius:4px;background:var(--sumi-block,rgba(255,255,255,0.08));font-size:11px;line-height:18px;font-weight:500;color:var(--sumi-text-tertiary,rgba(255,255,255,0.6));white-space:nowrap;user-select:none"

///|
/// A keyboard key hint, e.g. for shortcut labels in menus and tooltips.
pub fn kbd(
  key : String,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  @html.kbd(
    style=@internal.sumi_styles(
      [@internal.SumiBoxSizing, @internal.SumiFontNum, KbdStyle],
      style,
    ),
    id?,
    class?,
    attrs=@internal.sumi_attrs(attrs).data_set("slot", "kbd"),
    key,
  )
}
