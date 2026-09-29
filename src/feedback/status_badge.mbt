///|
/// The four looks of an async job's status badge. `Running` carries a
/// progress percentage (clamped to 0–100); `Count` carries a queue depth
/// (displayed capped at 99, matching the design's two-digit circle).
pub(all) enum StatusBadgeState {
  Running(Int)
  Count(Int)
  Complete
  Warning
}

///|
const StatusBadgeBaseStyle : String = "position:relative;width:20px;height:20px;flex:none"

///|
const StatusBadgeRunningStyle : String = "border-radius:16px;background:var(--sumi-block,rgba(255,255,255,0.08));backdrop-filter:blur(20px);-webkit-backdrop-filter:blur(20px)"

///|
const StatusBadgeCountStyle : String = "border-radius:10px;background:#ffffff;border:2px solid var(--sumi-spotlight,#292929);display:flex;align-items:center;justify-content:center"

///|
const StatusBadgeDiscStyle : String = "border-radius:10px;background:var(--sumi-spotlight,#292929);border:2px solid var(--sumi-spotlight,#292929)"

///|
fn status_badge_clamp(v : Int, lo : Int, hi : Int) -> Int {
  if v < lo {
    lo
  } else if v > hi {
    hi
  } else {
    v
  }
}

///|
/// Arc length of the progress ring for `pct` — the ring circle has r=15 on
/// the 50-unit grid, so a full turn is 2π·15 ≈ 94.2478.
fn status_badge_dash(pct : Int) -> Double {
  status_badge_clamp(pct, 0, 100).to_double() * 0.942478
}

///|
/// Queue depth as shown in the white circle: the design's circle fits two
/// digits, so anything past 99 renders as "99".
fn status_badge_count_label(n : Int) -> String {
  status_badge_clamp(n, 0, 99).to_string()
}

///|
/// The determinate progress ring: dim track plus a lighter arc that grows
/// clockwise from the top (the -90° rotation). Geometry sits on a 50-unit
/// grid so every SVG value stays integral; the box scales it to 16.667px.
fn status_badge_ring(pct : Int) -> @html.Html {
  let track = @svg.circle(
    cx=25,
    cy=25,
    r=15,
    fill="none",
    stroke="rgba(204,221,255,0.08)",
    stroke_width=6,
  )
  let arc_attrs = @svg.Attrs::build()
    .stroke_dasharray("\{status_badge_dash(pct)} 94.2478")
    .stroke_linecap("round")
  let arc = @svg.circle(
    cx=25,
    cy=25,
    r=15,
    fill="none",
    stroke="rgba(224,245,255,0.35)",
    stroke_width=6,
    transform="rotate(-90 25 25)",
    attrs=arc_attrs,
  )
  let children : Array[@svg.Svg] = if pct <= 0 { [track] } else { [track, arc] }
  @html.span(
    style=[
      @internal.SumiBoxSizing,
      "position:absolute;left:1.667px;top:1.667px;width:16.667px;height:16.667px;pointer-events:none",
    ],
    attrs=@html.Attrs::build().aria_hidden("true"),
    @svg.svg(
      view_box="0 0 50 50",
      style=["display:block;width:100%;height:100%"],
      children,
    ),
  )
}

///|
/// A 20px badge reporting an async job's state, per the design: a frosted
/// determinate ring while running, a white circle with the queue depth, a
/// blue tick disc on completion, an amber info disc for partial failure.
/// Rendered on dark imagery, so the palette is pinned to the dark values.
///
/// ```moonbit nocheck
/// status_badge(state=Running(45))
/// status_badge(state=Count(3))
/// status_badge(state=Complete)
/// status_badge(state=Warning)
/// ```
pub fn status_badge(
  state~ : StatusBadgeState,
  aria_label? : String,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let (state_name, variant_style, default_label) = match state {
    Running(pct) =>
      (
        "running",
        StatusBadgeRunningStyle,
        "In progress, \{status_badge_clamp(pct, 0, 100)}%",
      )
    Count(n) => ("count", StatusBadgeCountStyle, "\{n} tasks")
    Complete => ("complete", StatusBadgeDiscStyle, "Complete")
    Warning => ("warning", StatusBadgeDiscStyle, "Partially failed")
  }
  let element_attrs = @internal.sumi_attrs(attrs)
    .data_set("slot", "status-badge")
    .data_set("state", state_name)
    .role("img")
  ignore(element_attrs.aria_label(aria_label.unwrap_or(default_label)))
  let children : Array[@html.Html] = match state {
    Running(pct) => [status_badge_ring(pct)]
    Count(n) =>
      [
        @html.span(
          style=[
            @internal.SumiFontNum,
            "font-size:10px;line-height:1;font-weight:500;color:#0d0d0d;white-space:nowrap;pointer-events:none",
          ],
          [@html.text(status_badge_count_label(n))],
        ),
      ]
    Complete | Warning => {
      let (glyph, tint) = match state {
        Complete =>
          (
            @primitives.icon_tick_circle_fill(size=16, style=[
              "width:16.667px;height:16.667px",
            ]),
            "color:var(--sumi-brand,#009efa)",
          )
        _ =>
          (
            @primitives.icon_info_circle_fill(size=16, style=[
              "width:16.667px;height:16.667px",
            ]),
            "color:var(--sumi-favorite,#ffa21e)",
          )
      }
      [
        @html.span(
          style=[
            @internal.SumiBoxSizing,
            "position:absolute;inset:-2px;display:flex;align-items:center;justify-content:center;pointer-events:none;\{tint}",
          ],
          attrs=@html.Attrs::build().aria_hidden("true"),
          [glyph],
        ),
      ]
    }
  }
  @html.div(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        StatusBadgeBaseStyle,
        variant_style,
      ],
      style,
    ),
    id?,
    class?,
    attrs=element_attrs,
    children,
  )
}
