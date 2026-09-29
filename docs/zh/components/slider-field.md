# Slider Field 滑杆字段

带标签的数值字段：滑杆组合刻度标记与刻度标签，外加带单位后缀的数字框；可选自动行提供开关。

## 示例

### 刻度与数字框

<SumiDemo name="slider-field">

```moonbit
@sumi.slider_field(
  value=current,
  min=0,
  max=180,
  label="Clip length",
  unit="s",
  ticks=[0, 30, 60, 90, 120, 150, 180],
  auto=is_auto,
  on_auto_change=set_auto.map(v => _ => v),
  on_input=set_length.map(v => _ => v),
)
```

</SumiDemo>

## API

### slider_field

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| value **\*** | `Int` | — | 当前值（受控） |
| min | `Int` | 0 |  |
| max | `Int` | 100 |  |
| step | `Int` | 1 |  |
| label | `String` | — | 轨道上方标题，同时作为数字框 aria 标签 |
| unit | `String` | "" | 数字框内单位后缀 |
| ticks | `Array[Int]` | [] | 带刻度标记与标签的值 |
| auto | `Bool` | — | 传入时显示带开关的自动行 |
| auto_label | `String` | "Auto" |  |
| on_auto_change | `Emit[Bool]` | — |  |
| on_input | `Emit[Int]` | — | 拖拽逐格与数字提交时触发 |
| on_commit | `Emit[Int]` | — | 释放与数字提交时触发 |
| disabled | `Bool` | false | 禁用交互并降低不透明度 |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

\* 必填（标签）参数——其余均为可选。
