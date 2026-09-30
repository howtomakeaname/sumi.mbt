# Generation Meta 生成信息

生成结果下方的信息与操作区：14/22 三级色声明行（内容提示、已用额度），下方一个无底色复制操作。

## 示例

### 含复制操作

<SumiDemo name="generation-meta">

```moonbit
@sumi.generation_meta(
  text="AI-generated content | 0 credits used",
  on_copy=emit(CopyResult),
)
```

</SumiDemo>

## API

### generation_meta

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| text **\*** | `String` | — | 14/22 三级色声明行 |
| on_copy | `Cmd` | — | 传入后渲染复制操作 |
| copy_label | `String` | "Copy" | 操作的无障碍标签与提示（默认 "Copy"） |
| aria_label | `String` | — |  |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

\* 必填（标签）参数——其余均为可选。
