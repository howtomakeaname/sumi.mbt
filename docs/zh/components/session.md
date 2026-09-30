# Session 会话管理

聊天窗口的会话界面元素：头部为当前会话胶囊与新建/收起按钮；浮层会话列表的行展示生成状态，悬停时显示重命名/删除操作。

## 示例

### 头部与列表面板

<SumiDemo name="session-menu">

```moonbit
@sumi.session_header(
  title="Desert Mirage Expedition",
  status=@sumi.Done,
  on_title=toggle_menu,
  on_new=new_chat,
  on_collapse=collapse,
)
@sumi.session_list(max_height=280, children=[
  @sumi.session_item(label="Desert Mirage Expedition", active=true),
  @sumi.session_item(label="Weekly Sync Notes", status=@sumi.Generating),
  @sumi.session_item(label="API Migration Draft", status=@sumi.Done),
  @sumi.session_divider(),
  @sumi.session_item(label="Archived Threads", disabled=true),
])
```

</SumiDemo>

## API

### session_header

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| title **\*** | `String` | — | 当前会话名（14/22，溢出省略） |
| status | `SessionStatus` | — | 标题旁的可选 `SessionStatus` 状态 |
| on_title | `Cmd` | — | 标题胶囊点击（通常用于开合列表） |
| on_new | `Cmd` | — | 新建会话图标按钮 |
| on_collapse | `Cmd` | — | 收起图标按钮 |
| new_label | `String` | "New conversation" | 新建按钮的无障碍标签 |
| collapse_label | `String` | "Collapse" | 收起按钮的无障碍标签 |
| aria_label | `String` | — |  |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

### session_list

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| children **\*** | `Array[Html]` | — | `session_item` 行与 `session_divider` 分隔线 |
| width | `Int` | 280 | 面板宽度 px（默认 280） |
| max_height | `Int` | — | 滚动限高 px；启用细滚动条 |
| aria_label | `String` | — |  |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

### session_item

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| label **\*** | `String` | — | 13/22 行文本（溢出省略） |
| active | `Bool` | false | 显示尾部对勾并标记 `aria-current` |
| disabled | `Bool` | false | 禁用交互并降低不透明度 |
| status | `SessionStatus` | — | 尾部生成状态（悬停时隐藏） |
| on_click | `Cmd` | — | 点击时发送的命令 |
| on_edit | `Cmd` | — | 悬停时显示重命名操作 |
| on_delete | `Cmd` | — | 悬停时显示删除操作 |
| edit_label | `String` | "Rename" | 重命名操作的无障碍标签/提示（默认 "Rename"） |
| delete_label | `String` | "Delete" | 删除操作的无障碍标签/提示（默认 "Delete"） |
| aria_label | `String` | — |  |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

### session_status

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| kind **\*** | `SessionStatus` | — | `Generating | Count(Int) | Done | Dot | Pending(String) | Partial` |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

### session_title

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| label **\*** | `String` | — | 14/22 胶囊文本（溢出省略） |
| status | `SessionStatus` | — | 箭头前的可选状态 |
| on_click | `Cmd` | — | 点击时发送的命令 |
| disabled | `Bool` | false | 禁用交互并降低不透明度 |
| aria_label | `String` | — |  |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

### session_divider

分组之间的 4px 高细分隔线。

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

\* 必填（标签）参数——其余均为可选。
