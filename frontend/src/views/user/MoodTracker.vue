<template>
  <div>
    <Navbar :isLoggedIn="isLoggedIn" :username="username" :profilePicture="userInfo.profile_picture" />

    <div class="container">
      <!-- Mood Tracker Card -->
      

      <!-- Mood Dashboard Card -->
      <div class="card mood-dashboard-card">
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

    const selectMood = async (selectedMood) => {
      mood.value = selectedMood;
      await submitMood();
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

    return { isLoggedIn, username, userInfo, mood, comment, message, hasSubmittedToday, weeklyMoods, monthlyMoods, weeklyChartData, monthlyChartData, selectMood };
  },
};
</script>

<style scoped>
.container {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
  justify-content: center;
  margin: 20px;
}

.card {
  background-color: #fff;
  border: 1px solid #ddd;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  padding: 20px;
  width: 100%;
  max-width: 500px;
  text-align: center;
}

.mood-tracker-card {
  background-color: #a0e5d1;
}

.mood-dashboard-card {
  background-color: #77cc9a;
}


.character-selector span {
  font-size: 3rem;
  cursor: pointer;
  margin: 0 15px;
  position: relative;
}

.character-selector span.zoomed {
  transform: scale(1.2);
  transition: transform 0.3s ease;
}

.character-selector span::after {
  content: attr(title);
  position: absolute;
  bottom: -20px;
  left: 50%;
  transform: translateX(-50%);
  font-size: 1.2rem;
  color: #333;
  visibility: hidden;
  opacity: 0;
  transition: opacity 0.2s ease, visibility 0.2s ease;
}

.character-selector span:hover::after {
  visibility: visible;
  opacity: 1;
}

.mood-dashboard {
  padding: 20px;
}

.chart-container {
  margin: 10px auto;
  width: 90%;
  max-width: 400px;
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
