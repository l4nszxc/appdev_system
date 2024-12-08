<template>
  <div>
    <NavbarAdmin />
    <div class="feed-container">
      <h1 class="feed-title">Admin Feed</h1>
      <div v-if="successMessage" class="success-message">{{ successMessage }}</div>
      <div class="posts-list">
        <div v-if="posts.length === 0">No posts available.</div>
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
            <button @click="confirmDelete(post.id)" class="delete-button">Delete Post</button>
            <button class="reaction-count-button">
              {{ post.reactions_count }} Reactions
            </button>
            <button class="comment-count-button">
              {{ post.comments_count }} Comments
            </button>
            <button @click="showSentimentModal(post)" class="sentiment-button">Analyze Sentiment</button>
          </div>
        </div>
      </div>
    </div>
    <Modal :show="showModal" @close="showModal = false">
      <h2>Sentiment Analysis</h2>
      <p>Sentiment: {{ sentiment }}</p>
      <p>Translated Content: {{ translatedContent }}</p>
    </Modal>
  </div>
</template>

<script>
import NavbarAdmin from '@/components/NavbarAdmin.vue';
import Modal from '@/components/Modal.vue';
import axios from 'axios';

export default {
  components: {
    NavbarAdmin,
    Modal,
  },
  data() {
    return {
      posts: [],
      successMessage: '',
      showModal: false,
      sentiment: '',
      translatedContent: '',
    };
  },
  methods: {
    async fetchPosts() {
      try {
        const token = localStorage.getItem('token');
        const response = await axios.get('http://localhost:5000/posts', {
          headers: { Authorization: `Bearer ${token}` },
        });
        this.posts = response.data.map(post => ({
          ...post,
          reactions_count: post.reactions.length,
        }));
      } catch (error) {
        console.error('Failed to fetch posts:', error);
      }
    },
    confirmDelete(postId) {
      if (window.confirm('Are you sure you want to delete this post?')) {
        this.deletePost(postId);
      }
    },
    async deletePost(postId) {
      try {
        const token = localStorage.getItem('token');
        const response = await axios.delete(`http://localhost:5000/posts/${postId}`, {
          headers: { Authorization: `Bearer ${token}` },
        });
        this.successMessage = 'Post deleted successfully';
        this.fetchPosts();
        setTimeout(() => {
          this.successMessage = '';
        }, 3000);
      } catch (error) {
        console.error('Failed to delete post:', error);
      }
    },
    async showSentimentModal(post) {
      try {
        console.log('Analyzing sentiment for post:', post);
        const response = await axios.post('http://localhost:5001/analyze-sentiment', {
          content: post.content,
        });
        console.log('Sentiment analysis response:', response.data);
        this.sentiment = response.data.sentiment;
        this.translatedContent = response.data.translated_content;
        console.log('Sentiment:', this.sentiment);
        console.log('Translated Content:', this.translatedContent);
        this.showModal = true;
        console.log('Show Modal:', this.showModal);
      } catch (error) {
        console.error('Failed to analyze sentiment:', error);
      }
    },
    getProfilePicture(profilePath) {
      return profilePath 
        ? `http://localhost:5000${profilePath}` 
        : '/default-avatar.png';
    },
    formatDate(dateString) {
      const date = new Date(dateString);
      return date.toLocaleString();
    },
  },
  created() {
    this.fetchPosts();
  },
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
  color: #000000;
  margin-bottom: 20px;
}

.success-message {
  text-align: center;
  color: #28a745;
  margin-bottom: 20px;
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

.delete-button {
  background-color: #e74c3c;
  color: white;
  border: none;
  border-radius: 5px;
  padding: 5px 10px;
  cursor: pointer;
}

.reaction-count-button, .comment-count-button {
  background-color: #2a9d8f;
  color: white;
  border: none;
  border-radius: 5px;
  padding: 5px 10px;
  cursor: pointer;
}
</style>