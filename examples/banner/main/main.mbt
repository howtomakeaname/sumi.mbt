///|
using @rabbita {type Val, type Html}

///|
/// Promotional banner: a fixed 1280x640 stage (GitHub social-preview size)
/// composing the library's main controls around the repository wordmark.
/// Controls are grouped into a few dense clusters rather than spread out
/// individually. Everything is static — menus and toasts are pinned open via
/// their controlled `open` props. Screenshot via the CDP rig at
/// deviceScaleFactor 2 for the published asset.
const StageW = 1280

///|
const StageH = 640

///|
/// Soft drop shadow lifting a floating panel off the canvas.
const PanelShadow : String = "box-shadow:0 20px 56px 0 rgba(0,0,0,0.5);border-radius:16px"

///|
/// Floating panel pinned by its left edge.
fn panel(x : Int, y : Int, child : Html) -> Html {
  @html.div(
    style=[
      "position:absolute;left:" +
      x.to_string() +
      "px;top:" +
      y.to_string() +
      "px;" +
      PanelShadow,
    ],
    [child],
  )
}

///|
/// Floating panel pinned by its right edge (right column alignment).
fn panel_r(rx : Int, y : Int, child : Html) -> Html {
  @html.div(
    style=[
      "position:absolute;right:" +
      rx.to_string() +
      "px;top:" +
      y.to_string() +
      "px;" +
      PanelShadow,
    ],
    [child],
  )
}

///|
/// The centered wordmark: repository name plus a one-line tagline. The
/// "sumi" half carries the aurora text-fill gradient (the design's signature
/// accent) as the single color focus of the banner.
fn wordmark() -> Html {
  @html.div(
    style=[
      "position:absolute;left:0;right:0;top:0;bottom:0;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:14px;pointer-events:none",
    ],
    [
      @html.div(
        style=[
          "font-family:-apple-system,BlinkMacSystemFont,'SF Pro Display','Helvetica Neue',sans-serif;font-size:108px;line-height:1;font-weight:600;letter-spacing:-0.045em;color:#fff",
        ],
        [
          @html.span(
            style=[
              "background-image:radial-gradient(60% 130% at 18% 30%,#5cd8ef,transparent 62%),radial-gradient(55% 120% at 55% 65%,#7aa0ff,transparent 66%),radial-gradient(70% 140% at 88% 22%,#b07af0,transparent 60%),linear-gradient(#5cd8ef,#5cd8ef);background-clip:text;-webkit-background-clip:text;color:transparent",
            ],
            "sumi",
          ),
          @html.span(
            style=["color:rgba(255,255,255,0.35);font-weight:500"],
            ".mbt",
          ),
        ],
      ),
      @html.div(
        style=[
          "font-size:17px;line-height:24px;letter-spacing:0.01em;color:rgba(255,255,255,0.5)",
        ],
        "A MoonBit component library",
      ),
    ],
  )
}

///|
/// Canvas backdrop: dot grid over the canvas token with two faint blooms.
fn backdrop() -> Html {
  @html.div(
    style=[
      "position:absolute;inset:0;background:var(--sumi-canvas,#0d0d0d);background-image:radial-gradient(circle,var(--sumi-stroke-secondary,rgba(255,255,255,0.05)) 1px,transparent 1px);background-size:24px 24px",
    ],
    "",
  )
}

///|
fn blooms() -> Html {
  @html.fragment([
    @html.div(
      style=[
        "position:absolute;left:280px;top:100px;width:720px;height:440px;background:radial-gradient(closest-side,rgba(0,150,220,0.13),transparent);filter:blur(10px)",
      ],
      "",
    ),
    @html.div(
      style=[
        "position:absolute;left:-180px;top:320px;width:560px;height:440px;background:radial-gradient(closest-side,rgba(120,80,255,0.07),transparent)",
      ],
      "",
    ),
  ])
}

///|
/// Composer with a model picker, pinned with a prompt typed in.
fn composer() -> Html {
  @html.div(style=["width:430px"], [
    @sumi.prompt_box(
      value="A quiet lake at dawn, soft light",
      placeholder="Describe what to create",
      actions=@sumi.dropdown_menu(
        side=Top,
        trigger=@sumi.button(variant=Ghost, size=Sm, [
          @html.text("Nebula 2.0"),
          @sumi.menu_chevron(),
        ]),
        items=@sumi.MenuEntry::items([
          @sumi.MenuItem::new("nebula", "Nebula 2.0"),
          @sumi.MenuItem::new("nebula-pro", "Nebula 2.0 Pro"),
        ]),
        open=false,
        selected="nebula",
      ),
    ),
  ])
}

///|
/// Button variants row.
fn buttons_row() -> Html {
  @html.div(style=["display:flex;align-items:center;gap:10px"], [
    @sumi.button(variant=Primary, "Generate"),
    @sumi.button(variant=Secondary, "Export"),
    @sumi.button(variant=Ghost, [@sumi.icon_sparkle(), @html.text("AI Edit")]),
    @sumi.button(variant=Primary, loading=true, "Generate"),
  ])
}

///|
/// Icon-only buttons with the active-tool state.
fn icon_buttons_row() -> Html {
  @html.div(style=["display:flex;align-items:center;gap:8px"], [
    @sumi.icon_button(@sumi.icon_search(), aria_label="Search"),
    @sumi.icon_button(
      @sumi.icon_crop(),
      pressed=true,
      aria_label="Crop (active tool)",
    ),
    @sumi.icon_button(@sumi.icon_download(), aria_label="Download"),
    @sumi.icon_button(@sumi.icon_upload(), disabled=true, aria_label="Export"),
  ])
}

