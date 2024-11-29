<template>
  <Navbar :isLoggedIn="isLoggedIn" :username="username" :profilePicture="userInfo.profile_picture" />
  <div class="feed-container">
    <h1 class="feed-title">Mental Health Support Network</h1>
    
    <h2 class="text-xl font-semibold mb-4 text-green-800">How are you feeling today?</h2>
    <div class="flex justify-between mb-4 bg-white rounded-lg shadow-md p-6">
      <button
        v-for="emotion in emotions"
        :key="emotion"
        @click="selectEmotion(emotion)"
        :class="[
          'px-4 py-2 rounded-full transition-colors',
          selectedEmotion === emotion ? 'bg-green-500 text-white' : 'bg-green-100 text-green-800 hover:bg-green-200'
        ]"
      >
        {{ emotion }}
      </button>
    </div>
  
    <!-- Announcements Section -->
    <div class="announcements-section mb-6">
      <h2 class="text-xl font-semibold mb-4 text-green-800">Announcements</h2>
      <div v-for="announcement in announcements" :key="announcement.id" class="bg-white rounded-lg shadow-md p-4 mb-4">
        <h3 class="font-bold text-lg mb-2">{{ announcement.title }}</h3>
        <p class="text-gray-700">{{ announcement.content }}</p>
        <p class="text-sm text-gray-500 mt-2">Posted on: {{ formatDate(announcement.createdAt) }}</p>
      </div>
    </div>

    <!-- Post creation form -->
    <div class="post-form">
      <textarea v-model="newPostContent" placeholder="Share your thoughts..." class="post-input"></textarea>
      <button @click="createPost" class="post-button">Post</button>
    </div>

    <!-- List of posts -->
    <div class="posts-list">
      <div v-for="post in posts" :key="post.id" class="post">
        <div class="post-header">
          <img :src="post.authorAvatar" :alt="post.authorName" class="author-avatar" />
          <span class="author-name">{{ post.authorName }}</span>
        </div>
        <p class="post-content">{{ post.content }}</p>
        <div class="post-actions">
          <button @click="reactToPost(post.id)" class="action-button">
            {{ post.reacted ? '❤️' : '🤍' }} {{ post.reactions }}
          </button>
          <button @click="toggleComments(post.id)" class="action-button">
            💬 {{ post.comments.length }}
          </button>
        </div>
        <div v-if="post.showComments" class="comments-section">
          <div v-for="comment in post.comments" :key="comment.id" class="comment">
            <span class="comment-author">{{ comment.authorName }}:</span>
            <span class="comment-content">{{ comment.content }}</span>
          </div>
          <div class="comment-form">
            <input v-model="newComments[post.id]" placeholder="Add a comment..." class="comment-input" />
            <button @click="addComment(post.id)" class="comment-button">Send</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, reactive, onMounted } from 'vue';
import Navbar from '../../components/Navbar.vue';
import axios from 'axios';
import Modal from '../../components/Modal.vue';

export default {
  components: {
    Navbar,
    Modal,
  },
  setup() {
    const newPostContent = ref('');
    const newComments = reactive({});
    const posts = ref([]);
    const isLoggedIn = ref(false);
    const username = ref('');
    const userInfo = ref({});
    const emotions = ['Happy', 'Sad', 'Anxious', 'Calm', 'Stressed'];
    const selectedEmotion = ref(null);
    const announcements = ref([]);

    const selectEmotion = (emotion) => {
      selectedEmotion.value = emotion;
    };

    const fetchPosts = async () => {
      try {
        const response = await axios.get('http://localhost:5000/posts');
        posts.value = response.data;
      } catch (error) {
        console.error('Failed to fetch posts:', error);
      }
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

        // Fetch posts
        await fetchPosts();

      // Fetch announcements
      try {
        const response = await axios.get('http://localhost:5000/announcements');
        announcements.value = response.data;
      } catch (error) {
        console.error('Failed to fetch announcements:', error);
      }
    });

    
    const createPost = () => {
      if (newPostContent.value.trim()) {
        const newPost = {
          id: Date.now(),
          authorName: username.value,
          authorAvatar: userInfo.value.profile_picture 
            ? `http://localhost:5000${userInfo.value.profile_picture}`
            : require('@/assets/defaultProfile.png'),
          content: newPostContent.value,
          reactions: 0,
          reacted: false,
          comments: [],
          showComments: false
        };
        posts.value.unshift(newPost);
        newPostContent.value = '';
      }
    };

    const reactToPost = (postId) => {
      const post = posts.value.find(p => p.id === postId);
      if (post) {
        if (post.reacted) {
          post.reactions--;
        } else {
          post.reactions++;
        }
        post.reacted = !post.reacted;
      }
    };

    const toggleComments = (postId) => {
      const post = posts.value.find(p => p.id === postId);
      if (post) {
        post.showComments = !post.showComments;
      }
    };

    const addComment = (postId) => {
      const post = posts.value.find(p => p.id === postId);
      if (post && newComments[postId]?.trim()) {
        post.comments.push({
          id: Date.now(),
          authorName: username.value,
          content: newComments[postId]
        });
        newComments[postId] = '';
      }
    };

    const formatDate = (dateString) => {
      const options = { year: 'numeric', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit' };
      return new Date(dateString).toLocaleDateString(undefined, options);
    };

    return {
      newPostContent,
      newComments,
      posts,
      createPost,
      reactToPost,
      toggleComments,
      addComment,
      isLoggedIn,
      username,
      userInfo,
      emotions,
      selectedEmotion,
      selectEmotion,
      announcements,
      formatDate
    };
  }
};
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

.comments-section {
  margin-top: 10px;
  border-top: 1px solid #ddd;
  padding-top: 10px;
}

.comment {
  margin-bottom: 5px;
}

.comment-author {
  font-weight: bold;
  margin-right: 5px;
}

.comment-form {
  display: flex;
  margin-top: 10px;
}

.comment-input {
  flex-grow: 1;
  padding: 5px;
  border: 1px solid #ddd;
  border-radius: 3px;
}

.comment-button {
  margin-left: 5px;
  padding: 5px 10px;
  background-color: #2a9d8f;
  color: white;
  border: none;
  border-radius: 3px;
  cursor: pointer;
}

.announcements-section {
  background-color: #e9f5f3;
  border-radius: 5px;
  padding: 15px;
  margin-bottom: 20px;
}
</style>