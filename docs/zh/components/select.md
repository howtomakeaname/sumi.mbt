# Select 选择器

输入框外观的触发器，展开与触发器等宽的紧凑菜单。与下拉菜单共用 `MenuItem`。

## 示例

### 基础用法

<SumiDemo name="select-basic">

```moonbit
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
)
```

</SumiDemo>

### 筛选触发器

<SumiDemo name="select-filter">

```moonbit
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
)
```

</SumiDemo>

## API

### select

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| options **\*** | `Array[MenuItem]` | — | 选项列表 |
| value **\*** | `String` | — | 选中值（受控） |
| placeholder | `String` | "Select" | 占位文本 |
| open **\*** | `Bool` | — | 浮层是否打开（受控） |
| on_open_change | `Emit[Bool]` | — | 打开状态应变化时调用 |
| on_select | `Emit[String]` | — | 选中某项时以其值调用 |
| variant | `SelectVariant` | Form | `Form` 输入框外观，`Filter` 紧凑工具栏触发器 |
| on_clear | `Cmd` | — | Filter 变体：清除按钮触发 |
| disabled | `Bool` | false | 禁用交互并降低不透明度 |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

### MenuItem::new

一个菜单项。

### SelectVariant

| Variant | 说明 |
|---|---|
| `Form` | 输入框外观，占满宽度（默认） |
| `Filter` | 紧凑触发器，未筛选时显示筛选名 |

\* 必填（标签）参数——其余均为可选。
