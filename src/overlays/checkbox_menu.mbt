///|
/// One row in a `checkbox_menu` group: a label with an optional leading
/// icon that toggles independently of the other rows.
pub(all) struct CheckboxMenuItem {
  value : String
  label : String
  icon : @html.Html?
  checked : Bool
  disabled : Bool
}

///|
pub fn CheckboxMenuItem::new(
  value : String,
  label : String,
  icon? : @html.Html,
  checked? : Bool = false,
  disabled? : Bool = false,
) -> CheckboxMenuItem {
  { value, label, icon, checked, disabled, }
}

///|
/// A titled section of a `checkbox_menu`. Passing `clear_label` renders the
/// small text action at the title row's right edge (meant to clear the
/// group's selection); without a `title` it is ignored. A hairline divider
/// is inserted between consecutive groups, never after the last one.
pub(all) struct CheckboxMenuGroup {
  title : String?
  clear_label : String?
  on_clear : @cmd.Cmd?
  items : Array[CheckboxMenuItem]
}

///|
pub fn CheckboxMenuGroup::new(
  items : Array[CheckboxMenuItem],
  title? : String,
  clear_label? : String,
  on_clear? : @cmd.Cmd,
) -> CheckboxMenuGroup {
  { title, clear_label, on_clear, items, }
}

///|
const CheckboxMenuStyle : String = "display:flex;flex-direction:column;padding:4px;border-radius:var(--sumi-radius-lg,12px);background:var(--sumi-menu,#262626);box-shadow:var(--sumi-shadow-menu,0px 8px 56px 0px rgba(0,0,0,0.24));overflow:hidden"

///|
const CheckboxMenuBodyStyle : String = "display:flex;flex:1 1 0%;min-height:0;flex-direction:column;gap:4px;overflow-y:auto"

///|
const CheckboxMenuGroupStyle : String = "display:flex;flex-direction:column;gap:4px"

///|
const CheckboxMenuTitleStyle : String = "display:flex;align-items:center;justify-content:space-between;padding:8px 12px 4px;font-size:12px;line-height:20px;color:var(--sumi-text-caption,rgba(255,255,255,0.5));user-select:none"

///|
const CheckboxMenuClearStyle : String = "display:inline-flex;align-items:center;justify-content:center;height:20px;margin:0;padding:0;border:none;background:transparent;font-size:12px;line-height:20px;color:var(--sumi-text-caption,rgba(255,255,255,0.5));cursor:pointer;appearance:none;-webkit-appearance:none;outline:none"

///|
const CheckboxMenuItemStyle : String = "display:flex;align-items:center;gap:8px;width:100%;height:36px;max-height:36px;min-height:36px;padding:9px 10px 9px 12px;border:none;border-radius:var(--sumi-radius,8px);background:transparent;font-size:13px;line-height:22px;font-weight:400;color:var(--sumi-text,#ffffff);text-align:left;cursor:pointer;user-select:none;appearance:none;-webkit-appearance:none;outline:none"

///|
const CheckboxMenuIconStyle : String = "display:inline-flex;flex:none;align-items:center;justify-content:center;width:16px;height:16px"

///|
const CheckboxMenuLabelStyle : String = "flex:1 1 0%;min-width:0;overflow:hidden;text-overflow:ellipsis;white-space:nowrap"

///|
const CheckboxMenuCheckStyle : String = "position:relative;flex:none;width:20px;height:20px;overflow:hidden;transition:opacity 100ms cubic-bezier(0.4,0,0.2,1)"

///|
const CheckboxMenuDividerStyle : String = "display:flex;flex:none;height:4px;max-height:4px;min-height:4px;padding:0 12px"

///|
const CheckboxMenuDividerLineStyle : String = "width:100%;height:1px;background:var(--sumi-stroke-divider,rgba(255,255,255,0.12))"

///|
const CheckboxMenuFooterStyle : String = "display:flex;flex:none;flex-direction:column;padding-right:4px"

