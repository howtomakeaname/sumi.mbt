///|
/// A 24x24 stroke icon rendered as inline SVG. The surrounding span owns
/// accessibility hiding and a stable layout box; color inherits from the
/// parent via `currentColor`.
pub fn icon(
  path : String,
  size? : Int = 16,
  stroke_width? : Int = 2,
  style? : Array[String] = [],
) -> @html.Html {
  let px = size.to_string() + "px"
  @html.span(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        "display:inline-flex;width:\{px};height:\{px};flex:none;align-items:center;justify-content:center;pointer-events:none",
      ],
      style,
    ),
    attrs=@html.Attrs::build().aria_hidden("true"),
    @svg.svg(
      width=size,
      height=size,
      view_box="0 0 24 24",
      style=["display:block;width:100%;height:100%"],
      [
        @svg.path(
          d=path,
          fill="none",
          stroke="currentColor",
          stroke_width~,
          attrs=@svg.Attrs::build()
            .stroke_linecap("round")
            .stroke_linejoin("round"),
        ),
      ],
    ),
  )
}

///|
pub fn icon_chevron_down(size? : Int = 12) -> @html.Html {
  icon("m6 9 6 6 6-6", size~)
}

///|
pub fn icon_chevron_up(size? : Int = 12) -> @html.Html {
  icon("m18 15-6-6-6 6", size~)
}

///|
pub fn icon_chevron_left(size? : Int = 12) -> @html.Html {
  icon("m15 18-6-6 6-6", size~)
}

///|
pub fn icon_chevron_right(size? : Int = 12) -> @html.Html {
  icon("m9 18 6-6-6-6", size~)
}

///|
pub fn icon_check(size? : Int = 16) -> @html.Html {
  icon("M20 6 9 17l-5-5", size~)
}

///|
pub fn icon_x(size? : Int = 16) -> @html.Html {
  icon("M18 6 6 18M6 6l12 12", size~)
}

///|
pub fn icon_plus(size? : Int = 16) -> @html.Html {
  icon("M5 12h14M12 5v14", size~)
}

///|
pub fn icon_minus(size? : Int = 16) -> @html.Html {
  icon("M5 12h14", size~)
}

///|
pub fn icon_search(size? : Int = 16) -> @html.Html {
  icon("m21 21-4.3-4.3M19 11a8 8 0 1 1-16 0 8 8 0 0 1 16 0Z", size~)
}

///|
pub fn icon_arrow_up(size? : Int = 18) -> @html.Html {
  icon("M12 19V5M5 12l7-7 7 7", size~)
}

///|
pub fn icon_arrow_down(size? : Int = 16) -> @html.Html {
  icon("M12 5v14M19 12l-7 7-7-7", size~)
}

///|
pub fn icon_download(size? : Int = 16) -> @html.Html {
  icon("M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M7 10l5 5 5-5M12 15V3", size~)
}

///|
pub fn icon_upload(size? : Int = 16) -> @html.Html {
  icon("M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M17 8l-5-5-5 5M12 3v12", size~)
}

///|
pub fn icon_image(size? : Int = 16) -> @html.Html {
  icon(
    "M19 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V5a2 2 0 0 0-2-2ZM8.5 10a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3ZM21 15l-5-5L5 21",
    size~,
  )
}

///|
pub fn icon_sparkle(size? : Int = 16) -> @html.Html {
  icon(
    "M12 3l1.9 5.8a2 2 0 0 0 1.3 1.3L21 12l-5.8 1.9a2 2 0 0 0-1.3 1.3L12 21l-1.9-5.8a2 2 0 0 0-1.3-1.3L3 12l5.8-1.9a2 2 0 0 0 1.3-1.3L12 3Z",
    size~,
  )
}

///|
pub fn icon_adjust(size? : Int = 16) -> @html.Html {
  icon(
    "M4 21v-7M4 10V3M12 21v-9M12 8V3M20 21v-5M20 12V3M1 14h6M9 8h6M17 16h6",
    size~,
  )
}

///|
pub fn icon_reset(size? : Int = 16) -> @html.Html {
  icon("M3 12a9 9 0 1 0 3-6.7L3 8M3 3v5h5", size~)
}

///|
pub fn icon_expand(size? : Int = 16) -> @html.Html {
  icon(
    "M8 3H5a2 2 0 0 0-2 2v3M16 3h3a2 2 0 0 1 2 2v3M16 21h3a2 2 0 0 0 2-2v-3M8 21H5a2 2 0 0 1-2-2v-3",
    size~,
  )
}

///|
pub fn icon_crop(size? : Int = 16) -> @html.Html {
  icon("M6 2v14a2 2 0 0 0 2 2h14M2 6h14a2 2 0 0 1 2 2v14", size~)
}

///|
pub fn icon_layers(size? : Int = 16) -> @html.Html {
  icon("M12 2 2 7l10 5 10-5-10-5ZM2 17l10 5 10-5M2 12l10 5 10-5", size~)
}

///|
pub fn icon_grid(size? : Int = 16) -> @html.Html {
  icon("M3 3h7v7H3zM14 3h7v7h-7zM14 14h7v7h-7zM3 14h7v7H3z", size~)
}

///|
pub fn icon_play(size? : Int = 16) -> @html.Html {
  icon("M6 4l14 8-14 8V4Z", size~)
}

///|
pub fn icon_clock(size? : Int = 16) -> @html.Html {
  icon("M12 22a10 10 0 1 0 0-20 10 10 0 0 0 0 20ZM12 6v6l4 2", size~)
}

