#!/usr/bin/env python3
"""Generate the component doc pages (en + zh) from the Sumi source.

API tables are extracted from the component sources in src/ so they stay in
sync with the real signatures; prose (blurbs, demo titles, param descriptions)
is authored in the META table below. Run from the repo root:

    python3 docs/scripts/gen_pages.py
"""

import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# ---------------------------------------------------------------------------
# Source parsing
# ---------------------------------------------------------------------------

def read(path):
    with open(os.path.join(ROOT, path)) as f:
        return f.read()

def parse_fn(src, name):
    """Return list of (param_name, type, default|None, labelled) for pub fn name."""
    m = re.search(r"pub fn(?:\[[^\]]*\])?\s+" + re.escape(name) + r"\s*\(", src)
    if not m:
        return None
    i = m.end()
    depth = 1
    while depth:
        if src[i] == "(":
            depth += 1
        elif src[i] == ")":
            depth -= 1
        i += 1
    body = src[m.end():i - 1]
    params = []
    for part in split_top(body):
        part = part.strip()
        if not part or part == "Self":
            continue
        pm = re.match(r"(\w+)([~?])?\s*:\s*(.+?)(?:\s*=\s*(.+))?$", part, re.S)
        if pm:
            pname, label, ptype, default = pm.groups()
            params.append((pname, fmt_type(ptype), default, label or ""))
    return params

def split_top(s):
    out, depth, cur = [], 0, ""
    for ch in s:
        if ch in "([":
            depth += 1
        elif ch in ")]":
            depth -= 1
        if ch == "," and depth == 0:
            out.append(cur)
            cur = ""
        else:
            cur += ch
    out.append(cur)
    return out

def fmt_type(t):
    t = re.sub(r"\s+", " ", t.strip())
    t = t.replace("@html.", "").replace("@cmd.", "")
    t = t.replace("@overlays.", "").replace("@primitives.", "")
    t = t.replace("@internal.", "")
    return t

def parse_enum(src, name):
    m = re.search(
        r"pub\(all\) enum " + re.escape(name) + r"\s*\{([^}]*)\}", src, re.S
    )
    if not m:
        return None
    variants = []
    for line in m.group(1).splitlines():
        line = line.strip().rstrip(",")
        if not line or line.startswith("//"):
            continue
        vm = re.match(r"([A-Z]\w*)(\(.*)?$", line)
        if vm:
            variants.append(line)
    return variants

PKG_FILES = {
    "primitives": ["button.mbt", "icon.mbt", "tag.mbt", "media_tag.mbt", "badge.mbt", "kbd.mbt", "avatar.mbt", "credits.mbt", "favorite_toggle.mbt", "add_tile.mbt"],
    "forms": ["input.mbt", "textarea.mbt", "select.mbt", "stepper.mbt", "switch.mbt", "checkbox.mbt", "chip.mbt", "attachment_strip.mbt", "slider.mbt", "slider_field.mbt", "segmented.mbt", "prompt_box.mbt", "agent_input.mbt"],
    "overlays": ["checkbox_menu.mbt", "dropdown_menu.mbt", "context_menu.mbt", "popover.mbt", "tooltip.mbt", "dialog.mbt", "toast.mbt", "menu.mbt"],
    "feedback": ["progress.mbt", "skeleton.mbt", "empty_state.mbt", "alert.mbt", "status_badge.mbt", "shimmer_text.mbt", "tool_call_row.mbt"],
    "layout": ["card.mbt", "toolbar.mbt", "tabs.mbt", "divider.mbt", "pagination.mbt", "shortcuts_panel.mbt", "chat_bubble.mbt"],
}

def pkg_src(pkg):
    out = []
    for f in PKG_FILES[pkg]:
        p = f"src/{pkg}/{f}"
        if os.path.exists(os.path.join(ROOT, p)):
            out.append(read(p))
    return "\n".join(out)

# ---------------------------------------------------------------------------
# Shared prose
# ---------------------------------------------------------------------------

COMMON = {
    "id": ("Element id", "元素 id"),
    "class": ("Extra class names", "附加 class 名"),
    "attrs": ("Extra HTML attributes", "附加 HTML 属性"),
    "style": ("Extra inline styles", "附加内联样式"),
    "title": ("Native tooltip title", "原生 tooltip 标题"),
    "name": ("Form field name", "表单字段名"),
    "disabled": ("Blocks interaction and dims the control", "禁用交互并降低不透明度"),
    "on_click": ("Click command", "点击时发送的命令"),
    "autofocus": "FOCUS",
    "value": "VALUE",
    "open": ("Whether the overlay is open (controlled)", "浮层是否打开（受控）"),
    "on_open_change": ("Called when the open state should change", "打开状态应变化时调用"),
    "selected": ("Value of the currently selected item", "当前选中项的值"),
    "on_select": ("Called with the value of the picked item", "选中某项时以其值调用"),
    "placeholder": ("Placeholder text", "占位文本"),
    "on_input": ("Called on every input", "每次输入时调用"),
    "on_change": ("Called when the value changes", "值变化时调用"),
    "checked": ("Whether the control is checked (controlled)", "是否选中（受控）"),
    "maxlength": ("Maximum character count", "最大字符数"),
    "children": ("Content", "内容"),
}

FOCUS = ("Focus the control on mount", "挂载后自动聚焦")

CHILDREN = ("Content", "内容")

# ---------------------------------------------------------------------------
# Page specs
# ---------------------------------------------------------------------------

def demo(name, title_en, title_zh, code):
    return {"name": name, "title_en": title_en, "title_zh": title_zh, "code": code.strip()}

def api(fn, desc_en="", desc_zh="", params=None, note_en=None, note_zh=None):
    return {"fn": fn, "desc_en": desc_en, "desc_zh": desc_zh,
            "params": params or {}, "note_en": note_en, "note_zh": note_zh}

def enum(name, pkg, desc_en=None, desc_zh=None):
    return {"enum": name, "pkg": pkg, "desc_en": desc_en or {}, "desc_zh": desc_zh or {}}

def page(slug, pkg, title_en, title_zh, blurb_en, blurb_zh, demos, apis, enums=(), extra_en="", extra_zh=""):
    return locals()

