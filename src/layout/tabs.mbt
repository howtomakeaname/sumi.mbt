///|
/// One tab in a `tabs` control.
pub(all) struct TabEntry {
  value : String
  label : String
  icon : @html.Html?
}

///|
pub fn TabEntry::new(
  value : String,
  label : String,
  icon? : @html.Html,
) -> TabEntry {
  { value, label, icon, }
}

///|
const TabsListStyle : String = "display:inline-flex;align-items:center;gap:4px;padding:2px;border-radius:var(--sumi-radius-lg,12px);background:var(--sumi-block,rgba(255,255,255,0.08))"

///|
const TabsTriggerBaseStyle : String = "display:inline-flex;flex:none;align-items:center;justify-content:center;gap:4px;height:28px;padding:0 10px;margin:0;border:none;border-radius:calc(var(--sumi-radius,8px) - 2px);background:transparent;font-size:12px;line-height:20px;font-weight:500;white-space:nowrap;cursor:pointer;user-select:none;appearance:none;-webkit-appearance:none;outline:none"

///|
const TabsTriggerOnStyle : String = "background:var(--sumi-spotlight,#292929);color:var(--sumi-text,#ffffff)"

///|
const TabsTriggerOffStyle : String = "color:var(--sumi-text-secondary,rgba(255,255,255,0.7))"

///|
/// A tab strip. Controlled: the caller owns the selected value; render the
/// matching panel content next to the returned strip.
///
/// ```moonbit nocheck
/// tabs(
///   items=[TabEntry::new("all", "All"), TabEntry::new("mine", "Mine")],
///   selected=tab,
///   on_select=set_tab.map(v => _ => v),
/// )
/// ```
pub fn tabs(
  items~ : Array[TabEntry],
  selected~ : String,
  on_select? : @internal.Emit[String],
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs).data_set("slot", "tabs")
  @html.div(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        TabsListStyle,
      ],
      style,
    ),
    id?,
    class?,
    attrs=element_attrs,
    items.map(item => {
      let is_selected = item.value == selected
      let trigger_attrs = @html.Attrs::build()
        .data_set("slot", "tabs-trigger")
        .data_set("state", if is_selected { "on" } else { "off" })
        .role("tab")
        .aria_selected(@internal.sumi_bool(is_selected))
      let children : Array[@html.Html] = match item.icon {
        Some(icon) => [icon, @html.text(item.label)]
        None => [@html.text(item.label)]
      }
      @html.button(
        style=[
          @internal.SumiBoxSizing,
          @internal.SumiFontSans,
          @internal.SumiTextRendering,
          @internal.SumiTransition,
          TabsTriggerBaseStyle,
          if is_selected {
            TabsTriggerOnStyle
          } else {
            TabsTriggerOffStyle
          },
        ],
        type_="button",
        on_click?=on_select.map(emit => emit(item.value)),
        attrs=trigger_attrs,
        children,
      )
    }),
  )
}
