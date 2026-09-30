///|
/// An indeterminate loading spinner: a single arc that sweeps the ring while
/// growing and shrinking, per the design's loading asset. Ring geometry is
/// radius `size/3` with a `size*5/48` stroke; the arc motion comes from the
/// interaction sheet emitted by `theme` and respects `prefers-reduced-motion`.
pub fn spinner(
  size? : Int = 16,
  id? : String,
  class? : String,
  style? : Array[String] = [],
) -> @html.Html {
  let half = size / 2
  // The circle's path is normalized to 360 units (`pathLength`) so the
  // stylesheet can sweep the arc in degrees. The dash/offset attributes below
  // are the 0% keyframe: they keep a resting arc visible when animations are
  // disabled (reduced motion), while `sumi-spin` overrides them during play.
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
          r=size / 3,
          fill="none",
          stroke="currentColor",
          stroke_width=(size * 5 + 24) / 48,
          attrs=@svg.Attrs::build()
            .path_length("360")
            .stroke_dasharray("54 666")
            .stroke_dashoffset("474")
            .stroke_linecap("round"),
        ),
      ],
    ),
  )
}
