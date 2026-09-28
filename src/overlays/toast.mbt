///|
pub(all) enum ToastVariant {
  Info
  Success
  Error
} derive(Debug, Eq)

///|
pub extend ToastVariant with Eq::{equal, not_equal}

///|
pub extend ToastVariant with Debug::{to_repr}

///|
const ToastViewportStyle : String = "position:fixed;top:32px;left:50%;transform:translateX(-50%);z-index:60;display:flex;flex-direction:column;align-items:center;gap:8px;pointer-events:none"

///|
const ToastStyle : String = "display:flex;align-items:center;gap:8px;min-height:44px;padding:10px 16px 10px 14px;border-radius:var(--sumi-radius-lg,12px);background:var(--sumi-tooltip-bg,#333333);box-shadow:var(--sumi-shadow-menu,0px 8px 56px 0px rgba(0,0,0,0.24));font-size:13px;line-height:20px;color:var(--sumi-tooltip-fg,#ffffff);pointer-events:auto"

///|
fn toast_variant_value(variant : ToastVariant) -> String {
  match variant {
    Info => "info"
    Success => "success"
    Error => "error"
  }
}

///|
fn toast_variant_icon(variant : ToastVariant) -> @html.Html {
  match variant {
    Info =>
      @html.span(
        style=[
          "display:inline-flex;flex:none;color:var(--sumi-text-secondary,rgba(255,255,255,0.7))",
        ],
        [@primitives.icon_clock(size=14)],
      )
    Success =>
      @html.span(
        style=[
          "display:inline-flex;flex:none;align-items:center;justify-content:center;width:16px;height:16px;border-radius:9999px;background:var(--sumi-brand,#009efa);color:var(--sumi-tooltip-bg,#333333)",
        ],
        [@primitives.icon_check(size=10)],
      )
    Error =>
      @html.span(
        style=["display:inline-flex;flex:none;color:var(--sumi-error,#ff3355)"],
        [@primitives.icon_x(size=14)],
      )
  }
}

///|
/// A transient notification rendered in a fixed top-center viewport.
/// Controlled: the caller owns `open`; the enter/exit fade runs in the
/// interaction sheet (mount-stable + `hidden` toggle). Combine with
/// `@cmd.delay` to auto-dismiss.
///
/// ```moonbit nocheck
/// // show for 2.4s
/// @cmd.batch([set_toast(_ => true), @cmd.delay(set_toast(_ => false), 2400)])
/// ```
pub fn toast(
  message~ : String,
  open~ : Bool,
  variant? : ToastVariant = Info,
  on_close? : @cmd.Cmd,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs)
    .data_set("slot", "toast")
    .data_set("variant", toast_variant_value(variant))
    .role("status")
    .aria_live("polite")
  let close_button : @html.Html = match on_close {
    Some(cmd) =>
      @html.button(
        style=[
          @internal.SumiBoxSizing,
          "display:inline-flex;flex:none;align-items:center;justify-content:center;width:16px;height:16px;margin:0;padding:0;border:none;background:transparent;color:var(--sumi-text-placeholder,rgba(255,255,255,0.35));cursor:pointer;appearance:none;-webkit-appearance:none;outline:none",
        ],
        type_="button",
        on_click=cmd,
        attrs=@html.Attrs::build()
          .data_set("slot", "toast-close")
          .aria_label("Close"),
        [@primitives.icon_x(size=12)],
      )
    None => @html.nothing
  }
  @html.div(
    style=@internal.sumi_styles([@internal.SumiBoxSizing, ToastViewportStyle], []),
    attrs=@html.Attrs::build().data_set("slot", "toast-viewport"),
    [
      @html.div(
        style=@internal.sumi_styles(
          [@internal.SumiBoxSizing, @internal.SumiFontSans, ToastStyle],
          style,
        ),
        hidden=!open,
        id?,
        class?,
        attrs=element_attrs,
        [toast_variant_icon(variant), @html.text(message), close_button],
      ),
    ],
  )
}
