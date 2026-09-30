///|
/// One round of brief-breakdown copy, long enough to clamp when repeated.
const ChatSampleShort : String = "I will first break the request into smaller steps — gather the context, outline the structure, and draft the wording. Then I will refine the flow so the final version reads cleanly end to end."

///|
const ChatSampleLong : String = "I will first break the request into smaller steps — gather the context, outline the structure, and draft the wording. Then I will refine the flow so the final version reads cleanly end to end. Once the draft reads well, I will trim repetition and tighten the transitions. I will first break the request into smaller steps — gather the context, outline the structure, and draft the wording. Then I will refine the flow so the final version reads cleanly end to end."

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
            @html.text("Add more detail, like a full project brief."),
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
            label="(0/1) Draft generating…",
          ),
          @sumi.tool_call_row(
            icon=@sumi.icon_image(size=16),
            state=Done,
            label="(1/1) Draft generation completed",
          ),
          @sumi.tool_call_row(
            icon=@sumi.icon_image(size=16),
            state=Done,
            label="(1/1) Draft generation completed, 1 item failed",
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

///|
/// Agent input docks: an empty draft (disabled send) that enables as you
/// type and clears on send, an in-flight run whose stop button flips back
/// to send, and rich inline-tag content composed via `children`.
fn demo_agent_input(mode : @sumi.ThemeMode?) -> Val[Html] {
  let (prompt, set_prompt) = @rabbita.create_variable("")
  let (live, set_live) = @rabbita.create_variable(true)
  let toolbar = fn() {
    [
      @sumi.icon_button(
        @sumi.icon_plus_fill(size=14),
        aria_label="Add attachment",
        on_click=@cmd.none,
      ),
      @sumi.agent_tool_button(
        @sumi.icon_skill(size=16),
        label="Use Skill",
        on_click=@cmd.none,
      ),
      @sumi.icon_button(
        @sumi.icon_at(size=14),
        aria_label="Mention a reference",
        on_click=@cmd.none,
      ),
    ]
  }
  prompt.view2(live, fn(text, running) {
    stage_mode(mode, [
      @html.div(
        style=["width:400px;display:flex;flex-direction:column;gap:16px"],
        [
          @sumi.agent_input(
            value=text,
            placeholder="Describe your idea, or type / to use a skill",
            on_input=set_prompt.map(v => _ => v),
            on_send=set_prompt(_ => ""),
            send_disabled=text.is_empty(),
            actions=toolbar(),
          ),
          @sumi.agent_input(
            value="Extend the intro with a three-point summary of the Q3 goals",
            generating=running,
            on_stop=set_live(v => !v),
            on_send=@cmd.none,
            actions=toolbar(),
          ),
          @sumi.agent_input(children=[
            @sumi.media_tag(
              kind=Image,
              variant=Inline,
              thumbnail=attachment_thumb(5),
            ),
            @html.text("Using this draft, "),
            @sumi.media_tag(
              kind=Video,
              variant=Inline,
              thumbnail=attachment_thumb(9),
            ),
            @html.text("match the tone and keep the concise structure."),
          ]),
        ],
      ),
    ])
  })
}

///|
fn bool_flip_at(items : Array[Bool], index : Int) -> Array[Bool] {
  let out = []
  for i, item in items {
    out.push(if i == index { !item } else { item })
  }
  out
}

///|
/// HITL confirm cards: the checkable plan (toggle a row and the confirm
/// total recomputes) and the read-only receipt state after confirmation.
fn demo_hitl_card(mode : @sumi.ThemeMode?) -> Val[Html] {
  let (marks, set_marks) = @rabbita.create_variable([
    true, true, true, true, false,
  ])
  marks.view(fn(checked) {
    let rows = [
      ("Summarize the weekly sync notes", 100, [attachment_thumb(3)]),
      ("Draft the launch announcement email", 300, [attachment_thumb(6)]),
      ("Outline the onboarding guide", 120, [attachment_thumb(8)]),
      (
        "Compare the three vendor quotes",
        120,
        [attachment_thumb(11), attachment_thumb(5)],
      ),
      ("Write the customer follow-up", 120, [attachment_thumb(14)]),
    ]
    let items = []
    for i, row in rows {
      let (label, cost, thumbs) = row
      items.push(
        @sumi.HitlItem::new(label, cost~, thumbnails=thumbs, checked=checked[i]),
      )
    }
    stage_mode(mode, [
      @html.div(
        style=["width:400px;display:flex;flex-direction:column;gap:16px"],
        [
          @sumi.hitl_card(
            title="Generate the following 5 drafts",
            items~,
            on_toggle=set_marks.map(i => c => bool_flip_at(c, i)),
            on_cancel=@cmd.none,
            on_confirm=@cmd.none,
          ),
          @sumi.hitl_card(
            title="Generated the following 3 drafts",
            items=[
              @sumi.HitlItem::new("Summarize the weekly sync notes", cost=100, thumbnails=[
                attachment_thumb(3),
              ]),
              @sumi.HitlItem::new(
                "Draft the launch announcement email",
                cost=300,
                thumbnails=[attachment_thumb(6)],
              ),
              @sumi.HitlItem::new("Compare the three vendor quotes", cost=120, thumbnails=[
                attachment_thumb(11),
                attachment_thumb(5),
              ]),
            ],
            confirmed=true,
          ),
        ],
      ),
    ])
  })
}

///|
/// Session management: the chat-window header bound to the active row of
/// the session-list panel. Rows carry every generation status (spinner,
/// count, tick, unread dot, review pill, partial-failure mark); clicking a
/// row moves the active check, hovering reveals rename/delete actions.
fn demo_session_menu(mode : @sumi.ThemeMode?) -> Val[Html] {
  let (current, set_current) = @rabbita.create_variable(0)
  current.view(fn(cur) {
    let titles = [
      "Q3 Launch Plan", "Weekly Sync Notes", "API Migration Draft", "Marketing Calendar",
      "Bug Triage Summary", "Travel Itinerary", "Team Offsite Agenda",
    ]
    let statuses : Array[@sumi.SessionStatus?] = [
      None,
      Some(Generating),
      Some(Done),
      Some(Count(5)),
      Some(Pending("Review")),
      Some(Dot),
      Some(Partial),
    ]
    let rows : Array[Html] = []
    for i, title in titles {
      rows.push(
        @sumi.session_item(
          label=title,
          active=cur == i,
          status?=statuses[i],
          on_click=set_current(_ => i),
          on_edit=@cmd.none,
          on_delete=@cmd.none,
        ),
      )
    }
    rows.push(@sumi.session_divider())
    rows.push(@sumi.session_item(label="Archived Threads", disabled=true))
    stage_mode(mode, [
      @html.div(
        style=[
          "display:flex;flex-direction:column;gap:24px;align-items:flex-start",
        ],
        [
          @html.div(style=["width:376px"], [
            @sumi.session_header(
              title=titles[cur],
              status?=statuses[cur],
              on_title=@cmd.none,
              on_new=@cmd.none,
              on_collapse=@cmd.none,
            ),
          ]),
          @sumi.session_list(max_height=280, children=rows),
        ],
      ),
    ])
  })
}

///|
/// The task-card feed: six submitted-task bubbles covering every status
/// kind (review pill, spinner, tick, count, partial failure) plus a rich
/// body composed from a tool call row, scrolling under the bottom fade.
fn demo_task_list(mode : @sumi.ThemeMode?) -> Val[Html] {
  Val::constant(
    stage_mode(mode, [
      @html.div(style=["width:416px"], [
        @sumi.task_list(height=400, children=[
          @sumi.task_card(
            title="Weekly Sync Notes",
            status=Pending("Review"),
            summary=ChatSampleShort,
          ),
          @sumi.task_card(
            title="API Migration Draft",
            status=Generating,
            summary=ChatSampleShort,
          ),
          @sumi.task_card(title="Marketing Calendar", status=Generating, children=[
            @sumi.tool_call_row(
              label="Reading the project brief",
              icon=@sumi.icon_draw(size=16),
              expandable=true,
              on_toggle=@cmd.none,
            ),
          ]),
          @sumi.task_card(
            title="Bug Triage Summary",
            status=Done,
            summary=ChatSampleLong,
          ),
          @sumi.task_card(
            title="Q3 Launch Plan",
            status=Count(3),
            summary=ChatSampleShort,
          ),
          @sumi.task_card(
            title="Team Offsite Agenda",
            status=Partial,
            summary=ChatSampleShort,
          ),
        ]),
      ]),
    ]),
  )
}

///|
/// Skill chips and the "more actions" sheet: a picker row (leading icon,
/// New/Hot marks, More trigger) above two wrap panels — one of quick-action
/// buttons, one of skill chips.
fn demo_skill_chips(mode : @sumi.ThemeMode?) -> Val[Html] {
  Val::constant(
    stage_mode(mode, [
      @html.div(
        style=[
          "display:flex;flex-direction:column;align-items:center;gap:24px;width:100%",
        ],
        [
          @html.div(
            style=[
              "display:flex;flex-wrap:wrap;justify-content:center;gap:8px;max-width:520px",
            ],
            [
              @sumi.skill_chip(
                label="Summarize",
                icon=@sumi.icon_sparkle_fill(size=16),
                mark=New,
                on_click=@cmd.none,
              ),
              @sumi.skill_chip(label="Translate", mark=Hot, on_click=@cmd.none),
              @sumi.skill_chip(label="Outline", on_click=@cmd.none),
              @sumi.skill_chip(label="More", more=true, on_click=@cmd.none),
            ],
          ),
          @sumi.chip_panel(children=[
            @sumi.action_chip(label="Summarize", on_click=@cmd.none),
            @sumi.action_chip(label="Translate", on_click=@cmd.none),
            @sumi.action_chip(label="Outline", on_click=@cmd.none),
            @sumi.action_chip(label="Brainstorm", on_click=@cmd.none),
            @sumi.action_chip(label="Proofread", on_click=@cmd.none),
            @sumi.action_chip(label="Schedule", on_click=@cmd.none),
            @sumi.action_chip(label="Analyze", on_click=@cmd.none),
          ]),
          @sumi.chip_panel(children=[
            @sumi.skill_chip(label="Brainstorm", mark=Hot, on_click=@cmd.none),
            @sumi.skill_chip(label="Summarize", on_click=@cmd.none),
            @sumi.skill_chip(label="Translate", on_click=@cmd.none),
            @sumi.skill_chip(label="Outline", on_click=@cmd.none),
            @sumi.skill_chip(label="Proofread", on_click=@cmd.none),
            @sumi.skill_chip(label="Schedule", on_click=@cmd.none),
            @sumi.skill_chip(label="Analyze", on_click=@cmd.none),
          ]),
        ],
      ),
    ]),
  )
}

///|
/// Result reference chips: the blurred Small variant floating over
/// generated imagery, and the Medium variant of an inline chat result row.
fn demo_result_chips(mode : @sumi.ThemeMode?) -> Val[Html] {
  Val::constant(
    stage_mode(mode, [
      @html.div(
        style=[
          "display:flex;flex-direction:column;align-items:flex-start;gap:24px;width:100%;max-width:480px",
        ],
        [
          @html.div(
            style=[
              "position:relative;width:320px;height:180px;border-radius:12px;overflow:hidden",
            ],
            [
              @html.img(src=attachment_thumb(8), alt="", style=[
                "position:absolute;inset:0;width:100%;height:100%;object-fit:cover",
              ]),
              @html.div(
                style=[
                  "position:absolute;left:8px;bottom:8px;display:flex;gap:8px",
                ],
                [
                  @sumi.result_chip(
                    label="Cover Draft",
                    thumbnail=attachment_thumb(3),
                  ),
                  @sumi.result_chip(
                    label="Chart v2",
                    thumbnail=attachment_thumb(11),
                  ),
                ],
              ),
            ],
          ),
          @html.div(style=["display:flex;flex-wrap:wrap;gap:4px"], [
            @sumi.result_chip(
              label="Image",
              thumbnail=attachment_thumb(5),
              size=Medium,
            ),
            @sumi.result_chip(
              label="Draft A",
              thumbnail=attachment_thumb(6),
              size=Medium,
            ),
          ]),
        ],
      ),
    ]),
  )
}

///|
/// The MD 基础组件 type scale: an H2 section head, H3/H4 sub-heads, and
/// body paragraphs, stacked as a chat answer body.
fn demo_md_text(mode : @sumi.ThemeMode?) -> Val[Html] {
  Val::constant(
    stage_mode(mode, [
      @html.div(style=["width:377px;display:flex;flex-direction:column"], [
        @sumi.md_text(kind=H2, text="Launch plan"),
        @sumi.md_text(kind=Body, text=ChatSampleShort),
        @sumi.md_text(kind=H3, text="Timeline"),
        @sumi.md_text(
          kind=Body,
          text="Week one focuses on discovery; weeks two and three cover drafting and review.",
        ),
        @sumi.md_text(kind=H4, text="Open questions"),
        @sumi.md_text(
          kind=Body,
          text="Which metrics matter most, and who signs off on the final summary?",
        ),
      ]),
    ]),
  )
}

///|
/// The info-and-actions block under a generation result: the disclaimer
/// line plus a bare copy action.
fn demo_generation_meta(mode : @sumi.ThemeMode?) -> Val[Html] {
  Val::constant(
    stage_mode(mode, [
      @html.div(style=["width:360px"], [
        @sumi.generation_meta(
          text="AI-generated content | 0 credits used",
          on_copy=@cmd.none,
        ),
      ]),
    ]),
  )
}
