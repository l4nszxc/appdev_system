<template>
  <Navbar :isLoggedIn="isLoggedIn" />
  <div>
    <h1>USER HOMEPAGE</h1>
  </div>
</template>

<script setup>
import Navbar from '@/components/Navbar.vue';
import { ref, onMounted } from 'vue';

const isLoggedIn = ref(false);

// Check login status on component mount
onMounted(() => {
  isLoggedIn.value = localStorage.getItem('isLoggedIn') === 'true';
});
</script>

<style scoped>
/* Add styles specific to this component here */
</style>
