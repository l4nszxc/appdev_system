<template>
  <Navbar :isLoggedIn="isLoggedIn" :username="username" :profilePicture="userInfo.profile_picture" />
  <div class="feed-container">
    <h1 class="feed-title">Mental Health Support Network</h1>

    <h2 class="text-xl font-semibold mb-4 text-green-800">How are you feeling today?</h2>
    <div class="flex justify-between mb-4 bg-white rounded-lg shadow-md p-6">
      <button
        v-for="emotion in emotions"
        :key="emotion"
        @click="selectedEmotion = emotion"
        :class="[selectedEmotion === emotion ? 'bg-green-500 text-white' : 'bg-green-100 text-green-800 hover:bg-green-200', 'px-4 py-2 rounded-full transition-colors']"
      >
        {{ emotion }}
      </button>
    </div>

    <div class="post-form">
      <textarea 
        v-model="newPostContent" 
        placeholder="Share your thoughts..." 
        class="post-input"
      ></textarea>
      <button 
        @click="createPost" 
        class="post-button" 
        :disabled="!newPostContent.trim() || !selectedEmotion"
      >
        Post
      </button>
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
          <span 
            v-if="post.emotion" 
            class="ml-2 px-2 py-1 bg-green-100 text-green-800 rounded-full text-xs"
          >
            {{ post.emotion }}
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
              <button @click="addReaction(post.id, 'Angry')" class="reaction-option">😡 Angry</button>
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

    <Modal :show="showCommentsModal" @close="closeCommentsModal">
      <div class="modal-content">
        <h2>Comments</h2>
        <div v-for="comment in currentPost.comments" :key="comment.id" class="comment">
          <img 
            :src="getProfilePicture(comment.profile_picture)" 
            :alt="comment.username" 
            class="comment-author-avatar" 
          />
          <span class="comment-author">{{ comment.username }}</span>
          <p class="comment-content">{{ comment.content }}</p>
        </div>
        <textarea v-model="currentPost.newComment" placeholder="Write a comment..." class="comment-input"></textarea>
        <button @click="addComment(currentPost.id, currentPost.newComment)" class="add-comment-button">Add Comment</button>
      </div>
    </Modal>

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
  </div>
  <Footer />
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import axios from 'axios';
import Navbar from '@/components/Navbar.vue';
import Footer from "@/components/Footer.vue";
import Modal from '@/components/Modal.vue';

// State variables
const posts = ref([]);
const newPostContent = ref('');
const selectedEmotion = ref(null);
const emotions = ['Happy', 'Sad', 'Anxious', 'Calm', 'Stressed'];
const isLoggedIn = ref(false);
const username = ref('');
const userInfo = ref({});
const showCommentsModal = ref(false);
const showReactionsModal = ref(false);
const currentPost = ref({});
const showReactions = ref(null);
const selectedReactionType = ref('Like');
const reactionTypes = ['Like', 'Heart', 'Haha', 'Care', 'Sad', 'Angry'];

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
      reactions: post.reactions || []
    }));
  } catch (error) {
    console.error('Failed to fetch posts:', error);
  }
};

// Create a new post
const createPost = async () => {
  if (!newPostContent.value.trim() || !selectedEmotion.value) return;

  try {
    const token = localStorage.getItem('token');
    await axios.post(
      'http://localhost:5000/posts',
      {
        content: newPostContent.value,
        emotion: selectedEmotion.value,
      },
      { headers: { Authorization: `Bearer ${token}` } }
    );

    // Reset form
    newPostContent.value = '';
    selectedEmotion.value = null;
    
    // Refresh posts
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

    // Refresh posts
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

    // Refresh posts
    await fetchPosts();
  } catch (error) {
    console.error('Failed to add comment:', error);
  }
};

// Open comments modal
const openCommentsModal = (post) => {
  currentPost.value = post;
  showCommentsModal.value = true;
};

// Close comments modal
const closeCommentsModal = () => {
  showCommentsModal.value = false;
};

// Open reactions modal
const openReactionsModal = (post) => {
  currentPost.value = post;
  showReactionsModal.value = true;
  selectedReactionType.value = 'Like';
};

// Close reactions modal
const closeReactionsModal = () => {
  showReactionsModal.value = false;
};

// Filter reactions by selected type
const filteredReactions = computed(() => {
  if (!currentPost.value.reactions) return [];
  return currentPost.value.reactions.filter(reaction => reaction.reaction_type === selectedReactionType.value);
});

// Date formatting utility
const formatDate = (dateString) => {
  const date = new Date(dateString);
  return date.toLocaleString();
};

// Lifecycle hook
onMounted(async () => {
  isLoggedIn.value = !!localStorage.getItem('token');
  
  if (isLoggedIn.value) {
    await fetchUserDetails();
    await fetchPosts();
  }
});
</script>

<style scoped>
.feed-container {
  max-width: 600px;
  margin: 0 auto;
  padding: 20px;
  font-family: Arial, sans-serif;
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

.comment {
  background-color: #f9f9f9;
  border: 1px solid #ddd;
  border-radius: 5px;
  padding: 10px;
  margin-bottom: 10px;
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