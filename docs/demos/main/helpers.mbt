///|
/// Shared stage: every demo renders inside its own themed wrapper so the
/// token sheet and interaction layers are always present, no matter which
/// docs page mounts the demo.
fn stage_mode(mode : @sumi.ThemeMode, children : Array[Html]) -> Html {
  @sumi.theme(mode~, [
    @html.div(
      style=[
        "padding:28px 24px;display:flex;flex-wrap:wrap;align-items:center;gap:16px;background:var(--sumi-canvas,#0d0d0d)",
      ],
      children,
    ),
  ])
}

///|
fn stage(children : Array[Html]) -> Html {
  stage_mode(@sumi.Dark, children)
}

///|
fn row(children : Array[Html]) -> Html {
  @html.div(
    style=["display:flex;flex-wrap:wrap;align-items:center;gap:12px"],
    children,
  )
}

///|
fn column(gap : String, children : Array[Html]) -> Html {
  @html.div(
    style=[
      "display:flex;flex-direction:column;gap:" + gap + ";width:100%;max-width:420px",
    ],
    children,
  )
}

///|
fn hint(text : String) -> Html {
  @html.span(
    style=[
      "font-size:12px;line-height:20px;color:var(--sumi-text-placeholder,rgba(255,255,255,0.35))",
    ],
    text,
  )
}

///|
/// The small brand sparkle marking premium options in segmented controls.
fn sparkle_marker() -> Html {
  @html.span(
    style=["display:inline-flex;flex:none;color:var(--sumi-brand,#009efa)"],
    [@sumi.icon_sparkle(size=12)],
  )
}
