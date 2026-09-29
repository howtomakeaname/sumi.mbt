///|
using @rabbita {type Val, type Html}

///|
/// Compose independent section graphs into one page graph.
fn stack(sections : Array[Val[Html]]) -> Val[Html] {
  sections.fold(init=Val::constant(@html.nothing), fn(acc, section) {
    acc.view2(section, (a, b) => @html.fragment([a, b]))
  })
}

///|
/// One registry demo with its caption, anchored for direct links. `None`
/// makes the stage follow the page theme, so the dark/light toggle re-skins
/// every demo in place and demo state survives the switch.
fn demo_block(d : @demos.Demo) -> Val[Html] {
  (d.build)(None).view(fn(h) {
    @html.div(
      style=["display:flex;flex-direction:column;gap:10px;max-width:720px"],
      attrs=@html.Attrs::build().id("demo-" + d.key),
      [
        @html.div(
          style=[
            "font-size:12px;line-height:20px;color:var(--sumi-text-placeholder,rgba(255,255,255,0.35))",
          ],
          d.title,
        ),
        h,
      ],
    )
  })
}

///|
/// A category section stacking every registry demo in that group.
fn category_section(group : String) -> Val[Html] {
  let blocks : Array[Val[Html]] = []
  for d in @demos.demos() {
    if d.group == group {
      blocks.push(demo_block(d))
    }
  }
  stack(blocks).view(fn(content) {
    @html.div(
      style=["display:flex;flex-direction:column;gap:20px;max-width:720px"],
      attrs=@html.Attrs::build().id("sec-" + group.to_lower()),
      [
        @html.div(
          style=[
            "font-size:12px;line-height:20px;letter-spacing:0.08em;color:var(--sumi-text-tertiary,rgba(255,255,255,0.6))",
          ],
          group.to_upper(),
        ),
        content,
      ],
    )
  })
}

///|
fn app() -> Val[Html] {
  let (mode, set_mode) = @rabbita.create_variable("dark")
  let sections : Array[Val[Html]] = []
  for group in @demos.demo_groups() {
    sections.push(category_section(group))
  }
  let content = stack(sections)
  mode.view2(content, fn(current_mode, c) {
    // Page backdrop outside the themed tree (overscroll, first paint):
    // styles.css pins the dark default; this rule overrides it in light.
    let page_bg = if current_mode == "light" { "#f0f0f2" } else { "#0d0d0d" }
    @sumi.theme(
      mode=if current_mode == "light" { @sumi.Light } else { @sumi.Dark },
      [
        @html.style_tag(attrs=@html.Attrs::build(), [
          @html.text("body{background:" + page_bg + "}"),
        ]),
        @html.div(
          style=["position:fixed;top:16px;right:16px;z-index:70"],
          @sumi.segmented(
            items=[
              @sumi.SegmentedItem::new("dark", "Dark"),
              @sumi.SegmentedItem::new("light", "Light"),
            ],
            selected=current_mode,
            on_select=set_mode.map(v => _ => v),
          ),
        ),
        @html.div(
          style=[
            "min-height:100vh;padding:48px;display:flex;flex-direction:column;gap:40px;background:var(--sumi-canvas,#0d0d0d);background-image:radial-gradient(circle,var(--sumi-stroke-secondary,rgba(255,255,255,0.04)) 1px,transparent 1px);background-size:24px 24px",
          ],
          [c],
        ),
      ],
    )
  })
}

///|
fn main {
  @rabbita.new(app).mount("app")
}
