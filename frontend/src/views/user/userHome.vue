<template>
  <Navbar :isLoggedIn="isLoggedIn" :username="username" />
  <div class="user-home">
    <h1>USER HOMEPAGE</h1>
    <p v-if="isLoggedIn">Welcome back, {{ username }}!</p>
    <p v-else>Please log in to access your account.</p>
  </div>
</template>

<script setup>
import Navbar from '@/components/Navbar.vue';
import { ref, onMounted } from 'vue';

const isLoggedIn = ref(false);
const username = ref('');

// Check login status on component mount
onMounted(() => {
  isLoggedIn.value = localStorage.getItem('isLoggedIn') === 'true';
  username.value = localStorage.getItem('username') || '';
});
</script>

<style scoped>
.user-home {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: calc(100vh - 80px); /* Adjust for navbar height */
  background-color: #f0f0f0; /* Light background color */
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

h1 {
  font-size: 2rem;
  color: #333;
}

p {
  font-size: 1.2rem;
  color: #555;
}
</style>