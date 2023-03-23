<script setup lang="ts">
const images = [
  {
    id: "id",
    title: "text",
    src:
      "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/220px-Image_created_with_a_mobile_phone.png",
  },
  {
    id: "id",
    title: "text",
    src:
      "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/220px-Image_created_with_a_mobile_phone.png",
  },
  {
    id: "id",
    title: "text",
    src:
      "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/220px-Image_created_with_a_mobile_phone.png",
  },
  {
    id: "id",
    title: "text",
    src:
      "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/220px-Image_created_with_a_mobile_phone.png",
  },
  {
    id: "id",
    title: "text",
    src:
      "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/220px-Image_created_with_a_mobile_phone.png",
  },
  {
    id: "id",
    title: "text",
    src:
      "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/220px-Image_created_with_a_mobile_phone.png",
  },
  {
    id: "id",
    title: "text",
    src:
      "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/220px-Image_created_with_a_mobile_phone.png",
  },
  {
    id: "id",
    title: "text",
    src:
      "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/220px-Image_created_with_a_mobile_phone.png",
  },
  {
    id: "id",
    title: "text",
    src:
      "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/220px-Image_created_with_a_mobile_phone.png",
  },
  {
    id: "id",
    title: "text",
    src:
      "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/220px-Image_created_with_a_mobile_phone.png",
  },
];
</script>
<template>
  <div class="flex-1 flex flex-col bg-gray-100 h-screen overflow-y-auto scrollbar-hidden">
    <div class="flex-1 px-4 py-4 mb-10">
      <div
        class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 2xl:grid-cols-7 gap-4"
      >
        <div v-for="image in images" :key="image.id">
          <img :src="image.src" class="rounded-lg" />
          <div class="text-gray-700 mt-2 text-center">{{ image.title }}</div>
        </div>
      </div>
    </div>
  </div>
</template>
