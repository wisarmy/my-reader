import { createApp } from "vue";
import "./styles.css";
import App from "./App.vue";
import router from "./router/router";
import { setupI18n } from './i18n'
import en from './locales/en.json'
import zh from './locales/zh.json'
import { createPinia } from 'pinia'


const i18n = setupI18n({
    legacy: false,
    locale: 'en',
    fallbackLocale: 'en',
    messages: {
        en, zh
    }
})
const pinia = createPinia()

const app = createApp(App)
app.use(i18n);
app.use(pinia)
app.use(router);
app.mount("#app");