///|
const CheckboxMenuFooterRowStyle : String = "display:flex;align-items:center;gap:8px;width:100%;height:36px;max-height:36px;min-height:36px;padding:9px 12px;border:none;border-radius:var(--sumi-radius,8px);background:transparent;font-size:13px;line-height:22px;font-weight:400;color:var(--sumi-text,#ffffff);text-align:left;cursor:pointer;user-select:none;appearance:none;-webkit-appearance:none;outline:none"

///|
/// The hairline between groups (`top=false`, vertically centered) and above
/// the sticky footer (`top=true`, hugging the boundary).
fn checkbox_menu_divider(top? : Bool = false) -> @html.Html {
  @html.div(
    style=[
      CheckboxMenuDividerStyle,
      if top {
        "align-items:flex-start"
      } else {
        "align-items:center"
      },
    ],
    attrs=@html.Attrs::build()
      .data_set("slot", "checkbox-menu-divider")
      .role("separator")
      .aria_hidden("true"),
    [@html.div(style=[CheckboxMenuDividerLineStyle], "")],
  )
}

///|
fn checkbox_menu_title_row(group : CheckboxMenuGroup) -> @html.Html {
  let clear : Array[@html.Html] = match group.clear_label {
    Some(label) =>
      [
        @html.button(
          style=[
            @internal.SumiBoxSizing,
            @internal.SumiFontSans,
            CheckboxMenuClearStyle,
          ],
          type_="button",
          on_click?=group.on_clear,
          attrs=@html.Attrs::build().data_set("slot", "checkbox-menu-clear"),
          label,
        ),
      ]
    None => []
  }
  @html.div(
    style=[@internal.SumiFontSans, CheckboxMenuTitleStyle],
    attrs=@html.Attrs::build().data_set("slot", "checkbox-menu-title"),
    [@html.span(style=[], group.title.unwrap_or("")), ..clear],
  )
}

///|
fn checkbox_menu_row(
  item : CheckboxMenuItem,
  on_toggle : @internal.Emit[String]?,
) -> @html.Html {
  let row_attrs = @html.Attrs::build()
    .data_set("slot", "checkbox-menu-item")
    .role("menuitemcheckbox")
    .aria_checked(@internal.sumi_bool(item.checked))
  if item.disabled {
    ignore(row_attrs.aria_disabled("true"))
  }
  let leading : @html.Html = match item.icon {
    Some(icon) => @html.span(style=[CheckboxMenuIconStyle], [icon])
    None => @html.nothing
  }
  let glyph : Array[@html.Html] = if item.checked {
    [@primitives.icon_check_fill(size=12)]
  } else {
    []
  }
  let box_border = if item.checked {
    "border:1px solid var(--sumi-text,#ffffff)"
  } else {
    "border:1px solid var(--sumi-text-secondary,rgba(255,255,255,0.8))"
  }
  // Unchecked rows hide the box until hover/active (the interaction sheet
  // flips its opacity); checked rows keep the bordered tick visible.
  let check = @html.span(
    style=[
      CheckboxMenuCheckStyle,
      if item.checked {
        "opacity:1"
      } else {
        "opacity:0"
      },
    ],
    attrs=@html.Attrs::build()
      .data_set("slot", "checkbox-menu-check")
      .aria_hidden("true"),
    [
      @html.span(
        style=["position:absolute;inset:10%;border-radius:4px", box_border],
        ([] : Array[@html.Html]),
      ),
      @html.span(
        style=[
          "position:absolute;inset:20%;display:flex;align-items:center;justify-content:center;color:var(--sumi-text,#ffffff)",
        ],
        glyph,
      ),
    ],
  )
  @html.button(
    style=[
      @internal.SumiBoxSizing,
      @internal.SumiFontSans,
      @internal.SumiTextRendering,
      @internal.SumiTransition,
      CheckboxMenuItemStyle,
      if item.disabled {
        @internal.SumiDisabled +
        ";color:var(--sumi-text-faint,rgba(255,255,255,0.4))"
      } else {
        ""
      },
    ],
    type_="button",
    disabled=item.disabled,
    on_click?=on_toggle.map(emit => emit(item.value)),
    attrs=row_attrs,
    [leading, @html.span(style=[CheckboxMenuLabelStyle], item.label), check],
  )
}

