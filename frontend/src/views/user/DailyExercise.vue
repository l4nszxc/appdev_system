<template>
  <Navbar :isLoggedIn="isLoggedIn" :username="username" :profilePicture="userInfo.profile_picture" />
  <div class="daily-exercise">
    <div class="exercise-container">
      <h1>Mindful Exercise for Today</h1>
      <div v-if="todayExercise" class="exercise-card">
        <h2>{{ todayExercise.category }}</h2>
        <h3>{{ todayExercise.title }}</h3>
        <p>{{ todayExercise.description }}</p>
        <ol v-if="todayExercise.steps">
          <li v-for="(step, index) in todayExercise.steps" :key="index">
            {{ step }}
          </li>
        </ol>
        <button v-if="!exerciseCompleted" @click="completeExercise" :disabled="isLoading" class="complete-btn">
          {{ isLoading ? 'Saving...' : 'Mark as Completed' }}
        </button>
        <p v-else class="completion-message">Great job! You've completed today's exercise.</p>
      </div>
      <p v-else-if="exerciseCompleted" class="completion-message">
        You've already completed today's exercise. Great work!
      </p>
      <p v-else class="warning-message">
        You haven't done your daily exercise for today. Take a moment for mindfulness!
      </p>
      <div class="weekly-progress">
        <h2>Weekly Progress</h2>
        <div class="progress-grid">
          <div v-for="(day, index) in weeklyProgress" :key="index" class="progress-day">
            <span>{{ getDayName(index) }}</span>
            <span :class="{ 'completed': day }">{{ day ? '✓' : '✗' }}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
  <!-- Modal for Assessment -->
<div v-if="showAssessmentModal" class="modal-overlay">
  <div class="modal-content">
    <h2>Daily Exercise Assessment</h2>
    <p>How helpful was today's exercise?</p>
    <div class="rating-container">
      <label v-for="rating in [1, 2, 3, 4, 5]" :key="rating">
        <input
          type="radio"
          :value="rating"
          v-model="assessmentRating"
        />
        <span>{{ rating === 1 ? 'Not so helpful' : rating === 5 ? 'Very helpful' : `Rating: ${rating}` }}</span>
      </label>
    </div>
    <div class="modal-actions">
      <button @click="submitAssessment" class="submit-btn">Submit</button>
      <button @click="closeModal" class="cancel-btn">Cancel</button>
    </div>
  </div>
</div>
  <Footer />
</template>
  
<script setup>
import { ref, onMounted } from 'vue';
import axios from 'axios';
import Navbar from '@/components/Navbar.vue';
import Footer from "@/components/Footer.vue";

const isLoggedIn = ref(false);
const username = ref('');
const userInfo = ref({});
const todayExercise = ref(null);
const exerciseCompleted = ref(false);
const weeklyProgress = ref(Array(7).fill(false));
const isLoading = ref(false);
const showAssessmentModal = ref(false);
const assessmentRating = ref(null);
  
  const exercises = [
    {
      category: "Breathing Technique",
      title: "4-7-8 Breathing",
      description: "This breathing technique can help reduce anxiety and promote relaxation.",
      steps: [
        "Sit comfortably and close your eyes.",
        "Inhale quietly through your nose for 4 seconds.",
        "Hold your breath for 7 seconds.",
        "Exhale completely through your mouth for 8 seconds.",
        "Repeat this cycle 4 times."
      ]
    },
    {
      category: "Guided Meditation",
      title: "Body Scan Meditation",
      description: "This meditation helps increase body awareness and reduce tension.",
      steps: [
        "Lie down comfortably and close your eyes.",
        "Focus on your breath for a few moments.",
        "Gradually shift your attention to your toes, then move up through each part of your body.",
        "Notice any sensations without judgment.",
        "When you reach the top of your head, take a deep breath and slowly open your eyes."
      ]
    },
    {
      category: "Breathing Technique",
      title: "Box Breathing",
      description: "Box breathing is a simple technique that can help you relax and reduce stress.",
      steps: [
        "Sit in a comfortable position with your back straight.",
        "Slowly exhale through your mouth, getting all the oxygen out of your lungs.",
        "Inhale slowly and deeply through your nose to the count of 4.",
        "Hold your breath for 4 seconds.",
        "Exhale through your mouth for 4 seconds.",
        "Hold your breath for 4 seconds.",
        "Repeat this process for 4 rounds or until you feel calm."
      ]
    },
    {
      category: "Guided Meditation",
      title: "Loving-Kindness Meditation",
      description: "This meditation helps cultivate compassion for yourself and others.",
      steps: [
        "Sit comfortably and close your eyes.",
        "Take a few deep breaths to center yourself.",
        "Bring to mind someone you care about and silently repeat: 'May you be happy, may you be healthy, may you be safe, may you live with ease.'",
        "Now direct these wishes to yourself: 'May I be happy, may I be healthy, may I be safe, may I live with ease.'",
        "Extend these wishes to all beings everywhere: 'May all beings be happy, be healthy, be safe, and live with ease.'",
        "Sit with these feelings of kindness and compassion for a few moments before opening your eyes."
      ]
    }
  ];
  
  function getRandomExercise() {
    return exercises[Math.floor(Math.random() * exercises.length)];
  }
  
  function getDayName(index) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[index];
  }
  
  async function fetchWeeklyExercises() {
    try {
      const response = await axios.get('http://localhost:5000/exercises', {
        headers: { Authorization: `Bearer ${localStorage.getItem('token')}` }
      });
      const exercises = response.data;
      exercises.forEach(exercise => {
        const exerciseDate = new Date(exercise.exercise_date);
        const dayIndex = exerciseDate.getDay();
        weeklyProgress.value[dayIndex] = true;
      });
      const today = new Date();
      exerciseCompleted.value = exercises.some(exercise => 
        new Date(exercise.exercise_date).toDateString() === today.toDateString()
      );
    } catch (error) {
      console.error('Error fetching weekly exercises:', error.response ? error.response.data : error.message);
    }
  }
  
  async function completeExercise() {
  if (isLoading.value) return;
  isLoading.value = true;
  try {
    await axios.post('http://localhost:5000/exercises', {
      exerciseType: todayExercise.value.category,
      exerciseTitle: todayExercise.value.title
    }, {
      headers: { Authorization: `Bearer ${localStorage.getItem('token')}` }
    });
    exerciseCompleted.value = true;
    const today = new Date();
    const dayIndex = today.getDay();
    weeklyProgress.value[dayIndex] = true;
    await fetchWeeklyExercises();
    showAssessmentModal.value = true; // Show modal after completing exercise
  } catch (error) {
    console.error('Error completing exercise:', error.response ? error.response.data : error.message);
  } finally {
    isLoading.value = false;
  }
}
function closeModal() {
  showAssessmentModal.value = false;
}

