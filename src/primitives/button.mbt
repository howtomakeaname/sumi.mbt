///|
pub(all) enum ButtonVariant {
  Primary
  Secondary
  Ghost
} derive(Debug, Eq)

///|
pub extend ButtonVariant with Eq::{equal, not_equal}

///|
pub extend ButtonVariant with Debug::{to_repr}

///|
pub(all) enum ButtonSize {
  Default
  Sm
  Icon
  IconSm
} derive(Debug, Eq)

///|
pub extend ButtonSize with Eq::{equal, not_equal}

///|
pub extend ButtonSize with Debug::{to_repr}

///|
const ButtonBaseStyle : String = "position:relative;display:inline-flex;flex-shrink:0;align-items:center;justify-content:center;gap:4px;margin:0;border:none;border-radius:var(--sumi-radius,8px);font-size:13px;line-height:22px;font-weight:500;white-space:nowrap;cursor:pointer;user-select:none;appearance:none;-webkit-appearance:none;outline:none;vertical-align:middle"

///|
const ButtonPrimaryStyle : String = "padding:4px 16px;height:32px;background:var(--sumi-primary-bg,#fafafa);color:var(--sumi-primary-fg,#1a1a1a)"

///|
const ButtonPrimaryDisabledStyle : String = "background:var(--sumi-primary-bg-disabled,rgba(204,221,255,0.16));color:var(--sumi-primary-fg-disabled,rgba(224,245,255,0.2))"

///|
const ButtonSecondaryStyle : String = "padding:4px 16px;height:32px;background:var(--sumi-block,rgba(255,255,255,0.08));color:var(--sumi-text,#ffffff)"

///|
const ButtonGhostStyle : String = "padding:4px 8px;min-height:32px;background:transparent;color:var(--sumi-text,#ffffff)"

///|
const ButtonSmStyle : String = "padding:3px 12px;height:28px;font-size:12px;line-height:20px"

///|
const ButtonIconStyle : String = "padding:0;width:32px;height:32px"

///|
const ButtonIconSmStyle : String = "padding:0;width:28px;height:28px"

///|
fn button_variant_value(variant : ButtonVariant) -> String {
  match variant {
    Primary => "primary"
    Secondary => "secondary"
    Ghost => "ghost"
  }
}

///|
fn button_size_value(size : ButtonSize) -> String {
  match size {
    Default => "default"
    Sm => "sm"
    Icon => "icon"
    IconSm => "icon-sm"
  }
}

///|
fn button_variant_style(
  variant : ButtonVariant,
  disabled : Bool,
  pressed : Bool,
) -> String {
  match variant {
    Primary =>
      if disabled {
        ButtonPrimaryStyle + ";" + ButtonPrimaryDisabledStyle
      } else {
        ButtonPrimaryStyle
      }
    Secondary =>
      if disabled {
        ButtonSecondaryStyle +
        ";color:var(--sumi-text-disabled,rgba(255,255,255,0.2))"
      } else if pressed {
        ButtonSecondaryStyle +
        ";background:var(--sumi-block,rgba(255,255,255,0.08))"
      } else {
        ButtonSecondaryStyle
      }
    Ghost =>
      if disabled {
        ButtonGhostStyle +
        ";color:var(--sumi-text-disabled,rgba(255,255,255,0.2))"
      } else if pressed {
        ButtonGhostStyle +
        ";background:var(--sumi-block,rgba(255,255,255,0.08))"
      } else {
        ButtonGhostStyle
      }
  }
}

///|
fn button_size_style(variant : ButtonVariant, size : ButtonSize) -> String {
  match size {
    Default => ""
    Sm =>
      match variant {
        // Ghost sm is the menu-trigger size: keep the compact 8px gutter.
        Ghost => "height:28px;font-size:12px;line-height:20px"
        Primary | Secondary => ButtonSmStyle
      }
    Icon => ButtonIconStyle + ";padding:0"
    IconSm => ButtonIconSmStyle
  }
}

