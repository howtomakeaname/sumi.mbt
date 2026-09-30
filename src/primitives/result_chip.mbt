///|
/// The two label treatments of a `result_chip`.
///
/// - `Small` — 13/19.5 tertiary label over a 6px backdrop blur; floats on
///   generated imagery
/// - `Medium` — 14/24 secondary label; sits in a chat result row
pub(all) enum ResultChipSize {
  Small
  Medium
} derive(Eq)

///|
pub extend ResultChipSize with Eq::{equal, not_equal}

///|
const ResultChipStyle : String = "display:inline-flex;align-items:center;gap:4px;height:24px;padding:4px 8px 4px 4px;border-radius:8px;background:var(--sumi-block,rgba(255,255,255,0.08))"

///|
fn result_chip_label_style(size : ResultChipSize) -> String {
  match size {
    Small =>
      "font-size:13px;line-height:19.5px;color:var(--sumi-text-tertiary,rgba(255,255,255,0.6))"
    Medium =>
      "font-size:14px;line-height:24px;color:var(--sumi-text-secondary,rgba(255,255,255,0.7))"
  }
}

///|
/// A 24px rich-text reference tag of generation results: a rounded block
/// fill holding a 16px rounded thumbnail and a short label. `Small` blurs
/// the backdrop (6px) for floating over imagery; `Medium` drops the blur
/// and steps the label up to 14/24 secondary for inline chat rows.
///
/// ```moonbit nocheck
/// result_chip(label="Cover Draft", thumbnail=ref_url)
/// result_chip(label="Image", thumbnail=ref_url, size=Medium)
/// ```
pub fn result_chip(
  label~ : String,
  thumbnail? : String,
  size? : ResultChipSize = Small,
  aria_label? : String,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs)
    .data_set("slot", "result-chip")
    .data_set(
      "size",
      match size {
        Small => "small"
        Medium => "medium"
      },
    )
  if aria_label is Some(label_text) {
    ignore(element_attrs.aria_label(label_text))
  }
  let children : Array[@html.Html] = []
  if thumbnail is Some(src) {
    children.push(
      @html.span(
        style=[
          "position:relative;display:inline-block;width:16px;height:16px;flex:none;border-radius:4px;overflow:hidden",
        ],
        attrs=@html.Attrs::build().aria_hidden("true"),
        [
          @html.img(src~, alt="", style=[
            "position:absolute;inset:0;width:100%;height:100%;object-fit:cover;pointer-events:none",
          ]),
        ],
      ),
    )
  }
  children.push(
    @html.span(style=[result_chip_label_style(size)], [@html.text(label)]),
  )
  @html.span(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        ResultChipStyle,
        match size {
          Small => "backdrop-filter:blur(6px);-webkit-backdrop-filter:blur(6px)"
          Medium => ""
        },
      ],
      style,
    ),
    id?,
    class?,
    attrs=element_attrs,
    children,
  )
}
