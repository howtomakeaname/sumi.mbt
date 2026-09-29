///|
const SliderFieldStyle : String = "display:flex;flex-direction:column;gap:12px;width:100%"

///|
const SliderFieldTitleStyle : String = "display:flex;align-items:center;width:100%;min-height:16px"

///|
const SliderFieldLabelStyle : String = "flex:1 1 0%;min-width:0;font-size:12px;line-height:12px;color:var(--sumi-text-placeholder,rgba(255,255,255,0.35))"

///|
const SliderFieldAutoStyle : String = "display:flex;align-items:center;gap:8px;flex:none;font-size:12px;line-height:20px"

///|
const SliderFieldBodyStyle : String = "display:flex;align-items:center;gap:24px;width:100%"

///|
const SliderFieldTrackColumnStyle : String = "display:flex;flex:1 1 0%;min-width:0;flex-direction:column;gap:8px;padding-top:4px"

///|
const SliderFieldTicksStyle : String = "position:absolute;inset:0;pointer-events:none"

///|
const SliderFieldTickStyle : String = "position:absolute;top:4px;width:1px;height:4px;border-radius:11px;background:var(--sumi-text-disabled,rgba(255,255,255,0.2))"

///|
const SliderFieldTickLabelsStyle : String = "position:relative;width:100%;height:14px;font-size:10px;line-height:18px;font-weight:500;color:var(--sumi-text-placeholder,rgba(255,255,255,0.35))"

///|
const SliderFieldTickLabelStyle : String = "position:absolute;top:0;white-space:nowrap"

///|
const SliderFieldNumberStyle : String = "display:flex;flex:none;align-items:center;gap:4px;width:90px;height:36px;padding:3px 4px 3px 8px;border-radius:var(--sumi-radius,8px);background:var(--sumi-block,rgba(255,255,255,0.08))"

///|
const SliderFieldInputStyle : String = "flex:1 1 0%;min-width:0;margin:0;padding:0;border:none;background:transparent;font-size:12px;line-height:20px;color:var(--sumi-text,#ffffff);outline:none;text-overflow:ellipsis;appearance:none;-webkit-appearance:none"

///|
const SliderFieldUnitStyle : String = "flex:none;font-size:13px;line-height:22px;color:var(--sumi-text-placeholder,rgba(255,255,255,0.35))"

///|
fn slider_field_clamp(value : Int, min : Int, max : Int) -> Int {
  if value < min {
    min
  } else if value > max {
    max
  } else {
    value
  }
}

///|
/// Parse an integer, yielding `None` on invalid input.
fn slider_field_parse(text : String) -> Int? {
  Some(@string.parse_int(text)) catch {
    _ => None
  }
}

///|
/// Horizontal alignment of a tick label: the first label hugs the left edge,
/// the last hugs the right edge, the rest center on their tick.
fn slider_field_tick_position(pct : Int, index : Int, count : Int) -> String {
  if count <= 1 || index == 0 {
    "left:0%;transform:none"
  } else if index == count - 1 {
    "left:100%;transform:translateX(-100%)"
  } else {
    "left:\{pct}%;transform:translateX(-50%)"
  }
}

///|
fn slider_field_tick_label(
  pct : Int,
  tick : Int,
  index : Int,
  count : Int,
) -> @html.Html {
  let position = slider_field_tick_position(pct, index, count)
  @html.span(style=[SliderFieldTickLabelStyle, position], tick.to_string())
}

