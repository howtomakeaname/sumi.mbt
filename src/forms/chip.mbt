///|
const ChipStyle : String = "display:inline-flex;align-items:center;justify-content:center;gap:4px;height:36px;min-width:48px;padding:0 15px;margin:0;border:none;border-radius:10px;background:transparent;font-size:12px;line-height:20px;font-weight:500;white-space:nowrap;cursor:pointer;user-select:none;appearance:none;-webkit-appearance:none;outline:none"

///|
const ChipOnStyle : String = "background:var(--sumi-block,rgba(255,255,255,0.08));color:var(--sumi-text,#ffffff)"

///|
const ChipOffStyle : String = "color:var(--sumi-text,#ffffff)"

///|
fn chip_style(selected : Bool, disabled : Bool) -> String {
  let state = if selected { ChipOnStyle } else { ChipOffStyle }
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
/// A single selectable pill for one-choice option rows. Text stays
/// full-white in both states; selection shows only through the block fill.
/// Fully controlled — the caller owns `selected`; group several chips
/// under one value to build a radio-like row.
///
/// ```moonbit nocheck
/// chip("M", selected=size == "m", on_click=set_size.map(v => _ => "m"))
/// ```
pub fn chip(
  label : String,
  selected? : Bool = false,
  on_click? : @cmd.Cmd,
  disabled? : Bool = false,
  aria_label? : String,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs)
    .data_set("slot", "chip")
    .data_set("state", if selected { "on" } else { "off" })
    .aria_pressed(@internal.sumi_bool(selected))
  if aria_label is Some(label_text) {
    ignore(element_attrs.aria_label(label_text))
  }
  @html.button(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontNum,
        @internal.SumiTextRendering,
        @internal.SumiTransition,
        ChipStyle,
        chip_style(selected, disabled),
      ],
      style,
    ),
    type_="button",
    disabled~,
    on_click?,
    id?,
    class?,
    attrs=element_attrs,
    [@html.text(label)],
  )
}
