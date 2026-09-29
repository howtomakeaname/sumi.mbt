///|
using @rabbita {type Val, type Html}

///|
/// One interactive demo: a stable key (docs placeholders reference it), the
/// category it belongs to, a short caption, and the builder. The builder
/// takes an optional theme mode: the docs site passes `Some(Dark)` so every
/// mounted demo carries its own theme, while the gallery passes `None` so
/// its theme toggle re-skins demos in place through CSS variables (demo
/// state survives the toggle). The theming demos pin their own mode.
pub struct Demo {
  key : String
  group : String
  title : String
  build : (@sumi.ThemeMode?) -> Val[Html]
}

///|
/// The demo registry, in display order. Single source of truth for both the
/// gallery (stacks every entry by group) and the docs site (mounts entries
/// by key). A function rather than a top-level value: top-level collection
/// literals of function entries hit a compiler diagnostic quirk.
pub fn demos() -> Array[Demo] {
  [
    {
      key: "button-basic",
      group: "Actions",
      title: "Variants & states",
      build: demo_button_basic,
    },
    {
      key: "button-sizes",
      group: "Actions",
      title: "Sizes",
      build: demo_button_sizes,
    },
    {
      key: "icon-button-basic",
      group: "Actions",
      title: "Icon buttons",
      build: demo_icon_button_basic,
    },
    {
      key: "favorite-toggle",
      group: "Actions",
      title: "Favorite toggle",
      build: demo_favorite_toggle_basic,
    },
    {
      key: "add-tile-basic",
      group: "Actions",
      title: "Add tile",
      build: demo_add_tile_basic,
    },
    {
      key: "toolbar-basic",
      group: "Actions",
      title: "Toolbar",
      build: demo_toolbar_basic,
    },
    {
      key: "input-basic",
      group: "Forms",
      title: "Prefix & clear",
      build: demo_input_basic,
    },
    {
      key: "input-states",
      group: "Forms",
      title: "States",
      build: demo_input_states,
    },
    {
      key: "textarea-basic",
      group: "Forms",
      title: "Textarea",
      build: demo_textarea_basic,
    },
    {
      key: "select-basic",
      group: "Forms",
      title: "Select",
      build: demo_select_basic,
    },
    {
      key: "select-filter",
      group: "Forms",
      title: "Filter trigger",
      build: demo_select_filter,
    },
    {
      key: "stepper-basic",
      group: "Forms",
      title: "Stepper",
      build: demo_stepper_basic,
    },
    {
      key: "switch-basic",
      group: "Forms",
      title: "Switch",
      build: demo_switch_basic,
    },
    {
      key: "checkbox-basic",
      group: "Forms",
      title: "Checkbox",
      build: demo_checkbox_basic,
    },
    {
      key: "slider-basic",
      group: "Forms",
      title: "With readout",
      build: demo_slider_basic,
    },
    {
      key: "slider-tooltip",
      group: "Forms",
      title: "Value bubble",
      build: demo_slider_tooltip,
    },
    {
      key: "slider-field",
      group: "Forms",
      title: "Ticks & number box",
      build: demo_slider_field,
    },
    { key: "chip-row", group: "Forms", title: "Chips", build: demo_chip_row, },
    {
      key: "attachment-strip",
      group: "Forms",
      title: "Attachment strip",
      build: demo_attachment_strip,
    },
    {
      key: "segmented-basic",
      group: "Forms",
      title: "Row mode",
      build: demo_segmented_basic,
    },
    {
      key: "segmented-stacked",
      group: "Forms",
      title: "Stacked ratios",
      build: demo_segmented_stacked,
    },
    {
      key: "prompt-box-basic",
      group: "Forms",
      title: "With action picker",
      build: demo_prompt_box_basic,
    },
    {
      key: "prompt-box-count",
      group: "Forms",
      title: "Character count",
      build: demo_prompt_box_count,
    },
    {
      key: "editable-text-basic",
      group: "Forms",
      title: "Click to rename",
      build: demo_editable_text_basic,
    },
    {
      key: "send-button-basic",
      group: "Forms",
      title: "Send button",
      build: demo_send_button_basic,
    },
    {
      key: "dropdown-menu-basic",
      group: "Overlays",
      title: "Rich items",
      build: demo_dropdown_menu_basic,
    },
    {
      key: "dropdown-menu-compact",
      group: "Overlays",
      title: "Shortcuts",
      build: demo_dropdown_menu_compact,
    },
    {
      key: "checkbox-menu",
      group: "Overlays",
      title: "Multi-select",
      build: demo_checkbox_menu,
    },
    {
      key: "context-menu-basic",
      group: "Overlays",
      title: "Right-click",
      build: demo_context_menu_basic,
    },
    {
      key: "popover-basic",
      group: "Overlays",
      title: "Popover",
      build: demo_popover_basic,
    },
    {
      key: "tooltip-basic",
      group: "Overlays",
      title: "Four sides",
      build: demo_tooltip_basic,
    },
    {
      key: "dialog-basic",
      group: "Overlays",
      title: "Dialog",
      build: demo_dialog_basic,
    },
    {
      key: "toast-basic",
      group: "Overlays",
      title: "Toasts",
      build: demo_toast_basic,
    },
    {
      key: "spinner-basic",
      group: "Feedback",
      title: "Spinner",
      build: demo_spinner_basic,
    },
    {
      key: "status-badge",
      group: "Feedback",
      title: "Status badge",
      build: demo_status_badge_basic,
    },
    {
      key: "shimmer-text",
      group: "Feedback",
      title: "Shimmer text",
      build: demo_shimmer_text,
    },
    {
      key: "progress-basic",
      group: "Feedback",
      title: "Progress",
      build: demo_progress_basic,
    },
    {
      key: "skeleton-basic",
      group: "Feedback",
      title: "Skeleton",
      build: demo_skeleton_basic,
    },
    {
      key: "badge-basic",
      group: "Feedback",
      title: "Badge",
      build: demo_badge_basic,
    },
    {
      key: "empty-state-basic",
      group: "Feedback",
      title: "Empty state",
      build: demo_empty_state_basic,
    },
    {
      key: "alert-basic",
      group: "Feedback",
      title: "Solid & subtle",
      build: demo_alert_basic,
    },
    {
      key: "avatar-basic",
      group: "Display",
      title: "Avatar",
      build: demo_avatar_basic,
    },
    { key: "tag-basic", group: "Display", title: "Tag", build: demo_tag_basic, },
    {
      key: "media-tag",
      group: "Display",
      title: "Media tag",
      build: demo_media_tag,
    },
    { key: "kbd-basic", group: "Display", title: "Kbd", build: demo_kbd_basic, },
    {
      key: "card-basic",
      group: "Display",
      title: "Bare card",
      build: demo_card_basic,
    },
    {
      key: "card-section",
      group: "Display",
      title: "Section card",
      build: demo_card_section,
    },
    {
      key: "tabs-basic",
      group: "Display",
      title: "Tabs",
      build: demo_tabs_basic,
    },
    {
      key: "pagination-basic",
      group: "Display",
      title: "Current / total",
      build: demo_pagination_basic,
    },
    {
      key: "shortcuts-panel",
      group: "Display",
      title: "Shortcuts panel",
      build: demo_shortcuts_panel,
    },
    {
      key: "credits-basic",
      group: "Display",
      title: "Credits",
      build: demo_credits_basic,
    },
    {
      key: "icons-basic",
      group: "Display",
      title: "Icon set",
      build: demo_icons_basic,
    },
    {
      key: "theme-light",
      group: "Theming",
      title: "Light palette",
      build: demo_theme_light,
    },
    {
      key: "theme-tokens",
      group: "Theming",
      title: "Token override",
      build: demo_theme_tokens,
    },
  ]
}

///|
/// Demo groups in gallery display order.
pub fn demo_groups() -> Array[String] {
  ["Actions", "Forms", "Overlays", "Feedback", "Display", "Theming"]
}

///|
/// Look up a demo builder by registry key (docs hydration path).
pub fn find_demo(name : String) -> ((@sumi.ThemeMode?) -> Val[Html])? {
  for d in demos() {
    if d.key == name {
      return Some(d.build)
    }
  }
  None
}
