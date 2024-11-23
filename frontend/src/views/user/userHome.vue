<template>
  <Navbar :isLoggedIn="isLoggedIn" :username="username" :profilePicture="userInfo.profile_picture" />
  <div class="user-home container mx-auto p-6">
    <h1 class="text-4xl font-extrabold text-center text-white mb-8">Welcome to MindConnect</h1>
    <p v-if="isLoggedIn" class="text-xl text-center text-gray-300 mb-6">Hello, {{ username }}! Let's make today meaningful.</p>
    <p v-else class="text-xl text-center text-gray-300 mb-6">Please log in to explore all the features of MindConnect.</p>

    <!-- Features Section - Collage Style -->
    <div class="collage-container">
      <!-- Feed -->
      <div class="card collage-item feed">
        <img src="@/assets/feed.png" alt="Feed" class="card-img-top" />
        <div class="card-body bg-gradient-to-r from-teal-500 to-green-400 text-white p-4 rounded-lg">
          <h5 class="card-title">Community Feed</h5>
          <p class="card-text">Share your thoughts, interact with other users, and engage with the community.</p>
          <router-link to="/feed" class="btn btn-outline-light">Go to Feed</router-link>
        </div>
      </div>

      <!-- Chat Support -->
      <div class="card collage-item chat-support">
        <img src="@/assets/chatSupport.jpg" alt="Chat Support" class="card-img-top" />
        <div class="card-body bg-gradient-to-r from-indigo-500 to-blue-400 text-white p-4 rounded-lg">
          <h5 class="card-title">Chat Support</h5>
          <p class="card-text">Message the admin or volunteers directly for support and guidance.</p>
          <router-link to="/user/userChat" class="btn btn-outline-light">Message Support</router-link>
        </div>
      </div>

      <!-- Heart-to-Heart Room -->
      <div class="card collage-item heart-to-heart">
        <img src="@/assets/heart2heart.jpg" alt="Heart-to-Heart Room" class="card-img-top" />
        <div class="card-body bg-gradient-to-r from-purple-500 to-pink-400 text-white p-4 rounded-lg">
          <h5 class="card-title">Heart-to-Heart Room</h5>
          <p class="card-text">Schedule a one-on-one video conference for a heartfelt conversation.</p>
          <router-link to="/user/userHeartToHeartRoom" class="btn btn-outline-light">Book a Session</router-link>
        </div>
      </div>

      <!-- Daily Exercises -->
      <div class="card collage-item daily-exercise">
        <img src="@/assets/exercise.png" alt="Daily Exercises" class="card-img-top" />
        <div class="card-body bg-gradient-to-r from-yellow-500 to-orange-400 text-white p-4 rounded-lg">
          <h5 class="card-title">Daily Exercises</h5>
          <p class="card-text">Relax and meditate with daily mindfulness exercises designed for you.</p>
          <router-link to="/daily-exercise" class="btn btn-outline-light">Start Exercise</router-link>
        </div>
      </div>

      <!-- Help Center -->
      <div class="card collage-item help-center">
        <img src="@/assets/faqs.jpg" alt="Help Center" class="card-img-top" />
        <div class="card-body bg-gradient-to-r from-green-500 to-teal-400 text-white p-4 rounded-lg">
          <h5 class="card-title">Help Center</h5>
          <p class="card-text">Learn about MindConnect and how to make the most out of the app.</p>
          <router-link to="/help-center" class="btn btn-outline-light">Visit Help Center</router-link>
        </div>
      </div>
    </div>
  </div>
  <Footer />
</template>

<script setup>
import Navbar from '@/components/Navbar.vue';
import Footer from "@/components/Footer.vue";
import { ref, onMounted } from 'vue';
import axios from 'axios';

const isLoggedIn = ref(false);
const username = ref('');
const userInfo = ref({});

// Check login status and fetch user details
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
.user-home {
  background-image: linear-gradient(to right, #528b64, #39b443); /* Gradient green colors */
  padding-top: 20px;
  border-radius: 8px;
}

.collage-container {
  display: flex;
  flex-wrap: wrap;
  gap: 30px;
  justify-content: center;
  padding: 50px 0;
}

.card-img-top {
  height: 200px;
  object-fit: cover;
  width: 100%; /* Ensures images fill the width uniformly */
}

.card-body {
  padding: 1.5rem;
  text-align: center;
}

h1 {
  text-align: center;
  font-size: 2.5rem;
  color: white;
}

p {
  font-size: 1.2rem;
  color: #d1d5db;
  text-align: center;
}

a {
  font-weight: 600;
}

.card {
  border: none;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  width: 280px;
  height: 400px; /* Set uniform height for all cards */
  z-index: 1;
}

.card:hover {
  transform: translateY(-8px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
}

.collage-item {
  position: relative;
  transition: all 0.3s ease;
  z-index: 1;
}

.collage-item.feed,
.collage-item.chat-support,
.collage-item.heart-to-heart,
.collage-item.daily-exercise,
.collage-item.help-center {
  width: 280px; /* Set uniform width for all items */
  height: 400px; /* Set uniform height for all items */
}

</style>
