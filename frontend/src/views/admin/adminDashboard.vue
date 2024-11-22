<template>
  <div>
    <Navbar />
    <div class="container mt-5">
      <h2 class="text-center mb-4">User Feedback</h2>
      <div class="table-responsive">
        <table class="table table-bordered table-hover">
          <thead class="thead-dark">
            <tr>
              <th>Feedback ID</th>
              <th>Student ID</th>
              <th>Feedback Type</th>
              <th>Feedback Content</th>
              <th>Created At</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="feedback in feedbacks" :key="feedback.feedback_id">
              <td>{{ feedback.feedback_id }}</td>
              <td>{{ feedback.student_id }}</td>
              <td>{{ feedback.feedback_type }}</td>
              <td>{{ feedback.feedback_content }}</td>
              <td>{{ new Date(feedback.created_at).toLocaleString() }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script>
import Navbar from '../../components/NavbarAdmin.vue';
import axios from 'axios';
import { ref, onMounted } from 'vue';

export default {
  name: 'AdminDashboard',
  components: { Navbar },
  setup() {
    const feedbacks = ref([]);

    const fetchFeedbacks = async () => {
      try {
        const token = localStorage.getItem('token');
        const response = await axios.get('http://localhost:5000/api/feedback/all', {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        });
        console.log('Fetched feedbacks:', response.data);
        feedbacks.value = response.data;
      } catch (error) {
        console.error('Error fetching feedbacks:', error);
      }
    };

    onMounted(() => {
      fetchFeedbacks();
    });

    return {
      feedbacks,
    };
  },
};
</script>

<style scoped>
.container {
  max-width: 900px;
  margin: 0 auto;
  padding: 20px;
  background-color: #f8f9fa;
  border-radius: 8px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

h2 {
  font-family: 'Poppins', sans-serif;
  font-weight: 600;
  color: #343a40;
}

.table {
  margin-top: 20px;
  border-collapse: separate;
  border-spacing: 0 10px;
}

.table thead {
  background-color: #343a40;
  color: #fff;
}

.table th,
.table td {
  padding: 12px 15px;
  vertical-align: middle;
}

.table-hover tbody tr:hover {
  background-color: #e9ecef;
}

.table-responsive {
  overflow-x: auto;
}

.table-bordered th,
.table-bordered td {
  border: 1px solid #dee2e6;
}

.table-bordered {
  border: 1px solid #dee2e6;
  border-radius: 8px;
  overflow: hidden;
}

.table th:first-child,
.table td:first-child {
  border-top-left-radius: 8px;
  border-bottom-left-radius: 8px;
}

.table th:last-child,
.table td:last-child {
  border-top-right-radius: 8px;
  border-bottom-right-radius: 8px;
}
</style>