# Pagination 分页

极简 `‹ 页码 / 总数 ›` 分页器，箭头在边界处钳制并禁用。

## 示例

### 页码 / 总数

<SumiDemo name="pagination-basic">

```moonbit
@sumi.pagination(
  page=current,
  total=4,
  on_change=set_page.map(v => _ => v),
)
```

</SumiDemo>

## API

### pagination

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| page **\*** | `Int` | — | 当前页码，从 1 开始（受控） |
| total **\*** | `Int` | — | 总页数 |
| on_change | `Emit[Int]` | — | 以钳制后的目标页回调 |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

\* 必填（标签）参数——其余均为可选。
