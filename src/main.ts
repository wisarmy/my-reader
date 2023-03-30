import { createApp } from "vue";
import "./styles.css";
import App from "./App.vue";
import router from "./router/router";
import { setupI18n } from './i18n'
import en from './locales/en.json'
import zh from './locales/zh.json'

const i18n = setupI18n({
    legacy: false,
    locale: 'en',
    fallbackLocale: 'en',
    messages: {
        en, zh
    }
})

const app = createApp(App)
app.use(i18n);
app.use(router);
app.mount("#app");
