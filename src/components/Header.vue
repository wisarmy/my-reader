<script setup type="ts"></script>
<template>
  <!-- 头部 -->
  <header
    class="bg-gray-100 text-white flex items-center justify-between px-0 py-2 h-10 top-0 left-0 w-full border-b border-b-gray-300"
  >
    <!-- 头部左边的下拉框选项 -->
    <div class="flex items-center space-x-4">
      <div class="relative bg-gray-100 text-gray-400 hover:bg-gray-200 ml-2">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
          stroke-width="1.5"
          stroke="currentColor"
          class="w-5 h-5"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="M3.75 6A2.25 2.25 0 016 3.75h2.25A2.25 2.25 0 0110.5 6v2.25a2.25 2.25 0 01-2.25 2.25H6a2.25 2.25 0 01-2.25-2.25V6zM3.75 15.75A2.25 2.25 0 016 13.5h2.25a2.25 2.25 0 012.25 2.25V18a2.25 2.25 0 01-2.25 2.25H6A2.25 2.25 0 013.75 18v-2.25zM13.5 6a2.25 2.25 0 012.25-2.25H18A2.25 2.25 0 0120.25 6v2.25A2.25 2.25 0 0118 10.5h-2.25a2.25 2.25 0 01-2.25-2.25V6zM13.5 15.75a2.25 2.25 0 012.25-2.25H18a2.25 2.25 0 012.25 2.25V18A2.25 2.25 0 0118 20.25h-2.25A2.25 2.25 0 0113.5 18v-2.25z"
          />
        </svg>
      </div>
      <div class="relative bg-gray-100 text-gray-400 hover:bg-gray-200 px-0 mx-0">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
          stroke-width="1.5"
          stroke="currentColor"
          class="w-6 h-6"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="M8.25 6.75h12M8.25 12h12m-12 5.25h12M3.75 6.75h.007v.008H3.75V6.75zm.375 0a.375.375 0 11-.75 0 .375.375 0 01.75 0zM3.75 12h.007v.008H3.75V12zm.375 0a.375.375 0 11-.75 0 .375.375 0 01.75 0zm-.375 5.25h.007v.008H3.75v-.008zm.375 0a.375.375 0 11-.75 0 .375.375 0 01.75 0z"
          />
        </svg>
      </div>
      <div class="relative">
        <select
          class="block appearance-none w-full bg-gray-100 border border-gray-200 text-xs text-black py-1 px-3 pr-8 rounded leading-tight focus:outline-none focus:bg-gray-100 focus:border-gray-100"
        >
          <option>选项1</option>
          <option>选项2</option>
          <option>选项3</option>
        </select>
        <div
          class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-1 ml-1 text-gray-400"
        >
          <svg
            class="fill-current h-4 w-4"
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 20 20"
          >
            <path d="M10 12l-6-6h12z" />
          </svg>
        </div>
      </div>
      <div class="relative bg-gray-100 text-black">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
          stroke-width="1.5"
          stroke="currentColor"
          class="w-6 h-6 transition duration-300 ease-in-out hover:text-blue-500 hover:stroke-blue-500"
        >
          <path stroke-linecap="round" stroke-linejoin="round" d="M12 6v12m6-6H6" />
        </svg>
      </div>
    </div>
    <!-- 头部右边的搜索框 -->
    <div class="relative items-center my-1">
      <input
        type="text"
        class="px-8 py-0.5 mr-0.5 bg-gray-100 border border-gray-200 rounded-md text-black focus:outline-none focus:border-gray-500 sm:text-sm"
        placeholder="搜索（⌘ K）"
      />
      <div
        class="pointer-events-none absolute inset-y-0 left-0 flex items-center px-1 ml-1 text-gray-700"
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
          stroke-width="1.5"
          stroke="currentColor"
          class="w-4 h-4"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="M21 21l-5.197-5.197m0 0A7.5 7.5 0 105.196 5.196a7.5 7.5 0 0010.607 10.607z"
          />
        </svg>
      </div>
    </div>
  </header>
</template>
