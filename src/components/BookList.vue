<script setup lang="ts">
import { ref, onMounted } from "vue";
import { readDir, BaseDirectory } from "@tauri-apps/api/fs";
import { invoke } from "@tauri-apps/api";
const books = ref<any[]>([]);
onMounted(async () => {
  books.value = await readDir("books", { dir: BaseDirectory.AppData });
  console.log(books);
  // 将图片文件转换为 Base64 编码
  for (const book of books.value) {
    book.base64 = await invoke("read_file", { file: book.path });
  }
});
</script>
<template>
  <div class="flex-1 flex flex-col bg-gray-100 h-screen overflow-y-auto scrollbar-hidden">
    <div class="flex-1 px-4 py-4 mb-10">
      <div
        class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 2xl:grid-cols-6 gap-4"
      >
        <template v-for="book in books">
          <div v-if="book.base64" :key="book.path">
            <img :src="book.base64" class="rounded-lg" />
            <div class="text-gray-700 mt-2 text-center">{{ book.name }}</div>
          </div>
        </template>
      </div>
    </div>
  </div>
</template>
