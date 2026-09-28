///|
const SliderTrackStyle : String = "display:block;width:100%;height:12px;margin:0;padding:0;border:none;outline:none"

///|
const SliderValueStyle : String = "flex:none;min-width:28px;text-align:right;font-size:12px;line-height:20px;font-weight:500;color:var(--sumi-text,#ffffff);font-variant-numeric:tabular-nums"

///|
fn slider_percent(value : Int, min : Int, max : Int) -> Int {
  if max <= min {
    0
  } else {
    let clamped = if value < min {
      min
    } else if value > max {
      max
    } else {
      value
    }
    (clamped - min) * 100 / (max - min)
  }
}

///|
/// A single-value slider built on the native range input; track fill and
/// thumb styling live in the interaction sheet emitted by `theme`.
///
/// `value_tooltip=true` adds the design's value bubble above the thumb,
/// visible while hovering, dragging, or keyboard-focusing the slider.
/// `on_input` fires per tick (keep it cheap); `on_commit` fires once on
/// release for expensive reactions.
///
/// ```moonbit nocheck
/// slider(
///   value=35,
///   value_tooltip=true,
///   on_input=set_strength.map(v => _ => v),
///   on_commit=emit(CommitStrength),
///   suffix="°",
/// )
/// ```
pub fn slider(
  value~ : Int,
  min? : Int = 0,
  max? : Int = 100,
  step? : Int = 1,
  on_input? : @internal.Emit[Int],
  on_commit? : @internal.Emit[Int],
  disabled? : Bool = false,
  show_value? : Bool = false,
  value_tooltip? : Bool = false,
  suffix? : String = "",
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let percent = slider_percent(value, min, max)
  let input_attrs = @internal.sumi_attrs(attrs)
    .data_set("slot", "slider")
    .style("--sumi-slider-percent", "\{percent}%")
  if disabled {
    ignore(input_attrs.disabled(true))
  }
  let parse = fn(s : String) -> Int { @string.parse_int(s) catch { _ => min } }
  let input = @html.input(
    input_type=Range,
    value=value.to_string(),
    min~,
    max~,
    step~,
    on_input?=on_input.map(emit => emit.map(parse)),
    on_change?=on_commit.map(emit => emit.map(parse)),
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontNum,
        @internal.SumiTextRendering,
        SliderTrackStyle,
      ],
      [],
    ),
    id?,
    class?,
    attrs=input_attrs,
  )
  let bubble : @html.Html = if value_tooltip {
    @html.span(
      style=[
        "position:absolute;bottom:calc(100% + 12px);left:\{percent}%;transform:translateX(-50%);z-index:50;display:flex;align-items:center;justify-content:center;padding:10px 16px;border-radius:var(--sumi-radius,8px);background:var(--sumi-tooltip-bg,#333333);box-shadow:0px 8px 28px var(--sumi-shadow,rgba(0,0,0,0.24));font-size:12px;line-height:20px;font-weight:500;color:var(--sumi-tooltip-fg,#ffffff);font-variant-numeric:tabular-nums;pointer-events:none;opacity:0;transition:opacity 100ms ease",
      ],
      attrs=@html.Attrs::build()
        .data_set("slot", "slider-bubble")
        .aria_hidden("true"),
      "\{value}\{suffix}",
    )
  } else {
    @html.nothing
  }
  let track = @html.div(
    style=["position:relative;display:flex;align-items:center;width:100%"],
    attrs=@html.Attrs::build().data_set("slot", "slider-track"),
    [input, bubble],
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
      attrs=@html.Attrs::build().data_set("slot", "slider-root"),
      [
        track,
        @html.span(
          style=[
            @internal.SumiFontNum,
            @internal.SumiTextRendering,
            SliderValueStyle,
          ],
          attrs=@html.Attrs::build().data_set("slot", "slider-value"),
          "\{value}\{suffix}",
        ),
      ],
    )
  } else {
    track
  }
}
