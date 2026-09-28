///|
fn demo_spinner_basic() -> Val[Html] {
  Val::constant(stage([@sumi.spinner(), @sumi.spinner(size=24)]))
}

///|
fn demo_progress_basic() -> Val[Html] {
  Val::constant(
    stage([
      column("12px", [
        @sumi.progress(value=72, show_value=true),
        @sumi.progress(value=30),
      ]),
    ]),
  )
}

///|
fn demo_skeleton_basic() -> Val[Html] {
  Val::constant(
    stage([
      @sumi.skeleton_tile(width="160px", height="90px"),
      @html.div(style=["width:220px"], [@sumi.skeleton_lines(count=3)]),
      @sumi.skeleton(width="64px", height="64px", radius="50%"),
    ]),
  )
}

///|
fn demo_badge_basic() -> Val[Html] {
  Val::constant(
    stage([
      @sumi.badge(value=5),
      @sumi.badge(value=120),
      @sumi.badge(dot=true),
    ]),
  )
}

///|
fn demo_empty_state_basic() -> Val[Html] {
  Val::constant(
    stage([
      @sumi.card(style=["width:320px"], [
        @sumi.empty_state(
          title_text="No versions yet",
          description="Generated results will appear here.",
          icon=@sumi.icon_image(size=24),
          action=@sumi.button(variant=Secondary, size=Sm, "New Version"),
        ),
      ]),
    ]),
  )
}
