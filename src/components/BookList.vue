<script setup lang="ts">
import { onMounted } from "vue";
import { WebviewWindow } from "@tauri-apps/api/window";
import { useBookStore, Filter } from "../stores/book";
const store = useBookStore();

onMounted(async () => {
  const filter: Filter = { limit: [0, 10] };
  store.loadBookList(filter);
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
        <template v-for="book in store.booklist">
          <div
            v-if="book.cover"
            :key="book.path"
            @click="preview(book.path)"
            class="text-center"
          >
            <img :src="book.cover" class="rounded-lg h-52 inline-block" />
            <div class="text-gray-700 mt-2 text-center truncate">{{ book.title }}</div>
          </div>
        </template>
      </div>
    </div>
  </div>
</template>
