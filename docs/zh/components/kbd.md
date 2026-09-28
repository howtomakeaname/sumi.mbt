# Kbd 键盘按键

渲染键盘键帽，用于快捷键提示。

## 示例

### 组合键

<SumiDemo name="kbd-basic">

```moonbit
@sumi.kbd("⌘")
@sumi.kbd("K")
```

</SumiDemo>

## API

### kbd

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| key | `String` | — |  |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

\* 必填（标签）参数——其余均为可选。
