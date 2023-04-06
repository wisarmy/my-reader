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
      <div class="relative w-24">
        <Listbox v-model="selectedPerson">
          <div class="relative mt-1">
            <ListboxButton
              class="relative w-full h-5 cursor-defaule rounded-md bg-gray-100 pl-3 pr-10 text-left text-gray-500 shadow-md focus:outline-none focus-visible:border-indigo-500 focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75 focus-visible:ring-offset-2 focus-visible:ring-offset-orange-300 sm:text-sm"
            >
              <span class="block truncate">{{ selectedPerson.name }}</span>
              <span
                class="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-2"
              >
                <ChevronUpDownIcon class="h-5 w-5 text-gray-400" aria-hidden="true" />
              </span>
            </ListboxButton>

            <transition
              leave-active-class="transition duration-100 ease-in"
              leave-from-class="opacity-100"
              leave-to-class="opacity-0"
            >
              <ListboxOptions
                class="absolute mt-1 max-h-60 min-w-60 w-full overflow-auto rounded-md bg-white py-1 text-base shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none sm:text-sm"
              >
                <ListboxOption
                  v-slot="{ active, selected }"
                  v-for="person in people"
                  :key="person.name"
                  :value="person"
                  as="template"
                >
                  <li
                    :class="[
                      active ? 'bg-amber-100 text-amber-900' : 'text-gray-900',
                      'relative cursor-default select-none py-2 pl-10 pr-4',
                    ]"
                  >
                    <span
                      :class="[
                        selected ? 'font-medium' : 'font-normal',
                        'block truncate',
                      ]"
                      >{{ person.name }}</span
                    >
                    <span
                      v-if="selected"
                      class="absolute inset-y-0 left-0 flex items-center pl-3 text-amber-600"
                    >
                      <CheckIcon class="h-5 w-5" aria-hidden="true" />
                    </span>
                  </li>
                </ListboxOption>
              </ListboxOptions>
            </transition>
          </div>
        </Listbox>
      </div>
      <!-- 上传 -->
      <div class="relative bg-gray-100 text-black">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
          stroke-width="1.5"
          stroke="currentColor"
          class="w-6 h-6 transition duration-300 ease-in-out hover:text-blue-500 hover:stroke-blue-500"
          @click="handleFileSelect"
        >
          <path stroke-linecap="round" stroke-linejoin="round" d="M12 6v12m6-6H6" />
        </svg>
      </div>
    </div>
    <!-- 头部右边的搜索框 -->
    <div class="relative items-center my-1">
      <input
        id="search"
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

<script setup lang="ts">
import { ref, onMounted } from "vue";
import {
  Listbox,
  ListboxLabel,
  ListboxButton,
  ListboxOptions,
  ListboxOption,
} from "@headlessui/vue";
import { CheckIcon, ChevronUpDownIcon } from "@heroicons/vue/20/solid";
import { writeBinaryFile, BaseDirectory } from "@tauri-apps/api/fs";
import ePub from "epubjs";
import { message } from "@tauri-apps/api/dialog";
import { CONSTANTS } from "../common/constants";
import { useI18n } from "vue-i18n";
import { appWindow } from "@tauri-apps/api/window";
import { Filter, useBookStore } from "../stores/book";
const store = useBookStore();

const { t, locale } = useI18n();
const people = [{ name: "最近" }, { name: "标题" }, { name: "作者" }];
const selectedPerson = ref(people[0]);

locale.value = "zh";
appWindow.setTitle(t("appname"));

onMounted(() => {
  // search event
  const searchInput = document.querySelector("#search") as HTMLInputElement;
  searchInput.addEventListener("focus", () => {
    searchInput.classList.add("w-96");
  });
  searchInput.addEventListener("blur", () => {
    searchInput.classList.remove("w-96");
  });
  // shortcut key
  document.addEventListener("keydown", (event: KeyboardEvent) => {
    console.log(event.key);
    if (event.metaKey && event.key === "k") {
      event.preventDefault();
      searchInput.focus();
    }
    if (event.key === "Escape") {
      searchInput.blur();
    }
  });
  // load books when the input method is completed
  let inputting = false;
  searchInput.addEventListener("compositionstart", () => {
    inputting = true;
  });
  searchInput.addEventListener("compositionend", () => {
    inputting = false;
    const filter: Filter = { limit: [0, 10], kw: searchInput.value };
    store.loadBookList(filter);
  });
  // load books when search input value changed
  searchInput.addEventListener("input", async () => {
    if (!inputting) {
      const filter: Filter = { limit: [0, 10], kw: searchInput.value };
      store.loadBookList(filter);
    }
  });
});
async function handleFileSelect(): Promise<void> {
  const fileInput = document.createElement("input");
  fileInput.type = "file";
  // accept invalid
  // fileInput.accept = "application/epub+zip";
  fileInput.addEventListener("change", async () => {
    const files = fileInput.files;
    if (files && files.length > 0) {
      const file = files[0];
      console.log(file.type);
      if (!CONSTANTS.SupportFileAccepts.includes(file.type)) {
        await message("不支持的文件格式", { title: "文件导入", type: "error" });
        return;
      }
      const reader = new FileReader();
      reader.onload = (event) => {
        handleFileUpload(event, file);
      };
      reader.readAsArrayBuffer(file);
    }
  });
  fileInput.click();
}

async function handleFileUpload(event: any, file: File) {
  let filePath = "books/" + file.name;
  const fileContent = event.target?.result;
  let arrayBuffer = new Uint8Array(fileContent).buffer;
  let ebook = await ePub(arrayBuffer);
  let metadata = await ebook.loaded.metadata;
  let cover = await ebook.archive.createUrl(await ebook.loaded.cover, {
    base64: true,
  });
  // console.log("ebook metadata", metadata);
  try {
    await writeBinaryFile(filePath, arrayBuffer, {
      dir: BaseDirectory.AppData,
    });
    await store.addBook({
      title: metadata.title,
      path: filePath,
      cover: cover,
      author: metadata.creator,
    });
  } catch (error: any) {
    console.log("import error: ", error);
    await message(error, { title: "文件导入", type: "error" });
  }
}
</script>
