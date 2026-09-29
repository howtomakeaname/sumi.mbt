///|
/// Public façade: every component is re-exported here so callers use a
/// single import (`@sumi.button`, `@sumi.select`, …) while the
/// implementation stays organized in category packages. When adding a
/// component, add it to the matching `pub using` block — the committed
/// `pkg.generated.mbti` snapshot will flag a missing entry.

///|
pub using @primitives {
  avatar,
  badge,
  button,
  credits,
  icon,
  icon_adjust,
  icon_arrow_down,
  icon_arrow_up,
  icon_button,
  icon_check,
  icon_chevron_down,
  icon_chevron_left,
  icon_chevron_right,
  icon_chevron_up,
  icon_clock,
  icon_crop,
  icon_download,
  icon_expand,
  icon_grid,
  icon_image,
  icon_important,
  icon_layers,
  icon_minus,
  icon_more,
  icon_play,
  icon_plus,
  icon_ratio,
  icon_reset,
  icon_scissors,
  icon_search,
  icon_sparkle,
  icon_upload,
  icon_x,
  kbd,
  spinner,
  tag,
  type ButtonSize,
  type ButtonVariant,
  type TagVariant,
}

///|
pub using @feedback {
  alert,
  empty_state,
  progress,
  skeleton,
  skeleton_lines,
  skeleton_tile,
  type AlertVariant,
}

///|
pub using @layout {
  card,
  card_section,
  divider,
  tabs,
  toolbar,
  toolbar_divider,
  type TabEntry,
}

///|
pub using @forms {
  checkbox,
  input,
  prompt_box,
  segmented,
  select,
  send_button,
  slider,
  stepper,
  switch,
  textarea,
  type SegmentedItem,
}

///|
pub using @overlays {
  context_menu,
  dialog,
  dropdown_menu,
  menu_chevron,
  popover,
  toast,
  tooltip,
  type MenuAlign,
  type MenuEntry,
  type MenuItem,
  type MenuSide,
  type ToastVariant,
  type TooltipSide,
}
