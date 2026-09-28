///|
/// A round avatar. Shows the image at `src` when given, otherwise the
/// first character of `fallback` on a spotlight fill.
pub fn avatar(
  src? : String,
  fallback? : String = "",
  size? : Int = 32,
  alt? : String = "",
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let px = size.to_string() + "px"
  let element_attrs = @internal.sumi_attrs(attrs).data_set("slot", "avatar")
  let content : @html.Html = match src {
    Some(url) =>
      @html.img(src=url, alt~, style=[
        "display:block;width:100%;height:100%;object-fit:cover;border-radius:9999px",
      ])
    None =>
      @html.span(
        style=[
          @internal.SumiFontSans,
          "font-size:\{size * 2 / 5}px;font-weight:500;color:var(--sumi-text-secondary,rgba(255,255,255,0.7))",
        ],
        if fallback.is_empty() {
          ""
        } else {
          fallback[:1].to_owned().to_upper()
        },
      )
  }
  @html.span(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        "display:inline-flex;flex:none;align-items:center;justify-content:center;width:\{px};height:\{px};overflow:hidden;border-radius:9999px;background:var(--sumi-spotlight,#292929)",
      ],
      style,
    ),
    id?,
    class?,
    attrs=element_attrs,
    [content],
  )
}
