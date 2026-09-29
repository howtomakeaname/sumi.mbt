# Checkbox Menu 多选菜单

多选菜单面板：分组行右侧带描边勾选框，各行独立切换；支持分组清空操作与底部固定行，内容超出最大高度时滚动。

## 示例

### 分组多选

<SumiDemo name="checkbox-menu">

```moonbit
@sumi.checkbox_menu(
  groups=[
    @sumi.CheckboxMenuGroup::new([
      @sumi.CheckboxMenuItem::new("text", "Text", checked=true),
      @sumi.CheckboxMenuItem::new("date", "Date"),
    ], title="Fields", clear_label="Clear", on_clear=clear_fields),
  ],
  on_toggle=set_selected.map(v => fn(c) { toggle(c, v) }),
  footer_label="Show all",
  on_footer=show_all,
)
```

</SumiDemo>

## API

### checkbox_menu

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| groups **\*** | `Array[CheckboxMenuGroup]` | — | 带标题的分组行；组间以细分隔线相隔 |
| on_toggle | `Emit[String]` | — | 点击行时发出其 `value` |
| width | `Int` | 200 | 面板宽度——设计规格档位为 160/200/240/320 |
| max_height | `Int` | 480 | 正文区域的滚动阈值 |
| footer_label | `String` | — | 滚动区下方的固定行 |
| footer_icon | `Html` | — | 固定行的前置图标 |
| on_footer | `Cmd` | — | 固定行的激活回调 |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

### CheckboxMenuGroup::new

一个带标题的分组。

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| items | `Array[CheckboxMenuItem]` | — |  |
| title | `String` | — | 分组小标题 |
| clear_label | `String` | — | 标题右侧的文字操作 |
| on_clear | `Cmd` | — | 清空操作命令 |

### CheckboxMenuItem::new

一个可切换的行。

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| value | `String` | — |  |
| label | `String` | — |  |
| icon | `Html` | — | 前置图标 |
| checked | `Bool` | false | 受控选中状态 |
| disabled | `Bool` | false | 置灰并禁用该行 |

\* 必填（标签）参数——其余均为可选。
