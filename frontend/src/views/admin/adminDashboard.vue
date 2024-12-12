<template>
  <Navbar />
    <h2 class="text-center">User Feedback</h2>
 
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
/* General Layout */
.container {
max-width: 1200px;
margin: 0 auto;
padding: 20px;
}


h2 {
font-family: 'Poppins', sans-serif;
font-weight: 600;
font-size: 2rem;
text-transform: uppercase;
text-align: center;
margin: 5;
}

/* Table Styling */
.table-container {
background-color: #ffffff;
padding: 20px;
border-radius: 8px;
box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.table {
border-collapse: collapse;
margin-top: 10px;
width: 100%;
}

.table th {
background-color: #343a40;
color: #ffffff;
font-size: 16px;
font-weight: bold;
text-align: center;
padding: 12px 15px;
text-transform: uppercase;
}

.table td {
font-size: 14px;
text-align: center;
padding: 10px 12px;
color: #555555;
}

.table-hover tbody tr:hover {
background-color: #f1f1f1;
}

/* Borders and Spacing */
.table-bordered th,
.table-bordered td {
border: 1px solid #dee2e6;
}

.table-bordered {
border-radius: 8px;
overflow: hidden;
}

/* Responsive Table */
.table-responsive {
overflow-x: auto;
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