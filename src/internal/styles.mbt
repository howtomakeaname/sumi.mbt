///|
pub const SumiBoxSizing : String = "box-sizing:border-box"

///|
pub const SumiFontSans : String = "font-family:\"PingFang SC\",Inter,ui-sans-serif,system-ui,-apple-system,BlinkMacSystemFont,\"Segoe UI\",sans-serif"

///|
pub const SumiFontNum : String = "font-family:Montserrat,\"PingFang SC\",ui-sans-serif,system-ui,sans-serif"

///|
pub const SumiTextRendering : String = "-webkit-font-smoothing:antialiased;text-rendering:optimizeLegibility"

///|
/// Shared transition recipe for controls. 100ms at the soft curve keeps
/// hover feedback immediate without smearing rapid pointer movement.
pub const SumiTransition : String = "transition:color 100ms cubic-bezier(0.4,0,0.2,1),background-color 100ms cubic-bezier(0.4,0,0.2,1),border-color 100ms cubic-bezier(0.4,0,0.2,1),box-shadow 100ms cubic-bezier(0.4,0,0.2,1),opacity 100ms cubic-bezier(0.4,0,0.2,1),transform 100ms cubic-bezier(0.4,0,0.2,1)"

///|
pub const SumiDisabled : String = "cursor:not-allowed;pointer-events:none"

///|
pub fn sumi_attrs(attrs : @html.Attrs?) -> @html.Attrs {
  if attrs is Some(attrs) {
    attrs.copy()
  } else {
    @html.Attrs::build()
  }
}

///|
pub fn sumi_styles(
  parts : Array[String],
  extra : Array[String],
) -> Array[String] {
  let styles : Array[String] = []
  for part in parts {
    if part != "" {
      styles.push(part)
    }
  }
  for part in extra {
    if part != "" {
      styles.push(part)
    }
  }
  styles
}

///|
pub fn sumi_bool(value : Bool) -> String {
  if value {
    "true"
  } else {
    "false"
  }
}

///|
pub fn sumi_disabled_style(disabled : Bool) -> String {
  if disabled {
    SumiDisabled
  } else {
    ""
  }
}

///|
/// Normalize generic children into a single `Html` node without affecting
/// layout, so components can embed caller children inside a fixed structure.
pub fn[C : @html.IsChildren] sumi_slot(children : C) -> @html.Html {
  @html.div(style=["display:contents"], children)
}
