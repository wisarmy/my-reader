<template>
  <div id="reader" class="flex h-screen">
    <ReaderNav />
    <ReaderMenu
      :top="readerMenu.top"
      :left="readerMenu.left"
      :visibility="readerMenu.visibility"
    />
    <div class="w-full max-w-screen-2xl mx-auto items-center" v-on:click="page_turn">
      <div
        id="viewer"
        class="pl-10 pr-10 pt-10 bg-white shadow-lg h-screen"
        style="flex: 8"
      ></div>
    </div>
    <ReaderAnnotation />
  </div>
</template>
<script setup lang="ts">
import { ref, onMounted } from "vue";
import { BaseDirectory, readBinaryFile } from "@tauri-apps/api/fs";
import ePub, { Contents, EpubCFI } from "epubjs";
import { Rendition } from "epubjs";
import ReaderNav from "@/components/ReaderNav.vue";
import ReaderAnnotation from "@/components/ReaderAnnotation.vue";
import ReaderMenu from "@/components/ReaderMenu.vue";

const { query } = defineProps(["query"]);
console.log("query: ", query);

const rendition = ref<Rendition>();
const readerMenu = ref({ left: "0px", top: "0px", visibility: "hidden" });

onMounted(async () => {
  var readContent = await readBinaryFile(query.path, {
    dir: BaseDirectory.AppData,
  });
  var arrayBuffer = new Uint8Array(readContent).buffer;
  var ebook = ePub(arrayBuffer, {});
  rendition.value = ebook.renderTo("viewer", {
    flow: "scrolled-continuous",
    width: "100%",
    height: "100%",
    allowScriptedContent: true,
  });

  var displayed = rendition.value.display();
  // Navigation loaded
  ebook.loaded.navigation.then(function (toc) {
    console.log("toc: ", toc);
  });

  rendition.value.on("relocated", function (location: any) {
    console.log("location: ", location);
  });

  rendition.value.hooks.content.register(function (contents: Contents, view: Rendition) {
    const paragraphs = contents.content.querySelectorAll("p");
    paragraphs.forEach((p) => {
      p.innerHTML = p.innerHTML.replace(/时间/g, "<span style='color: red'>时间</span>");
    });
  });

  var selected = false;
  var selectContents = "";
  // mouse up
  rendition.value.on("mouseup", function (e: any) {
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

  rendition.value.on("selected", function (cfiRange: any, contents: any) {
    selected = true;
    rendition.value?.annotations.highlight(
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

  rendition.value.on("selected", function (cfiRange: any, contents: any) {
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
          rendition.value?.display(cfiRange);
        };
        remove.textContent = "remove";
        remove.href = "#" + cfiRange;
        remove.onclick = function () {
          rendition.value?.annotations.remove(cfiRange, "highlight");
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
  rendition.value?.prev();
}
function next() {
  rendition.value?.next();
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
    (rendition.value?.getContents() as any)[0]?.documentElement.scrollIntoView();
  } else {
    console.log("pageWidth or pageHeight is not a number");
  }
}
</script>
