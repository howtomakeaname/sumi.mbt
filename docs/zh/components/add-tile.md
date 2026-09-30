# Add Tile 添加磁贴

48px 的添加磁贴：低调的描边方块中央一个加号。可作为 `dropdown_menu` 的触发器组合，在上方弹出上传/选取菜单；悬停时填充提升为主块色。

## 示例

### 带选取菜单

<SumiDemo name="add-tile-basic">

```moonbit
@sumi.dropdown_menu(
  trigger=@sumi.add_tile(aria_label="Add image"),
  items=[
    Item(@sumi.MenuItem::new("upload", "Upload image",
      icon=@sumi.icon_upload_fill())),
    Item(@sumi.MenuItem::new("assets", "Select from assets",
      icon=@sumi.icon_folder())),
    Item(@sumi.MenuItem::new("project", "Select from project",
      icon=@sumi.icon_target())),
  ],
  open=is_open,
  on_open_change=set_open.map(v => _ => v),
  side=@sumi.Top,
  menu_style=["width:240px"],
)
@sumi.add_tile(disabled=true)
```

</SumiDemo>

## API

### add_tile

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| on_click | `Cmd` | — | 点击命令（组合用法下通常是菜单开关） |
| disabled | `Bool` | false | 加号置灰且不可交互 |
| aria_label | `String` | — | 无障碍标签（默认 "Add"） |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

\* 必填（标签）参数——其余均为可选。
