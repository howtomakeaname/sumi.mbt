///|
/// A shimmering placeholder block for loading layouts. The shimmer runs in
/// the interaction sheet and pauses under `prefers-reduced-motion`.
pub fn skeleton(
  width? : String = "100%",
  height? : String = "14px",
  radius? : String = "4px",
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs)
    .data_set("slot", "skeleton")
    .aria_hidden("true")
  @html.span(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        "display:block;width:\{width};height:\{height};border-radius:\{radius}",
      ],
      style,
    ),
    id?,
    class?,
    attrs=element_attrs,
    "",
  )
}

///|
/// The card-shaped skeleton used for image/video tiles on a canvas.
pub fn skeleton_tile(
  width? : String = "200px",
  height? : String = "200px",
  style? : Array[String] = [],
) -> @html.Html {
  skeleton(width~, height~, radius="var(--sumi-radius-lg,12px)", style~)
}

///|
/// Two lines of text-shaped skeletons with the design's line metrics.
pub fn skeleton_lines(
  count? : Int = 2,
  style? : Array[String] = [],
) -> @html.Html {
  let lines : Array[@html.Html] = []
  for i in 0..<count {
    let width = if i == count - 1 { "60%" } else { "100%" }
    lines.push(skeleton(width~, style=["margin-bottom:6px"]))
  }
  @html.div(
    style=@internal.sumi_styles(
      [@internal.SumiBoxSizing, "display:flex;flex-direction:column"],
      style,
    ),
    attrs=@html.Attrs::build().data_set("slot", "skeleton-lines"),
    lines,
  )
}
