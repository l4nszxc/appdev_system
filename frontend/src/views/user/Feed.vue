<template>
  <Navbar :isLoggedIn="isLoggedIn" :username="username" :profilePicture="userInfo.profile_picture" />
  
  <div class="content-wrapper">
    <!-- Left Section -->
    <div class="left-section">
      <div class="card bg-white shadow-md rounded-lg p-6">
    <h2 class="text-xl font-semibold mb-4 text-green-800">How are you feeling today?</h2>
    <div class="post-form">
      <textarea 
        v-model="newPostContent" 
        placeholder="Share your thoughts..." 
        class="post-input border border-gray-300 rounded-md p-2 w-full"
      ></textarea>
      <button 
        @click="createPost" 
        class="post-button mt-4 bg-green-600 text-white px-4 py-2 rounded-md hover:bg-green-700 disabled:opacity-50"
        :disabled="!newPostContent.trim()"
      >
        Post
      </button>
    </div>
  </div>
      <div class="posts-list">
        <div v-for="post in posts" :key="post.id" class="post">
          <div class="post-header">
            <img 
              :src="getProfilePicture(post.profile_picture)" 
              :alt="post.username" 
              class="author-avatar" 
            />
            <span class="author-name">{{ post.username }}</span>
            <span class="text-gray-500 ml-2 text-sm">
              {{ formatDate(post.created_at) }}
            </span>
          </div>
          <p class="post-content">{{ post.content }}</p>
          <div class="post-actions">
            <div class="reaction-button-container" @mouseover="showReactions = post.id" @mouseleave="showReactions = null">
              <button class="reaction-button">React</button>
              <div v-if="showReactions === post.id" class="reaction-options">
                <button @click="addReaction(post.id, 'Like')" class="reaction-option">👍 Like</button>
                <button @click="addReaction(post.id, 'Heart')" class="reaction-option">❤️ Heart</button>
                <button @click="addReaction(post.id, 'Haha')" class="reaction-option">😂 Haha</button>
                <button @click="addReaction(post.id, 'Care')" class="reaction-option">🤗 Care</button>
                <button @click="addReaction(post.id, 'Sad')" class="reaction-option">😢 Sad</button>
              </div>
            </div>
            <button @click="openReactionsModal(post)" class="reaction-count-button">
              {{ post.reactions_count }} Reactions
            </button>
            <button @click="openCommentsModal(post)" class="comment-count-button">
              {{ post.comments_count }} Comments
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Right Section -->
    <div class="right-section">
      
      <div class="card mood-tracker-card">
        <h1>Mood Tracker</h1>
        <div v-if="hasSubmittedToday">
          <p>You have already submitted your mood for today. Please come back tomorrow.</p>
        </div>
        <div v-else>
          <div class="character-selector">
            <span 
              @click="selectMood('Joy')" 
              class="mood-icon" 
              title="Joy"
              :class="{ zoomed: mood === 'Joy' }">
              😊
            </span>
            <span 
              @click="selectMood('Sadness')" 
              class="mood-icon" 
              title="Sadness"
              :class="{ zoomed: mood === 'Sadness' }">
              😞
            </span>
            <span 
              @click="selectMood('Anger')" 
              class="mood-icon" 
              title="Anger"
              :class="{ zoomed: mood === 'Anger' }">
              😡
            </span>
            <span 
              @click="selectMood('Disgust')" 
              class="mood-icon" 
              title="Disgust"
              :class="{ zoomed: mood === 'Disgust' }">
              🤢
            </span>
            <span 
              @click="selectMood('Fear')" 
              class="mood-icon" 
              title="Fear"
              :class="{ zoomed: mood === 'Fear' }">
              😨
            </span>
          </div>
        </div>
        <div v-if="message">{{ message }}</div>
      </div>

      <div><br></div>
      <div class="card heartRoom">
        <h2 class="text-2xl font-semibold mb-4 text-green-800">Heart-to-Heart Room</h2>

        
        <!-- Appointment Scheduling Section -->
        <div v-if="!currentAppointment">
          <h3 class="text-lg font-semibold mb-4 text-green-700">Schedule an Appointment</h3>

          <!-- Date Selection -->
          <div class="mb-6">
            <label class="block text-sm font-medium text-gray-700 mb-2">Select Date</label>
            <input
              type="date"
              v-model="selectedDate"
              class="w-full p-3 border rounded-lg focus:ring-green-500 focus:border-green-500"
              :min="today"
              @change="loadTimeSlots"
            />
          </div>

          <!-- Time Slots -->
          <div v-if="selectedDate" class="mb-6">
            <label class="block text-sm font-medium text-gray-700 mb-2">Available Time Slots</label>
            <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-4">
              <div
                v-for="slot in timeSlots"
                :key="slot.time"
                @click="selectTimeSlot(slot)"
                :class="[ 'card p-3 rounded-lg text-center cursor-pointer transition-all',
                          slot.available ? 'bg-green-100 hover:bg-green-200 text-green-800' : 'bg-gray-100 text-gray-400 cursor-not-allowed' ]"
              >
                {{ formatTime(slot.time) }}
              </div>
            </div>
          </div>

          <div v-if="error" class="text-red-600 mb-4">
            {{ error }}
          </div>
        </div>

        <!-- Current Appointment Display -->
        <div v-if="currentAppointment" class="mt-4">
          <h3 class="text-lg font-semibold mb-2 text-green-700">Your Current Appointment</h3>
          <div class="card bg-green-50 p-6 rounded-lg">
            <p class="mb-2">
              <span class="font-medium">Date:</span>
              {{ formatDate(currentAppointment.date) }}
            </p>
            <p class="mb-2">
              <span class="font-medium">Time:</span>
              {{ formatTime(currentAppointment.start_time) }} - {{ formatTime(currentAppointment.end_time) }}
            </p>
            <p v-if="currentAppointment.meeting_link" class="mb-4">
              <span class="font-medium">Meeting Link:</span>
              <a
                :href="currentAppointment.meeting_link"
                target="_blank"
                class="text-blue-600 hover:underline"
              >
                {{ currentAppointment.meeting_link }}
              </a>
            </p>
            <button
              @click="cancelAppointment"
              class="w-full px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-all"
            >
              Cancel Appointment
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>

  
  <!-- Comments Modal -->
  <Modal :show="showCommentsModal" @close="closeCommentsModal">
    <div class="modal-content">
      <h2>Comments</h2>
      <textarea 
        v-model="currentPost.newComment" 
        placeholder="Write a comment..." 
        class="comment-input">
      </textarea>
      <button 
        @click="addComment(currentPost.id, currentPost.newComment)" 
        class="add-comment-button">
        Add Comment
      </button>

      <div v-for="comment in currentPost.comments" :key="comment.id" class="comment">
        <img 
          :src="getProfilePicture(comment.profile_picture)" 
          :alt="comment.username" 
          class="comment-author-avatar" 
        />
        <span class="comment-author">{{ comment.username }}</span>
        <p class="comment-content">{{ comment.content }}</p>
      </div>
    </div>
  </Modal>

  <!-- Reactions Modal -->
  <Modal :show="showReactionsModal" @close="closeReactionsModal">
    <div class="modal-content">
      <h2>Reactions</h2>
      <div class="reaction-tabs">
        <button 
          v-for="type in reactionTypes" 
          :key="type" 
          @click="selectedReactionType = type"
          :class="[selectedReactionType === type ? 'active-tab' : '', 'reaction-tab']"
        >
          {{ type }}
        </button>
      </div>
      <div v-for="reaction in filteredReactions" :key="reaction.id" class="reaction">
        <img 
          :src="getProfilePicture(reaction.profile_picture)" 
          :alt="reaction.username" 
          class="reaction-author-avatar" 
        />
        <span class="reaction-author">{{ reaction.username }}</span>
      </div>
    </div>
  </Modal>

  <Footer />
