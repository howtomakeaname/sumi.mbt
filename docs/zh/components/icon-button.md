# Icon Button 图标按钮

承载单个图标的方形按钮，带无障碍标签。`pressed` 可将其变为工具切换钮。

## 示例

### 基础用法

<SumiDemo name="icon-button-basic">

```moonbit
@sumi.icon_button(@sumi.icon_download(), aria_label="Download")
@sumi.icon_button(@sumi.icon_crop(), pressed=true, aria_label="Crop (active tool)")
@sumi.icon_button(@sumi.icon_x(), size=@sumi.IconSm, aria_label="Close")
@sumi.icon_button(@sumi.icon_upload(), disabled=true, aria_label="Export")
```

</SumiDemo>

## API

### icon_button

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| icon | `Html` | — |  |
| variant | `ButtonVariant` | Ghost | 视觉风格 |
| size | `ButtonSize` | Icon | `Icon` 32×32 或 `IconSm` 28×28 |
| disabled | `Bool` | false | 禁用交互并降低不透明度 |
| pressed | `Bool` | false | 选中填充 + `aria-pressed` |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| title | `String` | — | 原生 tooltip 标题 |
| aria_label | `String` | — | 无障碍标签（纯图标按钮必填） |
| on_click | `Cmd` | — | 点击时发送的命令 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

### ButtonVariant

`Primary` · `Secondary` · `Ghost`

### ButtonSize

`Default` · `Sm` · `Icon` · `IconSm`

\* 必填（标签）参数——其余均为可选。
