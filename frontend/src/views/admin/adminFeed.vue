<template>
  <div>
    <NavbarAdmin />
    <div class="feed-container">
      <h1 class="feed-title">Admin Feed</h1>
      <div v-if="successMessage" class="success-message">{{ successMessage }}</div>
      <div class="posts-list">
        <div v-if="posts.length === 0" class="no-posts">No posts available.</div>
        <div v-for="post in posts" :key="post.id" class="post">
          <div class="post-header">
            <img 
              :src="getProfilePicture(post.profile_picture)" 
              :alt="post.username" 
              class="author-avatar" 
            />
            <div class="author-info">
              <span class="author-name">{{ post.username }}</span>
              <span class="post-date">{{ formatDate(post.created_at) }}</span>
            </div>
            <span 
              v-if="post.emotion" 
              class="post-emotion"
            >
              {{ post.emotion }}
            </span>
          </div>
          <p class="post-content">{{ post.content }}</p>
          <div class="post-actions">
            <button @click="confirmDelete(post.id)" class="button delete-button">Delete</button>
            <button @click="fetchReactions(post.id)" class="button">Reactions ({{ post.reactions_count }})</button>
            <button @click="fetchComments(post.id)" class="button">Comments ({{ post.comments_count }})</button>
            <button @click="analyzeSentiment(post)" class="button">Analyze Sentiment</button>
          </div>
        </div>
      </div>
    </div>
    <Modal :show="showReactionsModal" @close="showReactionsModal = false">
      <div class="modal-content">
        <h2>Reactions</h2>
        <div class="reaction-tabs">
          <button 
            v-for="type in reactionTypes" 
            :key="type" 
            @click="selectedReactionType = type" 
            :class="{ 'active-tab': selectedReactionType === type }"
            class="reaction-tab"
          >
            {{ type }}
          </button>
        </div>
        <ul>
          <li v-for="reaction in filteredReactions" :key="reaction.id" class="reaction">
            <img :src="getProfilePicture(reaction.profile_picture)" class="reaction-author-avatar" />
            <span class="reaction-author">{{ reaction.username }}</span>
            <span class="reaction-type">{{ reaction.reaction_type }}</span>
          </li>
        </ul>
      </div>
    </Modal>
    <Modal :show="showCommentsModal" @close="showCommentsModal = false">
      <div class="modal-content">
        <h2>Comments</h2>
        <ul>
          <li v-for="comment in comments" :key="comment.id" class="comment">
            <img :src="getProfilePicture(comment.profile_picture)" class="comment-author-avatar" />
            <span class="comment-author">{{ comment.username }}</span>
            <span class="comment-content">{{ comment.content }}</span>
          </li>
        </ul>
      </div>
    </Modal>
    <Modal :show="showSentimentModal" @close="showSentimentModal = false">
    <div class="modal-content">
      <h2>Sentiment Analysis</h2>
      <div class="sentiment-results">
        <div class="sentiment-header">
          <span :class="['sentiment-badge', sentiment.toLowerCase()]">
            {{ sentiment }} ({{ confidence }}% confidence)
          </span>
        </div>
        
        <div class="content-section">
          <p><strong>Original Content:</strong><br>{{ currentPost?.content }}</p>
          <p v-if="translatedContent && translatedContent !== currentPost?.content">
            <strong>Translated Content:</strong><br>{{ translatedContent }}
          </p>
        </div>

        <div class="emotions-breakdown">
          <h3>Emotion Analysis:</h3>
          <div v-for="emotion in emotions" :key="emotion.emotion" class="emotion-bar">
            <span class="emotion-label">{{ emotion.emotion }}</span>
            <div class="progress-container">
              <div class="progress" :style="{ width: emotion.confidence + '%' }"></div>
            </div>
            <span class="confidence-value">{{ Math.round(emotion.confidence) }}%</span>
          </div>
        </div>
      </div>
    </div>
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
      currentPost: null,
      successMessage: '',
      showReactionsModal: false,
      showCommentsModal: false,
      showSentimentModal: false,
      reactions: [],
      comments: [],
      sentiment: '',
      translatedContent: '',
      selectedReactionType: 'Like',
      reactionTypes: ['Like', 'Heart', 'Haha', 'Care', 'Sad'],
      confidence: 0,
      emotions: [],
    };
  },
  computed: {
    filteredReactions() {
      return this.reactions.filter(reaction => reaction.reaction_type === this.selectedReactionType);
    }
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
    async fetchReactions(postId) {
      try {
        const token = localStorage.getItem('token');
        const response = await axios.get(`http://localhost:5000/posts/${postId}/reactions`, {
          headers: { Authorization: `Bearer ${token}` },
        });
        this.reactions = response.data;
        this.showReactionsModal = true;
      } catch (error) {
        console.error('Failed to fetch reactions:', error);
      }
    },
    async fetchComments(postId) {
      try {
        const token = localStorage.getItem('token');
        const response = await axios.get(`http://localhost:5000/posts/${postId}/comments`, {
          headers: { Authorization: `Bearer ${token}` },
        });
        this.comments = response.data;
        this.showCommentsModal = true;
      } catch (error) {
        console.error('Failed to fetch comments:', error);
      }
    },
    async analyzeSentiment(post) {
      try {
        this.currentPost = post;
        const response = await axios.post('http://localhost:5001/analyze-sentiment', {
          content: post.content,
        });
        this.sentiment = response.data.sentiment;
        this.confidence = response.data.confidence;
        this.emotions = response.data.emotions;
        this.translatedContent = response.data.translated_content;
        this.showSentimentModal = true;
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
@import url('https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap');

body {
  font-family: 'Roboto', sans-serif;
}

.feed-container {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
  font-family: 'Roboto', sans-serif;
  background-color: #f9f9f9;
  border-radius: 10px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.feed-title {
  text-align: center;
  color: #333;
  margin-bottom: 20px;
  font-size: 2rem;
  font-weight: 500;
}

.success-message {
  text-align: center;
  color: #28a745;
  margin-bottom: 20px;
  font-size: 1rem;
}

.no-posts {
  text-align: center;
  color: #999;
  font-size: 1.2rem;
}

.posts-list {
  margin-top: 20px;
}

.post {
  background-color: white;
  border: 1px solid #ddd;
  border-radius: 10px;
  padding: 20px;
  margin-bottom: 20px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
}

.post-header {
  display: flex;
  align-items: center;
  margin-bottom: 15px;
}

.author-avatar {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  margin-right: 15px;
  object-fit: cover;
}

.author-info {
  flex-grow: 1;
}

.author-name {
  font-weight: 500;
  font-size: 1.1rem;
  color: #333;
}

.post-date {
  color: #999;
  font-size: 0.9rem;
}

.post-emotion {
  background-color: #e0f7fa;
  color: #00796b;
  border-radius: 20px;
  padding: 5px 10px;
  font-size: 0.8rem;
}

.post-content {
  margin-bottom: 15px;
  font-size: 1rem;
  color: #555;
}

.post-actions {
  display: flex;
  align-items: center;
  gap: 10px;
}

.button {
  background-color: #00796b;
  color: white;
  border: none;
  border-radius: 5px;
  padding: 10px 15px;
  cursor: pointer;
  font-size: 0.9rem;
  transition: background-color 0.3s;
}

.button:hover {
  background-color: #004d40;
}

.delete-button {
  background-color: #e74c3c;
}

.delete-button:hover {
  background-color: #c0392b;
}

.modal-content {
  max-height: 400px;
  overflow-y: auto;
  padding: 20px;
  background-color: white;
  border-radius: 10px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.reaction, .comment {
  display: flex;
  align-items: center;
  margin-bottom: 10px;
}

.reaction-author-avatar, .comment-author-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  margin-right: 10px;
  object-fit: cover;
}

.reaction-author, .comment-author {
  font-weight: 500;
  color: #333;
}

.reaction-type, .comment-content {
  margin-left: 10px;
  color: #555;
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
.sentiment-results {
  padding: 15px;
}

.sentiment-badge {
  padding: 4px 8px;
  border-radius: 4px;
  font-weight: 500;
  text-transform: capitalize;
}

.sentiment-badge.positive {
  background-color: #4caf50;
  color: white;
}

.sentiment-badge.negative {
  background-color: #f44336;
  color: white;
}

.sentiment-badge.neutral {
  background-color: #9e9e9e;
  color: white;
}

.emotion-breakdown {
  margin-top: 20px;
}

.emotion-bar {
  display: flex;
  align-items: center;
  margin: 8px 0;
  gap: 10px;
}

.emotion-label {
  width: 100px;
  text-transform: capitalize;
}

.progress-bar {
  flex-grow: 1;
  height: 20px;
  background-color: #f0f0f0;
  border-radius: 10px;
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  background-color: #2196f3;
  transition: width 0.3s ease;
}

.emotion-score {
  width: 50px;
  text-align: right;
}
</style>