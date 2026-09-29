///|
/// An indeterminate loading spinner. Rotation comes from the interaction
/// sheet emitted by `theme` and respects `prefers-reduced-motion`.
pub fn spinner(
  size? : Int = 16,
  id? : String,
  class? : String,
  style? : Array[String] = [],
) -> @html.Html {
  let half = size / 2
  let radius = half - 1
  @html.span(
    style=["display:inline-flex;color:inherit"],
    attrs=@html.Attrs::build().role("status").aria_label("Loading"),
    @svg.svg(
      width=size,
      height=size,
      view_box="0 0 \{size} \{size}",
      style=@internal.sumi_styles(["display:block"], style),
      id?,
      class?,
      attrs=@svg.Attrs::build().data_set("slot", "spinner"),
      [
        @svg.circle(
          cx=half,
          cy=half,
          r=radius,
          fill="none",
          stroke="currentColor",
          stroke_width=2,
          attrs=@svg.Attrs::build().stroke_opacity("0.25"),
        ),
        @svg.circle(
          cx=half,
          cy=half,
          r=radius,
          fill="none",
          stroke="currentColor",
          stroke_width=2,
          attrs=@svg.Attrs::build()
            .stroke_dasharray("\{radius * 2 * 314 / 1000}")
            .stroke_linecap("round"),
        ),
      ],
    ),
  )
}
