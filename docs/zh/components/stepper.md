# Stepper 步进器

分段的 − 值 + 控件，在 min/max 处钳位。

## 示例

### 基础用法

<SumiDemo name="stepper-basic">

```moonbit
@sumi.stepper(
  value=current,
  min=1,
  max=8,
  on_change=set_count.map(v => _ => v),
)
```

</SumiDemo>

## API

### stepper

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| value **\*** | `Int` | — | 当前数值（受控） |
| min | `Int` | 1 | 下限 |
| max | `Int` | 8 | 上限 |
| step | `Int` | 1 | 每次点击的步长 |
| on_change | `Emit[Int]` | — | 值变化时调用 |
| disabled | `Bool` | false | 禁用交互并降低不透明度 |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

\* 必填（标签）参数——其余均为可选。