///|
/// A menu pinned open with the current choice checked.
fn open_menu() -> Html {
  @sumi.dropdown_menu(
    trigger=@sumi.button(variant=Secondary, [
      @html.text("Model"),
      @sumi.menu_chevron(),
    ]),
    items=[
      SectionLabel("TIER"),
      Item(
        @sumi.MenuItem::new(
          "standard",
          "Standard",
          description="Fast drafts for everyday tasks",
        ),
      ),
      Item(
        @sumi.MenuItem::new(
          "pro",
          "Pro",
          description="Deeper reasoning for final versions",
        ),
      ),
    ],
    open=true,
    selected="standard",
  )
}

///|
/// The inspector panel: form controls grouped on one card surface, so the
/// small parts read as a single substantial unit instead of loose floats.
fn inspector_panel() -> Html {
  @sumi.card(style=["width:320px;padding:16px"], [
    @html.div(style=["display:flex;flex-direction:column;gap:14px"], [
      @sumi.input(
        value="Aurora study",
        placeholder="Search projects",
        prefix=@sumi.icon_search(size=14),
        clearable=true,
      ),
      @sumi.select(
        options=[
          @sumi.MenuItem::new("png", "PNG"),
          @sumi.MenuItem::new("jpg", "JPG"),
          @sumi.MenuItem::new("webp", "WebP"),
        ],
        value="webp",
        placeholder="Export format",
        open=false,
      ),
      @sumi.segmented(
        items=[
          @sumi.SegmentedItem::new("canvas", "Canvas"),
          @sumi.SegmentedItem::new("grid", "Grid"),
          @sumi.SegmentedItem::new("list", "List"),
        ],
        selected="canvas",
      ),
      @sumi.slider_field(
        value=45,
        min=0,
        max=180,
        label="Clip length",
        unit="s",
        ticks=[0, 60, 120, 180],
      ),
      @sumi.divider(),
      @html.div(style=["display:flex;align-items:center;gap:20px"], [
        @sumi.switch(checked=true),
        @sumi.checkbox(checked=true, label="Auto-save"),
      ]),
    ]),
  ])
}

///|
/// A generation task card: media skeleton, status badge and progress.
fn generation_card() -> Html {
  @sumi.card(style=["width:320px;padding:16px"], [
    @html.div(style=["display:flex;flex-direction:column;gap:14px"], [
      @html.div(style=["display:flex;align-items:center;gap:12px"], [
        @sumi.skeleton_tile(width="56px", height="56px"),
        @html.div(
          style=[
            "display:flex;flex-direction:column;gap:6px;flex:1;min-width:0",
          ],
          [
            @html.div(
              style=[
                "font-size:13px;line-height:20px;font-weight:500;color:var(--sumi-text-primary,#fff)",
              ],
              "Dune study",
            ),
            @html.div(style=["display:flex;align-items:center;gap:8px"], [
              @sumi.status_badge(state=Running(45)),
              @html.span(
                style=[
                  "font-size:12px;line-height:20px;color:var(--sumi-text-tertiary,rgba(255,255,255,0.6))",
                ],
                "Upscaling",
              ),
            ]),
          ],
        ),
      ]),
      @sumi.progress(value=45, show_value=true),
    ]),
  ])
}

///|
/// Small-part sprinkles below the wordmark.
fn sprinkles() -> Html {
  @html.div(
    style=[
      "display:flex;align-items:center;gap:16px;color:rgba(255,255,255,0.8)",
    ],
    [
      @sumi.spinner(size=24),
      @sumi.status_badge(state=Complete),
      @sumi.badge(value=5),
      @sumi.avatar(fallback="墨", size=36),
      @html.div(style=["display:flex;align-items:center;gap:4px"], [
        @sumi.kbd("⌘"),
        @sumi.kbd("K"),
      ]),
      @sumi.credits(value=24, original_value=48),
      @html.div(style=["width:110px"], [
        @sumi.progress(value=72, show_value=true),
      ]),
    ],
  )
}

///|
fn app() -> Val[Html] {
  Val::constant(
    @sumi.theme(mode=@sumi.Dark, [
      @html.div(
        style=[
          "position:relative;width:" +
          StageW.to_string() +
          "px;height:" +
          StageH.to_string() +
          "px;overflow:hidden;font-family:-apple-system,BlinkMacSystemFont,'PingFang SC','Helvetica Neue',sans-serif",
        ],
        [
          backdrop(),
          blooms(),
          // Left column: composer, actions, open menu — one tight stack.
          panel(48, 72, composer()),
          panel(48, 232, buttons_row()),
          panel(48, 292, open_menu()),
          panel(48, 580, @sumi.pagination(page=2, total=4)),
          // Right column: inspector panel with the task card under it and
          // icon buttons pinned to the bottom corner.
          panel_r(48, 64, inspector_panel()),
          panel_r(48, 424, generation_card()),
          panel_r(48, 568, icon_buttons_row()),
          // Toast pins itself to the viewport top-center.
          @sumi.toast(
            message="Export finished — 3 files saved",
            open=true,
            variant=Success,
          ),
          wordmark(),
          @html.div(
            style=[
              "position:absolute;left:0;right:0;bottom:52px;display:flex;justify-content:center",
            ],
            [sprinkles()],
          ),
        ],
      ),
    ]),
  )
}

///|
fn main {
  @rabbita.new(app).mount("app")
}
