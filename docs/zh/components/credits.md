# Credits 额度

紧凑的余额读数，可选划线原价。

## 示例

### 基础用法

<SumiDemo name="credits-basic">

```moonbit
@sumi.credits(value=24)
@sumi.credits(value=24, original_value=48)
@sumi.credits(value=8, muted=true)
```

</SumiDemo>

## API

### credits

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| value **\*** | `Int` | — | 当前额度 |
| original_value | `Int` | — | 折扣时显示划线原价 |
| muted | `Bool` | false | 降为占位色调，用于磨砂坞 |
| on_click | `Cmd` | — | 点击时发送的命令 |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| title | `String` | — | 原生 tooltip 标题 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

\* 必填（标签）参数——其余均为可选。