///|
pub fn icon_more(size? : Int = 16) -> @html.Html {
  icon(
    "M12 13a1 1 0 1 0 0-2 1 1 0 0 0 0 2ZM19 13a1 1 0 1 0 0-2 1 1 0 0 0 0 2ZM5 13a1 1 0 1 0 0-2 1 1 0 0 0 0 2Z",
    size~,
  )
}

///|
pub fn icon_scissors(size? : Int = 16) -> @html.Html {
  icon(
    "M6 9a3 3 0 1 0 0-6 3 3 0 0 0 0 6ZM6 21a3 3 0 1 0 0-6 3 3 0 0 0 0 6ZM20 4 8.1 15.9M14.5 14.5 20 20M8.1 8.1 12 12",
    size~,
  )
}

///|
/// An aspect-ratio artwork icon: a centered rectangle outline drawn at the
/// given ratio inside the icon box (ratio pickers in size panels).
pub fn icon_ratio(width~ : Int, height~ : Int, size? : Int = 16) -> @html.Html {
  let box = size - 2
  let (rw, rh) = if width >= height {
    (box, (box * height + width / 2) / width)
  } else {
    ((box * width + height / 2) / height, box)
  }
  let x = (size - rw) / 2
  let y = (size - rh) / 2
  let px = size.to_string() + "px"
  @html.span(
    style=[
      @internal.SumiBoxSizing,
      "display:inline-flex;width:\{px};height:\{px};flex:none;align-items:center;justify-content:center;pointer-events:none",
    ],
    attrs=@html.Attrs::build().aria_hidden("true"),
    @svg.svg(
      width=size,
      height=size,
      view_box="0 0 \{size} \{size}",
      style=["display:block;width:100%;height:100%"],
      [
        @svg.rect(
          x~,
          y~,
          width=rw,
          height=rh,
          rx=2,
          fill="none",
          stroke="currentColor",
          stroke_width=1,
        ),
      ],
    ),
  )
}

///|
/// A filled icon rendered as inline SVG on a 16x16 grid — companion to the
/// stroke set for glyphs the design draws as solids. Color inherits from the
/// parent via `currentColor`.
fn fill_icon(
  path : String,
  size? : Int = 16,
  style? : Array[String] = [],
) -> @html.Html {
  let px = size.to_string() + "px"
  @html.span(
    style=@internal.sumi_styles(
      [
        @internal.SumiBoxSizing,
        "display:inline-flex;width:\{px};height:\{px};flex:none;align-items:center;justify-content:center;pointer-events:none",
      ],
      style,
    ),
    attrs=@html.Attrs::build().aria_hidden("true"),
    @svg.svg(
      width=size,
      height=size,
      view_box="0 0 16 16",
      style=["display:block;width:100%;height:100%"],
      [@svg.path(d=path, fill="currentColor")],
    ),
  )
}

///|
/// Exclamation in a circle, used for inline validation and status notes.
pub fn icon_important(size? : Int = 16) -> @html.Html {
  fill_icon(
    "M8 1.33333C11.6819 1.33333 14.6667 4.3181 14.6667 8C14.6667 11.6819 11.6819 14.6667 8 14.6667C4.3181 14.6667 1.33333 11.6819 1.33333 8C1.33333 4.3181 4.3181 1.33333 8 1.33333ZM8 2.66667C5.05448 2.66667 2.66667 5.05448 2.66667 8C2.66667 10.9455 5.05448 13.3333 8 13.3333C10.9455 13.3333 13.3333 10.9455 13.3333 8C13.3333 5.05448 10.9455 2.66667 8 2.66667ZM8 9.41602C8.44182 9.41602 8.80013 9.77432 8.80013 10.2161C8.80006 10.6579 8.44178 11.0163 8 11.0163C7.55822 11.0163 7.19994 10.6579 7.19987 10.2161C7.19987 9.77432 7.55817 9.41602 8 9.41602ZM8 4.61589C8.44183 4.61589 8.80013 4.97419 8.80013 5.41602V7.81576C8.80013 8.25758 8.44183 8.61589 8 8.61589C7.55817 8.61589 7.19987 8.25758 7.19987 7.81576V5.41602C7.19987 4.97419 7.55817 4.61589 8 4.61589Z",
    size~,
  )
}

///|
/// Slanted bar separating pagination numbers — a filled glyph on a 9.333x14
/// design grid, sized by height (the width follows the glyph's ratio).
pub fn icon_slash(size? : Int = 14) -> @html.Html {
  let px = size.to_string() + "px"
  @html.span(
    style=[
      @internal.SumiBoxSizing,
      "display:inline-flex;height:\{px};flex:none;align-items:center;justify-content:center;pointer-events:none",
    ],
    attrs=@html.Attrs::build().aria_hidden("true"),
    @svg.svg(
      height=size,
      view_box="0 0 9.33333 14",
      style=["display:block;width:auto;height:100%"],
      [
        @svg.path(
          d="M5.89302 1.65749C5.99977 1.35366 6.33306 1.19409 6.63692 1.30066C6.94065 1.40751 7.10031 1.74018 6.99369 2.044L3.47614 12.0587C3.36932 12.3625 3.03615 12.5223 2.73224 12.4155C2.42852 12.3086 2.26867 11.9754 2.3754 11.6716L5.89302 1.65749Z",
          fill="currentColor",
        ),
      ],
    ),
  )
}
