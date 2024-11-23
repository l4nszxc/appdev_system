<template>
    <div>
      <Navbar :isLoggedIn="isLoggedIn" :username="username" :profilePicture="userInfo.profile_picture" />
      <div class="mood-tracker">
        <h1>Mood Tracker</h1>
        <p>Track your mood here.</p>
        <div v-if="hasSubmittedToday">
          <p>You have already submitted your mood for today. Please come back tomorrow.</p>
        </div>
        <div v-else>
          <div class="emoji-selector">
            <span @click="selectMood('Positive')">😊</span>
            <span @click="selectMood('Neutral')">😐</span>
            <span @click="selectMood('Negative')">😢</span>
          </div>
          <form @submit.prevent="submitMood">
            <textarea v-model="comment" placeholder="Add a comment (optional)"></textarea>
            <button type="submit">Submit Mood</button>
          </form>
        </div>
        <div v-if="message">{{ message }}</div>
      </div>
      <div class="mood-dashboard">
        <h1>Mood Dashboard</h1>
        <div>
          <h2>Weekly Mood Summary</h2>
          <div class="chart-container">
            <Pie :data="weeklyChartData" v-if="weeklyChartData.datasets.length"></Pie>
          </div>
        </div>
        <div>
          <h2>Monthly Mood Summary</h2>
          <div class="chart-container">
            <Pie :data="monthlyChartData" v-if="monthlyChartData.datasets.length"></Pie>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  import { ref, onMounted } from 'vue';
  import axios from 'axios';
  import Navbar from '@/components/Navbar.vue';
  import { Pie } from 'vue-chartjs';
  import { Chart as ChartJS, Title, Tooltip, Legend, ArcElement, CategoryScale } from 'chart.js';
  
  ChartJS.register(Title, Tooltip, Legend, ArcElement, CategoryScale);
  
  export default {
    name: 'MoodTracker',
    components: { Navbar, Pie },
    setup() {
      const isLoggedIn = ref(false);
      const username = ref('');
      const userInfo = ref({});
      const mood = ref('');
      const comment = ref('');
      const message = ref('');
      const hasSubmittedToday = ref(false);
      const weeklyMoods = ref([]);
      const monthlyMoods = ref([]);
      const weeklyChartData = ref({
        labels: [],
        datasets: []
      });
      const monthlyChartData = ref({
        labels: [],
        datasets: []
      });
  
      const selectMood = (selectedMood) => {
        mood.value = selectedMood;
      };
  
      const submitMood = async () => {
        try {
          const token = localStorage.getItem('token');
          const response = await axios.post('http://localhost:5000/mood', { mood: mood.value, comment: comment.value }, {
            headers: { Authorization: `Bearer ${token}` }
          });
          message.value = response.data.message;
          mood.value = '';
          comment.value = '';
          hasSubmittedToday.value = true;
          await fetchMoods();
        } catch (error) {
          console.error('Error submitting mood:', error);
          message.value = 'Failed to submit mood. Please try again.';
        }
      };
  
      const fetchMoods = async () => {
        try {
          const token = localStorage.getItem('token');
          const weeklyResponse = await axios.get('http://localhost:5000/mood/weekly', {
            headers: { Authorization: `Bearer ${token}` }
          });
          weeklyMoods.value = weeklyResponse.data;
          updateChartData(weeklyMoods.value, weeklyChartData);
  
          const monthlyResponse = await axios.get('http://localhost:5000/mood/monthly', {
            headers: { Authorization: `Bearer ${token}` }
          });
          monthlyMoods.value = monthlyResponse.data;
          updateChartData(monthlyMoods.value, monthlyChartData);
  
          // Check if the user has submitted a mood today
          const today = new Date().toISOString().split('T')[0];
          hasSubmittedToday.value = weeklyMoods.value.some(mood => mood.created_at.startsWith(today));
        } catch (error) {
          console.error('Error fetching moods:', error);
        }
      };
  
      const updateChartData = (moods, chartData) => {
        const moodCounts = { Positive: 0, Neutral: 0, Negative: 0 };
        moods.forEach(mood => {
          moodCounts[mood.sentiment]++;
        });
        chartData.value = {
          labels: ['Positive', 'Neutral', 'Negative'],
          datasets: [{
            data: [moodCounts.Positive, moodCounts.Neutral, moodCounts.Negative],
            backgroundColor: ['#4caf50', '#ffeb3b', '#f44336']
          }]
        };
      };
  
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
  
        await fetchMoods();
      });
  
      return { isLoggedIn, username, userInfo, mood, comment, message, submitMood, hasSubmittedToday, weeklyMoods, monthlyMoods, weeklyChartData, monthlyChartData, selectMood };
    },
  };
  </script>
  
  <style scoped>
  .mood-tracker {
    padding: 20px;
  }
  textarea {
    width: 100%;
    height: 100px;
    margin-bottom: 10px;
  }
  button {
    padding: 10px 20px;
    background-color: #0f6016;
    color: white;
    border: none;
    cursor: pointer;
  }
  .emoji-selector span {
    font-size: 2rem;
    cursor: pointer;
    margin: 0 10px;
  }
  .mood-dashboard {
    padding: 20px;
  }
  .chart-container {
    width: 200px; /* Adjust the width as needed */
    height: 200px; /* Adjust the height as needed */
    margin: 0 auto;
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