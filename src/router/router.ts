import { createRouter, createWebHistory } from "vue-router";

import Main from "../views/Main.vue";
import Config from "../views/Config.vue";
import Reader from "../views/Reader.vue";

const routes = [
    { path: "/", component: Main },
    { path: "/config", component: Config },
    { path: "/reader", component: Reader, props: (route: any) => ({ query: route.query.path }) },
];

const router = createRouter({
    history: createWebHistory(),
    routes,
});

export default router;
