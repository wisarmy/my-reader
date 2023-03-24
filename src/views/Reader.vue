<template>
  <div class="flex flex-col justify-center items-center h-screen">
    <div class="w-screen max-w-screen-lg mx-auto flex justify-center items-center h-full">
      <a
        href="#"
        @click="prev"
        class="w-1.5/12 text-gray-500 hover:text-gray-800 px-2 py-2 rounded-md border border-gray-300"
      >
        上一页
      </a>
      <div id="viewer" class="w-8/12 p-8 bg-white shadow-lg" style="flex: 8"></div>
      <a
        href="#"
        @click="next"
        class="w-1.5/12 text-gray-500 hover:text-gray-800 px-2 py-2 rounded-md border border-gray-300"
      >
        下一页
      </a>
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
</script>
