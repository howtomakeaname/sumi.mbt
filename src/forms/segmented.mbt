///|
/// One option in a `segmented` control.
pub(all) struct SegmentedItem {
  value : String
  label : String
  icon : @html.Html?
  trailing : @html.Html?
  numeric : Bool
  disabled : Bool
}

///|
pub fn SegmentedItem::new(
  value : String,
  label : String,
  icon? : @html.Html,
  trailing? : @html.Html,
  numeric? : Bool = false,
  disabled? : Bool = false,
) -> SegmentedItem {
  { value, label, icon, trailing, numeric, disabled, }
}

///|
const SegmentedStyle : String = "display:inline-flex;align-items:center;gap:2px"

///|
const SegmentedItemBaseStyle : String = "display:inline-flex;flex:none;align-items:center;justify-content:center;gap:4px;min-height:32px;padding:6px 8px;margin:0;border:none;border-radius:var(--sumi-radius,8px);background:transparent;font-size:13px;line-height:22px;font-weight:500;white-space:nowrap;cursor:pointer;user-select:none;appearance:none;-webkit-appearance:none;outline:none"

///|
const SegmentedItemNumericStyle : String = "font-family:Montserrat,\"PingFang SC\",ui-sans-serif,system-ui,sans-serif;font-size:13px;line-height:22px"

///|
const SegmentedItemOnStyle : String = "background:var(--sumi-block,rgba(255,255,255,0.08));color:var(--sumi-text,#ffffff)"

///|
const SegmentedItemOffStyle : String = "color:var(--sumi-text-secondary,rgba(255,255,255,0.7))"

///|
fn segmented_item_style(selected : Bool, disabled : Bool) -> String {
  let state = if selected {
    SegmentedItemOnStyle
  } else {
    SegmentedItemOffStyle
  }
  if disabled {
    state +
    ";" +
    @internal.SumiDisabled +
    ";color:var(--sumi-text-disabled,rgba(255,255,255,0.2))"
  } else {
    state
  }
}

///|
/// A segmented single-choice control (size / preset pickers in
/// the design). Controlled: the caller owns the selected value.
///
/// `stacked=true` renders tall items with the icon above the label — the
/// ratio-picker look (16px artwork icons over 12px labels, 56px tall).
pub fn segmented(
  items~ : Array[SegmentedItem],
  selected~ : String,
  stacked? : Bool = false,
  on_select? : @internal.Emit[String],
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs).data_set("slot", "segmented")
  @html.div(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        SegmentedStyle,
      ],
      style,
    ),
    id?,
    class?,
    attrs=element_attrs,
    items.map(item => {
      let is_selected = item.value == selected
      let item_attrs = @html.Attrs::build()
        .data_set("slot", "segmented-item")
        .data_set("state", if is_selected { "on" } else { "off" })
      if item.disabled {
        ignore(item_attrs.aria_disabled("true"))
      }
      let click : @cmd.Cmd? = if item.disabled {
        None
      } else {
        on_select.map(emit => emit(item.value))
      }
      let children : Array[@html.Html] = match item.icon {
        Some(icon) => [icon, @html.text(item.label)]
        None => [@html.text(item.label)]
      }
      match item.trailing {
        Some(trailing) => children.push(trailing)
        None => ()
      }
      @html.button(
        style=[
          @internal.SumiBoxSizing,
          if item.numeric {
            @internal.SumiFontNum
          } else {
            @internal.SumiFontSans
          },
          @internal.SumiTextRendering,
          @internal.SumiTransition,
          SegmentedItemBaseStyle,
          if item.numeric {
            SegmentedItemNumericStyle
          } else {
            ""
          },
          if stacked {
            "flex-direction:column;gap:4px;min-height:56px;padding:8px 12px;font-size:12px;line-height:16px"
          } else {
            ""
          },
          segmented_item_style(is_selected, item.disabled),
        ],
        type_="button",
        disabled=item.disabled,
        on_click?=click,
        attrs=item_attrs,
        children,
      )
    }),
  )
}
