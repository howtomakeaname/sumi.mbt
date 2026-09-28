///|
const ProgressTrackStyle : String = "display:block;width:100%;height:4px;margin:0;padding:0;border:none;border-radius:9999px;background:var(--sumi-block,rgba(255,255,255,0.08));overflow:hidden"

///|
const ProgressFillStyle : String = "display:block;height:100%;border-radius:9999px;background:var(--sumi-brand,#009efa);transition:width 200ms ease"

///|
fn progress_percent(value : Int, max : Int) -> Int {
  if max <= 0 {
    0
  } else if value < 0 {
    0
  } else if value > max {
    100
  } else {
    value * 100 / max
  }
}

///|
/// A determinate linear progress bar.
pub fn progress(
  value~ : Int,
  max? : Int = 100,
  show_value? : Bool = false,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let percent = progress_percent(value, max)
  let element_attrs = @internal.sumi_attrs(attrs)
    .data_set("slot", "progress")
    .role("progressbar")
    .aria_valuenow(value.to_string())
    .aria_valuemax(max.to_string())
  let bar = @html.div(
    style=@internal.sumi_styles([@internal.SumiBoxSizing, ProgressTrackStyle], []),
    id?,
    class?,
    attrs=element_attrs,
    [
      @html.div(
        style=[ProgressFillStyle, "width:\{percent}%"],
        attrs=@html.Attrs::build().data_set("slot", "progress-indicator"),
        "",
      ),
    ],
  )
  if show_value {
    @html.div(
      style=@internal.sumi_styles(
        [
          @internal.SumiBoxSizing,
          @internal.SumiFontSans,
          "display:flex;align-items:center;gap:8px;width:100%",
        ],
        style,
      ),
      attrs=@html.Attrs::build().data_set("slot", "progress-root"),
      [
        @html.div(style=["flex:1 1 0%;display:flex;align-items:center"], [bar]),
        @html.span(
          style=[
            @internal.SumiFontNum,
            "flex:none;min-width:28px;text-align:right;font-size:12px;line-height:20px;color:var(--sumi-text-secondary,rgba(255,255,255,0.7))",
          ],
          "\{percent}%",
        ),
      ],
    )
  } else {
    bar
  }
}
