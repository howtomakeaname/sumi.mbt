///|
/// The interaction layer stylesheet: pseudo classes cannot live in an HTML
/// `style` attribute, so hover/placeholder/pseudo-element/overlay-motion rules
/// ship as one static sheet emitted once by `theme`. Kept in its own file so
/// component files stay free of CSS text.
///
/// Cascade: the `@layer` keeps motion/base rules under host-page styles, but
/// state overrides that fight a component's inline base style (hover/active
/// backgrounds, focus borders and rings, placeholder colors) must carry
/// `!important` — author-important beats inline-normal regardless of layers.
/// Never `!important` a `transition`/`animation` here: inside a layer that
/// would outrank the unlayered reduced-motion block below.
const SumiInteractionCss : String =
  #|@keyframes sumi-spin {
  #|  to { transform:rotate(360deg); }
  #|}
  #|@keyframes sumi-shimmer {
  #|  from { background-position:200% 0; }
  #|  to { background-position:-200% 0; }
  #|}
  #|@keyframes sumi-shimmer-text {
  #|  from { background-position:100% 0; }
  #|  to { background-position:-100% 0; }
  #|}
  #|@keyframes sumi-fade-in {
  #|  from { opacity:0; }
  #|}
  #|@keyframes sumi-dialog-in {
  #|  from { opacity:0; transform:scale(0.5); }
  #|}
  #|@layer sumi-interactions {
  #|  :where([hidden]:not([hidden="until-found"])) {
  #|    display:none !important;
  #|  }
  #|  [data-slot="button"][data-variant="primary"]:not(:disabled):not([aria-disabled="true"]):hover {
  #|    background:var(--sumi-primary-bg-hover,#d9d9d9) !important;
  #|  }
  #|  [data-slot="button"][data-variant="secondary"]:not(:disabled):not([aria-disabled="true"]):hover {
  #|    background:var(--sumi-block-hover,rgba(255,255,255,0.12)) !important;
  #|  }
  #|  [data-slot="button"][data-variant="ghost"]:not(:disabled):not([aria-disabled="true"]):hover,
  #|  [data-slot="icon-button"]:not(:disabled):not([aria-disabled="true"]):hover {
  #|    background:var(--sumi-block,rgba(255,255,255,0.08)) !important;
  #|  }
  #|  [data-slot="icon-button"][aria-pressed="true"]:not(:disabled):not([aria-disabled="true"]) {
  #|    background:var(--sumi-block,rgba(255,255,255,0.08)) !important;
  #|  }
  #|  [data-slot="button"][data-variant="primary"]:not(:disabled):not([aria-disabled="true"]):active {
  #|    background:var(--sumi-primary-bg-pressed,#b2b2b2) !important;
  #|  }
  #|  [data-slot="button"][data-variant="secondary"]:not(:disabled):not([aria-disabled="true"]):active {
  #|    background:var(--sumi-block-pressed,rgba(255,255,255,0.16)) !important;
  #|  }
  #|  [data-slot="button"][data-variant="ghost"]:not(:disabled):not([aria-disabled="true"]):active,
  #|  [data-slot="icon-button"]:not(:disabled):not([aria-disabled="true"]):active {
  #|    background:var(--sumi-block-hover,rgba(255,255,255,0.12)) !important;
  #|  }
  #|  [data-slot="pagination-button"]:not(:disabled):not([aria-disabled="true"]):hover {
  #|    background:var(--sumi-block,rgba(255,255,255,0.08)) !important;
  #|  }
  #|  [data-slot="pagination-button"]:not(:disabled):not([aria-disabled="true"]):active {
  #|    background:var(--sumi-block-hover,rgba(255,255,255,0.12)) !important;
  #|  }
  #|  [data-slot="editable-text-input"]:not(:focus):hover {
  #|    background:var(--sumi-block,rgba(255,255,255,0.08)) !important;
  #|    backdrop-filter:blur(20px) !important;
  #|  }
  #|  [data-slot="editable-text-input"]:focus {
  #|    border-color:var(--sumi-stroke-secondary,rgba(255,255,255,0.04)) !important;
  #|    backdrop-filter:blur(10px) !important;
  #|  }
  #|  [data-slot="editable-text-input"]::placeholder {
  #|    color:var(--sumi-text-placeholder,rgba(255,255,255,0.35)) !important;
  #|  }
  #|  [data-slot="segmented-item"]:not([data-state="on"]):not(:disabled):hover {
  #|    background:var(--sumi-block,rgba(255,255,255,0.08)) !important;
  #|    color:var(--sumi-text,#ffffff) !important;
  #|  }
  #|  [data-slot="chip"]:not([data-state="on"]):not(:disabled):hover {
  #|    background:var(--sumi-block,rgba(255,255,255,0.08)) !important;
  #|  }
  #|  [data-slot="add-tile"]:not(:disabled):hover {
  #|    background:var(--sumi-block,rgba(255,255,255,0.08)) !important;
  #|  }
  #|  [data-slot="attachment-tile"]:hover [data-slot="attachment-remove"],
  #|  [data-slot="attachment-tile"]:focus-within [data-slot="attachment-remove"] {
  #|    opacity:1 !important;
  #|  }
  #|  [data-slot="media-tag"][data-interactive]:hover {
  #|    color:var(--sumi-text,#ffffff) !important;
  #|  }
  #|  [data-slot="chat-bubble"]:hover [data-slot="chat-bubble-copy"],
  #|  [data-slot="chat-bubble"]:focus-within [data-slot="chat-bubble-copy"] {
  #|    opacity:1 !important;
  #|    pointer-events:auto !important;
  #|  }
  #|  [data-slot="chat-bubble-toggle"]:hover {
  #|    color:var(--sumi-text,#ffffff) !important;
  #|  }
  #|  [data-slot="menu-item"]:not([aria-disabled="true"]):hover {
  #|    background:var(--sumi-block,rgba(255,255,255,0.08)) !important;
  #|  }
  #|  [data-slot="checkbox-menu-item"]:not([aria-disabled="true"]):hover,
  #|  [data-slot="checkbox-menu-footer-row"]:hover {
  #|    background:var(--sumi-block,rgba(255,255,255,0.08)) !important;
  #|  }
  #|  [data-slot="checkbox-menu-item"]:not([aria-disabled="true"]):active {
  #|    background:var(--sumi-block-hover,rgba(255,255,255,0.12)) !important;
  #|  }
  #|  [data-slot="checkbox-menu-item"]:not([aria-disabled="true"]):hover [data-slot="checkbox-menu-check"],
  #|  [data-slot="checkbox-menu-item"]:not([aria-disabled="true"]):active [data-slot="checkbox-menu-check"] {
  #|    opacity:1 !important;
  #|  }
  #|  [data-slot="checkbox-menu-clear"]:hover,
  #|  [data-slot="checkbox-menu-clear"]:active {
  #|    color:var(--sumi-text,#ffffff) !important;
  #|  }
  #|  [data-slot="switch"][data-state="off"]:not(:disabled):hover {
  #|    background:var(--sumi-block-hover,rgba(255,255,255,0.12)) !important;
  #|  }
  #|  [data-slot="switch"][data-state="on"]:not(:disabled):hover {
  #|    background:var(--sumi-brand-hover,#0099f2) !important;
  #|  }
  #|  [data-slot="send-button"]:not(:disabled):not([aria-disabled="true"]):hover {
  #|    background:var(--sumi-primary-bg-hover,#d9d9d9) !important;
  #|  }
  #|  [data-slot="send-button"]:not(:disabled):not([aria-disabled="true"]):active {
  #|    background:var(--sumi-primary-bg-pressed,#b2b2b2) !important;
  #|  }
  #|  [data-slot="select-trigger"][data-variant="form"]:not(:disabled):not([aria-disabled="true"]):hover {
  #|    background:var(--sumi-block-hover,rgba(255,255,255,0.12)) !important;
  #|  }
  #|  [data-slot="select-trigger"][data-variant="filter"]:not([aria-disabled="true"]):hover {
  #|    color:var(--sumi-text,#ffffff) !important;
  #|  }
  #|  [data-slot="select-filter-clear"]:not(:disabled):hover {
  #|    color:var(--sumi-text-secondary,rgba(255,255,255,0.7)) !important;
  #|  }
  #|  [data-slot="icon-button"]:disabled,
  #|  [data-slot="stepper-button"]:disabled {
  #|    cursor:not-allowed;
  #|    opacity:0.5;
  #|  }
  #|  [data-slot="input-clear"]:hover {
  #|    color:var(--sumi-text-secondary,rgba(255,255,255,0.7)) !important;
  #|  }
  #|  [data-slot="tooltip-content"] {
  #|    opacity:0;
  #|    pointer-events:none;
  #|    transition:opacity 100ms cubic-bezier(0.4,0,0.2,1),transform 100ms cubic-bezier(0.4,0,0.2,1);
  #|  }
  #|  [data-slot="tooltip-content"][data-side="top"],
  #|  [data-slot="tooltip-content"][data-side="bottom"] {
  #|    transform:translateX(-50%) scale(0.5);
  #|  }
  #|  [data-slot="tooltip-content"][data-side="left"],
  #|  [data-slot="tooltip-content"][data-side="right"] {
  #|    transform:translateY(-50%) scale(0.5);
  #|  }
  #|  [data-slot="tooltip-content"][data-side="top"] {
  #|    transform-origin:bottom center;
  #|  }
  #|  [data-slot="tooltip-content"][data-side="bottom"] {
  #|    transform-origin:top center;
  #|  }
  #|  [data-slot="tooltip-content"][data-side="left"] {
  #|    transform-origin:right center;
  #|  }
  #|  [data-slot="tooltip-content"][data-side="right"] {
  #|    transform-origin:left center;
  #|  }
  #|  [data-slot="tooltip"]:hover [data-slot="tooltip-content"][data-side="top"],
  #|  [data-slot="tooltip"]:hover [data-slot="tooltip-content"][data-side="bottom"],
  #|  [data-slot="tooltip"]:focus-visible [data-slot="tooltip-content"][data-side="top"],
  #|  [data-slot="tooltip"]:focus-visible [data-slot="tooltip-content"][data-side="bottom"] {
  #|    opacity:1;
  #|    transform:translateX(-50%) scale(1);
  #|  }
  #|  [data-slot="tooltip"]:hover [data-slot="tooltip-content"][data-side="left"],
  #|  [data-slot="tooltip"]:hover [data-slot="tooltip-content"][data-side="right"],
  #|  [data-slot="tooltip"]:focus-visible [data-slot="tooltip-content"][data-side="left"],
  #|  [data-slot="tooltip"]:focus-visible [data-slot="tooltip-content"][data-side="right"] {
  #|    opacity:1;
  #|    transform:translateY(-50%) scale(1);
  #|  }
  #|  [data-slot="input"]::placeholder,
  #|  [data-slot="textarea"]::placeholder,
  #|  [data-slot="prompt-textarea"]::placeholder {
  #|    color:var(--sumi-text-placeholder,rgba(255,255,255,0.35)) !important;
  #|    opacity:1 !important;
  #|  }
  #|  [data-slot="input"],
  #|  [data-slot="textarea"],
  #|  [data-slot="prompt-textarea"] {
  #|    caret-color:var(--sumi-brand,#009efa);
  #|  }
  #|  [data-slot="input"]::selection,
  #|  [data-slot="textarea"]::selection,
  #|  [data-slot="prompt-textarea"]::selection {
  #|    background:var(--sumi-selection-bg,rgba(0,158,250,0.35));
  #|    color:var(--sumi-selection-fg,#ffffff);
  #|  }
  #|  [data-slot="input"]:focus,
  #|  [data-slot="textarea"]:focus,
  #|  [data-slot="prompt-textarea"]:focus {
  #|    outline:none;
  #|  }
  #|  [data-slot="input"]:focus {
  #|    border-color:var(--sumi-brand,#009efa) !important;
  #|  }
  #|  [data-slot="slider"] {
  #|    -webkit-appearance:none;
  #|    appearance:none;
  #|    background:transparent;
  #|    cursor:pointer;
  #|  }
  #|  [data-slot="slider"]::-webkit-slider-runnable-track {
  #|    height:12px;
  #|    border-radius:4px;
  #|    background:linear-gradient(to right,var(--sumi-slider-fill,rgba(255,255,255,0.2)) 0%,var(--sumi-slider-fill,rgba(255,255,255,0.2)) var(--sumi-slider-percent,0%),var(--sumi-block,rgba(255,255,255,0.08)) var(--sumi-slider-percent,0%),var(--sumi-block,rgba(255,255,255,0.08)) 100%);
  #|  }
  #|  [data-slot="slider"]::-webkit-slider-thumb {
  #|    -webkit-appearance:none;
  #|    appearance:none;
  #|    width:4px;
  #|    height:16px;
  #|    border-radius:11px;
  #|    background:var(--sumi-slider-thumb,#ffffff);
  #|    margin-top:-2px;
  #|    box-shadow:none;
  #|  }
  #|  [data-slot="slider"]::-moz-range-track {
  #|    height:12px;
  #|    border-radius:4px;
  #|    background:var(--sumi-block,rgba(255,255,255,0.08));
  #|  }
  #|  [data-slot="slider"]::-moz-range-progress {
  #|    height:12px;
  #|    border-radius:4px;
  #|    background:var(--sumi-slider-fill,rgba(255,255,255,0.2));
  #|  }
  #|  [data-slot="slider"]::-moz-range-thumb {
  #|    width:4px;
  #|    height:16px;
  #|    border:none;
  #|    border-radius:11px;
  #|    background:var(--sumi-slider-thumb,#ffffff);
  #|  }
  #|  [data-slot="slider"]:disabled {
  #|    cursor:not-allowed;
  #|    opacity:0.5;
  #|  }
  #|  [data-slot="switch"]:disabled,
  #|  [data-slot="checkbox"]:disabled {
  #|    cursor:not-allowed;
  #|    opacity:0.5;
  #|  }
  #|  [data-slot="scroll-area"],
  #|  [data-slot="checkbox-menu-body"],
  #|  [data-slot="shortcuts-panel-body"],
  #|  [data-slot="prompt-textarea"] {
  #|    scrollbar-width:thin;
  #|    scrollbar-color:var(--sumi-scrollbar,rgba(255,255,255,0.08)) transparent;
  #|  }
  #|  [data-slot="scroll-area"]::-webkit-scrollbar,
  #|  [data-slot="checkbox-menu-body"]::-webkit-scrollbar,
  #|  [data-slot="shortcuts-panel-body"]::-webkit-scrollbar,
  #|  [data-slot="prompt-textarea"]::-webkit-scrollbar {
  #|    width:12px;
  #|    height:12px;
  #|  }
  #|  [data-slot="scroll-area"]::-webkit-scrollbar-thumb,
  #|  [data-slot="checkbox-menu-body"]::-webkit-scrollbar-thumb,
  #|  [data-slot="shortcuts-panel-body"]::-webkit-scrollbar-thumb,
  #|  [data-slot="prompt-textarea"]::-webkit-scrollbar-thumb {
  #|    background:var(--sumi-scrollbar,rgba(255,255,255,0.08));
  #|    border:5px solid transparent;
  #|    border-radius:10px;
  #|    background-clip:padding-box;
  #|  }
  #|  [data-slot="scroll-area"]::-webkit-scrollbar-thumb:hover,
  #|  [data-slot="checkbox-menu-body"]::-webkit-scrollbar-thumb:hover,
  #|  [data-slot="shortcuts-panel-body"]::-webkit-scrollbar-thumb:hover,
  #|  [data-slot="prompt-textarea"]::-webkit-scrollbar-thumb:hover {
  #|    background:var(--sumi-scrollbar-hover,rgba(255,255,255,0.12));
  #|    border-width:4px;
  #|  }
  #|  [data-slot="scroll-area"]::-webkit-scrollbar-thumb:active,
  #|  [data-slot="checkbox-menu-body"]::-webkit-scrollbar-thumb:active,
  #|  [data-slot="shortcuts-panel-body"]::-webkit-scrollbar-thumb:active,
  #|  [data-slot="prompt-textarea"]::-webkit-scrollbar-thumb:active {
  #|    background:var(--sumi-scrollbar-pressed,rgba(255,255,255,0.16));
  #|    border-width:4px;
  #|  }
  #|  [data-slot="scroll-area"]::-webkit-scrollbar-track,
  #|  [data-slot="checkbox-menu-body"]::-webkit-scrollbar-track,
  #|  [data-slot="shortcuts-panel-body"]::-webkit-scrollbar-track,
  #|  [data-slot="prompt-textarea"]::-webkit-scrollbar-track {
  #|    background:transparent;
  #|  }
  #|  [data-slot="checkbox-menu-body"]::-webkit-scrollbar {
  #|    width:8px;
  #|  }
  #|  [data-slot="checkbox-menu-body"]::-webkit-scrollbar-thumb {
  #|    border-width:3px;
  #|  }
  #|  [data-slot="checkbox-menu-body"]::-webkit-scrollbar-thumb:hover,
  #|  [data-slot="checkbox-menu-body"]::-webkit-scrollbar-thumb:active {
  #|    border-width:2px;
  #|  }
  #|  [data-slot="dialog"]::backdrop {
  #|    background:var(--sumi-backdrop,rgba(0,0,0,0.8));
  #|  }
  #|  [data-slot="dialog"][open] {
  #|    animation:sumi-dialog-in 400ms cubic-bezier(0.3,1.3,0.3,1);
  #|  }
  #|  [data-slot="dialog"][open]::backdrop {
  #|    animation:sumi-fade-in 200ms ease;
  #|  }
  #|  [data-slot="menu"],
  #|  [data-slot="popover-panel"] {
  #|    opacity:0;
  #|    transform:scale(0.5);
  #|    transform-origin:top left;
  #|    transition:opacity 200ms cubic-bezier(0.4,0,0.2,1),transform 200ms cubic-bezier(0.4,0,0.2,1),display 200ms allow-discrete;
  #|  }
  #|  [data-slot="menu"][data-side="bottom"][data-align="start"],
  #|  [data-slot="popover-panel"][data-side="bottom"][data-align="start"] {
  #|    transform-origin:top left;
  #|  }
  #|  [data-slot="menu"][data-side="bottom"][data-align="end"],
  #|  [data-slot="popover-panel"][data-side="bottom"][data-align="end"] {
  #|    transform-origin:top right;
  #|  }
  #|  [data-slot="menu"][data-side="top"][data-align="start"],
  #|  [data-slot="popover-panel"][data-side="top"][data-align="start"] {
  #|    transform-origin:bottom left;
  #|  }
  #|  [data-slot="menu"][data-side="top"][data-align="end"],
  #|  [data-slot="popover-panel"][data-side="top"][data-align="end"] {
  #|    transform-origin:bottom right;
  #|  }
  #|  [data-slot="menu"]:not([hidden]),
  #|  [data-slot="popover-panel"]:not([hidden]) {
  #|    opacity:1;
  #|    transform:none;
  #|    transition:opacity 200ms cubic-bezier(0.4,0,0.2,1),transform 200ms cubic-bezier(0.4,0,0.2,1),display 200ms allow-discrete;
  #|  }
  #|  [data-slot="toast"] {
  #|    opacity:0;
  #|    transition:opacity 200ms cubic-bezier(0.4,0,0.2,1),display 200ms allow-discrete;
  #|  }
  #|  [data-slot="toast"]:not([hidden]) {
  #|    opacity:1;
  #|    transition:opacity 200ms cubic-bezier(0.4,0,0.2,1),display 200ms allow-discrete;
  #|  }
  #|  [data-slot="menu-chevron"] {
  #|    transition:transform 200ms cubic-bezier(0.4,0,0.2,1);
  #|  }
  #|  [data-slot="dropdown"][data-state="open"] [data-slot="menu-chevron"] {
  #|    transform:rotate(180deg);
  #|  }
  #|  [data-slot="spinner"] {
  #|    animation:sumi-spin 0.8s linear infinite;
  #|  }
  #|  [data-slot="skeleton"] {
  #|    background:linear-gradient(100deg,transparent 40%,var(--sumi-shimmer,rgba(255,255,255,0.06)) 50%,transparent 60%) no-repeat, var(--sumi-block,rgba(255,255,255,0.08));
  #|    background-size:200% 100%,100% 100%;
  #|    animation:sumi-shimmer 1.6s ease-in-out infinite;
  #|  }
  #|  [data-slot="slider-track"]:hover > [data-slot="slider-bubble"],
  #|  [data-slot="slider-track"]:focus-within > [data-slot="slider-bubble"] {
  #|    opacity:1;
  #|  }
  #|  [data-slot="segmented-item"]:focus-visible,
  #|  [data-slot="chip"]:focus-visible,
  #|  [data-slot="media-tag"]:focus-visible,
  #|  [data-slot="add-tile"]:focus-visible,
  #|  [data-slot="attachment-remove"]:focus-visible,
  #|  [data-slot="chat-bubble-toggle"]:focus-visible,
  #|  [data-slot="chat-bubble-copy"]:focus-visible,
  #|  [data-slot="menu-item"]:focus-visible,
  #|  [data-slot="tool-call-row"]:focus-visible,
  #|  [data-slot="checkbox-menu-item"]:focus-visible {
  #|    outline:1px solid var(--sumi-text,#ffffff) !important;
  #|    outline-offset:-1px !important;
  #|  }
  #|}
  #|@starting-style {
  #|  [data-slot="menu"]:not([hidden]),
  #|  [data-slot="popover-panel"]:not([hidden]) {
  #|    opacity:0;
  #|    transform:scale(0.5);
  #|  }
  #|  [data-slot="toast"]:not([hidden]) {
  #|    opacity:0;
  #|  }
  #|}
  #|@media (prefers-reduced-motion: reduce) {
  #|  [data-slot="menu"],
  #|  [data-slot="toast"],
  #|  [data-slot="tooltip-content"],
  #|  [data-slot="menu-chevron"],
  #|  [data-slot="button"],
  #|  [data-slot="icon-button"],
  #|  [data-slot="segmented-item"],
  #|  [data-slot="chip"],
  #|  [data-slot="media-tag"],
  #|  [data-slot="add-tile"],
  #|  [data-slot="attachment-remove"],
  #|  [data-slot="chat-bubble-toggle"],
  #|  [data-slot="chat-bubble-copy"],
  #|  [data-slot="menu-item"],
  #|  [data-slot="checkbox-menu-item"],
  #|  [data-slot="checkbox-menu-check"],
  #|  [data-slot="switch"],
  #|  [data-slot="dialog"][open],
  #|  [data-slot="dialog"][open]::backdrop,
  #|  [data-slot="spinner"],
  #|  [data-slot="shimmer-text"],
  #|  [data-slot="skeleton"] {
  #|    transition:none !important;
  #|    animation:none !important;
  #|  }
  #|}

///|
#warnings("-alert_xss_vulnerable")
pub fn sumi_interaction_stylesheet() -> @html.Html {
  // `SumiInteractionCss` is a closed library constant. `inner_html` is used
  // here so SSR does not escape CSS selectors; no caller input reaches it.
  // (`<style>` content applied through innerHTML takes effect normally —
  // only `<script>` has the never-executes rule, see event_guard_js.mbt.)
  let attrs = @html.Attrs::build()
    .data_set("sumi-style", "interactions")
    .inner_html(SumiInteractionCss)
  @html.style_tag(attrs~, ([] : Array[@html.Html]))
}
