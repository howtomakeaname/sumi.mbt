# Slider 滑块

可拖拽的数值轨道。`on_input` 每次移动触发；`on_commit` 在释放时触发一次，避免昂贵响应被放大。

## 示例

### 带数值显示

<SumiDemo name="slider-basic">

```moonbit
@sumi.slider(
  value=current,
  show_value=true,
  suffix="°",
  on_input=set_strength.map(v => _ => v),
)
```

</SumiDemo>

### 跟随气泡

<SumiDemo name="slider-tooltip">

```moonbit
@sumi.slider(
  value=current,
  value_tooltip=true,
  on_input=set_amount.map(v => _ => v),
)
```

</SumiDemo>

## API

### slider

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| value **\*** | `Int` | — | 当前值（受控） |
| min | `Int` | 0 | 下限 |
| max | `Int` | 100 | 上限 |
| step | `Int` | 1 | 步长 |
| on_input | `Emit[Int]` | — | 每次输入时调用 |
| on_commit | `Emit[Int]` | — | 释放时调用一次 |
| disabled | `Bool` | false | 禁用交互并降低不透明度 |
| show_value | `Bool` | false | 右侧数值显示 |
| value_tooltip | `Bool` | false | 交互时滑块上方的跟随气泡 |
| suffix | `String` | "" | 数值显示的单位后缀 |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

\* 必填（标签）参数——其余均为可选。
