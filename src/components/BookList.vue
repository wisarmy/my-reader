<script setup lang="ts">
import { ref, onMounted } from "vue";
import { readDir, BaseDirectory, readTextFile, readBinaryFile } from "@tauri-apps/api/fs";
import { invoke } from "@tauri-apps/api";
import ePub from "epubjs";
import { WebviewWindow } from "@tauri-apps/api/window";

const books = ref<any[]>([]);

onMounted(async () => {
  books.value = await readDir("books", { dir: BaseDirectory.AppData });
  console.log(books);

  // 将图片文件转换为 Base64 编码
  for (const book of books.value) {
    if (book.name.endsWith(".epub")) {
      console.log(book.name);
      var readContent = await readBinaryFile("books/" + book.name, {
        dir: BaseDirectory.AppData,
      });
      var arrayBuffer = new Uint8Array(readContent).buffer;
      var ebook = await ePub(arrayBuffer);
      book.src = await ebook.coverUrl();
    } else {
      book.src = await invoke("read_file", { file: book.path });
    }
  }
});
// preview book
function preview(path: string) {
  console.log(path);
  const webview = new WebviewWindow("theUniqueLabel", {
    url: "/reader?path=" + path,
  });
}
</script>
<template>
  <div class="flex-1 flex flex-col bg-gray-100 h-screen overflow-y-auto scrollbar-hidden">
    <div class="flex-1 px-4 py-4 mb-10">
      <div
        class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 2xl:grid-cols-6 gap-4"
      >
        <template v-for="book in books">
          <div v-if="book.src" :key="book.path" @click="preview('books/' + book.name)">
            <img :src="book.src" class="rounded-lg" />
            <div class="text-gray-700 mt-2 text-center">{{ book.name }}</div>
          </div>
        </template>
      </div>
    </div>
  </div>
</template>
