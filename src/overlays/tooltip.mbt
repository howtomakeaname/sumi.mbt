///|
pub(all) enum TooltipSide {
  Top
  Bottom
  Left
  Right
} derive(Debug, Eq)

///|
pub extend TooltipSide with Eq::{equal, not_equal}

///|
pub extend TooltipSide with Debug::{to_repr}

///|
const TooltipWrapperStyle : String = "position:relative;display:inline-flex"

///|
const TooltipContentBaseStyle : String = "position:absolute;z-index:50;display:flex;align-items:center;justify-content:center;padding:10px 16px;border-radius:var(--sumi-radius,8px);background:var(--sumi-tooltip-bg,#333333);box-shadow:0px 8px 28px var(--sumi-shadow,rgba(0,0,0,0.24));font-size:12px;line-height:20px;font-weight:400;color:var(--sumi-tooltip-fg,#ffffff);text-align:center;white-space:nowrap;pointer-events:none"

///|
fn tooltip_side_style(side : TooltipSide) -> String {
  match side {
    Top => "bottom:calc(100% + 8px);left:50%"
    Bottom => "top:calc(100% + 8px);left:50%"
    Left => "right:calc(100% + 8px);top:50%"
    Right => "left:calc(100% + 8px);top:50%"
  }
}

///|
fn tooltip_side_value(side : TooltipSide) -> String {
  match side {
    Top => "top"
    Bottom => "bottom"
    Left => "left"
    Right => "right"
  }
}

///|
/// A hover tooltip. The bubble reveals via the interaction sheet (pure CSS),
/// so no state is involved. Wrap any trigger element:
///
/// ```moonbit nocheck
/// tooltip(content="Upscale to 4K", button(variant=Ghost, "4K"))
/// ```
pub fn[C : @html.IsChildren] tooltip(
  content~ : String,
  side? : TooltipSide = Top,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs).data_set("slot", "tooltip")
  @html.span(
    style=@internal.sumi_styles(
      [@internal.SumiBoxSizing, TooltipWrapperStyle],
      style,
    ),
    id?,
    class?,
    attrs=element_attrs,
    [
      @internal.sumi_slot(children),
      @html.span(
        style=[
          @internal.SumiBoxSizing,
          @internal.SumiFontSans,
          @internal.SumiTextRendering,
          TooltipContentBaseStyle,
          tooltip_side_style(side),
        ],
        attrs=@html.Attrs::build()
          .data_set("slot", "tooltip-content")
          .data_set("side", tooltip_side_value(side))
          .role("tooltip"),
        content,
      ),
    ],
  )
}