PAGES = [
    page(
        "button", "primitives", "Button", "Button 按钮",
        "Triggers an action with a click. Three variants, two text sizes, and built-in disabled, pressed and loading states.",
        "点击触发动作。三种变体、两种文字尺寸，内置禁用、按下选中与加载状态。",
        [
            demo("button-basic", "Variants & states", "变体与状态", """
@sumi.button(variant=@sumi.Primary, "Generate")
@sumi.button(variant=@sumi.Secondary, "HD Enhance")
@sumi.button(variant=@sumi.Ghost, [
  @sumi.icon_sparkle(),
  @html.text("AI Edit"),
])
@sumi.button(variant=@sumi.Primary, disabled=true, "Generate")
@sumi.button(variant=@sumi.Primary, loading=true, "Generate")"""),
            demo("button-sizes", "Sizes", "尺寸", """
@sumi.button(variant=@sumi.Primary, "Apply")
@sumi.button(variant=@sumi.Primary, size=@sumi.Sm, "Apply")
@sumi.button(variant=@sumi.Secondary, size=@sumi.Sm, "Apply")
@sumi.button(variant=@sumi.Ghost, size=@sumi.Sm, "Options")"""),
        ],
        [
            api("button", params={
                "variant": ("Visual style", "视觉风格"),
                "size": ("Control size", "控件尺寸"),
                "disabled": ("Blocks clicks; primary keeps a tinted fill", "阻止点击；主按钮保留淡色填充"),
                "pressed": ("Selected fill + `aria-pressed`, for tool toggles", "选中填充 + `aria-pressed`，用于工具切换"),
                "loading": ("Keeps width, hides content, centers a 16px spinner", "保持宽度，隐藏内容，居中显示 16px 加载圈"),
                "type_": ("Native `type` attribute", "原生 `type` 属性"),
                "value": ("Native `value` attribute", "原生 `value` 属性"),
            }),
        ],
        [
            enum("ButtonVariant", "primitives", {
                "Primary": "Filled accent surface for the main action",
                "Secondary": "Neutral filled surface (default)",
                "Ghost": "Transparent until hovered, for toolbars and menus",
            }, {
                "Primary": "实心强调表面，用于主要动作",
                "Secondary": "中性实心表面（默认）",
                "Ghost": "默认透明、悬停显现，用于工具栏与菜单",
            }),
            enum("ButtonSize", "primitives", {
                "Default": "32px height, 16px horizontal padding",
                "Sm": "28px height; ghost-sm is the menu-trigger size",
                "Icon": "32×32 square (icon_button)",
                "IconSm": "28×28 square (icon_button)",
            }, {
                "Default": "32px 高，水平内边距 16px",
                "Sm": "28px 高；ghost-sm 即菜单触发器尺寸",
                "Icon": "32×32 方形（icon_button）",
                "IconSm": "28×28 方形（icon_button）",
            }),
        ],
    ),
    page(
        "icon-button", "primitives", "Icon Button", "Icon Button 图标按钮",
        "A square button for a single icon, with an accessible label. `pressed` turns it into a tool toggle.",
        "承载单个图标的方形按钮，带无障碍标签。`pressed` 可将其变为工具切换钮。",
        [
            demo("icon-button-basic", "Basic usage", "基础用法", """
@sumi.icon_button(@sumi.icon_download(), aria_label="Download")
@sumi.icon_button(@sumi.icon_crop(), pressed=true, aria_label="Crop (active tool)")
@sumi.icon_button(@sumi.icon_x(), size=@sumi.IconSm, aria_label="Close")
@sumi.icon_button(@sumi.icon_upload(), disabled=true, aria_label="Export")"""),
        ],
        [
            api("icon_button", params={
                "variant": ("Visual style", "视觉风格"),
                "size": ("`Icon` 32×32 or `IconSm` 28×28", "`Icon` 32×32 或 `IconSm` 28×28"),
                "pressed": ("Selected fill + `aria-pressed`", "选中填充 + `aria-pressed`"),
                "aria_label": ("Accessible label (required for icon-only buttons)", "无障碍标签（纯图标按钮必填）"),
            }),
        ],
        [enum("ButtonVariant", "primitives"), enum("ButtonSize", "primitives")],
    ),
    page(
        "favorite-toggle", "primitives", "Favorite Toggle", "Favorite Toggle 收藏切换",
        "A chrome-less star button that toggles a favorite on or off. Unlike `icon_button` it carries no hover plate; state shows through the glyph alone — outline star at rest, filled amber when on.",
        "无底盘的星形收藏切换按钮。与 `icon_button` 不同，它没有悬停底板，状态完全通过图标呈现：常态为描边星形，收藏后为实心琥珀色。",
        [
            demo("favorite-toggle", "Basic usage", "基础用法", """
@sumi.favorite_toggle(checked=fav, on_change=set_fav.map(v => _ => v))
@sumi.favorite_toggle(checked=true, disabled=true)"""),
        ],
        [
            api("favorite_toggle", params={
                "checked": ("Current on/off state (controlled)", "当前收藏状态（受控）"),
                "on_change": ("Emitted with the flipped value on click", "点击时以翻转后的值触发"),
                "disabled": ("Faded and inert", "置灰且不可交互"),
                "aria_label": ("Override the accessible label (defaults flip with state)", "覆盖无障碍标签（默认随状态切换）"),
            }),
        ],
        [],
    ),
    page(
        "add-tile", "primitives", "Add Tile", "Add Tile 添加磁贴",
        "The 48px add tile: a quiet bordered square with a centered plus. Compose it as a `dropdown_menu` trigger to open an upload/picker menu above; hover raises the fill to the primary block.",
        "48px 的添加磁贴：低调的描边方块中央一个加号。可作为 `dropdown_menu` 的触发器组合，在上方弹出上传/选取菜单；悬停时填充提升为主块色。",
        [
            demo("add-tile-basic", "With picker menu", "带选取菜单", """
@sumi.dropdown_menu(
  trigger=@sumi.add_tile(aria_label="Add image"),
  items=[
    Item(@sumi.MenuItem::new("upload", "Upload image",
      icon=@sumi.icon_upload_fill())),
    Item(@sumi.MenuItem::new("assets", "Select from assets",
      icon=@sumi.icon_folder())),
    Item(@sumi.MenuItem::new("canvas", "Select from canvas",
      icon=@sumi.icon_target())),
  ],
  open=is_open,
  on_open_change=set_open.map(v => _ => v),
  side=@sumi.Top,
  menu_style=["width:240px"],
)
@sumi.add_tile(disabled=true)"""),
        ],
        [
            api("add_tile", params={
                "on_click": ("Click command (usually the menu toggle via composition)", "点击命令（组合用法下通常是菜单开关）"),
                "disabled": ("Faded plus and inert", "加号置灰且不可交互"),
                "aria_label": ("Accessible label (defaults to \"Add\")", "无障碍标签（默认 \"Add\"）"),
            }),
        ],
        [],
    ),
    page(
        "toolbar", "layout", "Toolbar", "Toolbar 工具栏",
        "A frosted action bar grouping menus, segmented controls, credits and the primary submit. Dividers separate clusters.",
        "磨砂质感的动作栏，将菜单、分段选择器、额度与主提交按钮编组，分组之间用分隔线区隔。",
        [
            demo("toolbar-basic", "Composed toolbar", "组合工具栏", """
@sumi.toolbar([
  @sumi.dropdown_menu(trigger=..., items=..., ...),
  @sumi.toolbar_divider(),
  @sumi.segmented(items=..., selected=..., on_select=...),
  @sumi.toolbar_divider(),
  @sumi.credits(value=24),
  @sumi.button(variant=@sumi.Primary, [
    @sumi.icon_sparkle(size=14),
    @html.text("Generate"),
  ]),
])"""),
        ],
        [
            api("toolbar", params={}),
            api("toolbar_divider", desc_en="A 1px vertical rule between toolbar clusters.",
                desc_zh="工具栏分组之间的 1px 竖线。"),
        ],
    ),
    page(
        "input", "forms", "Input", "Input 输入框",
        "Single-line text field with prefix/suffix adornments, clear button, and error presentation.",
        "单行文本框，支持前后缀装饰、清除按钮与错误展示。",
        [
            demo("input-basic", "Basic usage", "基础用法", """
@sumi.input(
  value=current,
  placeholder="Search projects",
  prefix=@sumi.icon_search(size=14),
  clearable=true,
  on_input=set_name.map(v => _ => v),
)"""),
            demo("input-states", "States", "状态", """
@sumi.input(value="Read only field", read_only=true)
@sumi.input(value="Disabled field", disabled=true)
@sumi.input(
  value="Untitled/:",
  error=true,
  error_text="Project name contains invalid characters",
)"""),
        ],
        [
            api("input", params={
                "value": ("Current text (controlled)", "当前文本（受控）"),
                "input_type": ("Native input type (`Text`, `Password`, …)", "原生输入类型（`Text`、`Password` 等）"),
                "on_clear": ("Custom clear behavior for `clearable`", "`clearable` 的自定义清除行为"),
                "clearable": ("Shows a ✕ button while non-empty", "非空时显示清除按钮"),
                "prefix": ("Leading adornment (icon)", "前置装饰（图标）"),
                "suffix": ("Trailing adornment", "后置装饰"),
                "error": ("Error border + `aria-invalid`", "错误边框 + `aria-invalid`"),
                "error_text": ("Error line rendered below the field", "在输入框下方渲染错误行"),
                "read_only": ("Read-only field", "只读"),
            }),
        ],
    ),
    page(
        "textarea", "forms", "Textarea", "Textarea 多行文本",
        "Multi-line plain-text field.",
        "多行纯文本输入框。",
        [
            demo("textarea-basic", "Basic usage", "基础用法", """
@sumi.textarea(
  value=current,
  placeholder="Add release notes",
  rows=4,
  on_input=set_notes.map(v => _ => v),
)"""),
        ],
        [
            api("textarea", params={
                "value": ("Current text (controlled)", "当前文本（受控）"),
                "rows": ("Visible row count", "可见行数"),
                "read_only": ("Read-only field", "只读"),
            }),
        ],
    ),
    page(
        "select", "forms", "Select", "Select 选择器",
        "An input-look trigger over a compact menu pinned to the trigger width. Shares `MenuItem` with dropdown menus.",
        "输入框外观的触发器，展开与触发器等宽的紧凑菜单。与下拉菜单共用 `MenuItem`。",
        [
            demo("select-basic", "Basic usage", "基础用法", """
@sumi.select(
  options=[
    @sumi.MenuItem::new("png", "PNG"),
    @sumi.MenuItem::new("jpg", "JPG"),
    @sumi.MenuItem::new("webp", "WebP"),
  ],
  value=current,
  placeholder="Export format",
  open=is_open,
  on_open_change=set_open.map(v => _ => v),
  on_select=set_format.map(v => _ => v),
)"""),
            demo("select-filter", "Filter trigger", "筛选触发器", """
@sumi.select(
  options=[
    @sumi.MenuItem::new("design", "Design"),
    @sumi.MenuItem::new("engineering", "Engineering"),
    @sumi.MenuItem::new("marketing", "Marketing"),
  ],
  value=current,
  placeholder="Team",
  open=is_open,
  on_open_change=set_open.map(v => _ => v),
  on_select=set_team.map(v => _ => v),
  variant=Filter,
  on_clear=set_team(_ => ""),
)"""),
        ],
        [
            api("select", params={
                "options": ("Option list", "选项列表"),
                "value": ("Selected value (controlled)", "选中值（受控）"),
                "variant": ("`Form` input look, `Filter` compact toolbar trigger", "`Form` 输入框外观，`Filter` 紧凑工具栏触发器"),
                "on_clear": ("Filter variant: emitted by the clear affordance", "Filter 变体：清除按钮触发"),
            }),
            api("MenuItem::new", desc_en="One menu option.",
                desc_zh="一个菜单项。", params={
                "0": ("`value~` item value, `String` label", "`value~` 项的值，`String` 标签"),
                "description": ("Secondary line for rich items", "富文本项的次级描述行"),
                "icon": ("Leading icon", "前置图标"),
                "shortcut": ("Right-aligned shortcut hint", "右对齐快捷键提示"),
            }),
        ],
        [
            enum("SelectVariant", "forms", {
                "Form": "Input-look trigger pinned to full width (default)",
                "Filter": "Compact trigger naming the filter until a value is set",
            }, {
                "Form": "输入框外观，占满宽度（默认）",
                "Filter": "紧凑触发器，未筛选时显示筛选名",
            }),
        ],
    ),
    page(
        "stepper", "forms", "Stepper", "Stepper 步进器",
        "Segmented − value + control that clamps at min/max.",
        "分段的 − 值 + 控件，在 min/max 处钳位。",
        [
            demo("stepper-basic", "Basic usage", "基础用法", """
@sumi.stepper(
  value=current,
  min=1,
  max=8,
  on_change=set_count.map(v => _ => v),
)"""),
        ],
        [
            api("stepper", params={
                "value": ("Current number (controlled)", "当前数值（受控）"),
                "min": ("Lower clamp", "下限"),
                "max": ("Upper clamp", "上限"),
                "step": ("Increment per click", "每次点击的步长"),
            }),
        ],
    ),
    page(
        "switch", "forms", "Switch", "Switch 开关",
        "A binary on/off toggle. Brand-blue when on.",
        "二元开关。打开时为品牌蓝。",
        [
            demo("switch-basic", "Basic usage", "基础用法", """
@sumi.switch(checked=is_on, on_change=set_enabled.map(v => _ => v))
@sumi.switch(checked=is_on, disabled=true)"""),
        ],
        [
            api("switch", params={}),
        ],
    ),
    page(
        "checkbox", "forms", "Checkbox", "Checkbox 复选框",
        "A labeled checkbox with an indeterminate state for partial selection.",
        "带标签的复选框，支持表示部分选中的不定状态。",
        [
            demo("checkbox-basic", "Basic usage", "基础用法", """
@sumi.checkbox(
  checked=is_checked,
  label="Keep original size",
  on_change=set_checked.map(v => _ => v),
)
@sumi.checkbox(
  checked=false,
  indeterminate=true,
  label="Select all",
  on_change=set_checked.map(v => _ => v),
)"""),
        ],
        [
            api("checkbox", params={
                "label": ("Label text next to the box", "复选框旁的标签文本"),
                "indeterminate": ("Mixed state; clicking resolves to checked", "不定状态；点击后变为选中"),
            }),
        ],
    ),
    page(
        "slider", "forms", "Slider", "Slider 滑块",
        "Draggable value track. `on_input` fires per tick; `on_commit` fires once on release so expensive reactions don't fan out.",
        "可拖拽的数值轨道。`on_input` 每次移动触发；`on_commit` 在释放时触发一次，避免昂贵响应被放大。",
        [
            demo("slider-basic", "With value", "带数值显示", """
@sumi.slider(
  value=current,
  show_value=true,
  suffix="°",
  on_input=set_strength.map(v => _ => v),
)"""),
            demo("slider-tooltip", "Value bubble", "跟随气泡", """
@sumi.slider(
  value=current,
  value_tooltip=true,
  on_input=set_amount.map(v => _ => v),
)"""),
        ],
        [
            api("slider", params={
                "value": ("Current value (controlled)", "当前值（受控）"),
                "min": ("Lower bound", "下限"),
                "max": ("Upper bound", "上限"),
                "step": ("Tick size", "步长"),
                "on_commit": ("Called once on release", "释放时调用一次"),
                "show_value": ("Right-aligned numeric readout", "右侧数值显示"),
                "value_tooltip": ("Bubble above the thumb while interacting", "交互时滑块上方的跟随气泡"),
                "suffix": ("Unit appended to the readout", "数值显示的单位后缀"),
            }),
        ],
    ),
    page(
        "slider-field", "forms", "Slider Field", "Slider Field 滑杆字段",
        "A labelled numeric field composing the slider with tick marks and labels plus a number box with unit suffix; an optional auto row adds a switch.",
        "带标签的数值字段：滑杆组合刻度标记与刻度标签，外加带单位后缀的数字框；可选自动行提供开关。",
        [
            demo("slider-field", "Ticks & number box", "刻度与数字框", """
@sumi.slider_field(
  value=current,
  min=0,
  max=180,
  label="Clip length",
  unit="s",
  ticks=[0, 30, 60, 90, 120, 150, 180],
  auto=is_auto,
  on_auto_change=set_auto.map(v => _ => v),
  on_input=set_length.map(v => _ => v),
)"""),
        ],
        [
            api("slider_field", params={
                "value": ("Current value (controlled)", "当前值（受控）"),
                "label": ("Title above the track; also the number-box aria label", "轨道上方标题，同时作为数字框 aria 标签"),
                "unit": ("Suffix inside the number box", "数字框内单位后缀"),
                "ticks": ("Values getting a track mark and a label", "带刻度标记与标签的值"),
                "auto": ("Shows the auto row with a switch when given", "传入时显示带开关的自动行"),
                "on_input": ("Per-tick during drags and number commits", "拖拽逐格与数字提交时触发"),
                "on_commit": ("On release and number commits", "释放与数字提交时触发"),
            }),
        ],
    ),
    page(
        "chip", "forms", "Chip", "Chip 选项片",
        "A single selectable pill — the quality-option look from the design. Text stays full-white in both states; selection shows through the block fill alone. Group several chips under one value for a radio-like row.",
        "单个可选药丸片。两种状态下文字均为全白，选中态仅通过块填充体现。将多个 chip 绑定到同一个值即可组成单选行。",
        [
            demo("chip-row", "Quality row", "质量选项行", """
@sumi.chip("720P", selected=quality == "720P",
  on_click=set_quality(_ => "720P"))
@sumi.chip("8K", disabled=true)"""),
        ],
        [
            api("chip", params={
                "0": ("`String` label", "`String` 标签"),
                "selected": ("Filled on-state (controlled)", "填充选中态（受控）"),
                "on_click": ("Click command (wire to your state)", "点击命令（接到你的状态）"),
                "disabled": ("Faded and inert", "置灰且不可交互"),
            }),
        ],
        [],
    ),
    page(
        "attachment-strip", "forms", "Attachment Strip", "Attachment Strip 附件条",
        "A row of 48px attachment tiles — cover-fit image thumbnails and slate-gradient document placeholders — followed by an add tile. Hovering a tile reveals its 8px remove badge. Past `max_visible` items the row clips, a right-edge fade appears, and the add tile pins over it.",
        "一排 48px 附件块：裁切填充的图片缩略图与石板渐变文档占位块，末尾跟随添加块。悬停附件块会显现 8px 移除角标。超过 `max_visible` 时行被裁断，右缘出现渐隐遮罩，添加块固定在遮罩之上。",
        [
            demo("attachment-strip", "Add & remove", "添加与移除", """
@sumi.attachment_strip(
  items=[
    @sumi.AttachmentItem::image("cover.png", label="Cover"),
    @sumi.AttachmentItem::document("Brief.pdf"),
  ],
  on_add=pick_files,
  on_remove=set_items.map(i => c => remove_at(c, i)),
)"""),
        ],
        [
            api("attachment_strip", params={
                "items": ("Attachments to render, in order", "按顺序渲染的附件"),
                "on_add": ("Adds the trailing add tile; in overflow it pins to the right edge", "提供则渲染末尾添加块；溢出时固定在右缘"),
                "on_remove": ("Emitted with the item index from the hover badge", "悬停角标触发，携带附件下标"),
                "max_visible": ("Visible tile cap before the fade + pinned add (default 10)", "超出该数量后出现渐隐遮罩与固定添加块（默认 10）"),
                "aria_label": ("Strip label (defaults to \"Attachments\")", "整条的无障碍标签（默认 \"Attachments\"）"),
            }),
            api("AttachmentItem::image", desc_en="An image attachment.", desc_zh="一个图片附件。", params={
                "0": ("`String` thumbnail URL", "`String` 缩略图地址"),
                "label": ("Alt text (defaults to \"Image attachment\")", "替代文本（默认 \"Image attachment\"）"),
            }),
            api("AttachmentItem::document", desc_en="A non-image attachment, rendered as a gradient placeholder.", desc_zh="非图片附件，渲染为渐变占位块。", params={
                "0": ("`String` file name used as the accessible label", "`String` 文件名，用作无障碍标签"),
            }),
        ],
        [enum("AttachmentKind", "forms", {
            "Image": "Cover-fit thumbnail tile",
            "Document": "Slate-gradient placeholder with a document glyph",
        }, {
            "Image": "裁切填充的缩略图块",
            "Document": "石板渐变占位块，带文档图标",
        })],
    ),
    page(
        "segmented", "forms", "Segmented", "Segmented 分段选择器",
        "A row of mutually exclusive options. `stacked` renders tall ratio-picker items with proportional artwork.",
        "一行互斥选项。`stacked` 渲染带比例示意图的高项，适合宽高比选择。",
        [
            demo("segmented-basic", "Row mode", "行模式", """
@sumi.segmented(
  items=[
    @sumi.SegmentedItem::new("2k", "2K", numeric=true),
    @sumi.SegmentedItem::new("4k", "4K", numeric=true, trailing=sparkle),
    @sumi.SegmentedItem::new("8k", "8K", numeric=true, trailing=sparkle),
  ],
  selected=current,
  on_select=set_res.map(v => _ => v),
)"""),
            demo("segmented-stacked", "Stacked ratio picker", "堆叠比例选择", """
@sumi.segmented(
  stacked=true,
  items=[
    @sumi.SegmentedItem::new("16:9", "16:9", numeric=true,
      icon=@sumi.icon_ratio(width=16, height=9)),
    @sumi.SegmentedItem::new("1:1", "1:1", numeric=true,
      icon=@sumi.icon_ratio(width=1, height=1)),
  ],
  selected=current,
  on_select=set_ratio.map(v => _ => v),
)"""),
        ],
        [
            api("segmented", params={
                "items": ("Option list", "选项列表"),
                "selected": ("Value of the selected option (controlled)", "选中项的值（受控）"),
                "stacked": ("Tall icon-over-label layout", "图标在上、标签在下的高布局"),
            }),
            api("SegmentedItem::new", desc_en="One option.", desc_zh="一个选项。", params={
                "0": ("`String` value, `String` label", "`String` 值，`String` 标签"),
                "icon": ("Leading artwork (stacked mode)", "前置图形（堆叠模式）"),
                "trailing": ("Trailing marker (e.g. a premium sparkle)", "尾部标记（如高级能力标识）"),
                "numeric": ("Numeric font rendering", "使用数字字体渲染"),
            }),
        ],
    ),
    page(
        "prompt-box", "forms", "Prompt Box", "Prompt Box 提示输入框",
        "A frosted multi-line prompt dock with a circular send button, optional character count, and an actions slot for pickers.",
        "磨砂多行输入坞，带圆形发送按钮、可选字符计数，以及放置选择器等操作的动作槽。",
        [
            demo("prompt-box-basic", "With action picker", "带操作选择器", """
@sumi.prompt_box(
  value=current_prompt,
  placeholder="Describe what to create",
  on_input=set_prompt.map(v => _ => v),
  on_send=set_prompt(_ => ""),
  send_disabled=current_prompt.is_empty(),
  actions=@sumi.dropdown_menu(...),
)"""),
            demo("prompt-box-count", "Character count", "字符计数", """
@sumi.prompt_box(
  value=current,
  rows=3,
  maxlength=120,
  show_count=true,
  on_input=set_prompt.map(v => _ => v),
)"""),
            demo("send-button-basic", "Send button", "发送按钮", """
@sumi.send_button(aria_label="Send")
@sumi.send_button(disabled=true, aria_label="Send (disabled)")
@sumi.send_button(loading=true, aria_label="Sending")"""),
        ],
        [
            api("prompt_box", params={
                "value": ("Current text (controlled)", "当前文本（受控）"),
                "rows": ("Visible row count", "可见行数"),
                "on_send": ("Send command (button or ⌘Enter)", "发送命令（按钮或 ⌘Enter）"),
                "send_disabled": ("Disables the send button", "禁用发送按钮"),
                "send_loading": ("Swaps the arrow for a spinner", "将箭头替换为加载圈"),
                "show_count": ("Renders `n / max`, red when over", "显示 `n / max`，超出时变红"),
                "actions": ("Leading slot for pickers and tools", "放置选择器与工具的前置槽位"),
            }),
            api("send_button", desc_en="The standalone circular send button.",
                desc_zh="独立的圆形发送按钮。", params={
                "loading": ("Spinner in the disabled tone", "以禁用色调显示加载圈"),
                "stop": ("Stop square for halting a generation", "用于停止生成的方块图标"),
            }),
        ],
    ),
    page(
        "agent-input", "forms", "Agent Input", "Agent Input 输入框",
        "The agent chat dock: a frosted container pairing an auto-clamped input region with a toolbar row of action atoms and a circular send button; the send button becomes a stop affordance while generating.",
        "Agent 会话输入坞：磨砂容器，输入区自动限高；工具行左侧为操作原子，右侧为圆形发送按钮，生成中切换为停止按钮。",
        [
            demo("agent-input", "Chat dock", "会话输入坞", """
@sumi.agent_input(
  value=current,
  placeholder="Describe your idea, or type / to use a skill",
  on_input=set_prompt.map(v => _ => v),
  on_send=set_prompt(_ => ""),
  send_disabled=current.is_empty(),
  actions=[
    @sumi.icon_button(@sumi.icon_plus_fill(size=14), aria_label="Add attachment"),
    @sumi.agent_tool_button(@sumi.icon_skill(), label="Use Skill"),
    @sumi.icon_button(@sumi.icon_at(), aria_label="Mention a reference"),
  ],
)"""),
        ],
        [
            api("agent_input", params={
                "value": ("Current text (controlled)", "当前文本（受控）"),
                "rows": ("Visible row count of the textarea", "输入区可见行数"),
                "on_send": ("Send command", "发送命令"),
                "on_stop": ("Stop command while `generating`", "`generating` 时的停止命令"),
                "send_disabled": ("Disables the send button", "禁用发送按钮"),
                "send_loading": ("Swaps the glyph for a spinner", "将图标替换为加载圈"),
                "generating": ("Swaps send for the stop square", "将发送按钮切换为停止方块"),
                "actions": ("Left toolbar atoms (icon buttons, tool pills)", "左侧工具原子（图标按钮、工具 pill）"),
                "children": ("Rich inline content replacing the textarea", "替换输入区的富文本内容"),
            }),
            api("agent_tool_button", desc_en="The icon-leading toolbar pill.",
                desc_zh="图标前置的工具 pill。", params={
                "0": ("`Html` icon (16px)", "`Html` 图标（16px）"),
                "label": ("12/20 label text", "12/20 标签文本"),
            }),
        ],
    ),
    page(
        "editable-text", "forms", "Editable Text", "Editable Text 可编辑文本",
        "A title that reads as plain text and becomes an input on click; Enter or blur commits, Escape reverts.",
        "看似普通文本，点击变为输入框；Enter 或失焦提交，Escape 还原。",
        [
            demo("editable-text-basic", "Click to rename", "点击重命名", """
@sumi.editable_text(
  value=current,
  placeholder="Enter a canvas name",
  on_change=set_title.map(v => _ => v),
)
@sumi.editable_text(value="", placeholder="Enter a canvas name")"""),
        ],
        [
            api("editable_text", params={
                "value": ("Committed text (controlled)", "已提交文本（受控）"),
                "placeholder": ("Shown when the value is empty", "值为空时显示"),
                "read_only": ("Renders as plain text", "渲染为纯文本"),
                "on_change": ("Commits on Enter or blur; Escape reverts", "Enter 或失焦时提交；Escape 还原"),
            }),
        ],
    ),
    page(
        "dropdown-menu", "overlays", "Dropdown Menu", "Dropdown Menu 下拉菜单",
        "A trigger-anchored menu with compact or rich items, section labels, separators and shortcut hints. Keyboard navigation and dismissal are handled by the theme's event layer.",
        "锚定触发器的菜单，支持紧凑或富文本项、分组标签、分隔线与快捷键提示。键盘导航与关闭行为由主题的事件层处理。",
        [
            demo("dropdown-menu-basic", "Rich items", "富文本项", """
@sumi.dropdown_menu(
  trigger=@sumi.button(variant=@sumi.Secondary, [
    @html.text("Enhance"),
    @sumi.menu_chevron(),
  ]),
  items=[
    @sumi.SectionLabel("QUALITY"),
    @sumi.Item(@sumi.MenuItem::new(
      "standard", "Standard",
      description="Balanced clarity for everyday images",
      icon=@sumi.icon_sparkle(size=16),
    )),
  ],
  open=is_open,
  on_open_change=set_open.map(v => _ => v),
  selected=current,
  on_select=set_choice.map(v => _ => v),
)"""),
            demo("dropdown-menu-compact", "Compact with shortcuts", "紧凑项与快捷键", """
items=[
  @sumi.Item(@sumi.MenuItem::new("rename", "Rename", shortcut="R")),
  @sumi.Item(@sumi.MenuItem::new("duplicate", "Duplicate",
    icon=@sumi.icon_layers(size=14), shortcut="⌘D")),
  @sumi.Separator,
  @sumi.Item(@sumi.MenuItem::new("delete", "Delete",
    icon=@sumi.icon_x(size=14), shortcut="⌫")),
]"""),
        ],
        [
            api("dropdown_menu", params={
                "items": ("Menu content — `Item`, `Separator`, `SectionLabel`", "菜单内容——`Item`、`Separator`、`SectionLabel`"),
                "trigger": ("The anchor element", "锚点元素"),
                "align": ("Horizontal alignment against the trigger", "相对触发器的水平对齐"),
                "side": ("Open above or below the trigger", "在触发器上方或下方展开"),
                "trigger_style": ("Styles for the trigger wrapper", "触发器包裹层的样式"),
                "menu_style": ("Styles for the floating panel", "浮层面板的样式"),
            }),
            api("menu_chevron", desc_en="The rotating trigger chevron (180° while open).",
                desc_zh="随菜单开合旋转 180° 的触发器箭头。"),
            api("MenuItem::new", desc_en="One menu item.", desc_zh="一个菜单项。", params={
                "0": ("`String` value, `String` label", "`String` 值，`String` 标签"),
                "description": ("Secondary line (rich layout)", "次级描述行（富文本布局）"),
                "icon": ("Leading icon", "前置图标"),
                "shortcut": ("Right-aligned shortcut hint", "右对齐快捷键提示"),
            }),
        ],
        [
            enum("MenuAlign", "overlays", {
                "Start": "Align the panel's left edge to the trigger",
                "End": "Align the panel's right edge to the trigger",
            }, {
                "Start": "面板左缘对齐触发器",
                "End": "面板右缘对齐触发器",
            }),
            enum("MenuSide", "overlays", {
                "Bottom": "Open below the trigger (default)",
                "Top": "Open above the trigger (input docks)",
            }, {
                "Bottom": "在触发器下方展开（默认）",
                "Top": "在触发器上方展开（输入坞）",
            }),
        ],
    ),
    page(
        "checkbox-menu", "overlays", "Checkbox Menu", "Checkbox Menu 多选菜单",
        "A multi-select menu panel: grouped rows carrying an outline checkbox that toggle independently, an optional per-group clear action, and a pinned footer row. The body scrolls past the max height.",
        "多选菜单面板：分组行右侧带描边勾选框，各行独立切换；支持分组清空操作与底部固定行，内容超出最大高度时滚动。",
        [
            demo("checkbox-menu", "Grouped multi-select", "分组多选", """
@sumi.checkbox_menu(
  groups=[
    @sumi.CheckboxMenuGroup::new([
      @sumi.CheckboxMenuItem::new("text", "Text", checked=true),
      @sumi.CheckboxMenuItem::new("date", "Date"),
    ], title="Fields", clear_label="Clear", on_clear=clear_fields),
  ],
  on_toggle=set_selected.map(v => fn(c) { toggle(c, v) }),
  footer_label="Show all",
  on_footer=show_all,
)"""),
        ],
        [
            api("checkbox_menu", params={
                "groups": ("Titled sections of rows; a hairline sits between groups", "带标题的分组行；组间以细分隔线相隔"),
                "on_toggle": ("Emits the clicked row's `value`", "点击行时发出其 `value`"),
                "width": ("Panel width — the design's steps are 160/200/240/320", "面板宽度——设计规格档位为 160/200/240/320"),
                "max_height": ("Scroll threshold for the body", "正文区域的滚动阈值"),
                "footer_label": ("Pinned row below the scroll area", "滚动区下方的固定行"),
                "footer_icon": ("Leading icon of the footer row", "固定行的前置图标"),
                "on_footer": ("Footer row activation", "固定行的激活回调"),
            }),
            api("CheckboxMenuGroup::new", desc_en="One titled section.", desc_zh="一个带标题的分组。", params={
                "0": ("`Array[CheckboxMenuItem]` rows", "`Array[CheckboxMenuItem]` 行"),
                "title": ("Section caption", "分组小标题"),
                "clear_label": ("Text action at the title's right edge", "标题右侧的文字操作"),
                "on_clear": ("Clear action command", "清空操作命令"),
            }),
            api("CheckboxMenuItem::new", desc_en="One toggleable row.", desc_zh="一个可切换的行。", params={
                "0": ("`String` value, `String` label", "`String` 值，`String` 标签"),
                "icon": ("Leading icon", "前置图标"),
                "checked": ("Controlled checked flag", "受控选中状态"),
                "disabled": ("Dims and deactivates the row", "置灰并禁用该行"),
            }),
        ],
    ),
    page(
        "context-menu", "overlays", "Context Menu", "Context Menu 上下文菜单",
        "Right-click menu fixed at the pointer position. The theme's event layer suppresses the native menu, records the pointer, and focuses the first item.",
        "固定于指针位置的右键菜单。主题事件层负责屏蔽原生菜单、记录指针位置并聚焦首项。",
        [
            demo("context-menu-basic", "Right-click the tile", "右键点击方块", """
@sumi.context_menu(
  entries=[
    @sumi.Item(@sumi.MenuItem::new("rename", "Rename", shortcut="R")),
    @sumi.Separator,
    @sumi.Item(@sumi.MenuItem::new("delete", "Delete", shortcut="⌫")),
  ],
  open=is_open,
  on_open_change=set_open.map(v => _ => v),
  on_select=set_action.map(v => _ => v),
  target_content,
)"""),
        ],
        [
            api("context_menu", params={
                "entries": ("Menu content — `Item`, `Separator`, `SectionLabel`", "菜单内容——`Item`、`Separator`、`SectionLabel`"),
                "menu_style": ("Styles for the floating panel", "浮层面板的样式"),
            }),
        ],
    ),
    page(
        "popover", "overlays", "Popover", "Popover 气泡卡片",
        "A trigger-anchored free-content panel for small forms and inspectors.",
        "锚定触发器的自由内容面板，适合放置小型表单与检查器。",
        [
            demo("popover-basic", "With a slider inside", "内嵌滑块", """
@sumi.popover(
  trigger=@sumi.button(variant=@sumi.Secondary, [
    @sumi.icon_adjust(size=14),
    @html.text("Adjust"),
  ]),
  open=is_open,
  on_open_change=set_open.map(v => _ => v),
  panel_content,
)"""),
        ],
        [
            api("popover", params={
                "trigger": ("The anchor element", "锚点元素"),
                "align": ("Horizontal alignment against the trigger", "相对触发器的水平对齐"),
                "side": ("Open above or below the trigger", "在触发器上方或下方展开"),
                "panel_style": ("Styles for the floating panel", "浮层面板的样式"),
            }),
        ],
        [enum("MenuAlign", "overlays"), enum("MenuSide", "overlays")],
    ),
    page(
        "tooltip", "overlays", "Tooltip", "Tooltip 文字提示",
        "A hover/focus bubble on any trigger, scaling in from the anchored edge. Four sides.",
        "悬停或聚焦时出现在任意触发器旁的气泡，从锚定边缘缩放进入。四个方向。",
        [
            demo("tooltip-basic", "Four sides", "四个方向", """
@sumi.tooltip(content="Export the current canvas",
  @sumi.icon_button(@sumi.icon_upload(), aria_label="Export"))
@sumi.tooltip(content="More actions", side=@sumi.Bottom,
  @sumi.icon_button(@sumi.icon_more(), aria_label="More"))"""),
        ],
        [
            api("tooltip", params={
                "content": ("Bubble text", "气泡文本"),
                "side": ("Which side of the trigger to sit on", "位于触发器的哪一侧"),
            }),
        ],
        [enum("TooltipSide", "overlays")],
    ),
    page(
        "dialog", "overlays", "Dialog", "Dialog 对话框",
        "A native `<dialog>` modal with overshoot enter motion and a plain dark backdrop. Open it with the framework's dialog command.",
        "基于原生 `<dialog>` 的模态框，入场带轻微回弹，配纯暗遮罩。使用框架的 dialog 命令打开。",
        [
            demo("dialog-basic", "Confirm destructive action", "确认破坏性操作", """
@sumi.button(
  variant=@sumi.Secondary,
  on_click=@dialog.show("my-dialog"),
  "Open Dialog",
)
@sumi.dialog(
  id="my-dialog",
  title_text="Delete project",
  description="This action cannot be undone.",
  [
    @html.form(method_="dialog", [
      @sumi.button(variant=@sumi.Primary, type_="submit", "Delete"),
    ]),
  ],
)"""),
        ],
        [
            api("dialog", params={
                "id": ("Element id — commands target this", "元素 id——命令以其为目标"),
                "title_text": ("Heading line", "标题行"),
                "description": ("Supporting text under the title", "标题下的辅助文本"),
                "show_close": ("Corner ✕ button", "右上角关闭按钮"),
                "spacious": ("Widens content from 480px to 616px", "内容宽度从 480px 加宽到 616px"),
                "closedby": ("Native `closedby` behavior", "原生 `closedby` 行为"),
                "on_close": ("Called with the dialog's return value", "以对话框返回值调用"),
                "on_cancel": ("Called on Esc-cancel", "Esc 取消时调用"),
            }),
        ],
    ),
    page(
        "toast", "overlays", "Toast", "Toast 轻提示",
        "A fixed top-center transient notice — success, error or info — that fades in and out.",
        "固定于视口顶部居中的瞬态通知——成功、错误或信息——淡入淡出。",
        [
            demo("toast-basic", "Variants", "变体", """
@sumi.toast(
  message="Export started — 3 files queued",
  open=show_success,
  variant=@sumi.Success,
  on_close=set_state(_ => ""),
)"""),
        ],
        [
            api("toast", params={
                "message": ("Notice text", "通知文本"),
                "variant": ("Status styling", "状态样式"),
                "on_close": ("Called when the toast dismisses", "轻提示消失时调用"),
            }),
        ],
        [enum("ToastVariant", "overlays", {
            "Success": "Brand circle with a check",
            "Error": "Error-red glyph",
            "Info": "Neutral glyph",
        }, {
            "Success": "品牌色对勾圆标",
            "Error": "错误红图标",
            "Info": "中性图标",
        })],
    ),
    page(
        "spinner", "feedback", "Spinner", "Spinner 加载指示器",
        "A rotating arc for inline loading. Also used inside buttons and the send button.",
        "旋转圆弧，用于局部加载。按钮与发送按钮内部也使用它。",
        [
            demo("spinner-basic", "Sizes", "尺寸", """
@sumi.spinner()
@sumi.spinner(size=24)"""),
        ],
        [api("spinner", params={"size": ("Diameter in px", "直径（px）")})],
    ),
    page(
        "status-badge", "feedback", "Status Badge", "Status Badge 状态徽标",
        "A 20px badge reporting an async job's state: frosted determinate ring while running, a white circle with the queue depth (capped at 99), a blue tick disc on completion, an amber info disc for partial failure. Rendered over dark imagery, so the palette is pinned dark.",
        "20px 的异步任务状态徽标：进行中的磨砂确定进度环、显示排队数量的白色圆片（超过 99 封顶）、完成时的蓝色对勾圆盘、部分失败时的琥珀色信息圆盘。浮于深色内容之上，配色固定为深色。",
        [
            demo("status-badge", "All states", "全部状态", """
@sumi.status_badge(state=Running(45))
@sumi.status_badge(state=Count(3))
@sumi.status_badge(state=Count(99))
@sumi.status_badge(state=Complete)
@sumi.status_badge(state=Warning)"""),
        ],
        [
            api("status_badge", params={
                "state": ("`StatusBadgeState` — `Running(pct)` / `Count(n)` / `Complete` / `Warning`", "`StatusBadgeState`——`Running(pct)` / `Count(n)` / `Complete` / `Warning`"),
                "aria_label": ("Override the state description read to assistive tech", "覆盖读给辅助技术的状态描述"),
            }),
        ],
        [],
    ),
    page(
        "shimmer-text", "feedback", "Shimmer Text", "Shimmer Text 扫光文字",
        "Loading text with a dim band sweeping endlessly across the glyphs — the agent status line's in-progress state. The gradient is clipped to the letterforms (`background-clip:text`); reduced motion freezes the sweep.",
        "一条暗带在文字上往复扫过的加载文案——agent 状态行的进行中态。渐变裁剪到字形上（`background-clip:text`）；减弱动效时扫动冻结。",
        [
            demo("shimmer-text", "Status lines", "状态文案", """
@sumi.shimmer_text("Working on it…")
@sumi.shimmer_text("Generating the image…")
@sumi.shimmer_text("Reading the canvas…")"""),
        ],
        [
            api("shimmer_text", params={
                "0": ("`String` loading text", "`String` 加载文案"),
            }),
        ],
        [],
    ),
    page(
        "tool-call-row", "feedback", "Tool Call Row", "Tool Call Row 工具调用行",
        "One line of agent progress: a 16px tool icon, a label that shimmers while the work streams and settles when done, and an optional expandable chevron that reveals sub-steps under a thread line.",
        "一行 agent 进度：16px 工具图标 + 进行中扫光、完成后静止的标签；可展开的行带箭头，展开后在线索连接线下显示子步骤。",
        [
            demo("tool-call-row", "States & expandable", "状态与展开", """
@sumi.tool_call_row(icon=@sumi.icon_image(), label="(0/1) Image generating…")
@sumi.tool_call_row(icon=@sumi.icon_image(), state=@sumi.Done,
  label="(1/1) Image generation completed")
@sumi.tool_call_row(
  icon=@sumi.icon_adjust(), label="2 commands executed",
  expandable=true, expanded=e, on_toggle=set_e.map(v => _ => !v),
  steps=["List file directories", "Search for related content"],
)"""),
        ],
        [
            api("tool_call_row", params={
                "label": ("Status text; counts and failure notes are part of the copy", "状态文案；计数与失败说明直接写入文案"),
                "icon": ("16px tool glyph (omit for icon-less rows)", "16px 工具图标（省略则无图标）"),
                "state": ("Doing shimmers, Done settles to static tertiary", "Doing 扫光，Done 静止为三级文字"),
                "expandable": ("Adds a right/down chevron and enables steps", "显示右/下箭头并启用子步骤"),
                "expanded": ("Controlled expand state", "受控展开状态"),
                "on_toggle": ("Whole-row click command", "整行点击命令"),
                "steps": ("Sub-step lines shown when expanded", "展开时显示的子步骤行"),
                "truncate": ("Single-line ellipsis (default) or wrapping", "单行省略（默认）或换行"),
            }),
        ],
        [enum("ToolCallState", "feedback", {
            "Doing": "Label keeps shimmering while work streams",
            "Done": "Static tertiary label",
        }, {
            "Doing": "工作进行时标签持续扫光",
            "Done": "静止的三级文字标签",
        })],
    ),
    page(
        "progress", "feedback", "Progress", "Progress 进度条",
        "A determinate progress bar with an optional numeric readout.",
        "确定进度的进度条，可选数值显示。",
        [
            demo("progress-basic", "Basic usage", "基础用法", """
@sumi.progress(value=72, show_value=true)
@sumi.progress(value=30)"""),
        ],
        [
            api("progress", params={
                "value": ("Current value (controlled)", "当前值（受控）"),
                "max": ("Full-scale value", "满量程值"),
                "show_value": ("Numeric readout on the right", "右侧数值显示"),
            }),
        ],
    ),
    page(
        "skeleton", "feedback", "Skeleton", "Skeleton 骨架屏",
        "Shimmering placeholder shapes while content loads.",
        "内容加载期间的微光占位形状。",
        [
            demo("skeleton-basic", "Shapes", "形状", """
@sumi.skeleton_tile(width="160px", height="90px")
@sumi.skeleton_lines(count=3)
@sumi.skeleton(width="64px", height="64px", radius="50%")"""),
        ],
        [
            api("skeleton", params={
                "width": ("CSS width", "CSS 宽度"),
                "height": ("CSS height", "CSS 高度"),
                "radius": ("Corner radius (50% for circles)", "圆角（圆形用 50%）"),
            }),
            api("skeleton_lines", desc_en="A stack of text-like lines.", desc_zh="一组文本行。", params={
                "count": ("Number of lines", "行数"),
            }),
            api("skeleton_tile", desc_en="A rounded media tile.", desc_zh="圆角媒体块。", params={
                "width": ("CSS width", "CSS 宽度"),
                "height": ("CSS height", "CSS 高度"),
            }),
        ],
    ),
    page(
        "badge", "primitives", "Badge", "Badge 徽标",
        "A numeric counter or status dot.",
        "数字计数或状态点。",
        [
            demo("badge-basic", "Basic usage", "基础用法", """
@sumi.badge(value=5)
@sumi.badge(value=120)
@sumi.badge(dot=true)"""),
        ],
        [
            api("badge", params={
                "value": ("Number to display (clamped display over 99)", "显示的数字（超过 99 截断显示）"),
                "dot": ("Renders a plain dot instead of a number", "渲染为纯圆点而非数字"),
            }),
        ],
    ),
    page(
        "empty-state", "feedback", "Empty State", "Empty State 空状态",
        "An icon + title + description placeholder with an optional action, for empty panels.",
        "图标 + 标题 + 描述的占位，可选动作按钮，用于空面板。",
        [
            demo("empty-state-basic", "Inside a card", "置于卡片内", """
@sumi.empty_state(
  title_text="No versions yet",
  description="Generated results will appear here.",
  icon=@sumi.icon_image(size=24),
  action=@sumi.button(variant=@sumi.Secondary, size=@sumi.Sm, "New Version"),
)"""),
        ],
        [
            api("empty_state", params={
                "title_text": ("Heading line", "标题行"),
                "description": ("Supporting text", "辅助文本"),
                "icon": ("Artwork above the title", "标题上方的图形"),
                "action": ("Call-to-action below the text", "文本下方的动作按钮"),
            }),
        ],
    ),
    page(
        "alert", "feedback", "Alert", "Alert 提示",
        "An inline icon + message note for validation and status inside a panel.",
        "面板内的行内图标 + 文案提示，用于校验与状态说明。",
        [
            demo("alert-basic", "Solid & subtle", "实底与淡底", """
@sumi.alert(
  message="Prompt exceeds the 800-word limit — shorten it before generating",
)
@sumi.alert(
  variant=@sumi.Subtle,
  message="Check the highlighted section before sending",
)"""),
        ],
        [
            api("alert", params={
                "message": ("Note text; wraps to multiple lines", "提示文案；可多行换行"),
                "variant": ("`Solid` on the canvas, `Subtle` on a filled surface", "`Solid` 用于画布，`Subtle` 用于已有填充的表面"),
                "icon": ("Leading glyph (defaults to `icon_important`)", "前置图标（默认为 `icon_important`）"),
            }),
        ],
        [
            enum("AlertVariant", "feedback", {
                "Solid": "Tooltip-dark fill for notes sitting on the canvas",
                "Subtle": "Barely-there fill for notes on an already-filled surface",
            }),
        ],
    ),
    page(
        "avatar", "primitives", "Avatar", "Avatar 头像",
        "A round identity image with an initials fallback.",
        "圆形身份图像，加载失败时回退为文字。",
        [
            demo("avatar-basic", "Fallback initials", "回退文字", """
@sumi.avatar(fallback="Sumi")
@sumi.avatar(fallback="墨", size=40)"""),
        ],
        [
            api("avatar", params={
                "src": ("Image URL; falls back when missing or failed", "图像 URL；缺失或加载失败时回退"),
                "fallback": ("Text rendered when no image is available", "无图像时渲染的文字"),
                "size": ("Diameter in px", "直径（px）"),
                "alt": ("Image alt text", "图像 alt 文本"),
            }),
        ],
    ),
    page(
        "tag", "primitives", "Tag", "Tag 标签",
        "A compact label for status and metadata, optionally removable.",
        "紧凑的状态与元数据标签，可选移除按钮。",
        [
            demo("tag-basic", "Variants", "变体", """
@sumi.tag("Draft")
@sumi.tag(variant=@sumi.Brand, [
  @sumi.icon_sparkle(size=12),
  @html.text("AI"),
])
@sumi.tag(variant=@sumi.Outline, "16:9")
@sumi.tag(on_remove=@cmd.none, "Removable")"""),
        ],
        [
            api("tag", params={
                "variant": ("Visual style", "视觉风格"),
                "on_remove": ("Renders a ✕ that fires this command", "渲染触发该命令的 ✕ 按钮"),
            }),
        ],
        [enum("TagVariant", "primitives", {
            "Default": "Filled neutral chip",
            "Brand": "Brand-tinted, for premium or AI marks",
            "Outline": "Bordered, no fill",
        }, {
            "Default": "中性实心",
            "Brand": "品牌色，用于高级或 AI 标识",
            "Outline": "描边无填充",
        })],
    ),
    page(
        "media-tag", "primitives", "Media Tag", "Media Tag 媒体标签",
        "An inline reference to a piece of content — the chip that prefixes a conversation bubble or sits inside the composer input.",
        "指向一段内容的行内引用标签——可前缀在对话气泡上，也可内嵌在输入框中。",
        [
            demo("media-tag", "Kinds, states & inline", "类型、状态与行内", """
@sumi.media_tag(kind=@sumi.Image, thumbnail=thumb_url)
@sumi.media_tag(kind=@sumi.Video, state=@sumi.Generating)
@sumi.media_tag(kind=@sumi.Audio, variant=@sumi.Inline)"""),
        ],
        [
            api("media_tag", params={
                "kind": ("What the tag references", "标签引用的内容类型"),
                "label": ("Text; defaults to the kind name", "文字；缺省为类型名"),
                "state": ("Lifecycle of the referenced content", "引用内容的生命周期状态"),
                "variant": ("Filled block chip or transparent inline form", "实心块或透明行内形式"),
                "thumbnail": ("16px square preview for Image/Video", "Image/Video 的 16px 方形缩略图"),
                "on_click": ("Renders as a button and brightens on hover", "渲染为按钮，悬停时提亮"),
            }),
        ],
        [
            enum("MediaTagKind", "primitives", {
                "Image": "Picture reference; can carry a thumbnail",
                "Video": "Clip reference; can carry a thumbnail",
                "Audio": "Waveform-glyph sound reference",
                "Text": "Plain-text reference",
                "Group": "Reference to several elements grouped together",
                "Timeline": "Sequence reference",
                "Element": "Single-element reference",
            }, {
                "Image": "图片引用；可带缩略图",
                "Video": "视频引用；可带缩略图",
                "Audio": "波形图标的音频引用",
                "Text": "纯文本引用",
                "Group": "成组元素的引用",
                "Timeline": "时间线引用",
                "Element": "单个元素引用",
            }),
            enum("MediaTagState", "primitives", {
                "Ready": "Default look",
                "Candidate": "Half-transparent suggestion",
                "Uploading": "Thumbnail dimmed under a centered spinner",
                "Generating": "Spinner replaces the visual",
                "Failed": "Warning disc replaces the visual",
                "Empty": "Placeholder glyph even when a thumbnail exists",
            }, {
                "Ready": "默认外观",
                "Candidate": "半透明候选态",
                "Uploading": "缩略图压暗并叠加居中加载圈",
                "Generating": "视觉位替换为加载圈",
                "Failed": "视觉位替换为警告圆盘",
                "Empty": "即使有缩略图也显示占位图标",
            }),
            enum("MediaTagVariant", "primitives", {
                "Block": "Filled chip, used inside conversation bubbles",
                "Inline": "Transparent, sits inside the composer input",
            }, {
                "Block": "实心块，用于对话气泡内",
                "Inline": "透明行内，嵌于输入框中",
            }),
        ],
    ),
    page(
        "kbd", "primitives", "Kbd", "Kbd 键盘按键",
        "Renders a keyboard keycap for shortcut hints.",
        "渲染键盘键帽，用于快捷键提示。",
        [
            demo("kbd-basic", "Combo", "组合键", """
@sumi.kbd("⌘")
@sumi.kbd("K")"""),
        ],
        [api("kbd", params={"0": ("`String` key label", "`String` 键名")})],
    ),
    page(
        "card", "layout", "Card", "Card 卡片",
        "`card` is the bare bordered surface; `card_section` adds the header/content split and is the default choice for panels.",
        "`card` 是裸边框表面；`card_section` 增加头部/内容分区，是面板的首选。",
        [
            demo("card-basic", "Bare card", "裸卡片", """
@sumi.card(style=["width:280px;padding:16px"], [
  @html.text("Bring your own padding and layout."),
])"""),
            demo("card-section", "Section card", "分区卡片", """
@sumi.card_section(header=@html.text("Settings"), [
  @sumi.checkbox(checked=true, label="Auto-save"),
  @sumi.divider(),
  ...
])"""),
        ],
        [
            api("card", params={}),
            api("card_section", params={
                "header": ("Header row content", "头部行内容"),
            }),
            api("divider", desc_en="A 1px rule for stacking inside card content.",
                desc_zh="卡片内容堆叠时的 1px 分隔线。"),
        ],
    ),
    page(
        "tabs", "layout", "Tabs", "Tabs 标签页",
        "An underline tab row for switching views.",
        "下划线样式的标签行，用于切换视图。",
        [
            demo("tabs-basic", "Basic usage", "基础用法", """
@sumi.tabs(
  items=[
    @sumi.TabEntry::new("all", "All"),
    @sumi.TabEntry::new("mine", "Mine"),
    @sumi.TabEntry::new("shared", "Shared"),
  ],
  selected=current,
  on_select=set_tab.map(v => _ => v),
)"""),
        ],
        [
            api("tabs", params={
                "items": ("Tab list", "标签列表"),
                "selected": ("Value of the active tab (controlled)", "激活标签的值（受控）"),
            }),
            api("TabEntry::new", desc_en="One tab.", desc_zh="一个标签。", params={
                "0": ("`String` value, `String` label", "`String` 值，`String` 标签"),
                "icon": ("Leading icon", "前置图标"),
            }),
        ],
    ),
    page(
        "pagination", "layout", "Pagination", "Pagination 分页",
        "A minimal `\u2039 page / total \u203a` pager with clamped arrow buttons.",
        "极简 `\u2039 页码 / 总数 \u203a` 分页器，箭头在边界处钳制并禁用。",
        [
            demo("pagination-basic", "Current / total", "页码 / 总数", """
@sumi.pagination(
  page=current,
  total=4,
  on_change=set_page.map(v => _ => v),
)"""),
        ],
        [
            api("pagination", params={
                "page": ("Current page, 1-based (controlled)", "当前页码，从 1 开始（受控）"),
                "total": ("Total page count", "总页数"),
                "on_change": ("Called with the clamped target page", "以钳制后的目标页回调"),
            }),
        ],
    ),
    page(
        "shortcuts-panel", "layout", "Shortcuts Panel", "Shortcuts Panel 快捷键面板",
        "The keyboard-shortcuts reference sheet: an elevated 264px panel with a titled header and close button, then titled sections of label + key-chip rows. Long lists scroll inside the body.",
        "快捷键速查面板：264px 的浮起面板，带标题栏与关闭按钮，下方是带小标题的标签 + 键位芯片行；内容过长时在体内滚动。",
        [
            demo("shortcuts-panel", "Three sections", "三个分组", """
@sumi.shortcuts_panel(
  sections=[
    @sumi.ShortcutSection::new("General", [
      @sumi.ShortcutItem::new("Toggle sidebar", "Cmd /"),
      @sumi.ShortcutItem::new("Send message", "Enter"),
    ]),
    @sumi.ShortcutSection::new("Editing", [
      @sumi.ShortcutItem::new("Select all", "\u2318 A"),
      @sumi.ShortcutItem::new("Undo", "\u2318 Z"),
    ]),
  ],
  on_close=close_panel,
)"""),
        ],
        [
            api("shortcuts_panel", params={
                "sections": ("Titled shortcut clusters", "带标题的快捷键分组"),
                "title": ("Header text (defaults to \"Shortcuts\")", "标题栏文字（默认 \"Shortcuts\"）"),
                "on_close": ("Close button command; omit to hide the button's action", "关闭按钮命令"),
                "width": ("Panel width in px (default 264)", "面板宽度 px（默认 264）"),
                "max_height": ("Panel max height in px (default 660)", "面板最大高度 px（默认 660）"),
            }),
            api("ShortcutSection::new", desc_en="A titled cluster.", desc_zh="一个带标题的分组。", params={
                "0": ("`String` title, `Array[ShortcutItem]` rows", "`String` 标题，`Array[ShortcutItem]` 行"),
            }),
            api("ShortcutItem::new", desc_en="One row.", desc_zh="一行。", params={
                "0": ("`String` action label, `String` key combination", "`String` 动作名，`String` 键位组合"),
            }),
        ],
        [],
    ),
    page(
        "chat-bubble", "layout", "Chat Bubble", "Chat Bubble 对话气泡",
        "The right-aligned bubble of a sent message. Plain text, or rich content with inline media tags; long messages clamp behind a fade with an Expand/Collapse toggle, and a copy action appears below on hover.",
        "发送消息的右对齐气泡：支持纯文本或内嵌媒体标签的富文本；长文可在渐变遮罩后折叠并提供展开/收起开关，悬停时下方出现复制按钮。",
        [
            demo("chat-bubble", "Plain, rich & collapsible", "纯文本、富文本与折叠", """
@sumi.chat_bubble(text="Continue")
@sumi.chat_bubble(children=[
  @sumi.media_tag(kind=@sumi.Image, variant=@sumi.Inline, thumbnail=thumb),
  @html.text("Add more detail"),
])
@sumi.chat_bubble(
  text=long,
  collapsible=true,
  collapsed=c,
  on_toggle=set_c.map(v => _ => !v),
  on_copy=copy_it,
)"""),
        ],
        [
            api("chat_bubble", params={
                "text": ("Plain-text content (mutually exclusive with children)", "纯文本内容（与 children 互斥）"),
                "children": ("Rich content row: inline media tags + text spans", "富文本行：行内媒体标签与文本"),
                "collapsible": ("Enables the clamp + Expand/Collapse toggle", "启用折叠与展开/收起开关"),
                "collapsed": ("Controlled clamp state", "受控折叠状态"),
                "on_toggle": ("Expand/Collapse click command", "展开/收起点击命令"),
                "collapse_lines": ("Lines kept when collapsed (default 9)", "折叠时保留的行数（默认 9）"),
                "on_copy": ("Copy action revealed below the bubble on hover", "悬停时在气泡下方显示的复制按钮"),
            }),
        ],
        [],
    ),
    page(
        "credits", "primitives", "Credits", "Credits 额度",
        "A compact balance readout with an optional strikethrough original price.",
        "紧凑的余额读数，可选划线原价。",
        [
            demo("credits-basic", "Basic usage", "基础用法", """
@sumi.credits(value=24)
@sumi.credits(value=24, original_value=48)
@sumi.credits(value=8, muted=true)"""),
        ],
        [
            api("credits", params={
                "value": ("Current balance", "当前额度"),
                "original_value": ("Struck-through original when discounted", "折扣时显示划线原价"),
                "muted": ("Drops to the placeholder tone for frosted docks", "降为占位色调，用于磨砂坞"),
            }),
        ],
    ),
    page(
        "icons", "primitives", "Icons", "Icons 图标",
        "A stroke icon set drawn as inline SVG. Every icon takes an optional `size` (default 16).",
        "以内联 SVG 绘制的线性图标集。每个图标接受可选 `size`（默认 16）。",
        [
            demo("icons-basic", "The set", "图标全集", """
@sumi.icon_search(size=16)
@sumi.icon_sparkle(size=16)
@sumi.icon_download(size=16)
// …25 icons in total"""),
        ],
        [
            api("icon", desc_en="Renders an icon by name from the set.",
                desc_zh="按名称渲染图标集中的图标。", params={
                "0": ("`String` icon name", "`String` 图标名"),
                "size": ("Size in px", "尺寸（px）"),
                "stroke_width": ("Stroke width", "描边宽度"),
            }),
            api("icon_ratio", desc_en="Proportional artwork for the ratio picker.",
                desc_zh="为比例选择器绘制按比例缩放的图形。", params={
                "width": ("Aspect width", "比例宽"),
                "height": ("Aspect height", "比例高"),
                "size": ("Bounding box in px", "外框尺寸（px）"),
            }),
        ],
        extra_en="\nAvailable names: `adjust`, `arrow-down`, `arrow-up`, `check`, `chevron-down`, `chevron-left`, `chevron-right`, `chevron-up`, `clock`, `crop`, `download`, `expand`, `grid`, `image`, `layers`, `minus`, `more`, `play`, `plus`, `reset`, `scissors`, `search`, `sparkle`, `upload`, `x` — each also has a dedicated `icon_<name>()` function.\n",
        extra_zh="\n可用名称：`adjust`、`arrow-down`、`arrow-up`、`check`、`chevron-down`、`chevron-left`、`chevron-right`、`chevron-up`、`clock`、`crop`、`download`、`expand`、`grid`、`image`、`layers`、`minus`、`more`、`play`、`plus`、`reset`、`scissors`、`search`、`sparkle`、`upload`、`x`——每个名称同时有对应的 `icon_<name>()` 函数。\n",
    ),
]

