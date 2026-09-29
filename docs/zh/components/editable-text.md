# Editable Text 可编辑文本

看似普通文本，点击变为输入框；Enter 或失焦提交，Escape 还原。

## 示例

### 点击重命名

<SumiDemo name="editable-text-basic">

```moonbit
@sumi.editable_text(
  value=current,
  placeholder="Enter a canvas name",
  on_change=set_title.map(v => _ => v),
)
@sumi.editable_text(value="", placeholder="Enter a canvas name")
```

</SumiDemo>

## API

### editable_text

\* 必填（标签）参数——其余均为可选。
