<template>
  <div>
    <NavbarAdmin />
    <div class="mood-report">
      <h1>Mood Report</h1>
      <div class="summary">
        <p><strong>Positive Moods:</strong> {{ summary.Positive }}</p>
        <p><strong>Neutral Moods:</strong> {{ summary.Neutral }}</p>
        <p><strong>Negative Moods:</strong> {{ summary.Negative }}</p>
      </div>
      <table>
        <thead>
          <tr>
            <th>Student ID</th>
            <th>Mood</th>
            <th>Sentiment</th>
            <th>Comment</th>
            <th>Created At</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="mood in moods" :key="mood.id">
            <td>{{ mood.student_id }}</td>
            <td>{{ mood.mood }}</td>
            <td>{{ mood.sentiment }}</td>
            <td>{{ mood.comment }}</td>
            <td>{{ mood.created_at }}</td>
            <td>
              <button @click="showModal('weekly', mood.student_id)">Weekly</button>
              <button @click="showModal('monthly', mood.student_id)">Monthly</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <Modal :show="isModalVisible" @close="isModalVisible = false">
      <h2>{{ modalTitle }}</h2>
      <ul>
        <li v-for="mood in modalMoods" :key="mood.created_at">
          {{ mood.created_at }} - {{ mood.mood }} ({{ mood.sentiment }})
        </li>
      </ul>
      <div class="chart-container">
        <PieChart :data="modalSummary" />
      </div>
    </Modal>
  </div>
</template>

<script>
import NavbarAdmin from '@/components/NavbarAdmin.vue';
import Modal from '@/components/Modal.vue';
import PieChart from '@/components/PieChart.vue';
import axios from 'axios';

export default {
  components: {
    NavbarAdmin,
    Modal,
    PieChart
  },
  data() {
    return {
      moods: [],
      summary: {
        Positive: 0,
        Neutral: 0,
        Negative: 0
      },
      isModalVisible: false,
      modalTitle: '',
      modalMoods: [],
      modalSummary: {
        Positive: 0,
        Neutral: 0,
        Negative: 0
      }
    };
  },
  async mounted() {
    try {
      const token = localStorage.getItem('token');
      const response = await axios.get('http://localhost:5000/moods', {
        headers: { Authorization: `Bearer ${token}` },
      });
      this.moods = response.data.moods;
      this.summary = response.data.summary;
    } catch (error) {
      console.error('Error fetching moods:', error);
    }
  },
  methods: {
    async showModal(period, studentId) {
      this.isModalVisible = true;
      this.modalTitle = `${period.charAt(0).toUpperCase() + period.slice(1)} Mood Summary`;

      try {
        const token = localStorage.getItem('token');
        const response = await axios.get(`http://localhost:5000/mood/${period}`, {
          headers: { Authorization: `Bearer ${token}` },
          params: { studentId }
        });
        this.modalMoods = response.data;

        // Calculate summary for the modal
        this.modalSummary = {
          Positive: 0,
          Neutral: 0,
          Negative: 0
        };
        this.modalMoods.forEach(mood => {
          this.modalSummary[mood.sentiment]++;
        });
      } catch (error) {
        console.error(`Error fetching ${period} moods:`, error);
      }
    }
  }
};
</script>

<style scoped>
.mood-report {
  padding: 20px;
}
.summary {
  margin-bottom: 20px;
}
table {
  width: 100%;
  border-collapse: collapse;
}
th, td {
  padding: 10px;
  border: 1px solid #ccc;
  text-align: left;
}
th {
  background-color: #f4f4f4;
}
button {
  margin-right: 5px;
}
.chart-container {
  position: relative;
  width: 100%;
  height: 400px;
  margin-top: 20px;
}
</style>