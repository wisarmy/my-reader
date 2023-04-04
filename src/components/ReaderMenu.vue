<template>
  <div class="relative" :style="{ top: top, left: left, visibility: visibility }">
    <div class="absolute bg-gray-200 rounded mt-2 py-2 w-32 z-10">
      <a href="#" class="block px-4 py-2 text-gray-800 hover:bg-gray-200">菜单项1</a>
      <a href="#" class="block px-4 py-2 text-gray-800 hover:bg-gray-200">菜单项2</a>
      <a href="#" class="block px-4 py-2 text-gray-800 hover:bg-gray-200">菜单项3</a>
    </div>
  </div>
</template>
<script setup lang="ts">
import { defineProps, toRefs } from "vue";
const props = defineProps(["top", "left", "visibility"]);
const { top, left, visibility } = toRefs(props);
</script>
