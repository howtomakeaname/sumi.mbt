///|
const ToolbarStyle : String = "display:inline-flex;align-items:center;gap:2px;padding:4px;border-radius:var(--sumi-radius-lg,12px);background:var(--sumi-frame,#202022);box-shadow:var(--sumi-shadow-float,0px 2px 6px 0px rgba(0,0,0,0.02),0px 4px 12px 0px rgba(0,0,0,0.06))"

///|
const ToolbarDividerStyle : String = "display:block;flex:none;width:1px;height:12px;margin:0 2px;background:var(--sumi-stroke,rgba(204,221,255,0.1))"

///|
/// A floating horizontal bar that groups controls — the design's signature
/// pill-shaped toolbar. Compose with `button(variant=Ghost)`, `segmented`,
/// `dropdown_menu` and `toolbar_divider`.
pub fn[C : @html.IsChildren] toolbar(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs)
    .data_set("slot", "toolbar")
    .role("toolbar")
  @html.div(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        ToolbarStyle,
      ],
      style,
    ),
    id?,
    class?,
    title?,
    attrs=element_attrs,
    children,
  )
}

///|
/// The thin vertical separator used between control groups inside a toolbar.
pub fn toolbar_divider(style? : Array[String] = []) -> @html.Html {
  @html.span(
    style=@internal.sumi_styles(
      [@internal.SumiBoxSizing, ToolbarDividerStyle],
      style,
    ),
    attrs=@html.Attrs::build()
      .data_set("slot", "toolbar-divider")
      .aria_hidden("true"),
    "",
  )
}
