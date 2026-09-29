///|
const AddTileStyle : String = "display:inline-flex;align-items:center;justify-content:center;width:48px;height:48px;padding:0;margin:0;border:1px solid var(--sumi-stroke-secondary,rgba(255,255,255,0.04));border-radius:8px;background:var(--sumi-block-secondary,rgba(255,255,255,0.04));color:var(--sumi-text-tertiary,rgba(255,255,255,0.6));cursor:pointer;appearance:none;-webkit-appearance:none;outline:none"

///|
/// The 48px "add" tile: a quiet bordered square with a centered plus that
/// opens an upload/picker menu (compose with `dropdown_menu` as the
/// trigger). Hover raises the fill to the primary block; disabled fades
/// the plus to the disabled text shade.
///
/// ```moonbit nocheck
/// dropdown_menu(
///   trigger=add_tile(aria_label="Add image"),
///   items=[...],
///   open=menu_open,
///   on_open_change=set_menu_open.map(v => _ => v),
/// )
/// ```
pub fn add_tile(
  on_click? : @cmd.Cmd,
  disabled? : Bool = false,
  aria_label? : String,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs).data_set("slot", "add-tile")
  ignore(element_attrs.aria_label(aria_label.unwrap_or("Add")))
  @html.button(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        @internal.SumiTransition,
        AddTileStyle,
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
    on_click?,
    id?,
    class?,
    attrs=element_attrs,
    [icon_plus_fill(size=16)],
  )
}
