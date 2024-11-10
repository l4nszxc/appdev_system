
<template>
  <div id="app">
    <router-view></router-view>
  </div>
</template>

<script>
import { ref } from 'vue';
import Navbar from './components/Navbar.vue'

export default {
  name: 'App',
  components: {
    Navbar
  },
  setup() {
    const isLoggedIn = ref(false); // Set this based on your authentication logic
    const username = ref('');

    // Logic to check login status and set username...

    return {
      isLoggedIn,
      username
    };
  }
}
</script>

<style>
#app {
  font-family: Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
</style>