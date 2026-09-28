///|
const DialogStyle : String = "position:fixed;inset:0;max-width:none;max-height:calc(100vh - 32px);margin:auto;padding:32px;overflow-y:auto;border:1px solid var(--sumi-stroke-secondary,rgba(255,255,255,0.04));border-radius:var(--sumi-radius-xl,16px);background:var(--sumi-surface,#1a1a1a);color:var(--sumi-text,#ffffff);box-shadow:var(--sumi-shadow-menu,0px 8px 56px 0px rgba(0,0,0,0.24))"

///|
const DialogTitleStyle : String = "margin:0;font-size:14px;line-height:22px;font-weight:500;color:var(--sumi-text,#ffffff)"

///|
const DialogDescriptionStyle : String = "margin:4px 0 0;font-size:12px;line-height:20px;color:var(--sumi-text-tertiary,rgba(255,255,255,0.6))"

///|
const DialogHeaderStyle : String = "display:flex;align-items:flex-start;justify-content:space-between;gap:16px;margin-bottom:16px"

///|
/// Render a styled native dialog without component state.
///
/// The browser owns visibility and focus: open it with the host
/// framework's dialog command (or the `open` attribute for SSR), and close
/// it with a `<form method="dialog">` submit button. `closedby` controls
/// native dismissal: `"any"` allows outside clicks and Escape,
/// `"closerequest"` allows Escape, and `"none"` requires an explicit close.
///
/// `spacious=true` widens the panel from the default 480px to 616px.
pub fn[C : @html.IsChildren] dialog(
  id~ : String,
  title_text? : String,
  description? : String,
  show_close? : Bool = true,
  spacious? : Bool = false,
  closedby? : String = "any",
  on_close? : @cmd.Emit[String],
  on_cancel? : @cmd.Cmd,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
  children : C,
) -> @html.Html {
  let header : @html.Html = match title_text {
    Some(text) =>
      @html.div(style=[@internal.SumiBoxSizing, DialogHeaderStyle], [
        @html.div(
          style=[@internal.SumiFontSans, DialogTitleStyle],
          attrs=@html.Attrs::build().data_set("slot", "dialog-title"),
          text,
        ),
        if show_close {
          @html.form(method_="dialog", style=["display:contents"], [
            @html.button(
              style=[
                @internal.SumiBoxSizing,
                "display:inline-flex;flex:none;align-items:center;justify-content:center;width:28px;height:28px;margin:-4px -4px 0 0;padding:0;border:none;border-radius:var(--sumi-radius,8px);background:transparent;color:var(--sumi-text-secondary,rgba(255,255,255,0.7));cursor:pointer;appearance:none;-webkit-appearance:none;outline:none",
              ],
              type_="submit",
              attrs=@html.Attrs::build()
                .data_set("slot", "dialog-close")
                .aria_label("Close")
                .formnovalidate(true),
              [@primitives.icon_x(size=14)],
            ),
          ])
        } else {
          @html.nothing
        },
      ])
    None => @html.nothing
  }
  let description_view : @html.Html = match description {
    Some(text) =>
      @html.p(
        style=[@internal.SumiFontSans, DialogDescriptionStyle],
        attrs=@html.Attrs::build().data_set("slot", "dialog-description"),
        text,
      )
    None => @html.nothing
  }
  @html.dialog(
    id~,
    class?,
    closedby~,
    on_close?,
    on_cancel?,
    attrs=@internal.sumi_attrs(attrs).data_set("slot", "dialog"),
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        DialogStyle,
        if spacious {
          "width:min(calc(100% - 32px),616px)"
        } else {
          "width:min(calc(100% - 32px),480px)"
        },
      ],
      style,
    ),
    [header, description_view, @internal.sumi_slot(children)],
  )
}
