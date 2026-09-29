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
    "primitives": ["button.mbt", "icon.mbt", "tag.mbt", "badge.mbt", "kbd.mbt", "avatar.mbt", "credits.mbt"],
    "forms": ["input.mbt", "textarea.mbt", "select.mbt", "stepper.mbt", "switch.mbt", "checkbox.mbt", "slider.mbt", "segmented.mbt", "prompt_box.mbt"],
    "overlays": ["dropdown_menu.mbt", "context_menu.mbt", "popover.mbt", "tooltip.mbt", "dialog.mbt", "toast.mbt", "menu.mbt"],
    "feedback": ["progress.mbt", "skeleton.mbt", "empty_state.mbt", "alert.mbt"],
    "layout": ["card.mbt", "toolbar.mbt", "tabs.mbt", "divider.mbt"],
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
        ],
        [
            api("select", params={
                "options": ("Option list", "选项列表"),
                "value": ("Selected value (controlled)", "选中值（受控）"),
            }),
            api("MenuItem::new", desc_en="One menu option.",
                desc_zh="一个菜单项。", params={
                "0": ("`value~` item value, `String` label", "`value~` 项的值，`String` 标签"),
                "description": ("Secondary line for rich items", "富文本项的次级描述行"),
                "icon": ("Leading icon", "前置图标"),
                "shortcut": ("Right-aligned shortcut hint", "右对齐快捷键提示"),
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
