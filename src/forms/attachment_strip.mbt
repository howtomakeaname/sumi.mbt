///|
/// The kind of attachment a tile renders: a cover-fit image thumbnail, or a
/// gradient placeholder with a document glyph for everything else.
pub(all) enum AttachmentKind {
  Image
  Document
} derive(Eq)

///|
pub extend AttachmentKind with Eq::{equal, not_equal}

///|
/// One attachment in the strip.
pub(all) struct AttachmentItem {
  kind : AttachmentKind
  src : String
  label : String
} derive(Eq)

///|
pub extend AttachmentItem with Eq::{equal, not_equal}

///|
/// An image attachment, rendered cover-fit slightly overset so the thumbnail
/// hides the tile border.
pub fn AttachmentItem::image(
  src : String,
  label? : String = "Image attachment",
) -> AttachmentItem {
  { kind: Image, src, label, }
}

///|
/// A non-image attachment, rendered as a slate gradient placeholder with a
/// centered document glyph.
pub fn AttachmentItem::document(label : String) -> AttachmentItem {
  { kind: Document, src: "", label, }
}

///|
const AttachmentStripStyle : String = "display:inline-flex;align-items:flex-start;gap:8px;position:relative"

///|
const AttachmentTileStyle : String = "position:relative;flex:none;width:48px;height:48px;border:1px solid var(--sumi-stroke-primary,rgba(255,255,255,0.08));border-radius:8px;background:var(--sumi-block,rgba(255,255,255,0.08));overflow:hidden"

///|
const AttachmentImageStyle : String = "position:absolute;top:-1px;left:-1px;width:calc(100% + 2px);height:calc(100% + 2px);object-fit:cover;pointer-events:none"

///|
const AttachmentDocumentStyle : String = "position:absolute;inset:0;display:flex;align-items:center;justify-content:center;background:linear-gradient(180.16deg,#4e6580 0.14%,#3d485d 99.3%);color:rgba(255,255,255,0.88)"

///|
const AttachmentRemoveStyle : String = "position:absolute;top:-2px;right:-2px;display:flex;align-items:center;justify-content:center;width:8px;height:8px;padding:0;margin:0;border:none;border-radius:11px;background:var(--sumi-canvas,#0d0d0d);color:#ffffff;cursor:pointer;appearance:none;-webkit-appearance:none;outline:none;opacity:0"

///|
const AttachmentFadeStyle : String = "position:absolute;top:0;right:0;width:91px;height:48px;background:linear-gradient(to left,var(--sumi-elevated,#222222) 60%,transparent);pointer-events:none"

///|
const AttachmentPinnedStyle : String = "position:absolute;top:0;right:0"

///|
fn attachment_tile(
  item : AttachmentItem,
  index : Int,
  on_remove? : @internal.Emit[Int],
) -> @html.Html {
  let tile_attrs = @html.Attrs::build()
    .data_set("slot", "attachment-tile")
    .data_set(
      "kind",
      match item.kind {
        Image => "image"
        Document => "document"
      },
    )
  let children : Array[@html.Html] = []
  match item.kind {
    Image =>
      children.push(
        @html.img(src=item.src, alt=item.label, style=[AttachmentImageStyle]),
      )
    Document =>
      children.push(
        @html.div(
          style=[AttachmentDocumentStyle],
          attrs=@html.Attrs::build().role("img").aria_label(item.label),
          [@primitives.icon_align_left(size=16)],
        ),
      )
  }
  if on_remove is Some(emit) {
    children.push(
      @html.button(
        style=[
          @internal.SumiBoxSizing,
          @internal.SumiTransition,
          AttachmentRemoveStyle,
        ],
        type_="button",
        on_click=emit(index),
        attrs=@html.Attrs::build()
          .data_set("slot", "attachment-remove")
          .aria_label("Remove \{item.label}"),
        [@primitives.icon_x_fill(size=4)],
      ),
    )
  }
  @html.div(
    style=[@internal.SumiBoxSizing, AttachmentTileStyle],
    attrs=tile_attrs,
    children,
  )
}

///|
/// The attachment strip from the design: a row of 48px tiles — image
/// thumbnails and document placeholders — followed by the add tile. Each
/// tile can carry an 8px remove badge that fades in on tile hover or
/// keyboard focus. Past `max_visible` attachments the row clips, a right-edge
/// fade appears, and the add tile pins itself over the fade.
///
/// ```moonbit nocheck
/// attachment_strip(
///   items=[
///     AttachmentItem::image("cover.png", label="Cover"),
///     AttachmentItem::document("Brief.pdf"),
///   ],
///   on_add=pick_files,
///   on_remove=set_items.map(i => items => items.filteri(fn(j, _) { j != i })),
/// )
/// ```
pub fn attachment_strip(
  items~ : Array[AttachmentItem],
  on_add? : @cmd.Cmd,
  on_remove? : @internal.Emit[Int],
  max_visible? : Int = 10,
  aria_label? : String = "Attachments",
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let element_attrs = @internal.sumi_attrs(attrs)
    .data_set("slot", "attachment-strip")
    .aria_label(aria_label)
  let overflow = items.length() > max_visible
  let visible_count = if overflow { max_visible } else { items.length() }
  let children : Array[@html.Html] = []
  for i in 0..<visible_count {
    children.push(attachment_tile(items[i], i, on_remove?))
  }
  if !overflow && on_add is Some(add) {
    children.push(@primitives.add_tile(on_click=add))
  }
  if overflow {
    children.push(
      @html.div(
        style=[AttachmentFadeStyle],
        attrs=@html.Attrs::build()
          .data_set("slot", "attachment-strip-fade")
          .aria_hidden("true"),
        ([] : Array[@html.Html]),
      ),
    )
    if on_add is Some(add) {
      children.push(
        @html.div(style=[AttachmentPinnedStyle], [
          @primitives.add_tile(on_click=add),
        ]),
      )
    }
  }
  @html.div(
    style=@internal.sumi_styles(
      [@internal.SumiBoxSizing, @internal.SumiFontSans, AttachmentStripStyle],
      style,
    ),
    id?,
    class?,
    attrs=element_attrs,
    children,
  )
}
