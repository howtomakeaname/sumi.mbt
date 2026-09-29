///|
const FavoriteToggleStyle : String = "display:inline-flex;align-items:center;justify-content:center;padding:2px;border:none;background:transparent;cursor:pointer;appearance:none;-webkit-appearance:none;outline:none"

///|
/// A bare star button that toggles a favorite on/off: outline star at rest,
/// filled amber star when on. Fully controlled — the caller owns `checked`.
/// Unlike `icon_button` it carries no hover plate, matching the design's
/// chrome-less affordance.
///
/// ```moonbit nocheck
/// favorite_toggle(
///   checked=starred,
///   on_change=set_starred.map(v => _ => v),
/// )
/// ```
pub fn favorite_toggle(
  checked~ : Bool,
  on_change? : @internal.Emit[Bool],
  disabled? : Bool = false,
  aria_label? : String,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs)
    .data_set("slot", "favorite-toggle")
    .aria_pressed(@internal.sumi_bool(checked))
  let label = aria_label.unwrap_or(
    if checked {
      "Remove from favorites"
    } else {
      "Add to favorites"
    },
  )
  ignore(element_attrs.aria_label(label))
  @html.button(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        @internal.SumiTransition,
        FavoriteToggleStyle,
        if checked {
          "color:var(--sumi-favorite,#ffa21e)"
        } else {
          "color:var(--sumi-text-tertiary,rgba(255,255,255,0.6))"
        },
        @internal.sumi_disabled_style(disabled),
      ],
      style,
    ),
    type_="button",
    disabled~,
    on_click?=on_change.map(emit => emit(!checked)),
    id?,
    class?,
    attrs=element_attrs,
    [if checked { icon_star_fill(size=16) } else { icon_star(size=16) }],
  )
}
