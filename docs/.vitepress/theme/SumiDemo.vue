<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { withBase } from 'vitepress'

const props = defineProps<{ name: string }>()
const root = ref<HTMLElement>()

onMounted(() => {
  // The demo bundle self-hydrates every [data-sumi-demo] placeholder on the
  // page and keeps watching for new ones via MutationObserver, so SPA
  // navigation needs no further wiring. Load it exactly once.
  if (!document.querySelector('script[data-sumi-demos]')) {
    const s = document.createElement('script')
    s.type = 'module'
    s.setAttribute('data-sumi-demos', '')
    s.src = withBase('/demos/sumi-demos.js')
    document.head.appendChild(s)
  }
  // The stage is appended outside Vue's virtual DOM on purpose: the Sumi
  // runtime mounts into it and owns its subtree, so Vue must never
  // reconcile its children.
  const stage = document.createElement('div')
  stage.className = 'sumi-demo-stage'
  stage.setAttribute('data-sumi-demo', props.name)
  root.value!.insertBefore(stage, root.value!.firstChild)
})
</script>

<template>
  <div ref="root" class="sumi-demo">
    <div class="sumi-demo-code"><slot /></div>
  </div>
</template>
