<template>
  <div>
    <NavbarAdmin />
    <h1 class="text-4xl font-extrabold text-center text-white mb-8">Welcome to Admin Home</h1>

    <div class="user-home container mx-auto p-6">
      

      <!-- Features Section - Collage Style -->
      <div class="collage-container grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
        <!-- Feed -->
        <div class="card collage-item">
          <img src="@/assets/feed.png" alt="Feed" class="card-img-top" />
          <div class="card-body bg-gradient-to-r from-teal-500 to-green-400 text-white p-4 rounded-lg">
            <h5 class="card-title">Community Feed</h5>
            <p class="card-text">Share your thoughts, interact with other users, and engage with the community.</p>
            <router-link to="/admin/users" class="btn btn-outline-light">Users</router-link>
          </div>
        </div>

        <!-- Chat Support -->
        <div class="card collage-item">
          <img src="@/assets/chatSupport.jpg" alt="Chat Support" class="card-img-top" />
          <div class="card-body bg-gradient-to-r from-indigo-500 to-blue-400 text-white p-4 rounded-lg">
            <h5 class="card-title">Chat Support</h5>
            <p class="card-text">Message the admin or volunteers directly for support and guidance.</p>
            <router-link to="/admin/adminFeed" class="btn btn-outline-light">Feed</router-link>
          </div>
        </div>

        <!-- Heart-to-Heart Room -->
        <div class="card collage-item">
          <img src="@/assets/heart2heart.jpg" alt="Heart-to-Heart Room" class="card-img-top" />
          <div class="card-body bg-gradient-to-r from-purple-500 to-pink-400 text-white p-4 rounded-lg">
            <h5 class="card-title">Heart-to-Heart Room</h5>
            <p class="card-text">Schedule a one-on-one video conference for a heartfelt conversation.</p>
            <router-link to="/admin/heartToHeartRoom" class="btn btn-outline-light">Heart-To-Heart Room</router-link>
          </div>
        </div>

        <!-- Daily Exercises -->
        <div class="card collage-item">
          <img src="@/assets/exercise.png" alt="Daily Exercises" class="card-img-top" />
          <div class="card-body bg-gradient-to-r from-yellow-500 to-orange-400 text-white p-4 rounded-lg">
            <h5 class="card-title">Daily Exercises</h5>
            <p class="card-text">Relax and meditate with daily mindfulness exercises designed for you.</p>
            <router-link to="/admin/moodReport" class="btn btn-outline-light">Student's Mood</router-link>
          </div>
        </div>

        <!-- Help Center -->
        <div class="card collage-item">
          <img src="@/assets/faqs.jpg" alt="Help Center" class="card-img-top" />
          <div class="card-body bg-gradient-to-r from-green-500 to-teal-400 text-white p-4 rounded-lg">
            <h5 class="card-title">Help Center</h5>
            <p class="card-text">Learn about MindConnect and how to make the most out of the app.</p>
            <router-link to="/admin/adminDashboard" class="btn btn-outline-light">Feedbacks</router-link>
          </div>
        </div>
      </div>
    </div>
    
  </div>
  <Footer />
</template>

<script setup>
  import NavbarAdmin from '@/components/NavbarAdmin.vue';
  import { ref } from 'vue';

  const username = ref('Admin'); // You can fetch this from the user's data
  const isLoggedIn = ref(true); // Dynamically set this based on user authentication
</script>

<style scoped>
  /* Ensure grid responsiveness for various screen sizes */
  .collage-container {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 16px;
  }

  .card {
    border-radius: 8px;
    overflow: hidden;
  }

  .card-img-top {
    width: 100%;
    height: 180px;
    object-fit: cover;
  }

  .card-body {
    transition: transform 0.2s ease-in-out;
  }

  .card-body:hover {
    transform: translateY(-10px);
  }
</style>