///|
/// Text buttons hold an 80px minimum so short labels ("OK", "Apply") keep
/// the design's standard footprint; ghost and icon sizes hug their content.
fn button_min_width_style(variant : ButtonVariant, size : ButtonSize) -> String {
  match variant {
    Ghost => ""
    Primary | Secondary =>
      match size {
        Default | Sm => "min-width:80px"
        Icon | IconSm => ""
      }
  }
}

///|
/// Render a button in one of the design's three variants.
///
/// * `Primary` — solid light fill with dark text, the main call to action.
/// * `Secondary` — translucent white fill.
/// * `Ghost` — transparent, fills on hover; the toolbar/menu-button look.
///
/// `pressed` marks a toggle-style button as the currently active tool: it
/// adds `aria-pressed` and the design's selected fill (same tone as hover).
///
/// `loading=true` keeps the default fill and the button's width: the content
/// stays rendered but invisible while a 16px spinner overlays its center, and
/// `aria-busy` is set; pass a `title` describing the busy action for screen
/// readers.
///
/// User styles are appended last and therefore override the built-in recipe.
pub fn[C : @html.IsChildren] button(
  variant? : ButtonVariant = Primary,
  size? : ButtonSize = Default,
  disabled? : Bool = false,
  pressed? : Bool = false,
  loading? : Bool = false,
  type_? : String = "button",
  id? : String,
  class? : String,
  title? : String,
  name? : String,
  value? : String,
  autofocus? : Bool,
  on_click? : @cmd.Cmd,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs)
    .data_set("slot", "button")
    .data_set("variant", button_variant_value(variant))
    .data_set("size", button_size_value(size))
  if disabled {
    ignore(element_attrs.aria_disabled("true"))
  }
  if pressed {
    ignore(element_attrs.aria_pressed(@internal.sumi_bool(true)))
  }
  if loading {
    ignore(element_attrs.aria_busy("true"))
  }
  let content : @html.Html = if loading {
    @html.fragment([
      @html.span(
        style=[
          "display:inline-flex;align-items:center;justify-content:center;gap:4px;visibility:hidden",
        ],
        attrs=@html.Attrs::build().aria_hidden("true"),
        [@internal.sumi_slot(children)],
      ),
      @html.span(
        style=[
          "position:absolute;inset:0;display:inline-flex;align-items:center;justify-content:center",
        ],
        [@feedback.spinner(size=16)],
      ),
    ])
  } else {
    @internal.sumi_slot(children)
  }
  @html.button(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        @internal.SumiTransition,
        ButtonBaseStyle,
        button_variant_style(variant, disabled, pressed),
        button_size_style(variant, size),
        button_min_width_style(variant, size),
        @internal.sumi_disabled_style(disabled || loading),
      ],
      style,
    ),
    id?,
    class?,
    title?,
    type_~,
    disabled~,
    name?,
    value?,
    autofocus?,
    on_click?,
    attrs=element_attrs,
    [content],
  )
}

///|
/// A square button for a single icon. Convenience wrapper over `button` with
/// `size=Icon`/`IconSm` and `variant=Ghost` by default.
pub fn icon_button(
  icon : @html.Html,
  variant? : ButtonVariant = Ghost,
  size? : ButtonSize = Icon,
  disabled? : Bool = false,
  pressed? : Bool = false,
  id? : String,
  class? : String,
  title? : String,
  aria_label? : String,
  on_click? : @cmd.Cmd,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs)
    .data_set("slot", "icon-button")
    .data_set("state", if pressed { "on" } else { "off" })
  if pressed {
    ignore(element_attrs.aria_pressed(@internal.sumi_bool(true)))
  }
  if aria_label is Some(label) {
    ignore(element_attrs.aria_label(label))
  }
  button(
    variant~,
    size~,
    disabled~,
    pressed~,
    id?,
    class?,
    title?,
    on_click?,
    attrs=element_attrs,
    style~,
    [icon],
  )
}
