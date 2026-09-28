///|
/// One entry in a `dropdown_menu`. Rendered as a rich row (thumbnail +
/// title + description + check mark) when `description` is present,
/// otherwise as a compact icon-label row. `shortcut` renders a muted
/// right-aligned key hint (e.g. `"⌘E"`).
pub(all) struct MenuItem {
  value : String
  label : String
  description : String?
  icon : @html.Html?
  shortcut : String?
  disabled : Bool
}

///|
pub fn MenuItem::new(
  value : String,
  label : String,
  description? : String,
  icon? : @html.Html,
  shortcut? : String,
  disabled? : Bool = false,
) -> MenuItem {
  { value, label, description, icon, shortcut, disabled, }
}

///|
/// The content of a menu: a list of selectable items with optional
/// separators and section labels between groups.
pub(all) enum MenuEntry {
  Item(MenuItem)
  Separator
  SectionLabel(String)
}

///|
/// Convenience for the common case — wrap a plain item list.
pub fn MenuEntry::items(items : Array[MenuItem]) -> Array[MenuEntry] {
  items.map(fn(item) { Item(item) })
}

///|
pub(all) enum MenuAlign {
  Start
  End
} derive(Debug, Eq)

///|
pub extend MenuAlign with Eq::{equal, not_equal}

///|
pub extend MenuAlign with Debug::{to_repr}

///|
pub(all) enum MenuSide {
  Bottom
  Top
} derive(Debug, Eq)

///|
pub extend MenuSide with Eq::{equal, not_equal}

///|
pub extend MenuSide with Debug::{to_repr}

///|
const MenuContainerStyle : String = "position:absolute;z-index:50;display:flex;flex-direction:column;gap:2px;min-width:240px;padding:4px;border:1px solid var(--sumi-stroke-secondary,rgba(255,255,255,0.04));border-radius:var(--sumi-radius-lg,12px);background:var(--sumi-menu,#262626);box-shadow:var(--sumi-shadow-menu,0px 8px 56px 0px rgba(0,0,0,0.24))"

///|
const MenuItemBaseStyle : String = "display:flex;align-items:center;gap:8px;width:100%;min-height:36px;padding:9px 12px;border:none;border-radius:var(--sumi-radius,8px);background:transparent;font-size:13px;line-height:22px;font-weight:400;color:var(--sumi-text,#ffffff);text-align:left;cursor:pointer;user-select:none;appearance:none;-webkit-appearance:none;outline:none"

///|
const MenuItemRichStyle : String = "padding:8px 16px 8px 12px;min-height:64px;gap:12px;border-radius:var(--sumi-radius-lg,12px)"

///|
const MenuItemSelectedStyle : String = "background:var(--sumi-block,rgba(255,255,255,0.08))"

///|
const MenuLabelStyle : String = "flex:1 1 0%;overflow:hidden;text-overflow:ellipsis;white-space:nowrap"

///|
const MenuDescriptionStyle : String = "overflow:hidden;text-overflow:ellipsis;white-space:nowrap;font-size:12px;line-height:20px;color:var(--sumi-text-placeholder,rgba(255,255,255,0.35))"

///|
const MenuOverlayStyle : String = "position:fixed;inset:0;z-index:40;background:transparent"

///|
const MenuSeparatorStyle : String = "height:1px;margin:4px 2px;background:var(--sumi-stroke-secondary,rgba(255,255,255,0.04))"

///|
const MenuSectionLabelStyle : String = "padding:6px 12px 2px;font-size:11px;line-height:16px;font-weight:500;color:var(--sumi-text-placeholder,rgba(255,255,255,0.35));user-select:none"

///|
const MenuShortcutStyle : String = "margin-left:auto;padding-left:16px;font-size:12px;line-height:20px;color:var(--sumi-text-placeholder,rgba(255,255,255,0.35))"

///|
fn menu_align_style(align : MenuAlign) -> String {
  match align {
    Start => "left:0"
    End => "right:0"
  }
}

///|
fn menu_align_value(align : MenuAlign) -> String {
  match align {
    Start => "start"
    End => "end"
  }
}

///|
fn menu_side_style(side : MenuSide) -> String {
  match side {
    Bottom => "top:calc(100% + 6px)"
    Top => "bottom:calc(100% + 6px)"
  }
}

