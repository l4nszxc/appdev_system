<template>
  <div>
    <NavbarAdmin />
  
    <div class="user-home container mx-auto p-6">
      <!-- Features Section - Cards in Single Column -->
      <div class="collage-container grid grid-cols-1 gap-8">
        <!-- User Management -->
        <router-link to="/admin/users" class="card collage-item">
          <div class="card-body bg-gradient-to-r from-teal-500 to-green-400 text-black p-6 rounded-xl hover:shadow-xl transition-shadow duration-300">
            <h5 class="card-title text-2xl font-semibold text-black">User Management</h5>
            <p class="card-text text-lg mt-2 text-black">Manage users, archive their accounts, and update their access levels within the system.</p>
          </div>
        </router-link>

        <!-- Admin Feed -->
        <router-link to="/admin/adminFeed" class="card collage-item">
          <div class="card-body bg-gradient-to-r from-indigo-500 to-blue-400 text-black p-6 rounded-xl hover:shadow-xl transition-shadow duration-300">
            <h5 class="card-title text-2xl font-semibold text-black">Admin Feed</h5>
            <p class="card-text text-lg mt-2 text-black">Monitor posts within the platform and take necessary actions for issues.</p>
          </div>
        </router-link>

        <!-- Heart-to-Heart Room Management -->
        <router-link to="/admin/heartToHeartRoom" class="card collage-item">
          <div class="card-body bg-gradient-to-r from-purple-500 to-pink-400 text-black p-6 rounded-xl hover:shadow-xl transition-shadow duration-300">
            <h5 class="card-title text-2xl font-semibold text-black">Heart-to-Heart Room</h5>
            <p class="card-text text-lg mt-2 text-black">Manage one-on-one video conferences and ensure users have a safe space for conversations.</p>
          </div>
        </router-link>

        <!-- Mood Reports -->
        <router-link to="/admin/moodReport" class="card collage-item">
          <div class="card-body bg-gradient-to-r from-yellow-500 to-orange-400 text-black p-6 rounded-xl hover:shadow-xl transition-shadow duration-300">
            <h5 class="card-title text-2xl font-semibold text-black">Mood Reports</h5>
            <p class="card-text text-lg mt-2 text-black">Access daily reports about users' emotional wellbeing and monitor any necessary interventions.</p>
          </div>
        </router-link>

        <!-- Feedback Center -->
        <router-link to="/admin/adminDashboard" class="card collage-item">
          <div class="card-body bg-gradient-to-r from-green-500 to-teal-400 text-black p-6 rounded-xl hover:shadow-xl transition-shadow duration-300">
            <h5 class="card-title text-2xl font-semibold text-black">Feedback Center</h5>
            <p class="card-text text-lg mt-2 text-black">Review user feedback, ensuring continuous improvement of the MindConnect platform.</p>
          </div>
        </router-link>
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
    grid-template-columns: 1fr; /* One card per row */
    gap: 32px; /* Larger gap between cards */
  }

  .card {
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    transition: transform 0.2s ease-in-out;
    text-decoration: none;
  }

  .card-body {
    padding: 1.5rem;
  }

  .card-body:hover {
    transform: translateY(-10px);
  }

  .card:hover {
    cursor: pointer;
  }

  /* Modern and clean heading style */
  h1 {
    text-align: center;
    font-family: 'Poopins', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    font-size: 2rem;
    font-weight: 700;
    letter-spacing: -0.5px;
    color: #000000;
  }
  
  /* Update card text color and font size */
  .card-title, .card-text {
    color: #000000; /* Black text color */
    font-size: 1.3rem; /* Larger font size */
  }
</style>
