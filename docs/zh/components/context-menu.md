# Context Menu 上下文菜单

固定于指针位置的右键菜单。主题事件层负责屏蔽原生菜单、记录指针位置并聚焦首项。

## 示例

### 右键点击方块

<SumiDemo name="context-menu-basic">

```moonbit
@sumi.context_menu(
  entries=[
    @sumi.Item(@sumi.MenuItem::new("rename", "Rename", shortcut="R")),
    @sumi.Separator,
    @sumi.Item(@sumi.MenuItem::new("delete", "Delete", shortcut="⌫")),
  ],
  open=is_open,
  on_open_change=set_open.map(v => _ => v),
  on_select=set_action.map(v => _ => v),
  target_content,
)
```

</SumiDemo>

## API

### context_menu

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| entries **\*** | `Array[MenuEntry]` | — | 菜单内容——`Item`、`Separator`、`SectionLabel` |
| open **\*** | `Bool` | — | 浮层是否打开（受控） |
| on_open_change | `Emit[Bool]` | — | 打开状态应变化时调用 |
| selected | `String` | — | 当前选中项的值 |
| on_select | `Emit[String]` | — | 选中某项时以其值调用 |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |
| menu_style | `Array[String]` | [] | 浮层面板的样式 |
| children | `C` | — | 内容 |

\* 必填（标签）参数——其余均为可选。