</template>



<script setup>
import { ref, onMounted, computed } from 'vue';
import axios from 'axios';
import Navbar from '@/components/Navbar.vue';
import Footer from "@/components/Footer.vue";
import Modal from '@/components/Modal.vue'
import { Pie } from 'vue-chartjs';
import { Chart as ChartJS, Title, Tooltip, Legend, ArcElement, CategoryScale } from 'chart.js';

ChartJS.register(Title, Tooltip, Legend, ArcElement, CategoryScale);

// Appointment Scheduling State Variables
const selectedDate = ref('');
const timeSlots = ref([
  { time: '10:00:00', available: true },
  { time: '15:00:00', available: true }
]);
const currentAppointment = ref(null);
const error = ref('');
const today = new Date().toISOString().split('T')[0];

// User Details and Posts State Variables
const posts = ref([]);
const newPostContent = ref('');
const isLoggedIn = ref(false);
const username = ref('');
const userInfo = ref({});
const showCommentsModal = ref(false);
const showReactionsModal = ref(false);
const currentPost = ref({});
const showReactions = ref(null);
const selectedReactionType = ref('Like');
const reactionTypes = ['Like', 'Heart', 'Haha', 'Care', 'Sad'];

// Mood Tracker State Variables
const mood = ref('');
const comment = ref('');
const message = ref('');
const hasSubmittedToday = ref(false);
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
    const monthlyResponse = await axios.get('http://localhost:5000/mood/monthly', {
      headers: { Authorization: `Bearer ${token}` }
    });
    updateChartData(weeklyResponse.data, weeklyChartData);
    updateChartData(monthlyResponse.data, monthlyChartData);

    const today = new Date().toISOString().split('T')[0];
    hasSubmittedToday.value = weeklyResponse.data.some(mood => mood.created_at.startsWith(today));
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
// Profile picture helper
const getProfilePicture = (profilePath) => {
  return profilePath 
    ? `http://localhost:5000${profilePath}` 
    : '/default-avatar.png';
};

