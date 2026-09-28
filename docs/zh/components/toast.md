# Toast 轻提示

固定于视口顶部居中的瞬态通知——成功、错误或信息——淡入淡出。

## 示例

### 变体

<SumiDemo name="toast-basic">

```moonbit
@sumi.toast(
  message="Export started — 3 files queued",
  open=show_success,
  variant=@sumi.Success,
  on_close=set_state(_ => ""),
)
```

</SumiDemo>

## API

### toast

| 名称 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| message **\*** | `String` | — | 通知文本 |
| open **\*** | `Bool` | — | 浮层是否打开（受控） |
| variant | `ToastVariant` | Info | 状态样式 |
| on_close | `Cmd` | — | 轻提示消失时调用 |
| id | `String` | — | 元素 id |
| class | `String` | — | 附加 class 名 |
| attrs | `Attrs` | — | 附加 HTML 属性 |
| style | `Array[String]` | [] | 附加内联样式 |

### ToastVariant

| Variant | 说明 |
|---|---|
| `Info` | 中性图标 |
| `Success` | 品牌色对勾圆标 |
| `Error` | 错误红图标 |

\* 必填（标签）参数——其余均为可选。
