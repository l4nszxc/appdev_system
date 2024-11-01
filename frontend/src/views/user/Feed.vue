<template>
  <div class="feed-container">
    <h1 class="feed-title">Mental Health Support Network</h1>
    
    <!-- Post creation form -->
    <div class="post-form">
      <textarea v-model="newPostContent" placeholder="Share your thoughts..." class="post-input"></textarea>
      <button @click="createPost" class="post-button">Post</button>
    </div>

    <!-- List of posts -->
    <div class="posts-list">
      <div v-for="post in posts" :key="post.id" class="post">
        <div class="post-header">
          <img :src="post.authorAvatar" :alt="post.authorName" class="authogit pusr-avatar" />
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
import { ref, reactive } from 'vue'

export default {
  setup() {
    const newPostContent = ref('')
    const newComments = reactive({})
    const posts = ref([
      {
        id: 1,
        authorName: 'Jane Doe',
        authorAvatar: '/placeholder.svg?height=40&width=40',
        content: 'Just had a great therapy session. Feeling optimistic!',
        reactions: 5,
        reacted: false,
        comments: [
          { id: 1, authorName: 'John Smith', content: 'That\'s wonderful to hear!' }
        ],
        showComments: false
      },
      {
        id: 2,
        authorName: 'Alex Johnson',
        authorAvatar: '/placeholder.svg?height=40&width=40',
        content: 'Struggling with anxiety today. Any tips?',
        reactions: 3,
        reacted: false,
        comments: [],
        showComments: false
      }
    ])

    const createPost = () => {
      if (newPostContent.value.trim()) {
        posts.value.unshift({
          id: Date.now(),
          authorName: 'Current User',
          authorAvatar: '/placeholder.svg?height=40&width=40',
          content: newPostContent.value,
          reactions: 0,
          reacted: false,
          comments: [],
          showComments: false
        })
        newPostContent.value = ''
      }
    }

    const reactToPost = (postId) => {
      const post = posts.value.find(p => p.id === postId)
      if (post) {
        if (post.reacted) {
          post.reactions--
        } else {
          post.reactions++
        }
        post.reacted = !post.reacted
      }
    }

    const toggleComments = (postId) => {
      const post = posts.value.find(p => p.id === postId)
      if (post) {
        post.showComments = !post.showComments
      }
    }

    const addComment = (postId) => {
      const post = posts.value.find(p => p.id === postId)
      if (post && newComments[postId]?.trim()) {
        post.comments.push({
          id: Date.now(),
          authorName: 'Current User',
          content: newComments[postId]
        })
        newComments[postId] = ''
      }
    }

    return {
      newPostContent,
      newComments,
      posts,
      createPost,
      reactToPost,
      toggleComments,
      addComment
    }
  }
}
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
</style>