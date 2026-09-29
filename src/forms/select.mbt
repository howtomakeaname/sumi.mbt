///|
pub(all) enum SelectVariant {
  Form
  Filter
}

///|
const SelectTriggerStyle : String = "display:flex;align-items:center;gap:8px;width:100%;height:32px;margin:0;padding:4px 12px;border:1px solid var(--sumi-stroke,rgba(204,221,255,0.1));border-radius:var(--sumi-radius,8px);background:var(--sumi-block,rgba(255,255,255,0.08));font-size:13px;line-height:22px;color:var(--sumi-text,#ffffff);text-align:left;cursor:pointer;user-select:none;appearance:none;-webkit-appearance:none;outline:none"

///|
const SelectFilterTriggerStyle : String = "display:flex;align-items:center;gap:8px;height:28px;margin:0;padding:3px 8px;border:0.5px solid var(--sumi-stroke-primary,rgba(255,255,255,0.08));border-radius:6px;background:transparent;font-size:12px;line-height:20px;text-align:left;cursor:pointer;user-select:none"

///|
const SelectFilterOpenStyle : String = "display:flex;align-items:center;gap:8px;flex:1 1 0%;min-width:0;margin:0;padding:0;border:none;background:transparent;font:inherit;color:inherit;text-align:left;cursor:pointer;appearance:none;-webkit-appearance:none;outline:none"

///|
const SelectFilterClearStyle : String = "display:inline-flex;flex:none;align-items:center;justify-content:center;width:16px;height:16px;margin:0;padding:0;border:none;background:transparent;color:var(--sumi-text-placeholder,rgba(255,255,255,0.35));cursor:pointer;appearance:none;-webkit-appearance:none;outline:none"

///|
const SelectFilterCaretStyle : String = "display:inline-flex;flex:none;align-items:center;justify-content:center;transition:transform 200ms cubic-bezier(0.4,0,0.2,1)"

///|
const SelectLabelStyle : String = "flex:1 1 0%;overflow:hidden;text-overflow:ellipsis;white-space:nowrap"

///|
fn select_trigger_color(
  disabled : Bool,
  filtered : Bool,
  open : Bool,
) -> String {
  if disabled {
    "color:var(--sumi-text-disabled,rgba(255,255,255,0.2))"
  } else if filtered || open {
    "color:var(--sumi-text,#ffffff)"
  } else {
    "color:var(--sumi-text-secondary,rgba(255,255,255,0.7))"
  }
}

///|
fn select_caret_color(disabled : Bool, open : Bool) -> String {
  if disabled {
    "color:var(--sumi-text-disabled,rgba(255,255,255,0.2))"
  } else if open {
    "color:var(--sumi-text-secondary,rgba(255,255,255,0.7))"
  } else {
    "color:var(--sumi-text-placeholder,rgba(255,255,255,0.35))"
  }
}

///|
/// The compact filter-trigger look: a hairline box whose label is the filter
/// name until a value is selected, then the value with a clear affordance.
/// The open state brightens and flips the caret; disabled dims both.
fn select_filter_trigger(
  label : @html.Html,
  filtered : Bool,
  open : Bool,
  disabled : Bool,
  on_clear : @cmd.Cmd?,
  element_attrs : @html.Attrs,
) -> @html.Html {
  let clear_button : Array[@html.Html] = if filtered {
    [
      @html.button(
        style=[@internal.SumiBoxSizing, SelectFilterClearStyle],
        type_="button",
        disabled~,
        attrs=@html.Attrs::build()
          .data_set("slot", "select-filter-clear")
          .aria_label("Clear filter")
          .on_click(fn(ev) {
            ev.stop_propagation()
            on_clear.unwrap_or(@cmd.none)
          }),
        [@primitives.icon_close_circle(size=16)],
      ),
    ]
  } else {
    []
  }
  let caret : Array[@html.Html] = if filtered {
    []
  } else {
    [
      @html.span(
        style=[
          SelectFilterCaretStyle,
          select_caret_color(disabled, open),
          if open {
            "transform:rotate(180deg)"
          } else {
            "transform:none"
          },
        ],
        attrs=@html.Attrs::build()
          .data_set("slot", "select-filter-caret")
          .aria_hidden("true"),
        [@primitives.icon_caret_down(size=16)],
      ),
    ]
  }
  @html.div(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        @internal.SumiTransition,
        SelectFilterTriggerStyle,
        select_trigger_color(disabled, filtered, open),
        @internal.sumi_disabled_style(disabled),
      ],
      [],
    ),
    attrs=element_attrs,
    [
      @html.button(
        style=[@internal.SumiBoxSizing, SelectFilterOpenStyle],
        type_="button",
        disabled~,
        attrs=@html.Attrs::build()
          .data_set("slot", "select-filter-open")
          .aria_haspopup("menu")
          .aria_expanded(@internal.sumi_bool(open)),
        [@html.span(style=[SelectLabelStyle], [label]), ..caret],
      ),
      ..clear_button,
    ],
  )
}

