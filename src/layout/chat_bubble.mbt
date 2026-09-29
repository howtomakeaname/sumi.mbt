///|
/// The right-aligned bubble of a sent message. Plain text by default;
/// pass `children` to compose rich content (inline media tags and text
/// spans share the same baseline flow). Long messages can be clamped to
/// `collapse_lines` behind a fade with an Expand/Collapse toggle — the
/// caller owns `collapsed`. `on_copy` reveals a copy action below the
/// bubble on hover.
///
/// ```moonbit nocheck
/// chat_bubble(text="Continue")
/// chat_bubble(children=[
///   media_tag(kind=Image, variant=Inline, thumbnail=thumb),
///   @html.text("Add more detail"),
/// ])
/// chat_bubble(text=long, collapsible=true, collapsed=c, on_toggle=set_c.map(v => _ => !v))
/// ```
pub fn chat_bubble(
  text? : String,
  children? : Array[@html.Html],
  collapsible? : Bool = false,
  collapsed? : Bool = true,
  on_toggle? : @cmd.Cmd,
  collapse_lines? : Int = 9,
  on_copy? : @cmd.Cmd,
  aria_label? : String,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs).data_set(
    "slot", "chat-bubble",
  )
  if collapsible {
    ignore(
      element_attrs.data_set(
        "state",
        if collapsed {
          "collapsed"
        } else {
          "expanded"
        },
      ),
    )
  }
  if aria_label is Some(label_text) {
    ignore(element_attrs.aria_label(label_text))
  }
  let body_children : Array[@html.Html] = []
  if children is Some(rich) {
    body_children.push(
      @html.span(
        style=[
          "display:flex;flex-wrap:wrap;align-items:center;column-gap:8px;overflow:clip;font-size:14px;line-height:24px;color:var(--sumi-text,#ffffff)",
        ],
        attrs=@html.Attrs::build().data_set("slot", "chat-bubble-rich"),
        rich,
      ),
    )
  } else if text is Some(content) {
    let text_style = if collapsible && collapsed {
      "margin:0;font-size:14px;line-height:24px;color:var(--sumi-text,#ffffff);white-space:pre-wrap;word-break:break-word;display:-webkit-box;-webkit-box-orient:vertical;-webkit-line-clamp:\{collapse_lines};overflow:hidden"
    } else {
      "margin:0;font-size:14px;line-height:24px;color:var(--sumi-text,#ffffff);white-space:pre-wrap;word-break:break-word"
    }
    let text_children : Array[@html.Html] = [
      @html.p(style=[text_style], [@html.text(content)]),
    ]
    if collapsible && collapsed {
      text_children.push(
        @html.span(
          style=[
            "position:absolute;left:0;right:0;bottom:0;height:48px;background:linear-gradient(to top,var(--sumi-elevated,#222222) 50%,transparent);pointer-events:none",
          ],
          attrs=@html.Attrs::build()
            .data_set("slot", "chat-bubble-fade")
            .aria_hidden("true"),
          ([] : Array[@html.Html]),
        ),
      )
    }
    body_children.push(
      @html.span(style=["position:relative;display:block"], text_children),
    )
  }
  if collapsible && on_toggle is Some(toggle) {
    let toggle_children : Array[@html.Html] = [
      @html.text(if collapsed { "Expand" } else { "Collapse" }),
    ]
    if !collapsed {
      toggle_children.push(@primitives.icon_chevron_up_fill(size=14))
    }
    body_children.push(
      @html.button(
        style=[
          @internal.SumiBoxSizing,
          @internal.SumiFontSans,
          @internal.SumiTextRendering,
          @internal.SumiTransition,
          "display:inline-flex;align-items:center;gap:4px;margin:0;padding:0;border:none;background:transparent;font-size:14px;line-height:22px;color:var(--sumi-text-secondary,rgba(255,255,255,0.7));cursor:pointer;appearance:none;-webkit-appearance:none;outline:none",
        ],
        type_="button",
        on_click=toggle,
        attrs=@html.Attrs::build().data_set("slot", "chat-bubble-toggle"),
        toggle_children,
      ),
    )
  }
  let outer_children : Array[@html.Html] = [
    @html.span(
      style=[
        "display:flex;flex-direction:column;align-items:flex-start;justify-content:center;gap:8px;max-width:640px;padding:12px 16px;border-radius:16px;background:var(--sumi-block,rgba(255,255,255,0.08))",
      ],
      attrs=@html.Attrs::build().data_set("slot", "chat-bubble-body"),
      body_children,
    ),
  ]
  if on_copy is Some(copy) {
    outer_children.push(
      @html.button(
        style=[
          @internal.SumiBoxSizing,
          @internal.SumiTextRendering,
          @internal.SumiTransition,
          "position:absolute;bottom:-40px;right:0;display:flex;align-items:center;justify-content:center;width:36px;height:36px;margin:0;padding:0;border:none;border-radius:8px;background:transparent;color:var(--sumi-text-placeholder,rgba(255,255,255,0.35));cursor:pointer;appearance:none;-webkit-appearance:none;outline:none;opacity:0;pointer-events:none",
        ],
        type_="button",
        on_click=copy,
        attrs=@html.Attrs::build()
          .data_set("slot", "chat-bubble-copy")
          .aria_label("Copy message"),
        [@primitives.icon_copy(size=16)],
      ),
    )
  }
  @html.div(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        "position:relative;display:flex;flex-direction:column;align-items:flex-end;gap:4px;width:100%",
      ],
      style,
    ),
    id?,
    class?,
    attrs=element_attrs,
    outer_children,
  )
}
