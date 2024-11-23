<template>
    <div>
      <Navbar :isLoggedIn="isLoggedIn" :username="username" :profilePicture="userInfo.profile_picture" />
      <div class="mood-dashboard">
        <h1>Mood Dashboard</h1>
        <div>
          <h2>Weekly Mood Summary</h2>
          <ul>
            <li v-for="mood in weeklyMoods" :key="mood.created_at">
              {{ mood.created_at }} - {{ mood.mood }} ({{ mood.sentiment }})
            </li>
          </ul>
        </div>
        <div>
          <h2>Monthly Mood Summary</h2>
          <ul>
            <li v-for="mood in monthlyMoods" :key="mood.created_at">
              {{ mood.created_at }} - {{ mood.mood }} ({{ mood.sentiment }})
            </li>
          </ul>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  import { ref, onMounted } from 'vue';
  import axios from 'axios';
  import Navbar from '@/components/Navbar.vue';
  
  export default {
    name: 'MoodDashboard',
    components: { Navbar },
    setup() {
      const isLoggedIn = ref(false);
      const username = ref('');
      const userInfo = ref({});
      const weeklyMoods = ref([]);
      const monthlyMoods = ref([]);
  
      const fetchMoods = async () => {
        try {
          const token = localStorage.getItem('token');
          const weeklyResponse = await axios.get('http://localhost:5000/mood/weekly', {
            headers: { Authorization: `Bearer ${token}` }
          });
          weeklyMoods.value = weeklyResponse.data;
  
          const monthlyResponse = await axios.get('http://localhost:5000/mood/monthly', {
            headers: { Authorization: `Bearer ${token}` }
          });
          monthlyMoods.value = monthlyResponse.data;
        } catch (error) {
          console.error('Error fetching moods:', error);
        }
      };
  
      onMounted(fetchMoods);
  
      return { isLoggedIn, username, userInfo, weeklyMoods, monthlyMoods };
    }
  };
  </script>
  
  <style scoped>
  .mood-dashboard {
    padding: 20px;
  }
  ul {
    list-style-type: none;
    padding: 0;
  }
  li {
    padding: 10px;
    border-bottom: 1px solid #ccc;
  }
  </style>