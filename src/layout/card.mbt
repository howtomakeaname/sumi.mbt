///|
const CardBaseStyle : String = "display:flex;flex-direction:column;min-width:0;border:1px solid var(--sumi-stroke-secondary,rgba(255,255,255,0.04));border-radius:var(--sumi-radius-lg,12px);background:var(--sumi-frame,#202022);overflow:hidden"

///|
/// A surface container for grouping content on the canvas.
pub fn[C : @html.IsChildren] card(
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs).data_set("slot", "card")
  @html.div(
    style=@internal.sumi_styles(
      [@internal.SumiBoxSizing, @internal.SumiFontSans, CardBaseStyle],
      style,
    ),
    id?,
    class?,
    title?,
    attrs=element_attrs,
    [@internal.sumi_slot(children)],
  )
}

///|
const CardHeaderStyle : String = "display:flex;align-items:center;gap:8px;padding:12px 16px;border-bottom:1px solid var(--sumi-stroke-secondary,rgba(255,255,255,0.04));font-size:13px;line-height:22px;font-weight:500;color:var(--sumi-text,#ffffff)"

///|
const CardContentStyle : String = "flex:1 1 auto;padding:16px;min-height:0;font-size:13px;line-height:22px;color:var(--sumi-text,#ffffff)"

///|
/// A card with the design's header/content split.
pub fn[C : @html.IsChildren] card_section(
  header~ : @html.Html,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs).data_set("slot", "card")
  @html.div(
    style=@internal.sumi_styles(
      [@internal.SumiBoxSizing, @internal.SumiFontSans, CardBaseStyle],
      style,
    ),
    id?,
    class?,
    attrs=element_attrs,
    [
      @html.div(
        style=[@internal.SumiBoxSizing, CardHeaderStyle],
        attrs=@html.Attrs::build().data_set("slot", "card-header"),
        [header],
      ),
      @html.div(
        style=[@internal.SumiBoxSizing, CardContentStyle],
        attrs=@html.Attrs::build().data_set("slot", "card-content"),
        [@internal.sumi_slot(children)],
      ),
    ],
  )
}

///|
/// A thin horizontal rule for separating stacked content.
pub fn divider(
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  @html.hr(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        "display:block;width:100%;height:1px;margin:0;padding:0;border:none;background:var(--sumi-stroke-secondary,rgba(255,255,255,0.04))",
      ],
      style,
    ),
    id?,
    class?,
    attrs=@internal.sumi_attrs(attrs).data_set("slot", "divider"),
  )
}
