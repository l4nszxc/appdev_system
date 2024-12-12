<template>
  <Navbar :isLoggedIn="isLoggedIn" :username="username" :profilePicture="userInfo.profile_picture" />
  
  <div class="content-wrapper">
    <!-- Left Section -->
    <div class="left-section">
      <div class="mood-tracker-wrapper">
        <div class="card mood-tracker-card">
          <h2 class="card-title">Mood Tracker</h2>
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
      </div>
    <br>
    <div class="card">
    <h2 class="card-title">How are you feeling today?</h2>
    <div class="post-form">
      <textarea 
        v-model="newPostContent" 
        placeholder="Share your thoughts..." 
        class="post-input"
      ></textarea>
      <div class="image-upload">
        <input 
          type="file" 
          ref="imageInput"
          @change="handleImageSelect"
          accept="image/*"
          class="hidden"
        />
        <button @click="triggerImageUpload" class="upload-btn">
          📷 Add Image
        </button>
        <div v-if="selectedImage" class="image-preview">
          <img :src="imagePreview" alt="Preview" />
          <button @click="removeImage" class="remove-image">×</button>
        </div>
      </div>
      <button 
        @click="createPost" 
        class="post-button"
        :disabled="!newPostContent.trim()"
      >
        Post
      </button>
    </div>
  </div>
      <br>

      <div class="posts-list">
        <div v-for="post in posts" :key="post.id" class="post card">
          <div class="post-header">
            <img 
              :src="getProfilePicture(post.profile_picture)" 
              :alt="post.username" 
              class="author-avatar"
            />
            <div class="author-info">
              <div class="author-name">{{ post.username }}</div>
              <span class="post-date">{{ formatDate(post.created_at) }}</span>
            </div>
            <div class="post-menu" v-if="post.student_id === userInfo.student_id">
              <button @click="togglePostMenu(post.id)" class="post-menu-button">⋮</button>
              <div v-if="post.showMenu" class="post-menu-dropdown">
                <button @click="editPost(post.id)">Edit</button>
                <button @click="deletePost(post.id)">Delete</button>
              </div>
            </div>
          </div>
          <div class="post-content">
            <div v-if="post.isEditing">
              <textarea v-model="post.editedContent" class="edit-textarea"></textarea>
              <button @click="updatePost(post.id)" class="update-button">Update</button>
            </div>
            <div v-else>
              <p>{{ post.content }}</p>
              <!-- Add image display -->
              <img 
                v-if="post.image_url" 
                :src="`http://localhost:5000${post.image_url}`" 
                alt="Post image"
                class="post-image"
                @error="handleImageError"
              />
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
        <div class="comment-header">
          <img 
            :src="getProfilePicture(comment.profile_picture)" 
            :alt="comment.username" 
            class="comment-author-avatar" 
          />
          <div class="comment-info">
            <span class="comment-author">{{ comment.username }}</span>
            <span class="comment-date">{{ formatDate(comment.created_at) }}</span>
          </div>
        </div>
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
import Modal from '@/components/Modal.vue';
import { Chart as ChartJS, Title, Tooltip, Legend, ArcElement, CategoryScale } from 'chart.js';

ChartJS.register(Title, Tooltip, Legend, ArcElement, CategoryScale);

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
const selectedImage = ref(null);
const imagePreview = ref('');

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
const handleImageError = (e) => {
  e.target.style.display = 'none'; // Hide broken images
  console.error('Failed to load image');
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
      headers: { Authorization: `Bearer ${token}` }
    });
    posts.value = response.data.map(post => ({
      ...post,
      showMenu: false,
      showComments: false,
      showReactions: false,
      newComment: '',
      comments: post.comments || [],
      reactions: post.reactions || [],
      isEditing: false,
      editedContent: post.content,
      image_url: post.image_url
    }));
  } catch (error) {
    console.error('Failed to fetch posts:', error);
  }
};
const handleImageSelect = (event) => {
  const file = event.target.files[0];
  if (file) {
    selectedImage.value = file;
    imagePreview.value = URL.createObjectURL(file);
  }
};

const triggerImageUpload = () => {
  document.querySelector('input[type="file"]').click();
};

const removeImage = () => {
  selectedImage.value = null;
  imagePreview.value = '';
  if (document.querySelector('input[type="file"]')) {
    document.querySelector('input[type="file"]').value = '';
  }
};

// Create a new post
const createPost = async () => {
  if (!newPostContent.value.trim()) return;
  
  try {
    const formData = new FormData();
    formData.append('content', newPostContent.value);
    if (selectedImage.value) {
      formData.append('image', selectedImage.value);
    }
    
    const token = localStorage.getItem('token');
    await axios.post('http://localhost:5000/posts', formData, {
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'multipart/form-data'
      }
    });
    
    newPostContent.value = '';
    removeImage();
    await fetchPosts();
  } catch (error) {
    console.error('Failed to create post:', error);
  }
};

// Toggle post menu
const togglePostMenu = (postId) => {
  posts.value = posts.value.map(post => ({
    ...post,
    showMenu: post.id === postId ? !post.showMenu : false,
  }));
};

// Edit post
const editPost = (postId) => {
  posts.value = posts.value.map(post => ({
    ...post,
    isEditing: post.id === postId ? true : post.isEditing,
  }));
};

// Update post
const updatePost = async (postId) => {
  const post = posts.value.find(post => post.id === postId);
  if (!post.editedContent.trim()) return;
  try {
    const token = localStorage.getItem('token');
    await axios.put(
      `http://localhost:5000/posts/${postId}`,
      { content: post.editedContent },
      { headers: { Authorization: `Bearer ${token}` } }
    );
    post.isEditing = false;
    await fetchPosts();
  } catch (error) {
    console.error('Failed to update post:', error);
  }
};

