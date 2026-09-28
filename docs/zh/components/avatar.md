# Avatar 头像

圆形身份图像，加载失败时回退为文字。

## 示例

### 回退文字

<SumiDemo name="avatar-basic">

```moonbit
@sumi.avatar(fallback="Sumi")
@sumi.avatar(fallback="墨", size=40)
```

</SumiDemo>

## API

### avatar

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| src | `String` | — | 图像 URL；缺失或加载失败时回退 |
| fallback | `String` | "" | 无图像时渲染的文字 |
| size | `Int` | 32 | 直径（px） |
| alt | `String` | "" | 图像 alt 文本 |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

\* 必填（标签）参数——其余均为可选。