// Fetch user details
const fetchUserDetails = async () => {
  try {
    const token = localStorage.getItem('token');
    const response = await axios.get('http://localhost:5000/user', {
      headers: { Authorization: `Bearer ${token}` },
    });
    userInfo.value = response.data;
    username.value = response.data.username;
  } catch (error) {
    console.error('Failed to fetch user details:', error);
  }
};

// Fetch posts
const fetchPosts = async () => {
  try {
    const token = localStorage.getItem('token');
    const response = await axios.get('http://localhost:5000/posts', {
      headers: { Authorization: `Bearer ${token}` },
    });
    posts.value = response.data.map(post => ({
      ...post,
      showComments: false,
      showReactions: false,
      newComment: '',
      comments: post.comments || [],
      reactions: post.reactions || [],
    }));
  } catch (error) {
    console.error('Failed to fetch posts:', error);
  }
};

// Create a new post
const createPost = async () => {
  if (!newPostContent.value.trim()) return;
  try {
    const token = localStorage.getItem('token');
    await axios.post(
      'http://localhost:5000/posts',
      { content: newPostContent.value },
      { headers: { Authorization: `Bearer ${token}` } }
    );
    newPostContent.value = '';
    await fetchPosts();
  } catch (error) {
    console.error('Failed to create post:', error);
  }
};

// Add a reaction to a post
const addReaction = async (postId, reactionType) => {
  try {
    const token = localStorage.getItem('token');
    await axios.post(
      'http://localhost:5000/posts/reactions',
      { postId, reactionType },
      { headers: { Authorization: `Bearer ${token}` } }
    );
    await axios.post(
      'http://localhost:5000/empathy-challenge/reaction-progress',
      {},
      { headers: { Authorization: `Bearer ${token}` } }
    );
    await fetchPosts();
  } catch (error) {
    console.error('Failed to add reaction:', error);
  }
};

// Add a comment to a post
const addComment = async (postId, content) => {
  if (!content.trim()) return;
  try {
    const token = localStorage.getItem('token');
    await axios.post(
      'http://localhost:5000/posts/comments',
      { postId, content },
      { headers: { Authorization: `Bearer ${token}` } }
    );
    await axios.post(
      'http://localhost:5000/empathy-challenge/comment-progress',
      {},
      { headers: { Authorization: `Bearer ${token}` } }
    );
    await fetchPosts();
  } catch (error) {
    console.error('Failed to add comment:', error);
  }
};

// Appointment Scheduling Functions
const loadTimeSlots = async () => {
  if (!selectedDate.value) return;
  try {
    error.value = '';
    const token = localStorage.getItem('token');
    const response = await axios.get(`http://localhost:5000/api/appointments`, {
      params: { date: selectedDate.value },
      headers: { Authorization: `Bearer ${token}` }
    });
    timeSlots.value = timeSlots.value.map(slot => ({ ...slot, available: true }));
    response.data.forEach(appointment => {
      const slot = timeSlots.value.find(s => s.time === appointment.start_time);
      if (slot) slot.available = false;
    });
    if (response.data.length >= 2) {
      timeSlots.value = timeSlots.value.map(slot => ({ ...slot, available: false }));
    }
  } catch (err) {
    console.error('Error loading time slots:', err);
    error.value = err.response?.data?.message || 'Failed to load available time slots';
  }
};

