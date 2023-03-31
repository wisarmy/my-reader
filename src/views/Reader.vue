<template>
  <div
    id="reader"
    class="items-center h-screen overflow-y-auto scrollbar-hidden"
    v-on:click="page_turn"
  >
    <div class="w-screen max-w-screen-lg mx-auto flex items-center">
      <div id="viewer" class="w-8/12 p-10 bg-white shadow-lg" style="flex: 8"></div>
    </div>
  </div>
</template>
<script setup lang="ts">
import { ref, onMounted } from "vue";
import { BaseDirectory, readBinaryFile } from "@tauri-apps/api/fs";
import ePub from "epubjs";
import { Rendition } from "epubjs";

const { query } = defineProps(["query"]);
console.log("query: ", query);

const rendition = ref<Rendition>();

onMounted(async () => {
  var readContent = await readBinaryFile(query.path, {
    dir: BaseDirectory.AppData,
  });
  var arrayBuffer = new Uint8Array(readContent).buffer;
  var ebook = ePub(arrayBuffer);
  rendition.value = ebook.renderTo("viewer", {
    width: "100%",
    height: 800,
  });

  var displayed = rendition.value.display();
});
function prev() {
  rendition.value?.prev();
}
function next() {
  window.scrollTo(0, 0);
  rendition.value?.next();
}

function page_turn(event: MouseEvent) {
  const pageWidth = event.view?.innerWidth;
  const pageHeight = event.view?.innerHeight;
  const clickX = event.offsetX;
  const clickY = event.offsetY;
  if (typeof pageWidth === "number" && typeof pageHeight === "number") {
    if (clickX <= pageWidth / 2 && clickY > pageHeight / 2) {
      prev();
    } else if (clickX > pageWidth / 2 && clickY > pageHeight / 2) {
      next();
    }
    (rendition.value?.getContents() as any)[0]?.documentElement.scrollIntoView();
  } else {
    console.log("pageWidth or pageHeight is not a number");
  }
}
</script>
