# Skill Chip

The skill pill of the agent's picker — a 36px radius-40 chip with a hairline border, an optional leading icon and New/Hot mark, plus a "More" trigger variant — and the frosted wrap panel that sheets skill chips or quick-action buttons above the input.

## Examples

### Picker & sheets

<SumiDemo name="skill-chips">

```moonbit
@sumi.skill_chip(label="Storyboard", icon=@sumi.icon_draw(size=16), mark=@sumi.New)
@sumi.skill_chip(label="Style Frame", mark=@sumi.Hot)
@sumi.skill_chip(label="More", more=true)

@sumi.chip_panel(children=[
  @sumi.action_chip(label="Storyboard"),
  @sumi.action_chip(label="Shot List"),
])

@sumi.chip_panel(children=[
  @sumi.skill_chip(label="Storyboard", mark=@sumi.Hot),
  @sumi.skill_chip(label="Quick Cut"),
])
```

</SumiDemo>

## API

### skill_chip

| Name | Type | Default | Description |
|---|---|---|---|
| label **\*** | `String` | — | 12/20 chip label |
| icon | `Html` | — | Optional 16px leading icon |
| mark | `SkillMark` | — | Optional `SkillMark` corner tag (`New` / `Hot`) |
| mark_label | `String` | — | Overrides the mark text |
| more | `Bool` | false | "More" trigger: gap 4, pr 12, trailing chevron |
| on_click | `Cmd` | — | Click command |
| disabled | `Bool` | false | Blocks interaction and dims the control |
| aria_label | `String` | — |  |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

### action_chip

| Name | Type | Default | Description |
|---|---|---|---|
| label **\*** | `String` | — | 13/22 Regular centered label |
| on_click | `Cmd` | — | Click command |
| disabled | `Bool` | false | Blocks interaction and dims the control |
| aria_label | `String` | — |  |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

### chip_panel

| Name | Type | Default | Description |
|---|---|---|---|
| children **\*** | `Array[Html]` | — | `skill_chip` / `action_chip` entries |
| width | `Int` | 338 | Panel width in px (default 338) |
| aria_label | `String` | — |  |
| id | `String` | — | Element id |
| class | `String` | — | Extra class names |
| attrs | `Attrs` | — | Extra HTML attributes |
| style | `Array[String]` | [] | Extra inline styles |

### SkillMark

| Variant | Description |
|---|---|
| `New` | ('Brand-blue "new skill" tag', '品牌蓝“新技能”角标') |
| `Hot` | ('Orange "trending skill" tag', '橙色“热门技能”角标') |

\* required (labelled) parameter — everything else is optional.
