
import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'

<<<<<<< HEAD
const app = createApp(App)
app.use(router)
app.mount('#app')
=======
createApp(App).use(store).use(router).mount('#app')
>>>>>>> 0f2941a0bc1337b7083106f0e75ce9460af8ff9e
