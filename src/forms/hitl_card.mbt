///|
/// One generation option of a `hitl_card`: a label, optional reference
/// thumbnails (one per modality), a credit cost, and whether it is
/// checked for the confirm run.
pub(all) struct HitlItem {
  label : String
  thumbnails : Array[String]
  cost : Int
  checked : Bool
} derive(Eq)

///|
pub extend HitlItem with Eq::{equal, not_equal}

///|
pub fn HitlItem::new(
  label : String,
  cost? : Int = 0,
  thumbnails? : Array[String] = [],
  checked? : Bool = true,
) -> HitlItem {
  { label, thumbnails, cost, checked, }
}

///|
const HitlCardStyle : String = "display:flex;flex-direction:column;gap:24px;width:100%;padding:12px 12px 12px 8px;border:1px solid var(--sumi-stroke-primary,rgba(255,255,255,0.08));border-radius:12px;background:var(--sumi-agent-form-bg,#181818)"

///|
const HitlHeaderStyle : String = "display:flex;align-items:center;gap:10px;height:32px;padding-left:10px"

///|
const HitlTitleStyle : String = "margin:0;font-size:14px;line-height:22px;font-weight:500;color:var(--sumi-text,#ffffff);overflow:hidden;text-overflow:ellipsis;white-space:nowrap"

///|
const HitlListStyle : String = "display:flex;flex-direction:column;gap:4px;padding-left:2px;overflow-x:clip;overflow-y:auto"

///|
const HitlRowStyle : String = "display:flex;align-items:center;gap:8px;width:100%;margin:0;padding:7px 12px 7px 8px;border:none;border-radius:8px;background:transparent;font-size:14px;line-height:22px;text-align:left;appearance:none;-webkit-appearance:none;outline:none"

///|
const HitlLabelStyle : String = "flex:1;min-width:0;margin:0;color:var(--sumi-text-secondary,rgba(255,255,255,0.7));overflow:hidden;text-overflow:ellipsis;white-space:nowrap"

///|
const HitlCostStyle : String = "display:flex;flex:none;align-items:center;gap:2px;color:var(--sumi-text-placeholder,rgba(255,255,255,0.35))"

///|
const HitlButtonStyle : String = "height:36px;min-height:36px;max-height:36px;min-width:80px;padding:4px 16px;font-size:12px;line-height:20px"

///|
/// A row's checkbox: a 16px outline box inside a 20px hit cell, with the
/// 12px tick overlaid while checked.
fn hitl_checkbox(checked : Bool) -> @html.Html {
  let tick : @html.Html = if checked {
    @html.span(
      style=[
        "position:absolute;inset:0;display:flex;align-items:center;justify-content:center;color:var(--sumi-text,#ffffff)",
      ],
      [@primitives.icon_check_fill(size=12)],
    )
  } else {
    @html.nothing
  }
  @html.span(
    style=["position:relative;display:block;width:20px;height:20px;flex:none"],
    attrs=@html.Attrs::build()
      .data_set("slot", "hitl-card-checkbox")
      .data_set("checked", if checked { "true" } else { "false" })
      .aria_hidden("true"),
    [
      @html.span(
        style=[
          "position:absolute;inset:10%;border:1px solid var(--sumi-text,#ffffff);border-radius:4px",
        ],
        ([] : Array[@html.Html]),
      ),
      tick,
    ],
  )
}

///|
/// One 24px reference thumbnail of a row.
fn hitl_thumb(src : String) -> @html.Html {
  @html.span(
    style=[
      "position:relative;display:inline-block;width:24px;height:24px;flex:none;border:0.5px solid var(--sumi-stroke-primary,rgba(255,255,255,0.08));border-radius:4px;overflow:hidden",
    ],
    [
      @html.img(src~, alt="", style=[
        "position:absolute;inset:0;width:100%;height:100%;object-fit:cover;pointer-events:none",
      ]),
    ],
  )
}

