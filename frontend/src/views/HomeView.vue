<template>
  <div>
    <Navbar :isLoggedIn="isLoggedIn" :username="username" :profilePicture="userInfo.profile_picture" />
    <div class="home-container">
      <h1 class="welcome-title">Welcome to Homepage</h1>
      <div v-if="isLoggedIn" class="user-info">
        <p class="greeting">Welcome back, {{ username }}!</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import axios from 'axios';
import Navbar from '../components/Navbar.vue';

const isLoggedIn = ref(false);
const username = ref('');
const userInfo = ref({});

// Fetch user login state, username, and profile picture
onMounted(async () => {
  isLoggedIn.value = localStorage.getItem('isLoggedIn') === 'true';
  username.value = localStorage.getItem('username') || '';

  if (isLoggedIn.value) {
    try {
      const token = localStorage.getItem('token');
      const response = await axios.get('http://localhost:5000/user', {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });
      userInfo.value = response.data;
    } catch (error) {
      console.error('Failed to fetch user details:', error);
    }
  }
});
</script>

<style scoped>
/* CSS Reset for body */
body {
  margin: 0;
  padding: 0;
  overflow-x: hidden;
}

/* Home container styles */
.home-container {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  height: calc(100vh - 80px);
  background: linear-gradient(to bottom right, #1a1a2e, #16213e);
  color: #ffffff;
  text-align: center;
  font-family: 'Arial', sans-serif;
  width: 100%;
}

.welcome-title {
  font-size: 2.5rem;
  margin-bottom: 20px;
  color: #ffffff;
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
}

.user-info {
  background: rgba(255, 255, 255, 0.1);
  padding: 20px;
  border-radius: 10px;
  backdrop-filter: blur(5px);
  margin-top: 20px;
}

.greeting {
  font-size: 1.2rem;
  margin: 0;
  color: #ffffff;
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .welcome-title {
    font-size: 2rem;
  }

  .greeting {
    font-size: 1rem;
  }
}
</style>