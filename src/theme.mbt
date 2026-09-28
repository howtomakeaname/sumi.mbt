///|
/// Provide the design tokens to a subtree and emit the library's static
/// pseudo-class interaction sheet plus the event-layer script. Wrap the app
/// root once:
///
/// ```moonbit nocheck
/// theme(mode=Dark, [my_app_content])
/// ```
///
/// `mode` picks the token palette (see tokens.mbt): `Dark` (default),
/// `Light`, or `System` to follow the viewer's OS setting. Tokens ride on
/// the emitted sheet keyed by `[data-sumi-theme]`, so nested themes with
/// different modes compose. Override any token by appending custom CSS
/// variables through `style`.
pub fn[C : @html.IsChildren] theme(
  mode? : ThemeMode = Dark,
  id? : String,
  class? : String,
  title? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs).data_set(
    "sumi-theme",
    mode.to_attr(),
  )
  // Native scrollbars and form controls follow the mode via color-scheme;
  // System allows both so the UA picks from prefers-color-scheme.
  let color_scheme = match mode {
    Dark => "color-scheme:dark"
    Light => "color-scheme:light"
    System => "color-scheme:dark light"
  }
  @html.fragment([
    sumi_token_stylesheet(mode),
    @internal.sumi_interaction_stylesheet(),
    @internal.sumi_event_guard_script(),
    @html.div(
      style=@internal.sumi_styles(
        [
          @internal.SumiBoxSizing,
          @internal.SumiFontSans,
          @internal.SumiTextRendering,
          color_scheme,
          "color:var(--sumi-text,#ffffff)",
        ],
        style,
      ),
      id?,
      class?,
      title?,
      attrs=element_attrs,
      children,
    ),
  ])
}