///|
/// A form-style single select: an input-look trigger opening the compact
/// menu. Fully controlled — the caller owns `open` and `value`. Built on
/// `dropdown_menu`, so outside click, Escape, and arrow-key navigation all
/// behave the same.
///
/// `variant=Filter` swaps in the compact toolbar trigger: the label is the
/// filter name (`placeholder`) until a value is selected, then the selected
/// label with a clear affordance that emits `on_clear` (without opening the
/// menu). The caller resets `value` in response.
///
/// ```moonbit nocheck
/// select(
///   options=[@overlays.MenuItem::new("png", "PNG"), @overlays.MenuItem::new("webp", "WebP")],
///   value=format,
///   placeholder="Export format",
///   open=select_open,
///   on_open_change=set_select_open.map(v => _ => v),
///   on_select=set_format.map(v => _ => v),
/// )
/// ```
pub fn select(
  options~ : Array[@overlays.MenuItem],
  value~ : String,
  placeholder? : String = "Select",
  open~ : Bool,
  on_open_change? : @internal.Emit[Bool],
  on_select? : @internal.Emit[String],
  variant? : SelectVariant = Form,
  on_clear? : @cmd.Cmd,
  disabled? : Bool = false,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let current = options.iter().find_first(option => option.value == value)
  let selected_label : @html.Html? = current.map(option => {
    @html.text(option.label)
  })
  let base_attrs = @internal.sumi_attrs(attrs).data_set(
    "slot", "select-trigger",
  )
  let trigger = match variant {
    Form => {
      let label : @html.Html = match selected_label {
        Some(label) => label
        None =>
          @html.span(
            style=["color:var(--sumi-text-placeholder,rgba(255,255,255,0.35))"],
            placeholder,
          )
      }
      let trigger_attrs = base_attrs
        .data_set("variant", "form")
        .aria_haspopup("menu")
        .aria_expanded(@internal.sumi_bool(open))
      if disabled {
        ignore(trigger_attrs.aria_disabled("true"))
      }
      @html.button(
        style=@internal.sumi_styles(
          [
            @internal.SumiBoxSizing,
            @internal.SumiFontSans,
            @internal.SumiTextRendering,
            @internal.SumiTransition,
            SelectTriggerStyle,
            @internal.sumi_disabled_style(disabled),
          ],
          [],
        ),
        type_="button",
        disabled~,
        attrs=trigger_attrs,
        [
          @html.span(style=[SelectLabelStyle], [label]),
          @overlays.menu_chevron(),
        ],
      )
    }
    Filter => {
      let label : @html.Html = selected_label.unwrap_or(@html.text(placeholder))
      let trigger_attrs = base_attrs.data_set("variant", "filter")
      if disabled {
        ignore(trigger_attrs.aria_disabled("true"))
      }
      select_filter_trigger(
        label,
        value != "",
        open,
        disabled,
        on_clear,
        trigger_attrs,
      )
    }
  }
  let (menu_style, trigger_style, root_style) = match variant {
    Form =>
      (
        ["width:100%"],
        ["display:flex;width:100%"],
        ["display:block;width:100%"],
      )
    Filter => ([], ["display:inline-flex"], ["display:inline-block"])
  }
  @overlays.dropdown_menu(
    items=@overlays.MenuEntry::items(options),
    trigger~,
    open~,
    on_open_change?,
    selected=value,
    on_select?,
    menu_style~,
    trigger_style~,
    id?,
    class?,
    style=@internal.sumi_styles(root_style, style),
  )
}