# ---------------------------------------------------------------------------
# Rendering
# ---------------------------------------------------------------------------

def render_demos(demos, lang):
    out = []
    out.append("## 示例" if lang == "zh" else "## Examples")
    out.append("")
    for d in demos:
        out.append("### " + d["title_" + lang])
        out.append("")
        out.append(f'<SumiDemo name="{d["name"]}">')
        out.append("")
        out.append("```moonbit")
        out.append(d["code"])
        out.append("```")
        out.append("")
        out.append("</SumiDemo>")
        out.append("")
    return out

def param_desc(spec_params, pname, lang):
    if pname in spec_params:
        v = spec_params[pname]
        if isinstance(v, tuple):
            return v[0 if lang == "en" else 1]
        return v
    if pname in COMMON:
        v = COMMON[pname]
        if v == "FOCUS":
            return FOCUS[0 if lang == "en" else 1]
        if v == "VALUE":
            return None
        if isinstance(v, tuple):
            return v[0 if lang == "en" else 1]
    return None

def render_api(apis, enums, pkg, lang):
    src = pkg_src(pkg)
    out = []
    out.append("## API")
    out.append("")
    for a in apis:
        out.append("### " + a["fn"])
        out.append("")
        if a["desc_" + lang]:
            out.append(a["desc_" + lang])
            out.append("")
        fn_name = a["fn"].split("::")[-1]
        if "::" in a["fn"]:
            params = parse_fn(src, a["fn"])
        else:
            params = parse_fn(src, fn_name)
        if params is None:
            continue
        hdr = ("| 名称 | 类型 | 默认值 | 说明 |" if lang == "zh"
               else "| Name | Type | Default | Description |")
        out.append(hdr)
        out.append("|---|---|---|---|")
        for pname, ptype, default, label in params:
            desc = param_desc(a["params"], pname, lang) or ""
            dflt = default if default else "—"
            req = " **\***" if label == "~" else ""
            out.append(f"| {pname}{req} | `{ptype}` | {dflt} | {desc} |")
        out.append("")
    if enums:
        for e in enums:
            variants = parse_enum(pkg_src(e["pkg"]), e["enum"])
            if not variants:
                continue
            out.append("### " + e["enum"])
            out.append("")
            descs = e["desc_" + lang]
            if descs:
                out.append("| Variant | " + ("说明 |" if lang == "zh" else "Description |"))
                out.append("|---|---|")
                for v in variants:
                    key = re.match(r"([A-Z]\w*)", v).group(1)
                    out.append(f"| `{v}` | {descs.get(key, '')} |")
            else:
                out.append(" · ".join(f"`{v}`" for v in variants))
            out.append("")
    return out

def render(spec, lang):
    out = []
    out.append("# " + spec["title_" + lang])
    out.append("")
    out.append(spec["blurb_" + lang])
    out.append("")
    out.extend(render_demos(spec["demos"], lang))
    out.extend(render_api(spec["apis"], spec["enums"], spec["pkg"], lang))
    extra = spec["extra_" + lang].strip()
    if extra:
        out.append(extra)
        out.append("")
    if lang == "en":
        out.append("\\* required (labelled) parameter — everything else is optional.")
        out.append("")
    else:
        out.append("\\* 必填（标签）参数——其余均为可选。")
        out.append("")
    return "\n".join(out)

def main():
    for spec in PAGES:
        slug = spec["slug"]
        en = render(spec, "en")
        zh = render(spec, "zh")
        en_path = f"docs/components/{slug}.md"
        zh_path = f"docs/zh/components/{slug}.md"
        with open(os.path.join(ROOT, en_path), "w") as f:
            f.write(en)
        with open(os.path.join(ROOT, zh_path), "w") as f:
            f.write(zh)
        print("wrote", en_path, "+ zh")

if __name__ == "__main__":
    main()
