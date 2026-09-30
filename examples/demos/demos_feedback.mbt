///|
fn demo_spinner_basic(mode : @sumi.ThemeMode?) -> Val[Html] {
  Val::constant(stage_mode(mode, [@sumi.spinner(), @sumi.spinner(size=24)]))
}

///|
fn demo_status_badge_basic(mode : @sumi.ThemeMode?) -> Val[Html] {
  Val::constant(
    stage_mode(mode, [
      @sumi.status_badge(state=Running(45)),
      @sumi.status_badge(state=Count(3)),
      @sumi.status_badge(state=Count(99)),
      @sumi.status_badge(state=Complete),
      @sumi.status_badge(state=Warning),
    ]),
  )
}

///|
fn demo_shimmer_text(mode : @sumi.ThemeMode?) -> Val[Html] {
  Val::constant(
    stage_mode(mode, [
      @sumi.shimmer_text("Working on it…"),
      @sumi.shimmer_text("Drafting the summary…"),
      @sumi.shimmer_text("Reading the files…"),
    ]),
  )
}

///|
fn demo_progress_basic(mode : @sumi.ThemeMode?) -> Val[Html] {
  Val::constant(
    stage_mode(mode, [
      column("12px", [
        @sumi.progress(value=72, show_value=true),
        @sumi.progress(value=30),
      ]),
    ]),
  )
}

///|
fn demo_skeleton_basic(mode : @sumi.ThemeMode?) -> Val[Html] {
  Val::constant(
    stage_mode(mode, [
      @sumi.skeleton_tile(width="160px", height="90px"),
      @html.div(style=["width:220px"], [@sumi.skeleton_lines(count=3)]),
      @sumi.skeleton(width="64px", height="64px", radius="50%"),
    ]),
  )
}

///|
fn demo_badge_basic(mode : @sumi.ThemeMode?) -> Val[Html] {
  Val::constant(
    stage_mode(mode, [
      @sumi.badge(value=5),
      @sumi.badge(value=120),
      @sumi.badge(dot=true),
    ]),
  )
}

///|
fn demo_empty_state_basic(mode : @sumi.ThemeMode?) -> Val[Html] {
  Val::constant(
    stage_mode(mode, [
      @sumi.card(style=["width:320px"], [
        @sumi.empty_state(
          title_text="No versions yet",
          description="Results will appear here.",
          icon=@sumi.icon_image(size=24),
          action=@sumi.button(variant=Secondary, size=Sm, "New Version"),
        ),
      ]),
    ]),
  )
}

///|
/// Inline validation notes on both fills.
fn demo_alert_basic(mode : @sumi.ThemeMode?) -> Val[Html] {
  Val::constant(
    stage_mode(mode, [
      column("12px", [
        @sumi.alert(
          message="Prompt exceeds the 800-word limit — shorten it before generating",
        ),
        @sumi.alert(
          variant=Subtle,
          message="Check the highlighted section before sending",
        ),
      ]),
    ]),
  )
}
