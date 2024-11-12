<template>
  <div>
    <Navbar :isLoggedIn="isLoggedIn" :username="username" />
    <div class="home-container">
      <h1 class="welcome-title">Welcome to Homepage</h1>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import Navbar from '../components/Navbar.vue'; // Adjust the path as necessary

export default {
  name: 'HomeView',
  components: {
    Navbar
  },
  setup() {
    const isLoggedIn = ref(false);
    const username = ref('');

    // Fetch user login state and username from local storage
    onMounted(() => {
      isLoggedIn.value = localStorage.getItem('isLoggedIn') === 'true';
      username.value = localStorage.getItem('username') || '';
    });

    return {
      isLoggedIn,
      username
    };
  }
};
</script>

<style scoped>
/* CSS Reset for body */
body {
  margin: 0; /* Remove default margin */
  padding: 0; /* Remove default padding */
  overflow-x: hidden; /* Prevent horizontal scroll */
}

/* Home container styles */
.home-container {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  height: calc(100vh - 80px); /* Adjusted height for navbar */
  background: linear-gradient(to bottom right, #1a1a2e, #16213e); /* Dark background to match register style */
  color: #ffffff;
  text-align: center;
  font-family: 'Arial', sans-serif;
  width: 100%; /* Ensure full width */
}

.welcome-title {
  font-size: 2.5rem;
  margin-bottom: 20px;
  color: #ffffff; /* Matching primary color for consistency */
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .welcome-title {
    font-size: 2rem;
  }
}
</style>