// Delete post
const deletePost = async (postId) => {
  if (!confirm('Are you sure you want to delete this post?')) return;
  try {
    const token = localStorage.getItem('token');
    await axios.delete(`http://localhost:5000/posts/${postId}`, {
      headers: { Authorization: `Bearer ${token}` },
    });
    await fetchPosts();
  } catch (error) {
    console.error('Failed to delete post:', error);
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
    await fetchMoods();
  }
});
</script>


<style scoped>
/* General styles */
body {
  font-family: 'Arial', sans-serif;
  background-color: #f9f9f9;
  color: #333;
  margin: 0;
}

.content-wrapper {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 20px;
  gap: 16px;
  width: 100%;
  max-width: 800px;
  margin: 0 auto;
}

/* Post styles */
.post {
  background-color: white;
  border-radius: 10px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  margin-bottom: 20px;
  padding: 20px;
  width: 100%;
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

.post-author {
  font-weight: bold;
  font-size: 1.1rem;
}

.post-time {
  font-size: 0.9rem;
  color: #888;
}

.post-content {
  margin-top: 10px;
  font-size: 1rem;
  line-height: 1.5;
}

.post-actions {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-top: 10px;
}

.post-button {
  padding: 10px 20px;
  background-color: #2a9d8f;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
}

.post-button:disabled {
  background-color: #ccc;
}

.post-button:hover {
  background-color: #21867a;
}

/* Reaction styles */
.reaction-button-container {
  position: relative;
}

.reaction-options {
  position: absolute;
  top: 100%;
  left: 0;
  display: flex;
  background-color: white;
  border: 1px solid #ddd;
  border-radius: 5px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  z-index: 10;
}

.reaction-option {
  padding: 5px 10px;
  cursor: pointer;
}

.reaction-option:hover {
  background-color: #f0f0f0;
}

.reaction-author-avatar {
  width: 30px;
  height: 30px;
  border-radius: 50%;
  margin-right: 5px;
  object-fit: cover;
}

/* Comment styles */
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

.comment {
  display: flex;
  align-items: center;
  margin-bottom: 10px;
}

.comment-content {
  background-color: #f0f0f0;
  border-radius: 10px;
  padding: 10px;
  flex: 1;
}

.add-comment-button {
  background-color: #2a9d8f;
  color: white;
  border: none;
  border-radius: 5px;
  padding: 5px 10px;
  cursor: pointer;
}

.add-comment-button:hover {
  background-color: #21867a;
}

/* Post menu dropdown */
.post-menu-dropdown {
  position: relative;
}

.post-menu-dropdown button {
  display: block;
  width: 100%;
  padding: 10px;
  background: none;
  border: none;
  text-align: left;
  cursor: pointer;
}

.post-menu-dropdown button:hover {
  background: #f0f0f0;
}

/* Update button */
.update-button {
  background-color: #4caf50;
  color: white;
  border: none;
  border-radius: 5px;
  padding: 5px 10px;
  cursor: pointer;
}

.update-button:hover {
  background-color: #45a049;
}

/* Delete button */
.delete-button {
  background-color: #e74c3c;
  color: white;
  border: none;
  border-radius: 5px;
  padding: 5px 10px;
  cursor: pointer;
}

.delete-button:hover {
  background-color: #c0392b;
}

/* Additional styles */
.card {
  display: flex;
  flex-direction: column;
  background-color: white;
  border-radius: 1rem;
  padding: 1.5rem;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  width: 100%;
}

.mood-tracker-card {
  background: linear-gradient(109.6deg, rgb(0, 204, 130) 11.2%, rgb(58, 181, 46) 91.7%);
}

.character-selector span {
  font-size: 1.8rem;
  cursor: pointer;
  margin: 0 15px;
  position: relative;
}

.post-form {
  margin-bottom: 20px;
  width: 100%;
}

.post-input {
  width: 100%;
  height: 100px;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 5px;
  resize: none;
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

.comment-author {
  font-weight: bold;
}

.comment-input {
  width: 100%;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 5px;
  resize: none;
  margin-bottom: 10px;
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

.reaction-type {
  margin-left: 5px;
}

.modal-content {
  max-height: 400px;
  overflow-y: auto;
}

.post-menu {
  position: relative;
  margin-left: auto;
}

.post-menu-button {
  background: none;
  border: none;
  cursor: pointer;
  font-size: 1.5rem;
}

.edit-textarea {
  width: 100%;
  height: 100px;
  border: 1px solid #ddd;
  border-radius: 5px;
  padding: 10px;
  margin-bottom: 10px;
}
.image-upload {
  margin: 10px 0;
}

.hidden {
  display: none;
}

.upload-btn {
  background-color: #4a9eff;
  color: white;
  padding: 8px 16px;
  border-radius: 5px;
  border: none;
  cursor: pointer;
}

.image-preview {
  position: relative;
  margin-top: 10px;
  max-width: 300px;
}

.image-preview img {
  width: 100%;
  height: auto;
  border-radius: 5px;
}

.remove-image {
  position: absolute;
  top: -10px;
  right: -10px;
  background: red;
  color: white;
  border: none;
  border-radius: 50%;
  width: 24px;
  height: 24px;
  cursor: pointer;
}

.post-image {
  max-width: 100%;
  height: auto;
  margin-top: 10px;
  border-radius: 8px;
  object-fit: contain;
}
</style>