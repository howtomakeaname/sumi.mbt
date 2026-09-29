///|
using @rabbita {type Val, type Html}

///|
/// Docs placeholders always mount the dark stage; the light palette and
/// token overrides have their own dedicated registry entries.
fn mountable(name : String) -> (() -> Val[Html])? {
  match @demos.find_demo(name) {
    Some(build) => Some(fn() { build(Some(@sumi.Dark)) })
    None => None
  }
}

///|
let mount_counter : Ref[Int] = { val: 0, }

///|
/// Mount every not-yet-mounted demo placeholder currently in the document.
/// VitePress swaps page content on client-side navigation, so this runs on
/// load and again on every DOM mutation (observed below).
fn hydrate() -> Unit {
  let nodes = @dom.document().query_selector_all(
    "[data-sumi-demo]:not([data-sumi-mounted])",
  )
  for el in nodes.iter() {
    if el.get_attribute("data-sumi-demo") is Some(name) {
      match mountable(name) {
        Some(builder) => {
          let id = "sumi-demo-" + name + "-" + mount_counter.val.to_string()
          mount_counter.val += 1
          el.set_attribute("id", id)
          el.set_attribute("data-sumi-mounted", "1")
          @rabbita.new(builder).mount(id)
        }
        None => el.set_attribute("data-sumi-mounted", "missing")
      }
    }
  }
}

///|
fn main {
  hydrate()
  let observer = @dom.MutationObserver::new(fn(_records, _observer) {
    hydrate()
  })
  if @dom.document().get_body() is Some(body) && body.to_node() is Some(node) {
    observer.observe(node, child_list=true, subtree=true)
  }
}
