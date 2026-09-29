///|
const EditableTextStyle : String = "background:transparent;border:1px solid transparent;border-radius:6px;padding:3px 8px;height:28px;font-size:13px;line-height:22px;font-weight:500;color:var(--sumi-text,#ffffff);outline:none;min-width:32px;max-width:100%;field-sizing:content;cursor:text;caret-color:var(--sumi-brand,#009efa)"

///|
/// A title that reads as plain text and turns into an input on click.
/// Focus selects the whole value so typing replaces it (interaction sheet
/// handles select-all, Enter, and Escape); the parent only sees commits —
/// Enter or blur emits `on_change`, Escape restores the last value. The
/// placeholder shows when the value is empty.
pub fn editable_text(
  value~ : String,
  placeholder? : String,
  on_change? : @internal.Emit[String],
  read_only? : Bool = false,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs)
    .data_set("slot", "editable-text-input")
    .data_set("value", value)
    .on_blur(fn(ev) {
      match (on_change, ev.target().to_html_input_element()) {
        (Some(emit), Some(input)) => emit(input.value())
        _ => @cmd.none
      }
    })
  @html.input(
    input_type=Text,
    value~,
    placeholder?,
    read_only~,
    id?,
    class?,
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        EditableTextStyle,
      ],
      style,
    ),
    attrs=element_attrs,
  )
}
