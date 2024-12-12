<template>
  <Navbar :isLoggedIn="isLoggedIn" :username="username" :profilePicture="userInfo.profile_picture" />
  <h2 class="challenge-title">Empathy Challenge</h2>
  <!-- Redesigned Dates Section -->
  <div class="challenge-dates">
    <div class="dates-container">
      <div class="date-box">
        <p class="date-label">Start Date:</p>
        <p class="date-value">{{ new Date(challenge.start_date).toLocaleDateString() }}</p>
      </div>
      <div class="date-box">
        <p class="date-label">End Date:</p>
        <p class="date-value">{{ new Date(challenge.end_date).toLocaleDateString() }}</p>
      </div>
    </div>
  </div>

  <div v-if="challenge" class="challenge-content">
    <div class="challenge-section">
      <h3>Comment Challenge - Level {{ challenge.comment_level }}</h3>
      <div class="progress-container">
        <p>Comment on <strong>{{ challenge.comment_level * 5 }}</strong> posts</p>
        <div class="progress-bar">
          <div
            class="progress"
            :style="{ width: ((challenge.comments_count / (challenge.comment_level * 5)) * 100) + '%' }"
          ></div>
        </div>
        <p class="progress-text">Progress: {{ challenge.comments_count }} / {{ challenge.comment_level * 5 }}</p>
        <p v-if="challenge.comments_count >= challenge.comment_level * 5" class="status completed">Completed</p>
        <p v-else class="status">{{ challenge.comment_level * 5 - challenge.comments_count }} comments left to proceed.</p>
      </div>
    </div>

    <div class="challenge-section">
      <h3>Reaction Challenge - Level {{ challenge.reaction_level }}</h3>
      <div class="progress-container">
        <p>React to <strong>{{ challenge.reaction_level * 5 }}</strong> posts</p>
        <div class="progress-bar">
          <div
            class="progress"
            :style="{ width: ((challenge.reactions_count / (challenge.reaction_level * 5)) * 100) + '%' }"
          ></div>
        </div>
        <p class="progress-text">Progress: {{ challenge.reactions_count }} / {{ challenge.reaction_level * 5 }}</p>
        <p v-if="challenge.reactions_count >= challenge.reaction_level * 5" class="status completed">Completed</p>
        <p v-else class="status">{{ challenge.reaction_level * 5 - challenge.reactions_count }} reactions left to proceed.</p>
      </div>
    </div>

    <div v-if="challengeCompleted" class="message">
      <p class="success-message">You've already completed the challenge!</p>
    </div>
    <div v-if="challenge.message" class="message">
      <p class="completed-message">{{ challenge.message }}</p>
    </div>
  </div>
  <div class="button-container">
    <button @click="goToFeed" class="feed-button">Go to Feed</button>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import axios from 'axios';
import { useRouter } from 'vue-router';
import Navbar from '@/components/Navbar.vue';

export default {
  name: 'UserEmpathyC',
  components: {
    Navbar,
  },
  setup() {
    const isLoggedIn = ref(false);
    const username = ref('');
    const userInfo = ref({});
    const challenge = ref({
      comment_level: 1,
      comments_count: 0,
      reaction_level: 1,
      reactions_count: 0,
      start_date: '',
      end_date: '',
      message: '',
    });
    const challengeCompleted = ref(false);
    const router = useRouter();

    const fetchChallenge = async () => {
      try {
        const token = localStorage.getItem('token');
        const challengeResponse = await axios.get('http://localhost:5000/empathy-challenge', {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        });
        challenge.value = challengeResponse.data;

        // Ensure the challenge duration is 1 week
        const startDate = new Date(challenge.value.start_date);
        const endDate = new Date(startDate);
        endDate.setDate(startDate.getDate() + 7); // Add 7 days
        challenge.value.end_date = endDate.toISOString();

        if (challenge.value.comment_level > 10 && challenge.value.reaction_level > 10) {
          challengeCompleted.value = true;
        }

        if (challenge.value.comments_count >= challenge.value.comment_level * 5 &&
            challenge.value.reactions_count >= challenge.value.reaction_level * 5) {
          challenge.value.message = "Level for today was completed, please come back tomorrow for more levels.";
        }
      } catch (error) {
        console.error('Failed to fetch challenge:', error);
      }
    };

    const goToFeed = () => {
      router.push('/feed');
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

          await fetchChallenge();
        } catch (error) {
          console.error('Failed to fetch user details or challenge:', error);
        }
      }
    });

    return {
      isLoggedIn,
      username,
      userInfo,
      challenge,
      challengeCompleted,
      goToFeed,
    };
  },
};
</script>

