///|
const GenerationMetaStyle : String = "display:flex;flex-direction:column;gap:12px;width:100%"

///|
const GenerationMetaTextStyle : String = "margin:0;font-size:14px;line-height:22px;color:var(--sumi-text-tertiary,rgba(255,255,255,0.6))"

///|
const GenerationMetaActionStyle : String = "display:inline-flex;align-items:center;justify-content:center;width:20px;height:20px;margin:0;padding:0;border:none;border-radius:4px;background:transparent;color:var(--sumi-text-tertiary,rgba(255,255,255,0.6));cursor:pointer;appearance:none;-webkit-appearance:none;outline:none"

///|
/// The info-and-actions block under a generation result: a 14/22 tertiary
/// disclaimer line (e.g. the content notice and the credits spent) with a
/// bare copy action below it. Render the action by passing `on_copy`.
///
/// ```moonbit nocheck
/// generation_meta(
///   text="AI-generated content | 0 credits used",
///   on_copy=emit(CopyResult),
/// )
/// ```
pub fn generation_meta(
  text~ : String,
  on_copy? : @cmd.Cmd,
  copy_label? : String = "Copy",
  aria_label? : String,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs).data_set(
    "slot", "generation-meta",
  )
  if aria_label is Some(label_text) {
    ignore(element_attrs.aria_label(label_text))
  }
  let children : Array[@html.Html] = [
    @html.p(style=[GenerationMetaTextStyle], [@html.text(text)]),
  ]
  if on_copy is Some(cmd) {
    children.push(
      @html.div(style=["display:flex;align-items:center"], [
        @html.button(
          style=[
            @internal.SumiBoxSizing,
            @internal.SumiTextRendering,
            @internal.SumiTransition,
            GenerationMetaActionStyle,
          ],
          type_="button",
          title=copy_label,
          on_click=cmd,
          attrs=@html.Attrs::build()
            .data_set("slot", "generation-meta-action")
            .aria_label(copy_label),
          [@primitives.icon_copy(size=16)],
        ),
      ]),
    )
  }
  @html.div(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        GenerationMetaStyle,
      ],
      style,
    ),
    id?,
    class?,
    attrs=element_attrs,
    children,
  )
}
