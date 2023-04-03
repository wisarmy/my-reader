import { ref } from 'vue'
import { defineStore } from 'pinia'
import { invoke } from '@tauri-apps/api';

export interface Filter {
    limit?: [number, number];
    kw: string;
}
export interface AddBookParams {
    title: string;
    path: string;
    cover: string;
    author: string;
}
export const useBookStore = defineStore('book', () => {
    const booklist = ref<any[]>([]);
    async function loadBookList(filter: Filter) {
        booklist.value = await invoke("list_books", { filter: filter });
    }

    async function addBook(params: AddBookParams) {
        let book = await invoke("add_book", {
            book: params,
        });
        booklist.value.unshift(book);
    }

    return { booklist, loadBookList, addBook }
})