<style scoped>
/* General Layout */
.challenge-container {
  font-family: Arial, sans-serif;
  margin: 20px auto;
  max-width: 800px;
  background-color: #f9f9f9;
  border-radius: 10px;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
  padding: 20px;
}

.challenge-title {
  text-align: center;
  font-size: 3rem;
  color: #333;
}

/* Dates Section Styling */
.challenge-dates {
  margin: 20px 0;
  padding: 15px;
  background-color: #9addbb;
  border: 1px solid #239633;
  border-radius: 8px;
}

.dates-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.date-box {
  text-align: center;
  flex: 1;
}

.date-label {
  font-size: 1rem;
  font-weight: bold;
  color: #287e3b;
}

.date-value {
  font-size: 1.3rem;
  color: #333;
  margin-top: 5px;
}

.date-box:not(:last-child) {
  border-right: 1px solid #2c7e37;
  padding-right: 10px;
}

.dates-container > div {
  margin-left: 10px;
  margin-right: 10px;
}

.challenge-content {
  padding: 15px;
  display: grid;
  font-size: 1.5rem;
  grid-template-columns: repeat(2, 1fr); /* Two equal columns */
  gap: 20px; /* Space between the items */
  max-width: 1200px; /* Centered layout with a maximum width */
  margin: 0 auto; /* Center the content on the page */
}

.challenge-section {
  padding: 15px;
  background: #fff;
  border-radius: 8px;
  border: 1px solid #ddd;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* Slight shadow for depth */
  transition: transform 0.2s ease, box-shadow 0.2s ease; /* Smooth hover effects */
}

.challenge-section:hover {
  transform: translateY(-3px); /* Subtle lift effect on hover */
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.2); /* More prominent shadow on hover */
}

/* Responsive Design */
@media (max-width: 768px) {
  .challenge-content {
    grid-template-columns: 1fr; /* Stack in a single column on smaller screens */
  }
}

.progress-container {
  margin: 10px 0;
}

.progress-bar {
  height: 10px;
  background: #ddd;
  border-radius: 5px;
  overflow: hidden;
}

.progress {
  height: 10px;
  background: #28a745;
  transition: width 0.3s ease;
}

.progress-text {
  font-size: 1rem;
  margin-top: 5px;
}

.status {
  margin-top: 10px;
  font-weight: bold;
  font-size: 1.5rem;
}

.completed {
  color: #28a745;
}

.challenge-dates {
  margin-top: 20px;
  font-size: 14px;
  color: #666;
}

.message {
  margin-top: 20px;
  padding: 10px;
  background: #e6f7ff;
  border: 1px solid #91d5ff;
  border-radius: 5px;
  color: #0050b3;
  text-align: center;
}

.success-message {
  color: #28a745;
}

.completed-message {
  color: #0050b3;
}

/* Buttons */
.button-container {
  text-align: center;
  margin-top: 20px;
}

.feed-button {
  background-color: #077203; /* Bright, modern blue */
  width: 100%;
  color: white;
  padding: 12px 25px; /* Slightly larger padding for better click feel */
  border: none;
  border-radius: 8px; /* More rounded corners for a softer look */
  cursor: pointer;
  font-size: 16px; /* Clear, readable font size */
  font-weight: bold; /* Emphasize text for better readability */
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* Subtle shadow for a 3D effect */
  transition: all 0.3s ease; /* Smooth transition for hover effect */
}

.feed-button:hover {
  background-color: #27af50; /* Darker shade of blue for hover effect */
  box-shadow: 0 6px 8px rgba(0, 0, 0, 0.2); /* Enhance shadow for hover */
  transform: translateY(-2px); /* Slight lift effect */
}
</style>