# 快速开始

## 安装

```bash
moon add howtomakeaname/sumi
```

然后在 `moon.pkg` 中引入该包：

```
import {
  "howtomakeaname/sumi",
}
```

## 最小应用

```moonbit
using @rabbita {type Val, type Html}

///|
fn app() -> Val[Html] {
  Val::constant(
    @sumi.theme(mode=@sumi.System, [
      @sumi.button(variant=@sumi.Primary, "Generate"),
      @sumi.tag(variant=@sumi.Brand, [
        @sumi.icon_sparkle(size=12),
        @html.text("AI"),
      ]),
    ]),
  )
}

///|
fn main {
  @rabbita.new(app).mount("app")
}
```

`theme()` 会注入 token 样式表、交互样式表与事件层，并将你的内容包裹在主题容器中。其余部分就是普通的 rabbita HTML。

## 状态由你持有

组件是**受控**的：状态存放在 `@rabbita.create_variable` 创建的变量中，当前值传入组件，变化在回调里更新：

```moonbit
let (open, set_open) = @rabbita.create_variable(false)
let (format, set_format) = @rabbita.create_variable("png")

open.view2(format, fn(is_open, current) {
  @sumi.select(
    options=[
      @sumi.MenuItem::new("png", "PNG"),
      @sumi.MenuItem::new("jpg", "JPG"),
    ],
    value=current,
    placeholder="Export format",
    open=is_open,
    on_open_change=set_open.map(v => _ => v),
    on_select=set_format.map(v => _ => v),
  )
})
```

`.map(v => _ => v)` 这个惯用法把 setter（`(T) -> Unit`）适配成组件期望的发射器形态——读作"把传入的值写进变量"。

## 接下来

- [主题](/zh/guide/theming)——深色 / 浅色 / 跟随系统与 token 覆盖
- [组件](/zh/components/button)——每个组件的在线演示与 API 表
