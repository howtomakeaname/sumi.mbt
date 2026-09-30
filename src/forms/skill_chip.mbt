///|
/// The small corner tag of a `skill_chip` highlighting a skill's freshness.
///
/// - `New` — brand blue on the translucent brand block
/// - `Hot` — orange on the translucent orange block
pub(all) enum SkillMark {
  New
  Hot
} derive(Eq)

///|
pub extend SkillMark with Eq::{equal, not_equal}

///|
const SkillChipStyle : String = "display:inline-flex;align-items:center;gap:8px;height:36px;margin:0;padding:4px 20px;border:1px solid var(--sumi-stroke-secondary,rgba(255,255,255,0.04));border-radius:40px;background:var(--sumi-block-secondary,rgba(255,255,255,0.04));font-size:12px;line-height:20px;color:var(--sumi-text,#ffffff);white-space:nowrap;cursor:pointer;user-select:none;appearance:none;-webkit-appearance:none;outline:none"

///|
const SkillChipMoreStyle : String = "gap:4px;padding:4px 12px 4px 20px"

///|
const SkillMarkStyle : String = "display:inline-flex;flex:none;align-items:center;justify-content:center;height:16px;min-width:26px;padding:2px 4px 2px 4px;border-radius:4px;font-size:9px;line-height:11.667px;font-weight:600"

///|
fn skill_mark_style(kind : SkillMark) -> String {
  match kind {
    New =>
      SkillMarkStyle +
      ";background:var(--sumi-brand-block,rgba(0,142,229,0.12));color:var(--sumi-brand,#009efa)"
    Hot =>
      SkillMarkStyle +
      ";background:var(--sumi-orange-block,rgba(255,146,48,0.16));color:var(--sumi-orange,#ff9230)"
  }
}

///|
/// One skill pill of the agent's skill picker: a 36px radius-40 chip with a
/// hairline border and a translucent fill, holding an optional 16px leading
/// icon, a 12/20 label, and an optional New/Hot `mark`. With `more=true`
/// the chip becomes the "More" trigger: tighter gap, asymmetric padding,
/// and a trailing 12px right chevron.
///
/// ```moonbit nocheck
/// skill_chip(label="Storyboard", icon=@sumi.icon_draw(size=16), mark=New)
/// skill_chip(label="More", more=true, on_click=emit(OpenSkillPanel))
/// ```
pub fn skill_chip(
  label~ : String,
  icon? : @html.Html,
  mark? : SkillMark,
  mark_label? : String,
  more? : Bool = false,
  on_click? : @cmd.Cmd,
  disabled? : Bool = false,
  aria_label? : String,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs).data_set("slot", "skill-chip")
  if more {
    ignore(element_attrs.data_set("more", "true"))
  }
  if disabled {
    ignore(element_attrs.data_set("disabled", "true").aria_disabled("true"))
  }
  if aria_label is Some(label_text) {
    ignore(element_attrs.aria_label(label_text))
  }
  let children : Array[@html.Html] = []
  if !more && icon is Some(icon_view) {
    children.push(
      @html.span(
        style=["display:inline-flex;flex:none"],
        attrs=@html.Attrs::build().aria_hidden("true"),
        [icon_view],
      ),
    )
  }
  children.push(@html.text(label))
  if !more && mark is Some(mark_kind) {
    let tag_text = match mark_label {
      Some(value) => value
      None =>
        match mark_kind {
          New => "New"
          Hot => "Hot"
        }
    }
    children.push(
      @html.span(
        style=[@internal.SumiFontNum, skill_mark_style(mark_kind)],
        attrs=@html.Attrs::build().data_set("slot", "skill-chip-mark"),
        [@html.text(tag_text)],
      ),
    )
  }
  if more {
    children.push(
      @html.span(
        style=["display:inline-flex;flex:none"],
        attrs=@html.Attrs::build().aria_hidden("true"),
        [@primitives.icon_chevron_right(size=12)],
      ),
    )
  }
  @html.button(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        @internal.SumiTransition,
        SkillChipStyle,
        if more {
          SkillChipMoreStyle
        } else {
          ""
        },
        if disabled {
          @internal.SumiDisabled +
          ";color:var(--sumi-text-disabled,rgba(255,255,255,0.2))"
        } else {
          ""
        },
      ],
      style,
    ),
    type_="button",
    disabled~,
    id?,
    class?,
    on_click?,
    attrs=element_attrs,
    children,
  )
}

///|
const ActionChipStyle : String = "display:inline-flex;align-items:center;justify-content:center;height:36px;min-width:80px;margin:0;padding:4px 16px;border:none;border-radius:8px;background:var(--sumi-block,rgba(255,255,255,0.08));font-size:13px;line-height:22px;color:var(--sumi-text,#ffffff);white-space:nowrap;cursor:pointer;user-select:none;appearance:none;-webkit-appearance:none;outline:none"

///|
/// One quick-action button of the "more actions" sheet: a 36px radius-8
/// block-fill button with a centered 13/22 Regular label and an 80px
/// minimum width, wrapping alongside its siblings inside a `chip_panel`.
///
/// ```moonbit nocheck
/// action_chip(label="Storyboard", on_click=emit.map(Run("storyboard")))
/// ```
pub fn action_chip(
  label~ : String,
  on_click? : @cmd.Cmd,
  disabled? : Bool = false,
  aria_label? : String,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs).data_set(
    "slot", "action-chip",
  )
  if disabled {
    ignore(element_attrs.data_set("disabled", "true").aria_disabled("true"))
  }
  if aria_label is Some(label_text) {
    ignore(element_attrs.aria_label(label_text))
  }
  @html.button(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        @internal.SumiTransition,
        ActionChipStyle,
        if disabled {
          @internal.SumiDisabled +
          ";color:var(--sumi-text-disabled,rgba(255,255,255,0.2))"
        } else {
          ""
        },
      ],
      style,
    ),
    type_="button",
    disabled~,
    id?,
    class?,
    on_click?,
    attrs=element_attrs,
    [@html.text(label)],
  )
}

///|
/// The "more actions" sheet of the agent input: a frosted top-rounded panel
/// (24px backdrop blur) whose children — `skill_chip` or `action_chip` —
/// wrap with 8px gaps around centered rows.
///
/// ```moonbit nocheck
/// chip_panel(children=[
///   skill_chip(label="Storyboard", mark=Hot),
///   skill_chip(label="Quick Cut"),
/// ])
/// ```
pub fn chip_panel(
  children~ : Array[@html.Html],
  width? : Int = 338,
  aria_label? : String,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs).data_set("slot", "chip-panel")
  if aria_label is Some(label_text) {
    ignore(element_attrs.aria_label(label_text))
  }
  @html.div(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        "display:flex;flex-wrap:wrap;gap:8px;align-items:flex-start;align-content:flex-start;justify-content:center;width:\{width}px;padding:8px;border-radius:20px 20px 0 0;background:transparent;backdrop-filter:blur(24px);-webkit-backdrop-filter:blur(24px);overflow:hidden",
      ],
      style,
    ),
    id?,
    class?,
    attrs=element_attrs,
    children,
  )
}
