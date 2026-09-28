# Getting Started

## Install

```bash
moon add howtomakeaname/sumi
```

Then import the package in your `moon.pkg`:

```
import {
  "howtomakeaname/sumi",
}
```

## A minimal app

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

`theme()` injects the token sheet, the interaction stylesheet and the event layer, then wraps your content in a themed container. Everything else is ordinary rabbita HTML.

## State is yours

Components are **controlled**: you hold state in variables created with `@rabbita.create_variable`, pass the current value in, and update it from the change callback:

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

The `.map(v => _ => v)` idiom adapts a setter (`(T) -> Unit`) to the emitter shape a component expects — read it as "set the variable to the incoming value".

## Where next

- [Theming](/guide/theming) — dark / light / system modes and token overrides
- [Components](/components/button) — live demos and API tables for every component
