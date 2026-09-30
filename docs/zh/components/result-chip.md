# Result Chip 结果标签

生成结果的 24px 富文本引用标签：圆角块面承载 16px 缩略图与短标签。Small 尺寸带 6px 背景模糊，浮于生成图之上；Medium 去掉模糊并将标签升为 14/24 次要色，用于对话内联结果行。

## 示例

### 两种尺寸

<SumiDemo name="result-chips">

```moonbit
// Small — floating over generated imagery (backdrop blur 6)
@sumi.result_chip(label="Cover Draft", thumbnail=ref_url)

// Medium — inline chat result row (14/24 secondary)
@sumi.result_chip(label="Image", thumbnail=ref_url, size=@sumi.Medium)
```

</SumiDemo>

## API

### result_chip

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| label **\*** | `String` | — | 短标签文案 |
| thumbnail | `String` | — | 可选 16px 圆角参考图 URL |
| size | `ResultChipSize` | Small | `Small`（13/19.5 三级色+模糊）或 `Medium`（14/24 次要色） |
| aria_label | `String` | — |  |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

### ResultChipSize

`Small` · `Medium`

\* 必填（标签）参数——其余均为可选。
