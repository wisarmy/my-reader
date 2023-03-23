<template>
  <div class="flex flex-col overflow-hidden">
    <slot name="header"></slot>
    <main class="flex-1 flex">
      <slot name="nav"></slot>
      <slot name="booklist"></slot>
    </main>
    <footer>
      <slot name="footer"></slot>
    </footer>
  </div>
</template>
<script setup></script>
