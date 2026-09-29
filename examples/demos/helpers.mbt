///|
/// Shared stage: padded surface on the canvas token. With `Some(mode)` the
/// stage brings its own themed wrapper (docs site mounts, where each demo
/// must carry the token sheet and interaction layers itself). With `None`
/// the stage stays theme-less and follows the ambient theme — the gallery
/// uses this so its theme toggle re-skins every demo via CSS variables
/// without rebuilding them (demo state survives the toggle).
fn stage_mode(mode : @sumi.ThemeMode?, children : Array[Html]) -> Html {
  let surface = @html.div(
    style=[
      "padding:28px 24px;display:flex;flex-wrap:wrap;align-items:center;gap:16px;background:var(--sumi-canvas,#0d0d0d)",
    ],
    children,
  )
  match mode {
    Some(m) => @sumi.theme(mode=m, [surface])
    None => surface
  }
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
