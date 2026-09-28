# 主题

## 模式

在应用根部用 `theme(mode=…)` 包裹一次：

| 模式 | 行为 |
|---|---|
| `Dark`（默认） | 深色调色板 |
| `Light` | 浅色调色板 |
| `System` | 跟随 `prefers-color-scheme`，实时切换 |

```moonbit
@sumi.theme(mode=@sumi.System, [content])
```

同一批组件在浅色调色板下的样子：

<SumiDemo name="theme-light">

```moonbit
@sumi.theme(mode=@sumi.Light, [
  @sumi.button(variant=@sumi.Primary, "Generate"),
  @sumi.switch(checked=is_on, on_change=set_on.map(v => _ => v)),
])
```

</SumiDemo>

## 工作原理

`theme()` 生成的 token 样式表挂靠在包裹层的 `data-sumi-theme` 属性上——而非内联样式——因此：

- **嵌套主题可组合。** 深色页面里放一块浅色卡片毫无问题；token 总是解析到最近的主题祖先。
- **调用方覆盖优先。** 同一元素上内联样式胜过样式表，因此你可以在不碰全局 CSS 的情况下为某棵子树改色。

组件以 `var(--sumi-x, <深色值>)` 引用 token，所以未包裹主题时仍呈深色渲染。推荐但非强制使用 `theme()`。

## 覆盖 token

通过包裹层的 `style` 参数传入 token 声明。下面把品牌色从蓝改为紫——子树里所有品牌色控件都会跟随：

<SumiDemo name="theme-tokens">

```moonbit
@sumi.theme(
  style=["--sumi-brand:#7c3aed;--sumi-brand-hover:#6d28d9"],
  [
    @sumi.switch(checked=is_on, on_change=set_on.map(v => _ => v)),
    @sumi.tag(variant=@sumi.Brand, [
      @sumi.icon_sparkle(size=12),
      @html.text("AI"),
    ]),
  ],
)
```

</SumiDemo>

## Token 一览

调色板覆盖五个家族——表面（`--sumi-canvas` … `--sumi-spotlight`）、填充（`--sumi-block*`）、描边（`--sumi-stroke*`）、文本（`--sumi-text*`）与强调（`--sumi-brand*`、`--sumi-error`、`--sumi-primary*`）——外加圆角、阴影与遮罩。完整清单（含双色调色板）见 [`tokens.mbt`](https://github.com/howtomakeaname/sumi.mbt/blob/main/src/tokens.mbt)；浅色模式的映射规则记录在 [DESIGN.md](https://github.com/howtomakeaname/sumi.mbt/blob/main/DESIGN.md)。
