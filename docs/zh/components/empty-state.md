# Empty State 空状态

图标 + 标题 + 描述的占位，可选动作按钮，用于空面板。

## 示例

### 置于卡片内

<SumiDemo name="empty-state-basic">

```moonbit
@sumi.empty_state(
  title_text="No versions yet",
  description="Generated results will appear here.",
  icon=@sumi.icon_image(size=24),
  action=@sumi.button(variant=@sumi.Secondary, size=@sumi.Sm, "New Version"),
)
```

</SumiDemo>

## API

### empty_state

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| title_text **\*** | `String` | — | 标题行 |
| description | `String` | — | 辅助文本 |
| icon | `Html` | — | 标题上方的图形 |
| action | `Html` | — | 文本下方的动作按钮 |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

\* 必填（标签）参数——其余均为可选。
