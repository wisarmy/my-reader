<template>
  <div id="reader" class="flex h-screen">
    <ReaderNav />
    <ReaderToc :rendition="readerRendition" :nav="readerNav" />
    <ReaderMenu
      :top="readerMenu.top"
      :left="readerMenu.left"
      :visibility="readerMenu.visibility"
    />
    <div
      class="w-full max-w-screen-2xl mx-auto items-center h-screen"
      v-on:click="page_turn"
    >
      <div id="viewer" class="p-10 bg-white shadow-lg h-screen"></div>
    </div>
    <ReaderAnnotation />
  </div>
</template>
<script setup lang="ts">
import { ref, onMounted } from "vue";
import { BaseDirectory, readBinaryFile } from "@tauri-apps/api/fs";
import ePub, { Contents } from "epubjs";
import { Rendition } from "epubjs";
import ReaderNav from "@/components/ReaderNav.vue";
import ReaderAnnotation from "@/components/ReaderAnnotation.vue";
import ReaderMenu from "@/components/ReaderMenu.vue";
import ReaderToc from "@/components/ReaderToc.vue";
import { useBookStore } from "../stores/book";
import Navigation from "epubjs/types/navigation";

const { query } = defineProps(["query"]);
console.log("query: ", query);
const store = useBookStore();

const readerMenu = ref({ left: "0px", top: "0px", visibility: "hidden" });
const readerRendition = ref<Rendition>();
const readerNav = ref<Navigation>();

onMounted(async () => {
  var readContent = await readBinaryFile(query.path, {
    dir: BaseDirectory.AppData,
  });
  var arrayBuffer = new Uint8Array(readContent).buffer;
  var ebook = ePub(arrayBuffer, {});
  const identifier = (await ebook.loaded.metadata).identifier;
  store.ebook.set(identifier, ebook);
  var rendition = ebook.renderTo("viewer", {
    flow: "scrolled-continuous",
    width: "100%",
    height: "100%",
    allowScriptedContent: true,
  });
  readerRendition.value = rendition;

  rendition.display();
  // Navigation loaded
  ebook.loaded.navigation.then(function (nav: Navigation) {
    readerNav.value = nav;
    // console.log("nav: ", nav);
  });

  rendition.on("relocated", function (location: any) {
    console.log("location: ", location);
  });

  rendition.hooks.content.register(function (contents: Contents, view: Rendition) {
    const paragraphs = contents.content.querySelectorAll("p");
    paragraphs.forEach((p) => {
      p.innerHTML = p.innerHTML.replace(/时间/g, "<span style='color: red'>时间</span>");
    });
  });

  var selected = false;
  var selectContents = "";
  // mouse up
  rendition.on("mouseup", function (e: any) {
    if (!selected && selectContents) {
      console.log("mouseup", e, selectContents);
      readerMenu.value = {
        left: e.screenX + "px",
        top: e.screenY + "px",
        visibility: "visible",
      };
      selectContents = "";
    }
  });

  rendition.on("selected", function (cfiRange: any, contents: any) {
    selected = true;
    rendition?.annotations.highlight(
      cfiRange,
      {},
      (e: any) => {
        console.log("highlight clicked", e.target);
      },
      "",
      { fill: "red" }
    );
    contents.window.getSelection().removeAllRanges();
    selectContents = contents.window.getSelection();
    selected = false;
  });
  var highlights = document.getElementById("highlights");

  rendition.on("selected", function (cfiRange: any, contents: any) {
    console.log("renderer:selected", cfiRange, contents.window.getSelection());

    ebook.getRange(cfiRange).then(function (range) {
      var text;
      var li = document.createElement("li");
      var a = document.createElement("a");
      var remove = document.createElement("a");
      var textNode;

      if (range) {
        text = range.toString();
        textNode = document.createTextNode(text);

        a.textContent = cfiRange;
        a.href = "#" + cfiRange;
        a.onclick = function () {
          rendition?.display(cfiRange);
        };
        remove.textContent = "remove";
        remove.href = "#" + cfiRange;
        remove.onclick = function () {
          rendition?.annotations.remove(cfiRange, "highlight");
          return false;
        };

        li.appendChild(a);
        li.appendChild(textNode);
        li.appendChild(remove);
        highlights?.appendChild(li);
      }
    });
  });
});
function prev() {
  readerRendition.value?.prev();
}
function next() {
  readerRendition.value?.next();
}

function page_turn(event: MouseEvent) {
  const pageWidth = event.view?.innerWidth;
  const pageHeight = event.view?.innerHeight;
  const clickX = event.offsetX;
  const clickY = event.offsetY;
  if (typeof pageWidth === "number" && typeof pageHeight === "number") {
    if (clickX <= pageWidth / 2 && clickY > pageHeight / 2) {
      prev();
    } else if (clickX > pageWidth / 2 && clickY > pageHeight / 2) {
      next();
    }
    (readerRendition.value?.getContents() as any)[0]?.documentElement.scrollIntoView();
  } else {
    console.log("pageWidth or pageHeight is not a number");
  }
}
</script>