///|
fn checkbox_menu_group_view(
  group : CheckboxMenuGroup,
  last~ : Bool,
  on_toggle : @internal.Emit[String]?,
) -> @html.Html {
  let children : Array[@html.Html] = []
  if group.title is Some(_) {
    children.push(checkbox_menu_title_row(group))
  }
  for item in group.items {
    children.push(checkbox_menu_row(item, on_toggle))
  }
  if !last {
    children.push(checkbox_menu_divider())
  }
  @html.div(
    style=[CheckboxMenuGroupStyle],
    attrs=@html.Attrs::build()
      .data_set("slot", "checkbox-menu-group")
      .role("group"),
    children,
  )
}

///|
/// A multi-select menu panel: grouped rows with an outline checkbox on the
/// right edge, toggled independently, so picking a row never closes anything.
/// Fully controlled — the caller owns each row's `checked` flag; `on_toggle`
/// emits the `value` of the row that was clicked. Unchecked rows reveal an
/// empty box on hover/press; checked rows always show the ticked box.
///
/// `width` follows the design's size steps (160 / 200 / 240 / 320, default
/// 200); the body scrolls once the content exceeds `max_height` (default
/// 480). `footer_label` pins a plain row (optional `footer_icon`, activated
/// through `on_footer`) below the scroll area, under a hairline.
///
/// The panel is unpositioned: wrap it in a dropdown/popover container to
/// anchor it to a trigger.
///
/// ```moonbit nocheck
/// checkbox_menu(
///   groups=[
///     CheckboxMenuGroup::new(
///       [
///         CheckboxMenuItem::new("text", "Text", checked=true),
///         CheckboxMenuItem::new("date", "Date"),
///       ],
///       title="Fields",
///       clear_label="Clear",
///       on_clear=clear_fields,
///     ),
///   ],
///   on_toggle=toggle_field.map(v => _ => v),
/// )
/// ```
pub fn checkbox_menu(
  groups~ : Array[CheckboxMenuGroup],
  on_toggle? : @internal.Emit[String],
  width? : Int = 200,
  max_height? : Int = 480,
  footer_label? : String,
  footer_icon? : @html.Html,
  on_footer? : @cmd.Cmd,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs)
    .data_set("slot", "checkbox-menu")
    .role("menu")
  let group_count = groups.length()
  let group_views = groups.mapi(fn(i, group) {
    checkbox_menu_group_view(group, last=i == group_count - 1, on_toggle)
  })
  let footer : Array[@html.Html] = match footer_label {
    Some(label) => {
      let icon_view : @html.Html = match footer_icon {
        Some(icon) => @html.span(style=[CheckboxMenuIconStyle], [icon])
        None => @html.nothing
      }
      [
        @html.div(
          style=[CheckboxMenuFooterStyle],
          attrs=@html.Attrs::build().data_set("slot", "checkbox-menu-footer"),
          [
            checkbox_menu_divider(top=true),
            @html.button(
              style=[
                @internal.SumiBoxSizing,
                @internal.SumiFontSans,
                @internal.SumiTextRendering,
                @internal.SumiTransition,
                CheckboxMenuFooterRowStyle,
              ],
              type_="button",
              on_click?=on_footer,
              attrs=@html.Attrs::build()
                .data_set("slot", "checkbox-menu-footer-row")
                .role("menuitem"),
              [icon_view, @html.span(style=[CheckboxMenuLabelStyle], label)],
            ),
          ],
        ),
      ]
    }
    None => []
  }
  @html.div(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        CheckboxMenuStyle,
        "width:\{width}px;max-height:\{max_height}px",
      ],
      style,
    ),
    id?,
    class?,
    attrs=element_attrs,
    [
      @html.div(
        style=[@internal.SumiBoxSizing, CheckboxMenuBodyStyle],
        attrs=@html.Attrs::build().data_set("slot", "checkbox-menu-body"),
        group_views,
      ),
      ..footer,
    ],
  )
}
