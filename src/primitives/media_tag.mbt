///|
/// What an inline reference points at. Image and Video can carry a
/// `thumbnail`; every kind falls back to its own glyph when no thumbnail
/// is given (or the state is `Empty`).
pub(all) enum MediaTagKind {
  Image
  Video
  Audio
  Text
  Group
  Timeline
  Element
} derive(Eq)

///|
pub extend MediaTagKind with Eq::{equal, not_equal}

///|
/// Lifecycle of the referenced content: `Candidate` is a half-transparent
/// suggestion, `Uploading` dims the thumbnail under a spinner, `Generating`
/// swaps the visual for a spinner, `Failed` shows the warning disc, and
/// `Empty` forces the placeholder glyph even when a thumbnail exists.
pub(all) enum MediaTagState {
  Ready
  Candidate
  Uploading
  Generating
  Failed
  Empty
} derive(Eq)

///|
pub extend MediaTagState with Eq::{equal, not_equal}

///|
/// `Block` is the filled chip used inside conversation bubbles; `Inline`
/// is the transparent variant that sits inside the composer input.
pub(all) enum MediaTagVariant {
  Block
  Inline
} derive(Eq)

///|
pub extend MediaTagVariant with Eq::{equal, not_equal}

///|
const MediaTagStyle : String = "display:inline-flex;align-items:center;gap:4px;height:24px;margin:0;border:none;border-radius:8px;font-size:14px;line-height:24px;font-weight:400;white-space:nowrap;color:var(--sumi-text-secondary,rgba(255,255,255,0.7));user-select:none;appearance:none;-webkit-appearance:none;outline:none;text-decoration:none"

///|
const MediaTagBlockStyle : String = "padding:0 8px 0 4px;background:var(--sumi-block,rgba(255,255,255,0.08))"

///|
const MediaTagInlineStyle : String = "padding:0 4px;background:transparent"

///|
const MediaTagVisualStyle : String = "display:inline-flex;width:16px;height:16px;flex:none;align-items:center;justify-content:center"

///|
fn media_tag_kind_name(kind : MediaTagKind) -> String {
  match kind {
    Image => "image"
    Video => "video"
    Audio => "audio"
    Text => "text"
    Group => "group"
    Timeline => "timeline"
    Element => "element"
  }
}

///|
fn media_tag_state_name(state : MediaTagState) -> String {
  match state {
    Ready => "ready"
    Candidate => "candidate"
    Uploading => "uploading"
    Generating => "generating"
    Failed => "failed"
    Empty => "empty"
  }
}

///|
fn media_tag_kind_icon(kind : MediaTagKind) -> @html.Html {
  match kind {
    Image => icon_image_fill()
    Video => icon_video()
    Audio => icon_sound()
    Text => icon_text()
    Group => icon_group()
    Timeline => icon_timeline()
    Element => icon_element()
  }
}

///|
/// The 16px square thumbnail, optionally dimmed under a centered spinner
/// while the content uploads.
fn media_tag_thumb(src : String, uploading : Bool) -> @html.Html {
  let children : Array[@html.Html] = [
    @html.img(src~, alt="", style=[
      "position:absolute;inset:0;width:100%;height:100%;object-fit:cover;pointer-events:none",
    ]),
  ]
  if uploading {
    children.push(
      @html.span(
        style=["position:absolute;inset:0;background:rgba(0,0,0,0.3)"],
        ([] : Array[@html.Html]),
      ),
    )
    children.push(
      @html.span(
        style=[
          "position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);display:inline-flex",
        ],
        [spinner(size=12)],
      ),
    )
  }
  @html.span(
    style=[
      "position:relative;display:inline-block;width:16px;height:16px;flex:none;border-radius:4px;overflow:hidden",
    ],
    attrs=@html.Attrs::build().data_set("slot", "media-tag-thumb"),
    children,
  )
}

///|
fn media_tag_visual(
  kind : MediaTagKind,
  state : MediaTagState,
  thumbnail : String?,
) -> @html.Html {
  match state {
    Failed =>
      @html.span(
        style=[MediaTagVisualStyle, "color:var(--sumi-favorite,#ffa21e)"],
        [icon_info_circle_fill(size=13)],
      )
    Generating => @html.span(style=[MediaTagVisualStyle], [spinner(size=16)])
    Uploading =>
      match thumbnail {
        Some(src) if kind is (Image | Video) => media_tag_thumb(src, true)
        _ => @html.span(style=[MediaTagVisualStyle], [spinner(size=16)])
      }
    Ready | Candidate | Empty =>
      match thumbnail {
        Some(src) if kind is (Image | Video) && !(state is Empty) =>
          media_tag_thumb(src, false)
        _ => media_tag_kind_icon(kind)
      }
  }
}

///|
/// A compact inline reference to a piece of content — the "Image" / "Video"
/// chip that prefixes a conversation bubble or sits inside the composer
/// input. Purely presentational unless `on_click` is given, in which case
/// it renders as a button and brightens on hover.
///
/// ```moonbit nocheck
/// media_tag(kind=Image, thumbnail=thumb_url)
/// media_tag(kind=Video, state=Generating)
/// media_tag(kind=Audio, variant=Inline, state=Candidate)
/// ```
pub fn media_tag(
  kind~ : MediaTagKind,
  label? : String,
  state? : MediaTagState = Ready,
  variant? : MediaTagVariant = Block,
  thumbnail? : String,
  on_click? : @cmd.Cmd,
  aria_label? : String,
  id? : String,
  class? : String,
  attrs? : @html.Attrs,
  style? : Array[String] = [],
) -> @html.Html {
  let text = match label {
    Some(value) => value
    None =>
      match kind {
        Image => "Image"
        Video => "Video"
        Audio => "Audio"
        Text => "Text"
        Group => "Group"
        Timeline => "Timeline"
        Element => "Element"
      }
  }
  let element_attrs = @internal.sumi_attrs(attrs)
    .data_set("slot", "media-tag")
    .data_set("kind", media_tag_kind_name(kind))
    .data_set("state", media_tag_state_name(state))
  if aria_label is Some(label_text) {
    ignore(element_attrs.aria_label(label_text))
  }
  let state_style = if state is Candidate { "opacity:0.5" } else { "" }
  let base = [
    @internal.SumiBoxSizing,
    @internal.SumiFontSans,
    @internal.SumiTextRendering,
    @internal.SumiTransition,
    MediaTagStyle,
  ]
  let variant_style = match variant {
    Block => MediaTagBlockStyle
    Inline => MediaTagInlineStyle
  }
  let children = [media_tag_visual(kind, state, thumbnail), @html.text(text)]
  if on_click is Some(click) {
    ignore(element_attrs.data_set("interactive", "true"))
    @html.button(
      style=@internal.sumi_styles(
        [..base, variant_style, state_style, "cursor:pointer"],
        style,
      ),
      type_="button",
      on_click=click,
      id?,
      class?,
      attrs=element_attrs,
      children,
    )
  } else {
    @html.span(
      style=@internal.sumi_styles([..base, variant_style, state_style], style),
      id?,
      class?,
      attrs=element_attrs,
      children,
    )
  }
}
