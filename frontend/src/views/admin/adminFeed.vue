<template>
  <NavbarAdmin/>
    <div class="admin-feed-container">
      <h1 class="admin-feed-title">Admin Dashboard - Pending Posts</h1>
      
      <div v-if="loading" class="loading">Loading...</div>
      
      <div v-else-if="error" class="error">{{ error }}</div>
      
      <div v-else class="posts-list">
        <div v-for="post in pendingPosts" :key="post.id" class="post">
          <p class="post-content">{{ post.content }}</p>
          <div class="post-actions">
            <button @click="approvePost(post.id)" class="action-button approve">
              Approve
            </button>
            <button @click="rejectPost(post.id)" class="action-button reject">
              Reject
            </button>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  import NavbarAdmin from '@/components/NavbarAdmin.vue';
import { ref, onMounted } from 'vue'
  
  export default {
    components: {
      NavbarAdmin,
    },
    setup() {
      const pendingPosts = ref([])
      const loading = ref(true)
      const error = ref(null)
  
      const fetchPendingPosts = async () => {
        try {
          const response = await fetch('/api/admin/posts')
          if (!response.ok) {
            throw new Error('Failed to fetch pending posts')
          }
          pendingPosts.value = await response.json()
          loading.value = false
        } catch (err) {
          error.value = err.message
          loading.value = false
        }
      }
  
      const approvePost = async (postId) => {
        try {
          const response = await fetch(`/api/admin/posts/${postId}/approve`, {
            method: 'POST'
          })
          if (!response.ok) {
            throw new Error('Failed to approve post')
          }
          // Remove the approved post from the list
          pendingPosts.value = pendingPosts.value.filter(post => post.id !== postId)
        } catch (err) {
          error.value = err.message
        }
      }
  
      const rejectPost = async (postId) => {
        try {
          const response = await fetch(`/api/admin/posts/${postId}/reject`, {
            method: 'POST'
          })
          if (!response.ok) {
            throw new Error('Failed to reject post')
          }
          // Remove the rejected post from the list
          pendingPosts.value = pendingPosts.value.filter(post => post.id !== postId)
        } catch (err) {
          error.value = err.message
        }
      }
  
      onMounted(fetchPendingPosts)
  
      return {
        pendingPosts,
        loading,
        error,
        approvePost,
        rejectPost
      }
    }
  }
  </script>
  
  <style scoped>
  .admin-feed-container {
    max-width: 800px;
    margin: 0 auto;
    padding: 20px;
    font-family: Arial, sans-serif;
  }
  
  .admin-feed-title {
    text-align: center;
    color: #2a9d8f;
    margin-bottom: 20px;
  }
  
  .loading, .error {
    text-align: center;
    margin-top: 20px;
    font-size: 18px;
  }
  
  .error {
    color: #e63946;
  }
  
  .posts-list {
    display: grid;
    gap: 20px;
  }
  
  .post {
    background-color: white;
    border: 1px solid #ddd;
    border-radius: 5px;
    padding: 15px;
  }
  
  .post-content {
    margin-bottom: 10px;
  }
  
  .post-actions {
    display: flex;
    gap: 10px;
  }
  
  .action-button {
    padding: 8px 16px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-weight: bold;
    transition: background-color 0.3s;
  }
  
  .approve {
    background-color: #2a9d8f;
    color: white;
  }
  
  .approve:hover {
    background-color: #238b7e;
  }
  
  .reject {
    background-color: #e63946;
    color: white;
  }
  
  .reject:hover {
    background-color: #d62f3c;
  }
  </style>