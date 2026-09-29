///|
/// Public façade: every component is re-exported here so callers use a
/// single import (`@sumi.button`, `@sumi.select`, …) while the
/// implementation stays organized in category packages. When adding a
/// component, add it to the matching `pub using` block — the committed
/// `pkg.generated.mbti` snapshot will flag a missing entry.

///|
pub using @primitives {
  add_tile,
  avatar,
  badge,
  button,
  credits,
  favorite_toggle,
  icon,
  icon_adjust,
  icon_caret_down,
  icon_arrow_down,
  icon_arrow_up,
  icon_button,
  icon_check,
  icon_check_fill,
  icon_chevron_down,
  icon_chevron_left,
  icon_chevron_right,
  icon_chevron_up,
  icon_clock,
  icon_close_circle,
  icon_crop,
  icon_download,
  icon_expand,
  icon_folder,
  icon_grid,
  icon_image,
  icon_important,
  icon_info_circle_fill,
  icon_layers,
  icon_minus,
  icon_more,
  icon_play,
  icon_plus,
  icon_plus_fill,
  icon_ratio,
  icon_reset,
  icon_scissors,
  icon_search,
  icon_slash,
  icon_sparkle,
  icon_star,
  icon_star_fill,
  icon_target,
  icon_tick_circle_fill,
  icon_upload,
  icon_upload_fill,
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
  status_badge,
  type AlertVariant,
  type StatusBadgeState,
}

///|
pub using @layout {
  card,
  card_section,
  divider,
  pagination,
  tabs,
  toolbar,
  toolbar_divider,
  type TabEntry,
}

///|
pub using @forms {
  editable_text,
  checkbox,
  chip,
  input,
  prompt_box,
  segmented,
  select,
  send_button,
  slider,
  slider_field,
  stepper,
  switch,
  textarea,
  type SegmentedItem,
  type SelectVariant,
}

///|
pub using @overlays {
  checkbox_menu,
  context_menu,
  dialog,
  dropdown_menu,
  menu_chevron,
  popover,
  toast,
  tooltip,
  type CheckboxMenuGroup,
  type CheckboxMenuItem,
  type MenuAlign,
  type MenuEntry,
  type MenuItem,
  type MenuSide,
  type ToastVariant,
  type TooltipSide,
}
