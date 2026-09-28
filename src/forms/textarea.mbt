///|
const TextareaBaseStyle : String = "display:block;width:100%;margin:0;padding:8px 12px;border:1px solid var(--sumi-stroke,rgba(204,221,255,0.1));border-radius:var(--sumi-radius,8px);background:var(--sumi-block,rgba(255,255,255,0.08));resize:vertical;font-size:13px;line-height:22px;color:var(--sumi-text,#ffffff);outline:none;appearance:none;-webkit-appearance:none"

///|
/// A multi-line text field. Controlled: the caller owns the value.
pub fn textarea(
  value~ : String,
  placeholder? : String = "",
  rows? : Int = 3,
  on_input? : @internal.Emit[String],
  on_change? : @internal.Emit[String],
  disabled? : Bool = false,
  read_only? : Bool = false,
  name? : String,
  maxlength? : Int,
  autofocus? : Bool,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs).data_set("slot", "textarea")
  @html.textarea(
    value~,
    placeholder~,
    rows~,
    on_input?,
    on_change?,
    disabled~,
    read_only~,
    name?,
    maxlength?,
    autofocus?,
    id?,
    class?,
    title?,
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        @internal.SumiTransition,
        TextareaBaseStyle,
        if disabled {
          @internal.SumiDisabled +
          ";color:var(--sumi-text-disabled,rgba(255,255,255,0.2))"
        } else {
          ""
        },
      ],
      style,
    ),
    attrs=element_attrs,
    "",
  )
}
