///|
using @rabbita {type Val, type Html}

///|
/// Demo registry, keyed by the `data-sumi-demo` attribute used in the docs
/// markdown. Each builder owns its own state, so every mount is independent.
fn find_demo(name : String) -> (() -> Val[Html])? {
  match name {
    "button-basic" => Some(demo_button_basic)
    "button-sizes" => Some(demo_button_sizes)
    "icon-button-basic" => Some(demo_icon_button_basic)
    "toolbar-basic" => Some(demo_toolbar_basic)
    "input-basic" => Some(demo_input_basic)
    "input-states" => Some(demo_input_states)
    "textarea-basic" => Some(demo_textarea_basic)
    "select-basic" => Some(demo_select_basic)
    "stepper-basic" => Some(demo_stepper_basic)
    "switch-basic" => Some(demo_switch_basic)
    "checkbox-basic" => Some(demo_checkbox_basic)
    "slider-basic" => Some(demo_slider_basic)
    "slider-tooltip" => Some(demo_slider_tooltip)
    "segmented-basic" => Some(demo_segmented_basic)
    "segmented-stacked" => Some(demo_segmented_stacked)
    "prompt-box-basic" => Some(demo_prompt_box_basic)
    "prompt-box-count" => Some(demo_prompt_box_count)
    "send-button-basic" => Some(demo_send_button_basic)
    "dropdown-menu-basic" => Some(demo_dropdown_menu_basic)
    "dropdown-menu-compact" => Some(demo_dropdown_menu_compact)
    "context-menu-basic" => Some(demo_context_menu_basic)
    "popover-basic" => Some(demo_popover_basic)
    "tooltip-basic" => Some(demo_tooltip_basic)
    "dialog-basic" => Some(demo_dialog_basic)
    "toast-basic" => Some(demo_toast_basic)
    "spinner-basic" => Some(demo_spinner_basic)
    "progress-basic" => Some(demo_progress_basic)
    "skeleton-basic" => Some(demo_skeleton_basic)
    "badge-basic" => Some(demo_badge_basic)
    "empty-state-basic" => Some(demo_empty_state_basic)
    "avatar-basic" => Some(demo_avatar_basic)
    "tag-basic" => Some(demo_tag_basic)
    "kbd-basic" => Some(demo_kbd_basic)
    "card-basic" => Some(demo_card_basic)
    "card-section" => Some(demo_card_section)
    "tabs-basic" => Some(demo_tabs_basic)
    "credits-basic" => Some(demo_credits_basic)
    "icons-basic" => Some(demo_icons_basic)
    "theme-light" => Some(demo_theme_light)
    "theme-tokens" => Some(demo_theme_tokens)
    _ => None
  }
}

///|
let mount_counter : Ref[Int] = { val: 0 }

///|
/// Mount every not-yet-mounted demo placeholder currently in the document.
/// VitePress swaps page content on client-side navigation, so this runs on
/// load and again on every DOM mutation (observed below).
fn hydrate() -> Unit {
  let nodes = @dom.document().query_selector_all(
    "[data-sumi-demo]:not([data-sumi-mounted])",
  )
  for el in nodes.iter() {
    if el.get_attribute("data-sumi-demo") is Some(name) {
      match find_demo(name) {
        Some(builder) => {
          let id = "sumi-demo-" + name + "-" + mount_counter.val.to_string()
          mount_counter.val += 1
          el.set_attribute("id", id)
          el.set_attribute("data-sumi-mounted", "1")
          @rabbita.new(builder).mount(id)
        }
        None => el.set_attribute("data-sumi-mounted", "missing")
      }
    }
  }
}

///|
fn main {
  hydrate()
  let observer = @dom.MutationObserver::new(fn(_records, _observer) {
    hydrate()
  })
  if @dom.document().get_body() is Some(body) &&
    body.to_node() is Some(node) {
    observer.observe(node, child_list=true, subtree=true)
  }
}
