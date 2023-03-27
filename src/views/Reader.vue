<template>
  <div class="flex flex-col justify-center items-center h-screen" v-on:click="page_turn">
    <div class="w-screen max-w-screen-lg mx-auto flex justify-center items-center h-full">
      <div id="viewer" class="w-8/12 p-10 bg-white shadow-lg" style="flex: 8"></div>
    </div>
  </div>
</template>
<script setup lang="ts">
import { ref, onMounted } from "vue";
import { BaseDirectory, readBinaryFile } from "@tauri-apps/api/fs";
import ePub from "epubjs";
import { Rendition } from "epubjs";
const props = defineProps(["query"]);
console.log("path: ", props.query);
const rendition = ref<Rendition>();

onMounted(async () => {
  var readContent = await readBinaryFile(props.query, {
    dir: BaseDirectory.AppData,
  });
  var arrayBuffer = new Uint8Array(readContent).buffer;
  var ebook = ePub(arrayBuffer);
  rendition.value = ebook.renderTo("viewer", {
    width: "100%",
    height: 600,
  });

  var displayed = rendition.value.display();
});
function prev() {
  rendition.value?.prev();
}
function next() {
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
  } else {
    console.log("pageWidth is not a number");
  }
}
</script>
