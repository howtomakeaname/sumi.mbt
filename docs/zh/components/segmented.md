# Segmented 分段选择器

一行互斥选项。`stacked` 渲染带比例示意图的高项，适合宽高比选择。

## 示例

### 行模式

<SumiDemo name="segmented-basic">

```moonbit
@sumi.segmented(
  items=[
    @sumi.SegmentedItem::new("2k", "2K", numeric=true),
    @sumi.SegmentedItem::new("4k", "4K", numeric=true, trailing=sparkle),
    @sumi.SegmentedItem::new("8k", "8K", numeric=true, trailing=sparkle),
  ],
  selected=current,
  on_select=set_res.map(v => _ => v),
)
```

</SumiDemo>

### 堆叠比例选择

<SumiDemo name="segmented-stacked">

```moonbit
@sumi.segmented(
  stacked=true,
  items=[
    @sumi.SegmentedItem::new("16:9", "16:9", numeric=true,
      icon=@sumi.icon_ratio(width=16, height=9)),
    @sumi.SegmentedItem::new("1:1", "1:1", numeric=true,
      icon=@sumi.icon_ratio(width=1, height=1)),
  ],
  selected=current,
  on_select=set_ratio.map(v => _ => v),
)
```

</SumiDemo>

## API

### segmented

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| items **\*** | `Array[SegmentedItem]` | — | 选项列表 |
| selected **\*** | `String` | — | 选中项的值（受控） |
| stacked | `Bool` | false | 图标在上、标签在下的高布局 |
| on_select | `Emit[String]` | — | 选中某项时以其值调用 |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

### SegmentedItem::new

一个选项。

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| value | `String` | — |  |
| label | `String` | — |  |
| icon | `Html` | — | 前置图形（堆叠模式） |
| trailing | `Html` | — | 尾部标记（如高级能力标识） |
| numeric | `Bool` | false | 使用数字字体渲染 |
| disabled | `Bool` | false | 禁用交互并降低不透明度 |

\* 必填（标签）参数——其余均为可选。
