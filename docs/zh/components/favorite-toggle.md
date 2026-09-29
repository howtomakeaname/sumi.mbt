# Favorite Toggle 收藏切换

无底盘的星形收藏切换按钮。与 `icon_button` 不同，它没有悬停底板，状态完全通过图标呈现：常态为描边星形，收藏后为实心琥珀色。

## 示例

### 基础用法

<SumiDemo name="favorite-toggle">

```moonbit
@sumi.favorite_toggle(checked=fav, on_change=set_fav.map(v => _ => v))
@sumi.favorite_toggle(checked=true, disabled=true)
```

</SumiDemo>

## API

### favorite_toggle

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| checked **\*** | `Bool` | — | 当前收藏状态（受控） |
| on_change | `Emit[Bool]` | — | 点击时以翻转后的值触发 |
| disabled | `Bool` | false | 置灰且不可交互 |
| aria_label | `String` | — | 覆盖无障碍标签（默认随状态切换） |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

\* 必填（标签）参数——其余均为可选。