///|
fn menu_side_value(side : MenuSide) -> String {
  match side {
    Bottom => "bottom"
    Top => "top"
  }
}

///|
fn menu_item_view(
  item : MenuItem,
  selected : String?,
  on_click : @cmd.Cmd?,
) -> @html.Html {
  let is_selected = match selected {
    Some(value) => value == item.value
    None => false
  }
  let rich = item.description is Some(_)
  let item_attrs = @html.Attrs::build().data_set("slot", "menu-item")
  if item.disabled {
    ignore(item_attrs.aria_disabled("true"))
  }
  let leading : @html.Html = match item.icon {
    Some(icon) =>
      if rich {
        @html.span(
          style=[
            "display:inline-flex;flex:none;align-items:center;justify-content:center;width:40px;height:40px;border:1px solid var(--sumi-stroke-secondary,rgba(255,255,255,0.04));border-radius:var(--sumi-radius,8px)",
          ],
          [icon],
        )
      } else {
        @html.span(
          style=[
            "display:inline-flex;flex:none;align-items:center;justify-content:center;width:20px;height:20px",
          ],
          [icon],
        )
      }
    None => @html.nothing
  }
  let text_block = if rich {
    @html.div(
      style=["display:flex;flex:1 1 0%;flex-direction:column;min-width:0"],
      [
        @html.div(
          style=[
            @internal.SumiFontNum,
            MenuLabelStyle,
            "font-size:14px;line-height:22px;font-weight:400;color:var(--sumi-text,#ffffff)",
          ],
          item.label,
        ),
        @html.div(style=[MenuDescriptionStyle], item.description.unwrap_or("")),
      ],
    )
  } else {
    @html.span(style=[MenuLabelStyle], item.label)
  }
  let trailing : @html.Html = if is_selected {
    @html.span(
      style=["display:inline-flex;flex:none;color:var(--sumi-text,#ffffff)"],
      [@primitives.icon_check(size=16)],
    )
  } else {
    @html.nothing
  }
  let shortcut_view : @html.Html = match item.shortcut {
    Some(shortcut) =>
      @html.span(
        style=[@internal.SumiFontNum, MenuShortcutStyle],
        attrs=@html.Attrs::build().data_set("slot", "menu-shortcut"),
        shortcut,
      )
    None => @html.nothing
  }
  @html.button(
    style=[
      @internal.SumiBoxSizing,
      @internal.SumiFontSans,
      @internal.SumiTextRendering,
      @internal.SumiTransition,
      MenuItemBaseStyle,
      if rich {
        MenuItemRichStyle
      } else {
        ""
      },
      if is_selected {
        MenuItemSelectedStyle
      } else {
        ""
      },
      if item.disabled {
        @internal.SumiDisabled +
        ";color:var(--sumi-text-disabled,rgba(255,255,255,0.2))"
      } else {
        ""
      },
    ],
    type_="button",
    disabled=item.disabled,
    on_click?,
    attrs=item_attrs,
    [leading, text_block, shortcut_view, trailing],
  )
}

///|
fn menu_entry_view(
  entry : MenuEntry,
  selected : String?,
  click_for : (MenuItem) -> @cmd.Cmd?,
) -> @html.Html {
  match entry {
    Item(item) => menu_item_view(item, selected, click_for(item))
    Separator =>
      @html.div(
        style=[MenuSeparatorStyle],
        attrs=@html.Attrs::build()
          .data_set("slot", "menu-separator")
          .role("separator")
          .aria_hidden("true"),
        "",
      )
    SectionLabel(text) =>
      @html.div(
        style=[@internal.SumiFontSans, MenuSectionLabelStyle],
        attrs=@html.Attrs::build().data_set("slot", "menu-section-label"),
        text,
      )
  }
}

///|
/// The chevron for menu triggers. It carries the `menu-chevron` slot, so the
/// interaction sheet rotates it 180° while the parent dropdown is open.
pub fn menu_chevron(size? : Int = 12) -> @html.Html {
  @html.span(
    style=[
      "display:inline-flex;flex:none;align-items:center;justify-content:center",
    ],
    attrs=@html.Attrs::build()
      .data_set("slot", "menu-chevron")
      .aria_hidden("true"),
    [@primitives.icon_chevron_down(size~)],
  )
}

