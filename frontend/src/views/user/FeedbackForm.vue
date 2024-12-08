<template>
  <Navbar :isLoggedIn="isLoggedIn" :username="username" :profilePicture="userInfo.profile_picture" />
  <div>
    <div class="container mt-5">
      <h2 class="text-center mb-4">Submit Your Feedback</h2>
      
      <form @submit.prevent="submitFeedback">
        <!-- Feedback Type -->
        <div class="mb-4">
          <label for="feedbackType" class="form-label">Feedback Type</label>
          <select v-model="feedback.type" id="feedbackType" class="form-select" required>
            <option value="suggestion">Suggestion</option>
            <option value="issue">Issue</option>
          </select>
        </div>
        
        <!-- Feedback Content -->
        <div class="mb-4">
          <label for="feedbackContent" class="form-label">Feedback Content</label>
          <textarea 
            v-model="feedback.content" 
            id="feedbackContent" 
            class="form-control" 
            rows="5" 
            placeholder="Enter your feedback here..." 
            required
          ></textarea>
        </div>

        <!-- Submit Button -->
        <button type="submit" class="btn btn-success w-100 py-2">Submit Feedback</button>
      </form>

      <!-- Message -->
      <div v-if="message" class="mt-4">
        <div 
          :class="messageType === 'success' ? 'alert alert-success' : 'alert alert-danger'" 
          role="alert"
        >
          {{ message }}
        </div>
      </div>
    </div>
  </div>
  <Footer />
</template>

<script>
import { ref, onMounted } from 'vue';
import Navbar from '../../components/Navbar.vue';
import axios from 'axios';
import Footer from "@/components/Footer.vue";

export default {
  name: 'FeedbackForm',
  components: {
    Navbar,
    Footer
  },
  setup() {
    const feedback = ref({
      type: 'suggestion',
      content: ''
    });
    const message = ref('');
    const messageType = ref(''); // success or error message type
    const isLoggedIn = ref(false);
    const username = ref('');
    const userInfo = ref({});

    const submitFeedback = async () => {
      try {
        const token = localStorage.getItem('token');
        const response = await fetch('http://localhost:5000/api/feedback', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${token}`
          },
          body: JSON.stringify(feedback.value)
        });

        if (response.ok) {
          const data = await response.json();
          message.value = data.message;
          messageType.value = 'success';
          feedback.value = { type: 'suggestion', content: '' };
        } else {
          const errorData = await response.json();
          message.value = errorData.message || 'Failed to submit feedback. Please try again.';
          messageType.value = 'error';
        }
      } catch (error) {
        console.error('Error submitting feedback:', error);
        message.value = 'An error occurred. Please try again later.';
        messageType.value = 'error';
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
    });

    return {
      feedback,
      message,
      messageType,
      isLoggedIn,
      username,
      userInfo,
      submitFeedback
    };
  }
};
</script>

<style scoped>

.container {
  max-width: 600px;
  margin: 0 auto;
  background: #f9f9f9;
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

h2 {
  font-size: 1.75rem;
  font-weight: bold;
  color: #333;
}

.form-label {
  font-weight: 500;
  color: #555;
}

.form-select, .form-control {
  width: 100%;
  padding: 0.85rem;
  margin-bottom: 1rem;
  border: 1px solid #ccc;
  border-radius: 8px;
  transition: border-color 0.3s ease;
}

.form-select:focus, 
.form-control:focus {
  border-color: #28a745;
  outline: none;
}

.btn-success {
  width: 100%;
  padding: 0.75rem;
  background-color: #28a745;
  border: none;
  color: white;
  font-size: 1rem;
  font-weight: bold;
  border-radius: 8px;
  transition: background-color 0.3s ease;
}

.btn-success:hover {
  background-color: #218838;
}

.alert {
  margin-top: 1rem;
  border-radius: 8px;
}

.alert-success {
  background-color: #e9f7ef;
  color: #155724;
  border: 1px solid #c3e6cb;
}

.alert-danger {
  background-color: #fce4e4;
  color: #721c24;
  border: 1px solid #f5c6cb;
}
</style>