async function submitAssessment() {
  if (!assessmentRating.value) {
    alert("Please select a rating.");
    return;
  }

  try {
    await axios.post('http://localhost:5000/assessment', {
      rating: assessmentRating.value,
      exerciseType: todayExercise.value.category,
      exerciseTitle: todayExercise.value.title,
    }, {
      headers: { Authorization: `Bearer ${localStorage.getItem('token')}` },
    });
    alert("Thank you for your feedback!");
    closeModal();
  } catch (error) {
    console.error('Error submitting assessment:', error.response ? error.response.data : error.message);
  }
}
  onMounted(async () => {
  isLoggedIn.value = localStorage.getItem('isLoggedIn') === 'true';
  username.value = localStorage.getItem('username') || '';
  
  if (isLoggedIn.value) {
    try {
      const token = localStorage.getItem('token');
      // Fetch user details including profile picture
      const response = await axios.get('http://localhost:5000/user', {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });
      userInfo.value = response.data;
      
      // Fetch exercises data
      await fetchWeeklyExercises();
      if (!exerciseCompleted.value) {
        todayExercise.value = getRandomExercise();
      }
    } catch (error) {
      console.error('Failed to fetch user details:', error);
    }
  }
});
  </script>
  
  <style scoped>
  .daily-exercise {
    max-width: 800px;
    margin: 0 auto;
    padding: 20px;
  }
  
  .exercise-container {
    background-color: #f0f0f0;
    border-radius: 8px;
    padding: 20px;
    margin-top: 20px;
  }
  
  h1, h2 {
    color: #0f6016;
    text-align: center;
  }
  
  .exercise-card {
    background-color: white;
    border-radius: 8px;
    padding: 20px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    margin-bottom: 20px;
  }
  
  h3 {
    color: #333;
    margin-bottom: 15px;
  }
  
  p {
    margin-bottom: 15px;
  }
  
  ol {
    padding-left: 20px;
  }
  
  li {
    margin-bottom: 10px;
  }
  
  .complete-btn {
    background-color: #0f6016;
    color: white;
    border: none;
    padding: 10px 20px;
    border-radius: 5px;
    cursor: pointer;
    font-size: 16px;
    margin-top: 15px;
  }
  
  .complete-btn:hover {
    background-color: #0a4610;
  }
  
  .complete-btn:disabled {
    background-color: #ccc;
    cursor: not-allowed;
  }
  
  .completion-message {
    color: #0f6016;
    font-weight: bold;
  }
  
  .warning-message {
    color: #d32f2f;
    font-weight: bold;
  }
  
  .weekly-progress {
    margin-top: 30px;
  }
  
  .progress-grid {
    display: grid;
    grid-template-columns: repeat(7, 1fr);
    gap: 10px;
    margin-top: 15px;
  }
  
  .progress-day {
    display: flex;
    flex-direction: column;
    align-items: center;
    background-color: white;
    padding: 10px;
    border-radius: 5px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }
  
  .progress-day span:first-child {
    font-weight: bold;
    margin-bottom: 5px;
  }
  
  .progress-day .completed {
    color: #0f6016;
  }

  /* Modal Styles */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
}

.modal-content {
  background: white;
  padding: 20px;
  border-radius: 8px;
  text-align: center;
  width: 90%;
  max-width: 400px;
}

textarea {
  width: 100%;
  margin: 10px 0;
  padding: 10px;
  border-radius: 4px;
  border: 1px solid #ccc;
}

.modal-actions {
  display: flex;
  justify-content: space-between;
}

.submit-btn {
  background-color: #0f6016;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 5px;
  cursor: pointer;
}

.cancel-btn {
  background-color: #ccc;
  border: none;
  padding: 10px 20px;
  border-radius: 5px;
  cursor: pointer;
}

.submit-btn:hover {
  background-color: #0a4610;
}

.cancel-btn:hover {
  background-color: #bbb;
}
.rating-container {
  display: flex;
  justify-content: space-around;
  margin: 10px 0;
}

.rating-container label {
  cursor: pointer;
}

.rating-container input[type="radio"] {
  display: none;
}

.rating-container span {
  background-color: #f0f0f0;
  padding: 10px;
  border-radius: 5px;
}

.rating-container input[type="radio"]:checked + span {
  background-color: #0f6016;
  color: white;
}
  </style>