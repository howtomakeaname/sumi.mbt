///|
const PopoverPanelStyle : String = "position:absolute;z-index:50;display:flex;flex-direction:column;min-width:200px;padding:12px;border:1px solid var(--sumi-stroke-secondary,rgba(255,255,255,0.04));border-radius:var(--sumi-radius-lg,12px);background:var(--sumi-menu,#262626);box-shadow:var(--sumi-shadow-menu,0px 8px 56px 0px rgba(0,0,0,0.24))"

///|
/// A generic anchored floating panel with a caller-supplied trigger — the
/// base for composite pickers that are not plain option lists (sliders,
/// forms, previews). Same overlay/motion model as `dropdown_menu`: fully
/// controlled (`open` + `on_open_change`), closes on outside click, enters
/// with the scale animation whose origin follows `side` and `align`.
///
/// ```moonbit nocheck
/// popover(
///   trigger=button(variant=Ghost, [text("16:9 · 2K"), menu_chevron()]),
///   open=panel_open,
///   on_open_change=set_panel_open.map(v => _ => v),
///   [my_panel_content],
/// )
/// ```
pub fn[C : @html.IsChildren] popover(
  trigger~ : @html.Html,
  open~ : Bool,
  on_open_change? : @internal.Emit[Bool],
  align? : MenuAlign = Start,
  side? : MenuSide = Bottom,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  panel_style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let close : @cmd.Cmd? = on_open_change.map(emit => emit(false))
  let toggle : @cmd.Cmd? = on_open_change.map(emit => emit(!open))
  let overlay : @html.Html = match close {
    Some(cmd) =>
      @html.div(
        style=[MenuOverlayStyle],
        hidden=!open,
        on_click=cmd,
        attrs=@html.Attrs::build()
          .data_set("slot", "menu-overlay")
          .aria_hidden("true"),
        "",
      )
    None => @html.nothing
  }
  let element_attrs = @internal.sumi_attrs(attrs)
    .data_set("slot", "popover")
    .data_set("state", if open { "open" } else { "closed" })
  let trigger_attrs = @html.Attrs::build().data_set("slot", "popover-trigger")
  if toggle is Some(cmd) {
    ignore(trigger_attrs.on_click(_ => cmd))
  }
  @html.div(
    style=@internal.sumi_styles(
      [@internal.SumiBoxSizing, "position:relative;display:inline-flex"],
      style,
    ),
    id?,
    class?,
    attrs=element_attrs,
    [
      @html.div(style=["display:inline-flex"], attrs=trigger_attrs, [trigger]),
      @html.fragment([
        overlay,
        @html.div(
          style=@internal.sumi_styles(
            [
              @internal.SumiBoxSizing,
              @internal.SumiFontSans,
              @internal.SumiTextRendering,
              PopoverPanelStyle,
              menu_align_style(align),
              menu_side_style(side),
            ],
            panel_style,
          ),
          hidden=!open,
          attrs=@html.Attrs::build()
            .data_set("slot", "popover-panel")
            .data_set("side", menu_side_value(side))
            .data_set("align", menu_align_value(align)),
          [@internal.sumi_slot(children)],
        ),
      ]),
    ],
  )
}
