# Markdown 文本

回答正文的 MD 基础组件字阶：语义化 H2–H4 标题与正文段落 —— H2 16/24 Medium，H3/H4 14/22 Medium 带上下 12px 留白，正文 14/22 Regular —— 均为主文本色。

## 示例

### 字阶

<SumiDemo name="md-text">

```moonbit
@sumi.md_text(kind=@sumi.H2, text="Story beats")
@sumi.md_text(kind=@sumi.Body, text=sample)
@sumi.md_text(kind=@sumi.H3, text="Opening shot")
@sumi.md_text(kind=@sumi.Body, text=sample)
```

</SumiDemo>

## API

### md_text

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| text **\*** | `String` | — | 块文本内容 |
| kind | `MdTextKind` | Body | `H2` / `H3` / `H4` 标题或 `Body` 正文 |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

### MdTextKind

`H2` · `H3` · `H4` · `Body`

\* 必填（标签）参数——其余均为可选。
