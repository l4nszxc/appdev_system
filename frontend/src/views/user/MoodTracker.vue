<template>
  <Navbar :isLoggedIn="isLoggedIn" :username="username" :profilePicture="userInfo.profile_picture" />
  
  <div class="heading">
    <h1>Mood Dashboard</h1>
  </div>

  <!-- Weekly and Monthly Mood Summary in Two Columns -->
  <div class="summary-container">
    <div class="summary-item">
      <h2>Weekly Mood Summary</h2>
      <div class="chart-container">
        <Pie :data="weeklyChartData" v-if="weeklyChartData.datasets.length"></Pie>
      </div>
    </div>

    <div class="summary-item">
      <h2>Monthly Mood Summary</h2>
      <div class="chart-container">
        <Pie :data="monthlyChartData" v-if="monthlyChartData.datasets.length"></Pie>
      </div>
    </div>
  </div>
<div><br></div>
  <!-- Feedback Form Section -->
  <div class="container mt-5">
    <h2 class="text-center mb-4">Submit Your Feedback</h2>
    <form @submit.prevent="submitFeedback">
      <!-- Feedback Type -->
      <div class="mb-4">
        <label for="feedbackType" class="form-label">Feedback Type</label>
        <select v-model="feedback.type" id="feedbackType" class="form-select" required>
          <option value="suggestion">Suggestion</option>
          <option value="issue">Issue</option>
        </select>
      </div>
      
      <!-- Feedback Content -->
      <div class="mb-4">
        <label for="feedbackContent" class="form-label">Feedback Content</label>
        <textarea 
          v-model="feedback.content" 
          id="feedbackContent" 
          class="form-control" 
          rows="5" 
          placeholder="Enter your feedback here..." 
          required
        ></textarea>
      </div>

      <!-- Submit Button -->
      <button type="submit" class="btn btn-success w-100 py-2">Submit Feedback</button>
    </form>

    <!-- Message -->
    <div v-if="message" class="mt-4">
      <div 
        :class="messageType === 'success' ? 'alert alert-success' : 'alert alert-danger'" 
        role="alert"
      >
        {{ message }}
      </div>
    </div>
  </div>
  
  <Footer />
</template>

<script>
import { ref, onMounted } from 'vue';
import axios from 'axios';
import Navbar from '@/components/Navbar.vue';
import { Pie } from 'vue-chartjs';
import Footer from "@/components/Footer.vue";
import { Chart as ChartJS, Title, Tooltip, Legend, ArcElement, CategoryScale } from 'chart.js';

ChartJS.register(Title, Tooltip, Legend, ArcElement, CategoryScale);

export default {
  name: 'MoodTracker',
  components: { Navbar, Pie, Footer },
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

    const feedback = ref({
      type: 'suggestion',
      content: ''
    });
    const messageType = ref('');
    
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

    const submitFeedback = async () => {
      try {
        const token = localStorage.getItem('token');
        const response = await fetch('http://localhost:5000/api/feedback', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${token}`
          },
          body: JSON.stringify(feedback.value)
        });

        if (response.ok) {
          const data = await response.json();
          message.value = data.message;
          messageType.value = 'success';
          feedback.value = { type: 'suggestion', content: '' };
        } else {
          const errorData = await response.json();
          message.value = errorData.message || 'Failed to submit feedback. Please try again.';
          messageType.value = 'error';
        }
      } catch (error) {
        console.error('Error submitting feedback:', error);
        message.value = 'An error occurred. Please try again later.';
        messageType.value = 'error';
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

    return { 
      isLoggedIn, username, userInfo, mood, comment, message, hasSubmittedToday, 
      weeklyMoods, monthlyMoods, weeklyChartData, monthlyChartData, selectMood,
      feedback, messageType, submitFeedback 
    };
  },
};
</script>

<style scoped>
.heading{
  text-align: center;
}
.card {
  background-color: #fff;
  border: 1px solid #ddd;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  padding: 20px;
  width: 100%;
  max-width: 900px;  /* Updated for wider card */
  text-align: center;
  margin: 0 auto;  /* Centers the card horizontally */
}

.mood-dashboard-card {
  background-color: #77cc9a;
}

.chart-container {
  margin: 10px auto;
  width: 90%;
  max-width: 400px;
}

.summary-container {
  display: grid;
  grid-template-columns: repeat(2, 1fr);  /* Two columns */
  gap: 20px;
  padding-top: 20px;
  justify-content: center;  /* Centers the columns horizontally */
  align-items: center;  /* Centers the content vertically if height is tall */
}

.summary-item {
  background-color: #f9f9f9;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

h2 {
  font-size: 1.75rem;
  font-weight: bold;
  color: #333;
}

@media (max-width: 768px) {
  .summary-container {
    grid-template-columns: 1fr;  /* Stack columns on smaller screens */
  }
}

.container {
  max-width: 600px;
  margin: 0 auto;
  background: #f9f9f9;
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
}

.form-select, .form-control, .btn {
  font-size: 1rem;
  border-radius: 8px;
}

.mt-5 {
  margin-top: 2.5rem;
}

.container {
  max-width: 600px;
  margin: 0 auto;
  background: #f9f9f9;
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

h2 {
  font-size: 1.75rem;
  font-weight: bold;
  color: #333;
}

.form-label {
  font-weight: 500;
  color: #555;
}

.form-select, .form-control {
  width: 100%;
  padding: 0.85rem;
  margin-bottom: 1rem;
  border: 1px solid #ccc;
  border-radius: 8px;
  transition: border-color 0.3s ease;
}

.form-select:focus, 
.form-control:focus {
  border-color: #28a745;
  outline: none;
}

.btn-success {
  width: 100%;
  padding: 0.75rem;
  background-color: #28a745;
  border: none;
  color: white;
  font-size: 1rem;
  font-weight: bold;
  border-radius: 8px;
  transition: background-color 0.3s ease;
}

.btn-success:hover {
  background-color: #218838;
}

.alert {
  margin-top: 1rem;
  border-radius: 8px;
}

.alert-success {
  background-color: #e9f7ef;
  color: #155724;
  border: 1px solid #c3e6cb;
}

.alert-danger {
  background-color: #fce4e4;
  color: #721c24;
  border: 1px solid #f5c6cb;
}
</style>
