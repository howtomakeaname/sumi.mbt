///|
const ContextMenuContainerStyle : String = "position:fixed;left:var(--sumi-ctx-x,0px);top:var(--sumi-ctx-y,0px);z-index:50;display:flex;flex-direction:column;gap:2px;min-width:200px;padding:4px;border:1px solid var(--sumi-stroke-secondary,rgba(255,255,255,0.04));border-radius:var(--sumi-radius-lg,12px);background:var(--sumi-menu,#262626);box-shadow:var(--sumi-shadow-menu,0px 8px 56px 0px rgba(0,0,0,0.24))"

///|
/// A right-click menu wrapping any target. Fully controlled: the caller owns
/// `open`; right-clicking the target emits `on_open_change(true)` while the
/// theme's static event layer suppresses the native menu and records the
/// pointer position into the `--sumi-ctx-x/y` variables the panel reads.
/// Closes on outside click, Escape, and selection; arrow keys move focus.
///
/// ```moonbit nocheck
/// context_menu(
///   entries=[
///     Item(MenuItem::new("rename", "Rename", shortcut="R")),
///     Separator,
///     Item(MenuItem::new("delete", "Delete", shortcut="⌫")),
///   ],
///   open=ctx_open,
///   on_open_change=set_ctx_open.map(v => _ => v),
///   on_select=set_action.map(v => _ => v),
///   [canvas_card],
/// )
/// ```
pub fn[C : @html.IsChildren] context_menu(
  entries~ : Array[MenuEntry],
  open~ : Bool,
  on_open_change? : @internal.Emit[Bool],
  selected? : String,
  on_select? : @internal.Emit[String],
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  menu_style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let close : @cmd.Cmd? = on_open_change.map(emit => emit(false))
  let request_open : @cmd.Cmd? = on_open_change.map(emit => emit(true))
  let element_attrs = @internal.sumi_attrs(attrs).data_set(
    "slot", "context-menu-root",
  )
  // The event payload is unused: the guard script has already recorded the
  // pointer position and suppressed the native menu by the time this runs.
  if request_open is Some(cmd) {
    ignore(element_attrs.on_contextmenu(_ => cmd))
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
  @html.div(
    style=@internal.sumi_styles(
      [@internal.SumiBoxSizing, "display:contents"],
      style,
    ),
    id?,
    class?,
    attrs=element_attrs,
    [
      @internal.sumi_slot(children),
      @html.fragment([
        overlay,
        @html.div(
          style=@internal.sumi_styles(
            [
              @internal.SumiBoxSizing,
              @internal.SumiFontSans,
              @internal.SumiTextRendering,
              ContextMenuContainerStyle,
            ],
            menu_style,
          ),
          hidden=!open,
          attrs=@html.Attrs::build().data_set("slot", "menu").role("menu"),
          entries.map(entry => menu_entry_view(entry, selected, click_for)),
        ),
      ]),
    ],
  )
}