///|
/// A dropdown menu with a caller-supplied trigger. Fully controlled: the
/// caller owns both the open flag (`open` + `on_open_change`) and the
/// selected value (`selected` + `on_select`). Closes on outside click and
/// Escape; when open, Arrow/Home/End keys move focus between items and
/// Enter activates the focused item (handled by the theme's static event
/// layer, so callers wire nothing extra).
///
/// `side=Top` opens the panel above the trigger (input docks at the bottom
/// of the page); the enter animation's transform origin follows `side` and
/// `align`. `menu_style` appends overrides to the panel (e.g. a width).
///
/// ```moonbit nocheck
/// dropdown_menu(
///   trigger=button(variant=Ghost, [text(model_label), menu_chevron()]),
///   open=menu_open,
///   on_open_change=set_menu_open.map(v => _ => v),
///   items=MenuEntry::items([MenuItem::new("sd", "Sketch Diffusion")]),
///   selected=model,
///   on_select=set_model.map(v => _ => v),
/// )
/// ```
pub fn dropdown_menu(
  items~ : Array[MenuEntry],
  trigger~ : @html.Html,
  open~ : Bool,
  on_open_change? : @internal.Emit[Bool],
  selected? : String,
  on_select? : @internal.Emit[String],
  align? : MenuAlign = Start,
  side? : MenuSide = Bottom,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  trigger_style? : Array[String] = [],
  menu_style? : Array[String] = [],
) -> @html.Html {
  let close : @cmd.Cmd? = on_open_change.map(emit => emit(false))
  let toggle : @cmd.Cmd? = on_open_change.map(emit => emit(!open))
  let menu : @html.Html = {
    // The overlay and panel stay mounted and toggle `hidden`, so the
    // `display ... allow-discrete` transition in the interaction sheet can
    // animate both the enter and the exit instead of cutting off abruptly.
    let overlay : @html.Html = match close {
      Some(cmd) =>
        @html.div(
          style=[MenuOverlayStyle],
          hidden=!open,
          on_click=cmd,
          attrs=@html.Attrs::build()
            .data_set("slot", "menu-overlay")
            .aria_hidden("true"),
          "",
        )
      None => @html.nothing
    }
    let click_for = fn(item : MenuItem) -> @cmd.Cmd? {
      if item.disabled {
        None
      } else {
        let select_cmd = on_select.map(emit => emit(item.value))
        match (close, select_cmd) {
          (Some(c), Some(s)) => Some(@cmd.batch([c, s]))
          (Some(c), None) => Some(c)
          (None, Some(s)) => Some(s)
          (None, None) => None
        }
      }
    }
    let item_views = items.map(entry => {
      menu_entry_view(entry, selected, click_for)
    })
    @html.fragment([
      overlay,
      @html.div(
        style=@internal.sumi_styles(
          [
            @internal.SumiBoxSizing,
            @internal.SumiFontSans,
            @internal.SumiTextRendering,
            MenuContainerStyle,
            menu_align_style(align),
            menu_side_style(side),
          ],
          menu_style,
        ),
        hidden=!open,
        attrs=@html.Attrs::build()
          .data_set("slot", "menu")
          .data_set("side", menu_side_value(side))
          .data_set("align", menu_align_value(align))
          .role("menu"),
        item_views,
      ),
    ])
  }
  let element_attrs = @internal.sumi_attrs(attrs)
    .data_set("slot", "dropdown")
    .data_set("state", if open { "open" } else { "closed" })
  let trigger_attrs = @html.Attrs::build().data_set("slot", "dropdown-trigger")
  if toggle is Some(cmd) {
    ignore(trigger_attrs.on_click(_ => cmd))
  }
  @html.div(
    style=@internal.sumi_styles(
      [@internal.SumiBoxSizing, "position:relative;display:inline-flex"],
      style,
    ),
    id?,
    class?,
    attrs=element_attrs,
    [
      @html.div(
        style=@internal.sumi_styles(["display:inline-flex"], trigger_style),
        attrs=trigger_attrs,
        [trigger],
      ),
      menu,
    ],
  )
}
