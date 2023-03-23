<script setup lang="ts">
import Layout from "../components/Layout.vue";
import Header from "../components/Header.vue";
import BookList from "../components/BookList.vue";
</script>

<template>
  <Layout>
    <template #header>
      <Header />
    </template>
    <template #booklist>
      <BookList />
    </template>
  </Layout>
</template>
