///|
const CreditsStyle : String = "display:inline-flex;flex:none;align-items:center;gap:4px;height:32px;margin:0 4px;font-size:12px;line-height:20px;font-weight:500;font-variant-numeric:tabular-nums;user-select:none"

///|
const CreditsDefaultTone : String = "color:var(--sumi-text-secondary,rgba(255,255,255,0.7))"

///|
const CreditsMutedTone : String = "color:var(--sumi-text-placeholder,rgba(255,255,255,0.35))"

///|
const CreditsStrikeStyle : String = "text-decoration:line-through;color:var(--sumi-text-placeholder,rgba(255,255,255,0.35))"

///|
fn credits_diamond_icon(size : Int) -> @html.Html {
  icon(
    "M6 3h12l4 6-10 12L2 9l4-6ZM2 9h20M12 21 8 9l4-6 4 6-4 12",
    size~,
    stroke_width=1,
  )
}

///|
/// The credit-cost indicator shown inline in toolbars before the primary
/// submit. `original_value` renders a struck-through pre-discount price.
/// `muted=true` drops the tone to placeholder strength for frosted input
/// docks, where the indicator is secondary to the composer itself.
pub fn credits(
  value~ : Int,
  original_value? : Int,
  muted? : Bool = false,
  on_click? : @cmd.Cmd,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs).data_set("slot", "credits")
  let tone = if muted { CreditsMutedTone } else { CreditsDefaultTone }
  let original : @html.Html = match original_value {
    Some(original) =>
      @html.span(
        style=[@internal.SumiFontNum, CreditsStrikeStyle],
        attrs=@html.Attrs::build().data_set("slot", "credits-original"),
        original.to_string(),
      )
    None => @html.nothing
  }
  let body : Array[@html.Html] = [
    credits_diamond_icon(12),
    original,
    @html.span(
      style=[
        @internal.SumiFontNum,
        "font-size:12px;line-height:20px;font-weight:500",
      ],
      attrs=@html.Attrs::build().data_set("slot", "credits-value"),
      value.to_string(),
    ),
  ]
  if on_click is Some(_) {
    @html.button(
      style=@internal.sumi_styles(
        [
          @internal.SumiBoxSizing,
          @internal.SumiTransition,
          CreditsStyle,
          tone,
          "cursor:pointer;background:transparent;border:none;padding:0 4px;border-radius:var(--sumi-radius,8px);appearance:none;-webkit-appearance:none;outline:none",
        ],
        style,
      ),
      type_="button",
      id?,
      class?,
      title?,
      on_click?,
      attrs=element_attrs,
      body,
    )
  } else {
    @html.span(
      style=@internal.sumi_styles(
        [@internal.SumiBoxSizing, @internal.SumiFontNum, CreditsStyle, tone],
        style,
      ),
      id?,
      class?,
      title?,
      attrs=element_attrs,
      body,
    )
  }
}
