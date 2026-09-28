///|
pub(all) enum TagVariant {
  Default
  Brand
  Outline
} derive(Debug, Eq)

///|
pub extend TagVariant with Eq::{equal, not_equal}

///|
pub extend TagVariant with Debug::{to_repr}

///|
const TagBaseStyle : String = "display:inline-flex;flex:none;align-items:center;justify-content:center;gap:4px;height:22px;padding:2px 8px;border-radius:6px;font-size:12px;line-height:20px;font-weight:400;white-space:nowrap;user-select:none"

///|
const TagDefaultStyle : String = "background:var(--sumi-block,rgba(255,255,255,0.08));color:var(--sumi-text-secondary,rgba(255,255,255,0.7))"

///|
const TagBrandStyle : String = "background:rgba(0,158,250,0.16);color:var(--sumi-brand,#009efa)"

///|
const TagOutlineStyle : String = "border:1px solid var(--sumi-stroke,rgba(204,221,255,0.1));color:var(--sumi-text-secondary,rgba(255,255,255,0.7))"

///|
fn tag_variant_value(variant : TagVariant) -> String {
  match variant {
    Default => "default"
    Brand => "brand"
    Outline => "outline"
  }
}

///|
fn tag_variant_style(variant : TagVariant) -> String {
  match variant {
    Default => TagDefaultStyle
    Brand => TagBrandStyle
    Outline => TagOutlineStyle
  }
}

///|
/// A small status/category label. Pass `on_remove` to render a removable
/// tag with a trailing close icon.
pub fn[C : @html.IsChildren] tag(
  variant? : TagVariant = Default,
  on_remove? : @cmd.Cmd,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs)
    .data_set("slot", "tag")
    .data_set("variant", tag_variant_value(variant))
  let remove_button = match on_remove {
    Some(cmd) =>
      @html.button(
        style=[
          @internal.SumiBoxSizing,
          "display:inline-flex;align-items:center;justify-content:center;width:12px;height:12px;margin:0;padding:0;border:none;background:transparent;color:inherit;cursor:pointer;appearance:none;-webkit-appearance:none;outline:none",
        ],
        type_="button",
        on_click=cmd,
        attrs=@html.Attrs::build()
          .data_set("slot", "tag-remove")
          .aria_label("Remove"),
        [icon_x(size=10)],
      )
    None => @html.nothing
  }
  @html.span(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        TagBaseStyle,
        tag_variant_style(variant),
      ],
      style,
    ),
    id?,
    class?,
    attrs=element_attrs,
    [@internal.sumi_slot(children), remove_button],
  )
}
