# Card 卡片

`card` 是裸边框表面；`card_section` 增加头部/内容分区，是面板的首选。

## 示例

### 裸卡片

<SumiDemo name="card-basic">

```moonbit
@sumi.card(style=["width:280px;padding:16px"], [
  @html.text("Bring your own padding and layout."),
])
```

</SumiDemo>

### 分区卡片

<SumiDemo name="card-section">

```moonbit
@sumi.card_section(header=@html.text("Settings"), [
  @sumi.checkbox(checked=true, label="Auto-save"),
  @sumi.divider(),
  ...
])
```

</SumiDemo>

## API

### card

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| title | `String` | — | 原生 tooltip 标题 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |
| children | `C` | — | 内容 |

### card_section

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| header **\*** | `Html` | — | 头部行内容 |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |
| children | `C` | — | 内容 |

### divider

卡片内容堆叠时的 1px 分隔线。

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

\* 必填（标签）参数——其余均为可选。
