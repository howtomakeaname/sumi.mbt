///|
/// A tiny static event layer for the behaviors neither inline styles nor the
/// cross-platform event structs can express:
///
/// - suppressing the native context menu over `context_menu` targets while
///   recording the pointer position into the `--sumi-ctx-x/y` variables the
///   panel reads (the framework offers no `preventDefault` across targets),
/// - roving-focus arrow-key / Home / End navigation inside open menus, with
///   Escape routed back through the component's own close command.
///
/// It is a closed library constant emitted once by `theme`; no caller input
/// reaches it. Comparisons avoid `<` so the body also survives SSR text
/// escaping (`&lt;` would corrupt the script).
const SumiEventGuardJs : String =
  #|(function(){
  #|  if (window.__sumiEventGuard) return;
  #|  window.__sumiEventGuard = true;
  #|  var ROOT_SEL = '[data-slot="dropdown"],[data-slot="context-menu-root"]';
  #|  var MENU_SEL = '[data-slot="menu"]:not([hidden])';
  #|  var ITEM_SEL = '[data-slot="menu-item"]:not([aria-disabled="true"])';
  #|  function closestOf(e, sel) {
  #|    return e.target && e.target.closest ? e.target.closest(sel) : null;
  #|  }
  #|  function itemsOf(menu) {
  #|    return Array.prototype.slice.call(menu.querySelectorAll(ITEM_SEL));
  #|  }
  #|  // Keyboard events land on <body> when nothing inside the menu root holds
  #|  // focus (the state right after a right-click open), so the open menu is
  #|  // found from the event target when possible and globally otherwise.
  #|  function openMenu(e) {
  #|    var root = closestOf(e, ROOT_SEL);
  #|    var menu = root ? root.querySelector(MENU_SEL) : null;
  #|    if (menu) return menu;
  #|    var active = document.activeElement;
  #|    if (active && active !== document.body && active !== document.documentElement) {
  #|      return null;
  #|    }
  #|    return document.querySelector(ROOT_SEL + ' ' + MENU_SEL);
  #|  }
  #|  document.addEventListener('contextmenu', function(e){
  #|    var root = closestOf(e, '[data-slot="context-menu-root"]');
  #|    if (!root) return;
  #|    e.preventDefault();
  #|    document.documentElement.style.setProperty('--sumi-ctx-x', e.clientX + 'px');
  #|    document.documentElement.style.setProperty('--sumi-ctx-y', e.clientY + 'px');
  #|    // The panel renders after the component processes its own event, so the
  #|    // first item is focused on the next frames (keyboard users can then
  #|    // arrow and Escape without an extra click).
  #|    var tries = 0;
  #|    (function focusFirst(){
  #|      var menu = root.querySelector(MENU_SEL);
  #|      var first = menu ? itemsOf(menu)[0] : null;
  #|      if (first) { first.focus(); return; }
  #|      tries += 1;
  #|      if (tries > 9) return;
  #|      requestAnimationFrame(focusFirst);
  #|    })();
  #|  }, true);
  #|  document.addEventListener('keydown', function(e){
  #|    var menu = openMenu(e);
  #|    if (!menu) return;
  #|    if (e.key === 'ArrowDown' || e.key === 'ArrowUp') {
  #|      var list = itemsOf(menu);
  #|      if (!list.length) return;
  #|      e.preventDefault();
  #|      var i = list.indexOf(document.activeElement);
  #|      var next = e.key === 'ArrowDown'
  #|        ? (i === -1 ? 0 : (i + 1) % list.length)
  #|        : (i === -1 ? list.length - 1 : (i - 1 + list.length) % list.length);
  #|      list[next].focus();
  #|    } else if (e.key === 'Home') {
  #|      var first = itemsOf(menu);
  #|      if (!first.length) return;
  #|      e.preventDefault();
  #|      first[0].focus();
  #|    } else if (e.key === 'End') {
  #|      var last = itemsOf(menu);
  #|      if (!last.length) return;
  #|      e.preventDefault();
  #|      last[last.length - 1].focus();
  #|    } else if (e.key === 'Escape') {
  #|      var scope = menu.closest(ROOT_SEL);
  #|      var overlay = scope ? scope.querySelector('[data-slot="menu-overlay"]:not([hidden])') : null;
  #|      if (overlay) {
  #|        e.preventDefault();
  #|        overlay.click();
  #|      }
  #|    }
  #|  }, true);
  #|  // Editable text / slider-field number: focus selects the whole title so
  #|  // typing replaces it outright (editable only); Enter commits through the
  #|  // blur path, Escape restores the committed value (mirrored on
  #|  // data-value) before blurring, which makes the resulting commit a no-op.
  #|  document.addEventListener('focusin', function(e){
  #|    var t = e.target;
  #|    if (t && t.matches && t.matches('[data-slot="editable-text-input"]')) {
  #|      requestAnimationFrame(function(){ t.select(); });
  #|    }
  #|  });
  #|  document.addEventListener('keydown', function(e){
  #|    var t = e.target;
  #|    if (!t || !t.matches || !t.matches('[data-slot="editable-text-input"],[data-slot="slider-field-input"]')) return;
  #|    if (e.key === 'Enter') {
  #|      e.preventDefault();
  #|      t.blur();
  #|    } else if (e.key === 'Escape') {
  #|      var v = t.getAttribute('data-value');
  #|      if (v !== null) t.value = v;
  #|      t.blur();
  #|    }
  #|  }, true);
  #|})();

///|
#warnings("-alert_xss_vulnerable")
pub fn sumi_event_guard_script() -> @html.Html {
  // The body is emitted as a plain text child, not through `inner_html`:
  // a <script> populated via the innerHTML property is marked "already
  // started" by the HTML spec and never executes, while a script carrying a
  // text node runs as soon as the element enters the document. The constant
  // is closed library code; no caller input reaches it.
  let attrs = @html.Attrs::build().data_set("sumi-script", "event-guard")
  @html.script(attrs~, [@html.text(SumiEventGuardJs)])
}
