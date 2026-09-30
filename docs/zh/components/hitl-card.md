# HITL 确认卡片

人机协作确认卡片：带标题的生成项列表，行可勾选并标注额度消耗；底部为取消/确认按钮，确认按钮显示勾选项总额；确认后转为只读回执状态。

## 示例

### 确认与回执

<SumiDemo name="hitl-card">

```moonbit
@sumi.hitl_card(
  title="Generate the following 5 drafts",
  items=plan,
  on_toggle=set_plan.map(i => c => flip_at(c, i)),
  on_cancel=emit(Dismiss),
  on_confirm=emit(ConfirmAll),
)
@sumi.hitl_card(title="Generated the following 3 drafts", items=done, confirmed=true)
```

</SumiDemo>

## API

### hitl_card

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| title **\*** | `String` | — | 标题文本（14/22 Medium） |
| items **\*** | `Array[HitlItem]` | — | `HitlItem` 行（受控） |
| on_toggle | `Emit[Int]` | — | 行点击，回传行索引 |
| confirmed | `Bool` | false | 只读回执：无勾选框与底部按钮 |
| on_cancel | `Cmd` | — |  |
| on_confirm | `Cmd` | — | 主按钮，显示勾选项总额 |
| cancel_label | `String` | "Cancel" |  |
| confirm_label | `String` | "Generate All" |  |
| max_height | `Int` | 190 | 列表滚动限高 px（默认 190） |
| aria_label | `String` | — |  |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

### HitlItem::new

一个生成选项。

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| label | `String` | — |  |
| cost | `Int` | 0 | 额度消耗；大于 0 时显示 |
| thumbnails | `Array[String]` | [] | 参考缩略图（每种模态一张） |
| checked | `Bool` | true | 是否勾选参与本次生成；未勾选行下沉（0.2 标签、缩略图半透、消耗隐藏） |

\* 必填（标签）参数——其余均为可选。
