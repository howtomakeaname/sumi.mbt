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