///|
/// A human-in-the-loop confirm card: a titled list of generation options
/// with per-row checkboxes and credit costs, plus a Cancel / confirm
/// footer whose primary button carries the total cost of the checked
/// rows. Controlled: the caller owns each item's `checked` and receives
/// row clicks via `on_toggle(index)`.
///
/// `confirmed=true` renders the read-only receipt state — checkboxes and
/// the footer drop out, leaving the settled list.
///
/// ```moonbit nocheck
/// hitl_card(
///   title="Generate the following 4 videos",
///   items=plan,
///   on_toggle=emit.map(ToggleRow),
///   on_cancel=emit(Dismiss),
///   on_confirm=emit(ConfirmAll),
/// )
/// ```
pub fn hitl_card(
  title~ : String,
  items~ : Array[HitlItem],
  on_toggle? : @internal.Emit[Int],
  confirmed? : Bool = false,
  on_cancel? : @cmd.Cmd,
  on_confirm? : @cmd.Cmd,
  cancel_label? : String = "Cancel",
  confirm_label? : String = "Generate All",
  max_height? : Int = 190,
  aria_label? : String,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs).data_set("slot", "hitl-card")
  if confirmed {
    ignore(element_attrs.data_set("state", "confirmed"))
  }
  if aria_label is Some(label_text) {
    ignore(element_attrs.aria_label(label_text))
  }
  let rows : Array[@html.Html] = []
  for index, item in items {
    let row_children : Array[@html.Html] = []
    if !confirmed {
      row_children.push(hitl_checkbox(item.checked))
    }
    if item.thumbnails.length() > 0 {
      row_children.push(
        @html.span(
          style=["display:flex;flex:none;align-items:center;gap:6px"],
          attrs=@html.Attrs::build().data_set("slot", "hitl-card-thumbs"),
          item.thumbnails.map(hitl_thumb),
        ),
      )
    }
    row_children.push(@html.p(style=[HitlLabelStyle], [@html.text(item.label)]))
    if item.cost > 0 {
      row_children.push(
        @html.span(
          style=[HitlCostStyle],
          attrs=@html.Attrs::build().data_set("slot", "hitl-card-cost"),
          [
            @primitives.icon_sparkle_fill(size=16),
            @html.span(
              style=[
                @internal.SumiFontNum,
                "font-size:12px;line-height:20px;font-weight:500",
              ],
              [@html.text(item.cost.to_string())],
            ),
          ],
        ),
      )
    }
    let row_attrs = @html.Attrs::build()
      .data_set("slot", "hitl-card-row")
      .data_set("checked", if item.checked { "true" } else { "false" })
    match on_toggle {
      Some(_) =>
        rows.push(
          @html.button(
            style=[
              @internal.SumiBoxSizing,
              @internal.SumiFontSans,
              @internal.SumiTextRendering,
              @internal.SumiTransition,
              HitlRowStyle,
              "cursor:pointer",
            ],
            type_="button",
            on_click?=on_toggle.map(emit => emit(index)),
            attrs=row_attrs.aria_pressed(@internal.sumi_bool(item.checked)),
            row_children,
          ),
        )
      None =>
        rows.push(
          @html.div(
            style=[@internal.SumiBoxSizing, HitlRowStyle],
            attrs=row_attrs,
            row_children,
          ),
        )
    }
  }
  let card_children : Array[@html.Html] = [
    @html.div(style=[HitlHeaderStyle], [
      @html.p(style=[HitlTitleStyle], [@html.text(title)]),
      @html.span(
        style=["flex:1;min-width:4px;height:1px"],
        attrs=@html.Attrs::build().aria_hidden("true"),
        ([] : Array[@html.Html]),
      ),
    ]),
    @html.div(
      style=[HitlListStyle, "max-height:\{max_height}px"],
      attrs=@html.Attrs::build().data_set("slot", "hitl-card-list"),
      rows,
    ),
  ]
  if !confirmed {
    let mut total = 0
    for item in items {
      if item.checked {
        total += item.cost
      }
    }
    let confirm_children : Array[@html.Html] = []
    if total > 0 {
      confirm_children.push(
        @html.span(style=["display:inline-flex;align-items:center;gap:2px"], [
          @primitives.icon_sparkle_fill(size=16),
          @html.span(
            style=[
              @internal.SumiFontNum,
              "font-size:12px;line-height:20px;font-weight:500",
            ],
            [@html.text(total.to_string())],
          ),
        ]),
      )
    }
    confirm_children.push(@html.text(confirm_label))
    card_children.push(
      @html.div(
        style=["display:flex;justify-content:flex-end;gap:12px;width:100%"],
        attrs=@html.Attrs::build().data_set("slot", "hitl-card-footer"),
        [
          @primitives.button(
            variant=Secondary,
            on_click?=on_cancel,
            style=[HitlButtonStyle, "font-weight:400"],
            [@html.text(cancel_label)],
          ),
          @primitives.button(
            variant=Primary,
            on_click?=on_confirm,
            style=[HitlButtonStyle],
            confirm_children,
          ),
        ],
      ),
    )
  }
  @html.div(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        @internal.SumiFontSans,
        @internal.SumiTextRendering,
        if confirmed {
          "display:flex;flex-direction:column;gap:24px;width:100%;padding:12px 12px 16px 8px;border:1px solid var(--sumi-stroke-primary,rgba(255,255,255,0.08));border-radius:12px;background:var(--sumi-agent-form-bg,#181818)"
        } else {
          HitlCardStyle
        },
      ],
      style,
    ),
    id?,
    class?,
    attrs=element_attrs,
    card_children,
  )
}
