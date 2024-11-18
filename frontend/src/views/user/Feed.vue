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
        :class="[
          'px-4 py-2 rounded-full transition-colors',
          selectedEmotion === emotion ? 'bg-green-500 text-white' : 'bg-green-100 text-green-800 hover:bg-green-200',
        ]"
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
          <button 
            @click="toggleReaction(post.id)" 
            class="action-button flex items-center"
          >
            <span>❤️</span>
            <span class="ml-1">{{ post.reactions }}</span>
          </button>
          <button 
            @click="toggleComments(post)" 
            class="action-button flex items-center"
          >
            <span>💬</span>
            <span class="ml-1">{{ post.comments_count }}</span>
          </button>
        </div>
        
        <div v-if="post.showComments" class="comments-section">
          <div v-for="comment in post.comments" :key="comment.id" class="comment flex items-center mb-2">
            <img 
              :src="getProfilePicture(comment.profile_picture)" 
              :alt="comment.username" 
              class="w-8 h-8 rounded-full mr-2"
            />
            <div>
              <span class="font-bold mr-2">{{ comment.username }}</span>
              <span>{{ comment.content }}</span>
            </div>
          </div>
          <div class="comment-form flex mt-2">
            <input 
              v-model="newComments[post.id]" 
              placeholder="Add a comment..." 
              class="flex-grow mr-2 p-2 border rounded"
              @keyup.enter="addComment(post.id)"
            />
            <button 
              @click="addComment(post.id)" 
              class="bg-green-500 text-white px-4 py-2 rounded"
              :disabled="!newComments[post.id]"
            >
              Send
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, reactive, computed } from 'vue';
import axios from 'axios';
import Navbar from '@/components/Navbar.vue';

// State variables
const posts = ref([]);
const newPostContent = ref('');
const newComments = reactive({});
const selectedEmotion = ref(null);
const emotions = ['Happy', 'Sad', 'Anxious', 'Calm', 'Stressed'];
const isLoggedIn = ref(false);
const username = ref('');
const userInfo = ref({});

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

// Fetch posts with comments
const fetchPosts = async () => {
  try {
    const token = localStorage.getItem('token');
    const response = await axios.get('http://localhost:5000/posts', {
      headers: { Authorization: `Bearer ${token}` },
    });
    
    // Fetch comments for each post
    const postsWithComments = await Promise.all(response.data.map(async (post) => {
      try {
        const commentsResponse = await axios.get(`http://localhost:5000/posts/${post.id}/comments`, {
          headers: { Authorization: `Bearer ${token}` },
        });
        return {
          ...post,
          comments: commentsResponse.data,
          showComments: false
        };
      } catch (error) {
        console.error(`Failed to fetch comments for post ${post.id}:`, error);
        return {
          ...post,
          comments: [],
          showComments: false
        };
      }
    }));

    posts.value = postsWithComments;
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

// Toggle post reaction
const toggleReaction = async (postId) => {
  try {
    const token = localStorage.getItem('token');
    await axios.post(
      `http://localhost:5000/posts/${postId}/reactions`,
      {},
      { headers: { Authorization: `Bearer ${token}` } }
    );
    await fetchPosts();
  } catch (error) {
    console.error('Failed to toggle reaction:', error);
  }
};

// Toggle comments visibility
const toggleComments = (post) => {
  post.showComments = !post.showComments;
};

// Add a comment
const addComment = async (postId) => {
  const commentContent = newComments[postId]?.trim();
  if (!commentContent) return;

  try {
    const token = localStorage.getItem('token');
    await axios.post(
      `http://localhost:5000/posts/${postId}/comments`,
      { content: commentContent },
      { headers: { Authorization: `Bearer ${token}` } }
    );
    
    // Clear comment input
    newComments[postId] = '';
    
    // Refresh posts to get updated comments
    await fetchPosts();
  } catch (error) {
    console.error('Failed to add comment:', error);
  }
};

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
/* Existing styles from the previous component */
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
  gap: 10px;
}

.action-button {
  background: none;
  border: none;
  cursor: pointer;
  font-size: 16px;
}
</style>