///|
/// One shortcut row: an action label and its key combination.
pub(all) struct ShortcutItem {
  label : String
  keys : String
}

///|
pub fn ShortcutItem::new(label : String, keys : String) -> ShortcutItem {
  { label, keys, }
}

///|
/// A titled cluster of shortcuts. The title carries a hairline underline;
/// sections are separated by an 8px gap.
pub(all) struct ShortcutSection {
  title : String
  items : Array[ShortcutItem]
}

///|
pub fn ShortcutSection::new(
  title : String,
  items : Array[ShortcutItem],
) -> ShortcutSection {
  { title, items, }
}

///|
const ShortcutsPanelHeaderStyle : String = "display:flex;flex:none;align-items:center;justify-content:space-between;height:48px;padding:0 8px 0 16px"

///|
const ShortcutsPanelTitleStyle : String = "font-size:14px;line-height:20px;font-weight:500;color:var(--sumi-text,#ffffff)"

///|
const ShortcutsPanelBodyStyle : String = "display:flex;flex:1 1 0%;min-height:0;flex-direction:column;gap:8px;overflow-y:auto;padding-bottom:8px"

///|
const ShortcutSectionStyle : String = "display:flex;flex-direction:column;gap:4px"

///|
const ShortcutSectionTitleStyle : String = "margin:0 16px;padding:11px 0;border-bottom:1px solid var(--sumi-stroke-primary,rgba(255,255,255,0.08));font-size:12px;line-height:20px;font-weight:500;color:var(--sumi-text,#ffffff)"

///|
const ShortcutRowOuterStyle : String = "padding:1px 4px"

///|
const ShortcutRowStyle : String = "display:flex;align-items:center;justify-content:space-between;height:40px;padding:8px 12px;border-radius:8px"

///|
const ShortcutLabelStyle : String = "font-size:12px;line-height:20px;color:var(--sumi-text-secondary,rgba(255,255,255,0.8));white-space:nowrap"

///|
const ShortcutKeysStyle : String = "display:inline-flex;align-items:center;justify-content:flex-end;padding:2px 8px;border-radius:8px;background:var(--sumi-block,rgba(255,255,255,0.08));font-size:12px;line-height:18px;font-weight:500;color:var(--sumi-text,#ffffff);white-space:nowrap"

///|
fn shortcut_row(item : ShortcutItem) -> @html.Html {
  @html.div(style=[@internal.SumiBoxSizing, ShortcutRowOuterStyle], [
    @html.div(
      style=[@internal.SumiBoxSizing, ShortcutRowStyle],
      attrs=@html.Attrs::build().data_set("slot", "shortcut-row"),
      [
        @html.span(style=[ShortcutLabelStyle], [@html.text(item.label)]),
        @html.span(
          style=[@internal.SumiBoxSizing, ShortcutKeysStyle],
          attrs=@html.Attrs::build().data_set("slot", "shortcut-keys"),
          [@html.text(item.keys)],
        ),
      ],
    ),
  ])
}

///|
fn shortcut_section(section : ShortcutSection) -> @html.Html {
  let children : Array[@html.Html] = [
    @html.div(
      style=[@internal.SumiBoxSizing, ShortcutSectionTitleStyle],
      attrs=@html.Attrs::build().data_set("slot", "shortcut-section-title"),
      [@html.text(section.title)],
    ),
  ]
  for item in section.items {
    children.push(shortcut_row(item))
  }
  @html.div(style=[@internal.SumiBoxSizing, ShortcutSectionStyle], children)
}

///|
/// The keyboard-shortcuts reference panel from the design: an elevated
/// 264px sheet with a titled header and close button, then titled sections
/// of label + key-chip rows. Long lists scroll inside the body with the
/// library's standard scrollbar.
///
/// ```moonbit nocheck
/// shortcuts_panel(
///   title="Shortcuts",
///   sections=[
///     ShortcutSection::new(
///       "General",
///       [
///         ShortcutItem::new("Toggle sidebar", "Cmd /"),
///         ShortcutItem::new("Send message", "Enter"),
///       ],
///     ),
///   ],
///   on_close=close_panel,
/// )
/// ```
pub fn shortcuts_panel(
  sections~ : Array[ShortcutSection],
  title? : String = "Shortcuts",
  on_close? : @cmd.Cmd,
  width? : Int = 264,
  max_height? : Int = 660,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs).data_set(
    "slot", "shortcuts-panel",
  )
  let body_children : Array[@html.Html] = sections.map(shortcut_section)
  @html.div(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        "display:flex;flex-direction:column;border:0.5px solid var(--sumi-stroke-primary,rgba(255,255,255,0.08));border-radius:20px;background:var(--sumi-elevated,#222222);overflow:hidden",
        "width:\{width}px;max-height:\{max_height}px",
      ],
      style,
    ),
    id?,
    class?,
    attrs=element_attrs,
    [
      @html.div(style=[@internal.SumiBoxSizing, ShortcutsPanelHeaderStyle], [
        @html.span(style=[ShortcutsPanelTitleStyle], [@html.text(title)]),
        @primitives.icon_button(
          @primitives.icon_x(),
          size=@primitives.IconSm,
          aria_label="Close",
          on_click?=on_close,
        ),
      ]),
      @html.div(
        style=[@internal.SumiBoxSizing, ShortcutsPanelBodyStyle],
        attrs=@html.Attrs::build().data_set("slot", "shortcuts-panel-body"),
        body_children,
      ),
    ],
  )
}
