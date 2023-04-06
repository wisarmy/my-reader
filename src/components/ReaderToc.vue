<template>
  <div
    class="absolute top-0 left-16 right-0 z-10 px-2 pt-4 w-72 h-screen bg-gray-100 border-r border-gray-400"
    :class="store.theme.reader.tocHiddenClass"
  >
    <h2 class="text-lg font-bold mb-4">目录</h2>
    <ul class="list-none pl-4">
      <li v-for="(item, index) in nav?.toc" :key="index">
        <a
          href="#"
          class="text-blue-500 hover:text-blue-700 border-b border-gray-300"
          @click="goto(item.href)"
        >
          {{ item.label }}
        </a>
      </li>
    </ul>
  </div>
</template>
<script setup lang="ts">
import { defineProps, toRefs } from "vue";
import { useBookStore } from "../stores/book";
import { Rendition } from "epubjs";

const store = useBookStore();
const props = defineProps({ rendition: Rendition, nav: Object });
const { rendition, nav } = toRefs(props);

function goto(href: string) {
  rendition?.value?.display(href);
  store.theme.reader.tocHiddenClass = "hidden";
}
</script>