const selectTimeSlot = async (slot) => {
  if (!slot.available) return;
  try {
    error.value = '';
    const token = localStorage.getItem('token');
    const response = await axios.post('http://localhost:5000/api/appointments', {
      date: selectedDate.value,
      start_time: slot.time
    }, {
      headers: { Authorization: `Bearer ${token}` }
    });
    currentAppointment.value = response.data;
    await loadTimeSlots();
  } catch (err) {
    console.error('Error scheduling appointment:', err);
    error.value = err.response?.data?.message || 'Failed to schedule appointment';
  }
};

const cancelAppointment = async () => {
  if (!currentAppointment.value) return;
  try {
    error.value = '';
    const token = localStorage.getItem('token');
    await axios.delete(`http://localhost:5000/api/appointments/${currentAppointment.value.id}`, {
      headers: { Authorization: `Bearer ${token}` }
    });
    currentAppointment.value = null;
    await loadTimeSlots();
  } catch (err) {
    console.error('Error canceling appointment:', err);
    error.value = err.response?.data?.message || 'Failed to cancel appointment';
  }
};

const loadCurrentAppointment = async () => {
  try {
    const token = localStorage.getItem('token');
    const response = await axios.get('http://localhost:5000/api/appointments/current', {
      headers: { Authorization: `Bearer ${token}` }
    });
    currentAppointment.value = response.data;
  } catch (err) {
    console.error('Error loading current appointment:', err);
    error.value = err.response?.data?.message || 'Failed to load current appointment';
  }
};

// Date formatting utility
const formatTime = (time) => new Date(`2000-01-01T${time}`).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
const formatDate = (date) => new Date(date).toLocaleDateString('en-US', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' });

// Modal Management Functions
const openCommentsModal = (post) => {
  currentPost.value = post;
  showCommentsModal.value = true;
};

const closeCommentsModal = () => {
  showCommentsModal.value = false;
};

const openReactionsModal = (post) => {
  currentPost.value = post;
  showReactionsModal.value = true;
  selectedReactionType.value = 'Like';
};

const closeReactionsModal = () => {
  showReactionsModal.value = false;
};

// Filter reactions by selected type
const filteredReactions = computed(() => {
  if (!currentPost.value.reactions) return [];
  return currentPost.value.reactions.filter(reaction => reaction.reaction_type === selectedReactionType.value);
});

// Lifecycle hook
onMounted(async () => {
  isLoggedIn.value = !!localStorage.getItem('token');
  if (isLoggedIn.value) {
    await fetchUserDetails();
    await fetchPosts();
    await loadCurrentAppointment();
    await fetchMoods();
  }
});
</script>



<style scoped>
.card {
  display: flex;
  flex-direction: column;
  background-color: white;
  border-radius: 1rem;
  padding: 1.5rem;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}
.content-wrapper {
  display: flex;
  gap: 16px;
}
.mood-tracker-card {
  background: linear-gradient(109.6deg, rgb(0, 204, 130) 11.2%, rgb(58, 181, 46) 91.7%);
}
.heartRoom{
  background: linear-gradient(109.6deg, rgb(0, 204, 130) 11.2%, rgb(58, 181, 46) 91.7%);
}
.character-selector span {
  font-size: 1.8rem;
  cursor: pointer;
  margin: 0 15px;
  position: relative;
}

.left-section, .right-section {
  width: 48%;
}

.left-section {
  flex: 3; /* Left section is wider */
  padding: 16px;
}

.right-section {
  flex: 2; /* Right section is smaller */
  padding: 16px;
}


.feed-container {
  max-width: 100%;
}

.post-form {
  margin-bottom: 20px;
}

.post-input {
  width: 100%;
  height: 100px;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 5px;
  resize: none;
}

.post-button {
  margin-top: 10px;
  padding: 10px 20px;
  background-color: #2a9d8f;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
}

.post-button:disabled {
  background-color: #a0a0a0;
  cursor: not-allowed;
}

.posts-list {
  margin-top: 20px;
}

.post {
  background-color: white;
  border: 1px solid #ddd;
  border-radius: 5px;
  padding: 15px;
  margin-bottom: 20px;
  font-size: 1.5rem;
}

.post-header {
  display: flex;
  align-items: center;
  margin-bottom: 10px;
}

.author-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  margin-right: 10px;
  object-fit: cover;
}

