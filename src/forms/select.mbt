///|
const SelectTriggerStyle : String = "display:flex;align-items:center;gap:8px;width:100%;height:32px;margin:0;padding:4px 12px;border:1px solid var(--sumi-stroke,rgba(204,221,255,0.1));border-radius:var(--sumi-radius,8px);background:var(--sumi-block,rgba(255,255,255,0.08));font-size:13px;line-height:22px;color:var(--sumi-text,#ffffff);text-align:left;cursor:pointer;user-select:none;appearance:none;-webkit-appearance:none;outline:none"

///|
/// A form-style single select: an input-look trigger opening the compact
/// menu. Fully controlled — the caller owns `open` and `value`. Built on
/// `dropdown_menu`, so outside click, Escape, and arrow-key navigation all
/// behave the same.
///
/// ```moonbit nocheck
/// select(
///   options=[@overlays.MenuItem::new("png", "PNG"), @overlays.MenuItem::new("webp", "WebP")],
///   value=format,
///   placeholder="Export format",
///   open=select_open,
///   on_open_change=set_select_open.map(v => _ => v),
///   on_select=set_format.map(v => _ => v),
/// )
/// ```
pub fn select(
  options~ : Array[@overlays.MenuItem],
  value~ : String,
  placeholder? : String = "Select",
  open~ : Bool,
  on_open_change? : @internal.Emit[Bool],
  on_select? : @internal.Emit[String],
  disabled? : Bool = false,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let current = options.iter().find_first(option => option.value == value)
  let label : @html.Html = match current {
    Some(option) => @html.text(option.label)
    None =>
      @html.span(
        style=["color:var(--sumi-text-placeholder,rgba(255,255,255,0.35))"],
        placeholder,
      )
  }
  let element_attrs = @internal.sumi_attrs(attrs)
    .data_set("slot", "select-trigger")
    .aria_haspopup("menu")
    .aria_expanded(@internal.sumi_bool(open))
  if disabled {
    ignore(element_attrs.aria_disabled("true"))
  }
  @overlays.dropdown_menu(
    items=@overlays.MenuEntry::items(options),
    trigger=@html.button(
      style=@internal.sumi_styles(
        [
          @internal.SumiBoxSizing,
          @internal.SumiFontSans,
          @internal.SumiTextRendering,
          @internal.SumiTransition,
          SelectTriggerStyle,
          @internal.sumi_disabled_style(disabled),
        ],
        [],
      ),
      type_="button",
      disabled~,
      attrs=element_attrs,
      [
        @html.span(
          style=[
            "flex:1 1 0%;overflow:hidden;text-overflow:ellipsis;white-space:nowrap",
          ],
          [label],
        ),
        @overlays.menu_chevron(),
      ],
    ),
    open~,
    on_open_change?,
    selected=value,
    on_select?,
    menu_style=["width:100%"],
    trigger_style=["display:flex;width:100%"],
    id?,
    class?,
    style=@internal.sumi_styles(["display:block;width:100%"], style),
  )
}
