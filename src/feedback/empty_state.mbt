///|
const EmptyStateStyle : String = "display:flex;flex-direction:column;align-items:center;justify-content:center;gap:8px;padding:40px 24px;text-align:center"

///|
const EmptyStateIconStyle : String = "display:inline-flex;align-items:center;justify-content:center;width:48px;height:48px;margin-bottom:4px;border-radius:9999px;background:var(--sumi-block,rgba(255,255,255,0.08));color:var(--sumi-text-placeholder,rgba(255,255,255,0.35))"

///|
const EmptyStateTitleStyle : String = "font-size:14px;line-height:22px;font-weight:500;color:var(--sumi-text-secondary,rgba(255,255,255,0.7))"

///|
const EmptyStateDescriptionStyle : String = "max-width:280px;font-size:12px;line-height:20px;color:var(--sumi-text-placeholder,rgba(255,255,255,0.35))"

///|
/// A placeholder for empty regions of the canvas or a result list. Pass an
/// optional `action` (usually a button) below the copy.
pub fn empty_state(
  title_text~ : String,
  description? : String,
  icon? : @html.Html,
  action? : @html.Html,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs).data_set(
    "slot", "empty-state",
  )
  let icon_view : @html.Html = match icon {
    Some(icon) =>
      @html.span(
        style=[@internal.SumiBoxSizing, EmptyStateIconStyle],
        attrs=@html.Attrs::build().aria_hidden("true"),
        [icon],
      )
    None => @html.nothing
  }
  let description_view : @html.Html = match description {
    Some(text) =>
      @html.p(
        style=[@internal.SumiFontSans, EmptyStateDescriptionStyle],
        attrs=@html.Attrs::build().data_set("slot", "empty-state-description"),
        text,
      )
    None => @html.nothing
  }
  let action_view : @html.Html = match action {
    Some(action) => @html.div(style=["margin-top:8px"], [action])
    None => @html.nothing
  }
  @html.div(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        EmptyStateStyle,
      ],
      style,
    ),
    id?,
    class?,
    attrs=element_attrs,
    [
      icon_view,
      @html.div(
        style=[@internal.SumiFontSans, EmptyStateTitleStyle],
        attrs=@html.Attrs::build().data_set("slot", "empty-state-title"),
        title_text,
      ),
      description_view,
      action_view,
    ],
  )
}
