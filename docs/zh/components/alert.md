# Alert 提示

面板内的行内图标 + 文案提示，用于校验与状态说明。

## 示例

### 实底与淡底

<SumiDemo name="alert-basic">

```moonbit
@sumi.alert(
  message="Prompt exceeds the 800-word limit — shorten it before generating",
)
@sumi.alert(
  variant=@sumi.Subtle,
  message="Check the highlighted section before sending",
)
```

</SumiDemo>

## API

### alert

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| message **\*** | `String` | — | 提示文案；可多行换行 |
| variant | `AlertVariant` | Solid | `Solid` 用于媒体底色之上，`Subtle` 用于已有填充的表面 |
| icon | `Html` | — | 前置图标（默认为 `icon_important`） |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

### AlertVariant

`Solid` · `Subtle`

\* 必填（标签）参数——其余均为可选。
