<template>
  <Navbar :isLoggedIn="isLoggedIn" :username="username" :profilePicture="userInfo.profile_picture" />
  <div>
    <div class="container mt-5 d-flex justify-content-center">
      <div class="card shadow-lg p-4 bg-light" style="max-width: 600px; width: 100%;">
        <h2 class="text-success text-center mb-4">Submit Your Feedback</h2>
        <form @submit.prevent="submitFeedback">
          <div class="mb-4">
            <label for="feedbackType" class="form-label fw-bold">Feedback Type</label>
            <select
              v-model="feedback.type"
              id="feedbackType"
              class="form-select shadow-sm"
              required
            >
              <option value="suggestion">Suggestion</option>
              <option value="issue">Issue</option>
            </select>
          </div>
          <div class="mb-4">
            <label for="feedbackContent" class="form-label fw-bold">Feedback Content</label>
            <textarea
              v-model="feedback.content"
              id="feedbackContent"
              class="form-control shadow-sm"
              rows="5"
              placeholder="Enter your feedback here..."
              required
            ></textarea>
          </div>
          <button type="submit" class="btn btn-success w-100 py-2 shadow-sm hover-shadow">
            Submit Feedback
          </button>
        </form>
        <div
          v-if="message"
          class="alert mt-4"
          :class="messageType === 'success' ? 'alert-success' : 'alert-danger'"
          role="alert"
        >
          {{ message }}
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import Navbar from '../../components/Navbar.vue';
import axios from 'axios';

export default {
  name: 'FeedbackForm',
  components: {
    Navbar
  },
  setup() {
    const feedback = ref({
      type: 'suggestion',
      content: ''
    });
    const message = ref('');
    const messageType = ref('');
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
  max-width: 700px;
  margin: 0 auto;
  background: linear-gradient(135deg, #f0f9ff, #cbebff);
  padding: 2rem;
  border-radius: 15px;
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
  animation: fadeIn 1s ease-out;
}

.card {
  border-radius: 15px;
  background-color: #ffffff;
  border: 1px solid #ddd;
  transition: transform 0.3s ease-in-out;
}

.card:hover {
  transform: translateY(-5px);
}

h2 {
  font-family: 'Poppins', sans-serif;
  font-weight: bold;
  letter-spacing: 1px;
  color: #28a745;
}

.btn-success {
  background-color: #28a745;
  border: none;
  font-weight: bold;
  border-radius: 6px;
  transition: background-color 0.3s ease;
}

.btn-success:hover {
  background-color: #218838;
}

.form-select,
.form-control {
  border: 1px solid #ced4da;
  border-radius: 8px;
  padding: 0.75rem;
  transition: border-color 0.3s ease;
}

.form-select:focus,
.form-control:focus {
  border-color: #28a745;
  box-shadow: 0 0 5px rgba(40, 167, 69, 0.3);
}

.alert-success {
  background-color: #d4edda;
  color: #155724;
  border-color: #c3e6cb;
  border-radius: 6px;
}

.alert-danger {
  background-color: #f8d7da;
  color: #721c24;
  border-color: #f5c6cb;
  border-radius: 6px;
}

.shadow-sm {
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.hover-shadow:hover {
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
}

@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}
</style>