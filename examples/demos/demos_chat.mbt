///|
/// One round of brief-breakdown copy, long enough to clamp when repeated.
const ChatSampleShort : String = "I will first break down the brief into its core elements — setting, characters, visual tone, and pacing. Then I will shape those into a working document that can anchor the image and video drafts."

///|
const ChatSampleLong : String = "I will first break down the brief into its core elements — setting, characters, visual tone, and pacing. Then I will shape those into a working document that can anchor the image and video drafts. Once the draft reads well, I will trim repetition and tighten the transitions so the final version flows end to end. I will first break down the brief into its core elements — setting, characters, visual tone, and pacing. Then I will shape those into a working document that can anchor the image and video drafts."

///|
/// Sent-message bubbles: single line, wrapped plain text, rich inline
/// media tag, and a clamped long message with Expand/Collapse plus the
/// hover-revealed copy action.
fn demo_chat_bubble(mode : @sumi.ThemeMode?) -> Val[Html] {
  let (collapsed, set_collapsed) = @rabbita.create_variable(true)
  collapsed.view(fn(c) {
    stage_mode(mode, [
      @html.div(
        style=["width:360px;display:flex;flex-direction:column;gap:16px"],
        [
          @sumi.chat_bubble(text="Continue"),
          @sumi.chat_bubble(text=ChatSampleShort),
          @sumi.chat_bubble(children=[
            @sumi.media_tag(
              kind=Image,
              variant=Inline,
              thumbnail=attachment_thumb(2),
            ),
            @html.text("Add more detail, like a film concept sheet."),
          ]),
          @sumi.chat_bubble(
            text=ChatSampleLong,
            collapsible=true,
            collapsed=c,
            on_toggle=set_collapsed(v => !v),
            on_copy=@cmd.none,
          ),
        ],
      ),
    ])
  })
}

///|
/// Agent progress rows: shimmer while working, static when settled, an
/// icon-less reasoning row, and an expandable row with threaded steps
/// (click to flip).
fn demo_tool_call_row(mode : @sumi.ThemeMode?) -> Val[Html] {
  let (expanded, set_expanded) = @rabbita.create_variable(false)
  expanded.view(fn(e) {
    stage_mode(mode, [
      @html.div(
        style=["width:400px;display:flex;flex-direction:column;gap:12px"],
        [
          @sumi.tool_call_row(
            icon=@sumi.icon_align_left(size=16),
            label="Writing an outline document: project-notes.md",
            truncate=false,
          ),
          @sumi.tool_call_row(
            icon=@sumi.icon_image(size=16),
            label="(0/1) Image generating…",
          ),
          @sumi.tool_call_row(
            icon=@sumi.icon_image(size=16),
            state=Done,
            label="(1/1) Image generation completed",
          ),
          @sumi.tool_call_row(
            icon=@sumi.icon_image(size=16),
            state=Done,
            label="(1/1) Image generation completed, 1 item failed",
          ),
          @sumi.tool_call_row(label="Thinking"),
          @sumi.tool_call_row(
            icon=@sumi.icon_adjust(size=16),
            label="2 commands executed",
            expandable=true,
            expanded=e,
            on_toggle=set_expanded(v => !v),
            steps=["List file directories", "Search for related content"],
          ),
          @sumi.tool_call_row(
            icon=@sumi.icon_clock(size=16),
            label="Waiting to complete task: agent name",
          ),
        ],
      ),
    ])
  })
}
