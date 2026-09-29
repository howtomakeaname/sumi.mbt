///|
/// The agent status line's in-progress look: a dim band sweeping endlessly
/// across otherwise readable text. The gradient is clipped to the glyphs
/// (`background-clip:text`), so the sweep rides on the letterforms rather
/// than the box. The `sumi-shimmer-text` keyframes live in the interaction
/// sheet; reduced motion freezes the sweep.
///
/// ```moonbit nocheck
/// shimmer_text("Working on it…")
/// ```
pub fn shimmer_text(
  text : String,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs).data_set(
    "slot", "shimmer-text",
  )
  @html.span(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        ShimmerTextStyle,
      ],
      style,
    ),
    id?,
    class?,
    attrs=element_attrs,
    [@html.text(text)],
  )
}

///|
const ShimmerTextStyle : String = "display:inline-block;font-size:14px;line-height:22px;font-weight:500;background:linear-gradient(90deg,var(--sumi-text-tertiary,rgba(255,255,255,0.6)) 0%,var(--sumi-text-tertiary,rgba(255,255,255,0.6)) 30%,var(--sumi-text-disabled,rgba(255,255,255,0.2)) 50%,var(--sumi-text-tertiary,rgba(255,255,255,0.6)) 70%,var(--sumi-text-tertiary,rgba(255,255,255,0.6)) 100%);background-size:200% 100%;-webkit-background-clip:text;background-clip:text;color:transparent;animation:sumi-shimmer-text 2s linear infinite"
