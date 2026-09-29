# Status Badge 状态徽标

20px 的异步任务状态徽标：进行中的磨砂确定进度环、显示排队数量的白色圆片（超过 99 封顶）、完成时的蓝色对勾圆盘、部分失败时的琥珀色信息圆盘。浮于深色内容之上，配色固定为深色。

## 示例

### 全部状态

<SumiDemo name="status-badge">

```moonbit
@sumi.status_badge(state=Running(45))
@sumi.status_badge(state=Count(3))
@sumi.status_badge(state=Count(99))
@sumi.status_badge(state=Complete)
@sumi.status_badge(state=Warning)
```

</SumiDemo>

## API

### status_badge

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| state **\*** | `StatusBadgeState` | — | `StatusBadgeState`——`Running(pct)` / `Count(n)` / `Complete` / `Warning` |
| aria_label | `String` | — | 覆盖读给辅助技术的状态描述 |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

\* 必填（标签）参数——其余均为可选。
