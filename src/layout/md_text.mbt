///|
/// The block kinds of a markdown answer body, matching the MD 基础组件
/// type scale: `H2` is 16/24 Medium, `H3` and `H4` are 14/22 Medium
/// (headings carry 12px vertical padding), and `Body` is 14/22 Regular.
pub(all) enum MdTextKind {
  H2
  H3
  H4
  Body
} derive(Eq)

///|
pub extend MdTextKind with Eq::{equal, not_equal}

///|
/// One block of a markdown answer: a semantic heading (`H2`–`H4`) or body
/// paragraph in the design's type scale. All kinds read at the primary
/// text tone; headings pad 12px above and below, the body pads none.
///
/// ```moonbit nocheck
/// md_text(kind=H2, text="Story beats")
/// md_text(kind=Body, text="The opening shot drifts over the quiet bay.")
/// ```
pub fn md_text(
  text~ : String,
  kind? : MdTextKind = Body,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs)
    .data_set("slot", "md-text")
    .data_set(
      "kind",
      match kind {
        H2 => "h2"
        H3 => "h3"
        H4 => "h4"
        Body => "body"
      },
    )
  let block_style = match kind {
    H2 =>
      "margin:0;padding:12px 0;font-size:16px;line-height:24px;font-weight:500;color:var(--sumi-text,#ffffff)"
    H3 | H4 =>
      "margin:0;padding:12px 0;font-size:14px;line-height:22px;font-weight:500;color:var(--sumi-text,#ffffff)"
    Body =>
      "margin:0;font-size:14px;line-height:22px;color:var(--sumi-text,#ffffff)"
  }
  let full_style = @internal.sumi_styles(
    [
      @internal.SumiBoxSizing,
      @internal.SumiFontSans,
      @internal.SumiTextRendering,
      block_style,
    ],
    style,
  )
  match kind {
    H2 =>
      @html.h2(style=full_style, id?, class?, attrs=element_attrs, [
        @html.text(text),
      ])
    H3 =>
      @html.h3(style=full_style, id?, class?, attrs=element_attrs, [
        @html.text(text),
      ])
    H4 =>
      @html.h4(style=full_style, id?, class?, attrs=element_attrs, [
        @html.text(text),
      ])
    Body =>
      @html.p(style=full_style, id?, class?, attrs=element_attrs, [
        @html.text(text),
      ])
  }
}
