# Switch 开关

二元开关。打开时为品牌蓝。

## 示例

### 基础用法

<SumiDemo name="switch-basic">

```moonbit
@sumi.switch(checked=is_on, on_change=set_enabled.map(v => _ => v))
@sumi.switch(checked=is_on, disabled=true)
```

</SumiDemo>

## API

### switch

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| checked **\*** | `Bool` | — | 是否选中（受控） |
| on_change | `Emit[Bool]` | — | 值变化时调用 |
| disabled | `Bool` | false | 禁用交互并降低不透明度 |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| title | `String` | — | 原生 tooltip 标题 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

\* 必填（标签）参数——其余均为可选。
