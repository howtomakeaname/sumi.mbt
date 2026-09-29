///|
const PaginationStyle : String = "display:flex;align-items:center;justify-content:center;gap:10px"

///|
const PaginationButtonStyle : String = "display:inline-flex;align-items:center;justify-content:center;width:28px;height:28px;padding:6px;border:none;border-radius:var(--sumi-radius,8px);background:var(--sumi-block-secondary,rgba(255,255,255,0.04));color:var(--sumi-text,#ffffff);cursor:pointer"

///|
const PaginationLabelStyle : String = "display:flex;align-items:center;justify-content:center;font-size:14px;line-height:22px;color:var(--sumi-text,#ffffff)"

///|
fn pagination_button(
  icon : @html.Html,
  enabled : Bool,
  on_click : @cmd.Cmd?,
  aria_label : String,
) -> @html.Html {
  @html.button(
    style=[
      @internal.SumiBoxSizing,
      @internal.SumiTextRendering,
      @internal.SumiTransition,
      PaginationButtonStyle,
      @internal.sumi_disabled_style(!enabled),
    ],
    type_="button",
    disabled=!enabled,
    on_click?=if enabled { on_click } else { None },
    attrs=@html.Attrs::build()
      .data_set("slot", "pagination-button")
      .aria_label(aria_label),
    [icon],
  )
}

///|
/// A minimal `‹ page / total ›` pager for stepping through a small result
/// set. Controlled: the parent owns `page` and applies `on_change`. The
/// arrow buttons clamp at the range ends and disable there.
pub fn pagination(
  page~ : Int,
  total~ : Int,
  on_change? : @internal.Emit[Int],
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs).data_set("slot", "pagination")
  let at_start = page <= 1
  let at_end = page >= total
  let dec = on_change.map(emit => emit(@cmp.maximum(1, page - 1)))
  let inc = on_change.map(emit => emit(@cmp.minimum(total, page + 1)))
  @html.div(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        PaginationStyle,
      ],
      style,
    ),
    id?,
    class?,
    attrs=element_attrs,
    [
      pagination_button(
        @primitives.icon_chevron_left(size=16),
        !at_start,
        dec,
        "Previous page",
      ),
      @html.div(
        style=[@internal.SumiFontSans, PaginationLabelStyle],
        attrs=@html.Attrs::build().data_set("slot", "pagination-label"),
        [
          @html.text(page.to_string()),
          @primitives.icon_slash(size=14),
          @html.text(total.to_string()),
        ],
      ),
      pagination_button(
        @primitives.icon_chevron_right(size=16),
        !at_end,
        inc,
        "Next page",
      ),
    ],
  )
}