.author-name {
  font-weight: bold;
  margin-right: 1rem;
}

.post-content {
  margin-bottom: 10px;
  font-size: 1.5rem;
}

.post-actions {
  display: flex;
  align-items: center;
  gap: 10px;
}

.reaction-button-container {
  position: relative;
}

.reaction-button {
  background-color: #2a9d8f;
  color: white;
  border: none;
  border-radius: 5px;
  padding: 5px 10px;
  cursor: pointer;
}

.reaction-options {
  position: absolute;
  top: 100%;
  left: 0;
  display: flex;
  flex-direction: column;
  background-color: white;
  border: 1px solid #ddd;
  border-radius: 5px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  z-index: 10;
}

.reaction-option {
  padding: 5px 10px;
  cursor: pointer;
  background-color: white;
  border: none;
  text-align: left;
}

.reaction-option:hover {
  background-color: #f0f0f0;
}

.comment-button, .reaction-count-button, .comment-count-button {
  background-color: #2a9d8f;
  color: white;
  border: none;
  border-radius: 5px;
  padding: 5px 10px;
  cursor: pointer;
}


.feed-title {
  text-align: center;
  color: #2a9d8f;
  margin-bottom: 20px;
}

.post-form {
  margin-bottom: 20px;
}

.post-input {
  width: 100%;
  height: 100px;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 5px;
  resize: none;
}

.post-button {
  margin-top: 10px;
  padding: 10px 20px;
  background-color: #2a9d8f;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
}

.post-button:disabled {
  background-color: #a0a0a0;
  cursor: not-allowed;
}

.posts-list {
  margin-top: 20px;
}

.post {
  background-color: white;
  border: 1px solid #ddd;
  border-radius: 5px;
  padding: 15px;
  margin-bottom: 20px;
}

.post-header {
  display: flex;
  align-items: center;
  margin-bottom: 10px;
}

.author-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  margin-right: 10px;
  object-fit: cover;
}

.author-name {
  font-weight: bold;
}

.post-content {
  margin-bottom: 10px;
}

.post-actions {
  display: flex;
  align-items: center;
  gap: 10px;
}

.reaction-button-container {
  position: relative;
}

.reaction-button {
  background-color: #2a9d8f;
  color: white;
  border: none;
  border-radius: 5px;
  padding: 5px 10px;
  cursor: pointer;
}

.reaction-options {
  position: absolute;
  top: 100%;
  left: 0;
  display: flex;
  flex-direction: column;
  background-color: white;
  border: 1px solid #ddd;
  border-radius: 5px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  z-index: 10;
}

.reaction-option {
  padding: 5px 10px;
  cursor: pointer;
  background-color: white;
  border: none;
  text-align: left;
}

.reaction-option:hover {
  background-color: #f0f0f0;
}

.comment-button, .reaction-count-button, .comment-count-button {
  background-color: #2a9d8f;
  color: white;
  border: none;
  border-radius: 5px;
  padding: 5px 10px;
  cursor: pointer;
}

.comments-section {
  margin-top: 10px;
}

.comment-author-avatar {
  width: 30px;
  height: 30px;
  border-radius: 50%;
  margin-right: 10px;
  object-fit: cover;
}

.comment-author {
  font-weight: bold;
}

.comment-content {
  margin-top: 5px;
}

.comment-input {
  width: 100%;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 5px;
  resize: none;
  margin-bottom: 10px;
}

.add-comment-button {
  background-color: #2a9d8f;
  color: white;
  border: none;
  border-radius: 5px;
  padding: 5px 10px;
  cursor: pointer;
}

.reactions-section {
  margin-top: 10px;
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.reaction-tabs {
  display: flex;
  gap: 10px;
  margin-bottom: 10px;
}

.reaction-tab {
  padding: 5px 10px;
  cursor: pointer;
  background-color: #f0f0f0;
  border: none;
  border-radius: 5px;
}

.reaction-tab.active-tab {
  background-color: #2a9d8f;
  color: white;
}

.reaction {
  display: flex;
  align-items: center;
}

.reaction-author-avatar {
  width: 30px;
  height: 30px;
  border-radius: 50%;
  margin-right: 5px;
  object-fit: cover;
}

.reaction-author {
  font-weight: bold;
}

.reaction-type {
  margin-left: 5px;
}

.modal-content {
  max-height: 400px; /* Adjust the height as needed */
  overflow-y: auto;
}
</style>