///|
/// A labelled numeric field composing the slider with tick marks, tick
/// labels, and a number box carrying the unit suffix — the duration-field
/// pattern. Fully controlled: the parent owns `value` (and `auto` when the
/// optional auto row is shown by passing it). The slider fires `on_input`
/// per tick and `on_commit` on release; the number box commits on Enter or
/// blur (Escape reverts), firing both.
///
/// `ticks` lists the values that get a track mark and a label below; the
/// first and last marks stay invisible like the design's end caps.
///
/// ```moonbit nocheck
/// slider_field(
///   value=duration,
///   min=0, max=180,
///   label="Total duration",
///   unit="s",
///   ticks=[0, 30, 60, 90, 120, 150, 180],
///   on_input=set_duration.map(v => _ => v),
/// )
/// ```
pub fn slider_field(
  value~ : Int,
  min? : Int = 0,
  max? : Int = 100,
  step? : Int = 1,
  label? : String,
  unit? : String = "",
  ticks? : Array[Int] = [],
  auto? : Bool,
  auto_label? : String = "Auto",
  on_auto_change? : @internal.Emit[Bool],
  on_input? : @internal.Emit[Int],
  on_commit? : @internal.Emit[Int],
  disabled? : Bool = false,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs).data_set(
    "slot", "slider-field",
  )
  let range = max - min
  let percent_of = fn(tick : Int) -> Int {
    if range <= 0 {
      0
    } else {
      (slider_field_clamp(tick, min, max) - min) * 100 / range
    }
  }
  let auto_row : Array[@html.Html] = match auto {
    Some(is_auto) => {
      let auto_color = if is_auto {
        "color:var(--sumi-text-placeholder,rgba(255,255,255,0.35))"
      } else {
        "color:var(--sumi-text-secondary,rgba(255,255,255,0.7))"
      }
      [
        @html.div(
          style=[
            @internal.SumiBoxSizing,
            @internal.SumiFontNum,
            SliderFieldAutoStyle,
            auto_color,
          ],
          attrs=@html.Attrs::build().data_set("slot", "slider-field-auto"),
          [
            @html.span(style=[], auto_label),
            switch(checked=is_auto, on_change?=on_auto_change, disabled~),
          ],
        ),
      ]
    }
    None => []
  }
  let title_row : Array[@html.Html] = match label {
    Some(text) =>
      [
        @html.div(
          style=[
            @internal.SumiBoxSizing,
            @internal.SumiFontSans,
            SliderFieldTitleStyle,
          ],
          attrs=@html.Attrs::build().data_set("slot", "slider-field-title"),
          [
            @html.span(
              style=[@internal.SumiFontSans, SliderFieldLabelStyle],
              attrs=@html.Attrs::build().data_set("slot", "slider-field-label"),
              text,
            ),
            ..auto_row,
          ],
        ),
      ]
    None => []
  }
  let tick_count = ticks.length()
  let tick_marks = ticks.mapi(fn(i, tick) {
    @html.span(
      style=[
        SliderFieldTickStyle,
        "left:\{percent_of(tick)}%",
        if i == 0 || i == tick_count - 1 {
          "opacity:0"
        } else {
          "opacity:1"
        },
      ],
      attrs=@html.Attrs::build()
        .data_set("slot", "slider-field-tick")
        .aria_hidden("true"),
      ([] : Array[@html.Html]),
    )
  })
  let tick_labels = ticks.mapi(fn(i, tick) {
    slider_field_tick_label(percent_of(tick), tick, i, tick_count)
  })
  let slider_wrap = @html.div(style=["position:relative;width:100%"], [
    slider(value~, min~, max~, step~, on_input?, on_commit?, disabled~),
    @html.div(
      style=[SliderFieldTicksStyle],
      attrs=@html.Attrs::build().aria_hidden("true"),
      tick_marks,
    ),
  ])
  let commit = fn(text : String) -> @cmd.Cmd {
    match slider_field_parse(text) {
      Some(v) => {
        let clamped = slider_field_clamp(v, min, max)
        if clamped == value {
          @cmd.none
        } else {
          let cmds : Array[@cmd.Cmd] = []
          if on_input is Some(emit) {
            cmds.push(emit(clamped))
          }
          if on_commit is Some(emit) {
            cmds.push(emit(clamped))
          }
          @cmd.batch(cmds)
        }
      }
      None => @cmd.none
    }
  }
  let number_box = @html.div(
    style=[
      @internal.SumiBoxSizing,
      @internal.SumiFontNum,
      @internal.SumiTextRendering,
      SliderFieldNumberStyle,
    ],
    attrs=@html.Attrs::build().data_set("slot", "slider-field-number"),
    [
      @html.input(
        input_type=Text,
        value=value.to_string(),
        read_only=disabled,
        style=[
          @internal.SumiBoxSizing,
          @internal.SumiFontNum,
          SliderFieldInputStyle,
        ],
        attrs=@html.Attrs::build()
          .data_set("slot", "slider-field-input")
          .data_set("value", value.to_string())
          .aria_label(label.unwrap_or("Value"))
          .on_blur(fn(ev) {
            match ev.target().to_html_input_element() {
              Some(input) => {
                let text = input.value()
                let cmd = commit(text)
                input.set_value(value.to_string())
                cmd
              }
              None => @cmd.none
            }
          }),
      ),
      @html.span(
        style=[@internal.SumiFontNum, SliderFieldUnitStyle],
        attrs=@html.Attrs::build().data_set("slot", "slider-field-unit"),
        unit,
      ),
    ],
  )
  @html.div(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        SliderFieldStyle,
      ],
      style,
    ),
    id?,
    class?,
    attrs=element_attrs,
    [
      ..title_row,
      @html.div(
        style=[@internal.SumiBoxSizing, SliderFieldBodyStyle],
        attrs=@html.Attrs::build().data_set("slot", "slider-field-body"),
        [
          @html.div(
            style=[@internal.SumiBoxSizing, SliderFieldTrackColumnStyle],
            [
              slider_wrap,
              @html.div(
                style=[@internal.SumiFontNum, SliderFieldTickLabelsStyle],
                attrs=@html.Attrs::build()
                  .data_set("slot", "slider-field-tick-labels")
                  .aria_hidden("true"),
                tick_labels,
              ),
            ],
          ),
          number_box,
        ],
      ),
    ],
  )
}
