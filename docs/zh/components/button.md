# Button 按钮

点击触发动作。三种变体、两种文字尺寸，内置禁用、按下选中与加载状态。

## 示例

### 变体与状态

<SumiDemo name="button-basic">

```moonbit
@sumi.button(variant=@sumi.Primary, "Generate")
@sumi.button(variant=@sumi.Secondary, "Export")
@sumi.button(variant=@sumi.Ghost, [
  @sumi.icon_sparkle(),
  @html.text("AI Edit"),
])
@sumi.button(variant=@sumi.Primary, disabled=true, "Generate")
@sumi.button(variant=@sumi.Primary, loading=true, "Generate")
```

</SumiDemo>

### 尺寸

<SumiDemo name="button-sizes">

```moonbit
@sumi.button(variant=@sumi.Primary, "Apply")
@sumi.button(variant=@sumi.Primary, size=@sumi.Sm, "Apply")
@sumi.button(variant=@sumi.Secondary, size=@sumi.Sm, "Apply")
@sumi.button(variant=@sumi.Ghost, size=@sumi.Sm, "Options")
```

</SumiDemo>

## API

### button

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| variant | `ButtonVariant` | Primary | 视觉风格 |
| size | `ButtonSize` | Default | 控件尺寸 |
| disabled | `Bool` | false | 阻止点击；主按钮保留淡色填充 |
| pressed | `Bool` | false | 选中填充 + `aria-pressed`，用于工具切换 |
| loading | `Bool` | false | 保持宽度，隐藏内容，居中显示 16px 加载圈 |
| type_ | `String` | "button" | 原生 `type` 属性 |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| title | `String` | — | 原生 tooltip 标题 |
| name | `String` | — | 表单字段名 |
| value | `String` | — | 原生 `value` 属性 |
| autofocus | `Bool` | — | 挂载后自动聚焦 |
| on_click | `Cmd` | — | 点击时发送的命令 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |
| children | `C` | — | 内容 |

### ButtonVariant

| Variant | 说明 |
|---|---|
| `Primary` | 实心强调表面，用于主要动作 |
| `Secondary` | 中性实心表面（默认） |
| `Ghost` | 默认透明、悬停显现，用于工具栏与菜单 |

### ButtonSize

| Variant | 说明 |
|---|---|
| `Default` | 32px 高，水平内边距 16px |
| `Sm` | 28px 高；ghost-sm 即菜单触发器尺寸 |
| `Icon` | 32×32 方形（icon_button） |
| `IconSm` | 28×28 方形（icon_button） |

\* 必填（标签）参数——其余均为可选。
