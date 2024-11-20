<template>
    <div>
      <Navbar />
      <div class="container mt-5">
        <div class="card shadow-lg p-4 bg-light">
          <h2 class="text-center text-success mb-4">Admin Dashboard</h2>
          <p class="text-center text-muted mb-4">
            View feedback and issues sent by users to improve their experience.
          </p>
  
          <div v-if="feedbacks.length === 0" class="text-center text-muted">
            <p>No feedbacks received yet.</p>
          </div>
  
          <div v-else>
            <div v-for="feedback in feedbacks" :key="feedback.feedback_id" class="feedback-card mb-3">
              <div class="card border-0 shadow-sm p-3">
                <div class="d-flex justify-content-between">
                  <div>
                    <h5 class="fw-bold text-success">{{ feedback.feedback_type }}</h5>
                    <p class="text-muted mb-1">Submitted by: {{ feedback.student_id }}</p>
                  </div>
                  <small class="text-muted">{{ formatDate(feedback.created_at) }}</small>
                </div>
                <p class="mt-2">{{ feedback.feedback_content }}</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  import Navbar from '../../components/NavbarAdmin.vue';
  
  export default {
    name: 'AdminDashboard',
    components: { Navbar },
    data() {
      return {
        feedbacks: [], // Array to hold feedbacks
      };
    },
    methods: {
      async fetchFeedbacks() {
        try {
          const response = await fetch('http://localhost:5000/api/feedback'); // Adjust the API endpoint as needed
          if (!response.ok) throw new Error('Failed to fetch feedback data.');
          this.feedbacks = await response.json();
        } catch (error) {
          console.error('Error fetching feedbacks:', error);
        }
      },
      formatDate(date) {
        const options = { year: 'numeric', month: 'long', day: 'numeric' };
        return new Date(date).toLocaleDateString(undefined, options);
      },
    },
    mounted() {
      this.fetchFeedbacks();
    },
  };
  </script>
  
  <style scoped>
  .container {
    max-width: 800px;
    margin: auto;
  }
  
  .card {
    border-radius: 15px;
    background: linear-gradient(135deg, #f8fff4, #e6f7e9);
  }
  
  .feedback-card .card {
    transition: transform 0.2s ease;
  }
  
  .feedback-card .card:hover {
    transform: scale(1.02);
  }
  
  h2 {
    font-family: 'Poppins', sans-serif;
    font-weight: bold;
    letter-spacing: 1px;
  }
  
  .text-success {
    color: #28a745 !important;
  }
  
  .text-muted {
    color: #6c757d !important;
  }
  
  .shadow-lg {
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1) !important;
  }
  </style>
  