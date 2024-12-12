<template>
  <div>
    <NavbarAdmin />
    <div class="container">
      <h2 class="text-center">Mood Report</h2>
      
      <div class="summary-container grid grid-cols-4 gap-6">
        <div class="summary-item">
          <p><strong>Positive Moods:</strong> {{ summary.Positive }} ({{ positivePercentage }}%)</p>
          <div class="progress-bar">
            <div class="progress positive" :style="{ width: positivePercentage + '%' }"></div>
          </div>
        </div>
        <div class="summary-item">
          <p><strong>Neutral Moods:</strong> {{ summary.Neutral }} ({{ neutralPercentage }}%)</p>
          <div class="progress-bar">
            <div class="progress neutral" :style="{ width: neutralPercentage + '%' }"></div>
          </div>
        </div>
        <div class="summary-item">
          <p><strong>Negative Moods:</strong> {{ summary.Negative }} ({{ negativePercentage }}%)</p>
          <div class="progress-bar">
            <div class="progress negative" :style="{ width: negativePercentage + '%' }"></div>
          </div>
        </div>
      </div>

      <!-- Print Report Button -->
      <button class="btn btn-success mb-3" @click="printReport">Print Report</button>

      <div class="table-container">
        <div class="table-responsive">
          <table class="table table-bordered table-hover">
            <thead class="thead-dark">
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
              <tr v-if="moods.length === 0">
                <td colspan="6" class="text-center">No moods recorded yet.</td>
              </tr>
              <tr v-for="mood in moods" :key="mood.id">
                <td>{{ mood.student_id }}</td>
                <td>{{ mood.mood }}</td>
                <td>{{ mood.sentiment }}</td>
                <td>{{ mood.comment }}</td>
                <td>{{ new Date(mood.created_at).toLocaleString() }}</td>
                <td>
                  <button class="btn btn-primary btn-sm" @click="showModal('weekly', mood.student_id)">Weekly</button>
                  <button class="btn btn-secondary btn-sm" @click="showModal('monthly', mood.student_id)">Monthly</button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- Modal -->
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
  computed: {
    totalMoods() {
      return this.summary.Positive + this.summary.Neutral + this.summary.Negative;
    },
    positivePercentage() {
      return ((this.summary.Positive / this.totalMoods) * 100).toFixed(2);
    },
    neutralPercentage() {
      return ((this.summary.Neutral / this.totalMoods) * 100).toFixed(2);
    },
    negativePercentage() {
      return ((this.summary.Negative / this.totalMoods) * 100).toFixed(2);
    }
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
    },
    printReport() {
      const reportContent = `
        <h1>Mood Report</h1>
        <p><strong>Positive Moods:</strong> ${this.summary.Positive} (${this.positivePercentage}%)</p>
        <p><strong>Neutral Moods:</strong> ${this.summary.Neutral} (${this.neutralPercentage}%)</p>
        <p><strong>Negative Moods:</strong> ${this.summary.Negative} (${this.negativePercentage}%)</p>
        <h2>Student Mood Details</h2>
        <table>
          <thead>
            <tr>
              <th>Student ID</th>
              <th>Mood</th>
              <th>Sentiment</th>
              <th>Comment</th>
              <th>Created At</th>
            </tr>
          </thead>
          <tbody>
            ${this.moods.map(mood => `
              <tr>
                <td>${mood.student_id}</td>
                <td>${mood.mood}</td>
                <td>${mood.sentiment}</td>
                <td>${mood.comment}</td>
                <td>${mood.created_at}</td>
              </tr>
            `).join('')}
          </tbody>
        </table>
      `;
      const printWindow = window.open('', '', 'height=600,width=800');
      printWindow.document.write('<html><head><title>Mood Report</title></head><body>');
      printWindow.document.write(reportContent);
      printWindow.document.write('</body></html>');
      printWindow.document.close();
      printWindow.print();
    }
  }
};
</script>

<style scoped>
/* Set up a grid with 4 columns */
.summary-container {
  display: grid;
  grid-template-columns: repeat(4, 1fr); /* 4 equal columns */
  gap: 1.5rem; /* space between columns */
  padding: 1.5rem;
  margin-left: 15rem
}

.summary-item {
  background-color: #f4f4f4;
  padding: 1rem;
  border-radius: 8px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.summary-item p {
  font-size: 1rem;
  color: #333;
}

.summary-item strong {
  font-weight: bold;
}

/* Progress Bar Styles */
.progress-bar {
  height: 10px;
  background: #ddd;
  border-radius: 5px;
  overflow: hidden;
  margin-top: 5px;
}

.progress {
  height: 10px;
  transition: width 0.3s ease;
}

.progress.positive {
  background: #28a745; /* Green for positive */
}

.progress.neutral {
  background: #007bff; /* Blue for neutral */
}

.progress.negative {
  background: #dc3545; /* Red for negative */
}

/* Use table design from User Feedback */
.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

h2 {
  font-family: 'Roboto', sans-serif;
  font-weight: 600;
  font-size: 2rem;
  text-transform: uppercase;
  text-align: center;
}

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

.table-bordered th,
.table-bordered td {
  border: 1px solid #dee2e6;
}

.table-responsive {
  overflow-x: auto;
}

.btn {
  font-size: 14px;
  padding: 8px 12px;
}

.btn-print-report {
  background-color: #4CAF50;
  color: white;
  padding: 10px 15px;
  border: none;
  cursor: pointer;
  margin-bottom: 20px;
}

.btn-print-report:hover {
  background-color: #45a049;
}
</style>