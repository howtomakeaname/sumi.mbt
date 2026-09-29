# Media Tag 媒体标签

指向一段内容的行内引用标签——可前缀在对话气泡上，也可内嵌在输入框中。

## 示例

### 类型、状态与行内

<SumiDemo name="media-tag">

```moonbit
@sumi.media_tag(kind=@sumi.Image, thumbnail=thumb_url)
@sumi.media_tag(kind=@sumi.Video, state=@sumi.Generating)
@sumi.media_tag(kind=@sumi.Audio, variant=@sumi.Inline)
```

</SumiDemo>

## API

### media_tag

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| kind **\*** | `MediaTagKind` | — | 标签引用的内容类型 |
| label | `String` | — | 文字；缺省为类型名 |
| state | `MediaTagState` | Ready | 引用内容的生命周期状态 |
| variant | `MediaTagVariant` | Block | 实心块或透明行内形式 |
| thumbnail | `String` | — | Image/Video 的 16px 方形缩略图 |
| on_click | `Cmd` | — | 渲染为按钮，悬停时提亮 |
| aria_label | `String` | — |  |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

### MediaTagKind

| Variant | 说明 |
|---|---|
| `Image` | 图片引用；可带缩略图 |
| `Video` | 视频引用；可带缩略图 |
| `Audio` | 波形图标的音频引用 |
| `Text` | 纯文本引用 |
| `Group` | 成组元素的引用 |
| `Timeline` | 时间线引用 |
| `Element` | 单个元素引用 |

### MediaTagState

| Variant | 说明 |
|---|---|
| `Ready` | 默认外观 |
| `Candidate` | 半透明候选态 |
| `Uploading` | 缩略图压暗并叠加居中加载圈 |
| `Generating` | 视觉位替换为加载圈 |
| `Failed` | 视觉位替换为警告圆盘 |
| `Empty` | 即使有缩略图也显示占位图标 |

### MediaTagVariant

| Variant | 说明 |
|---|---|
| `Block` | 实心块，用于对话气泡内 |
| `Inline` | 透明行内，嵌于输入框中 |

\* 必填（标签）参数——其余均为可选。
