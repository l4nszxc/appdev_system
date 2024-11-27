<template>
  <NavbarAdmin/>
  <div class="college-container">
    <h1 class="text-2xl font-bold mb-4 text-green-800">Manage Students by Program</h1>

    <!-- Buttons to switch between colleges -->
    <div class="button-group mb-6">
      <button v-for="college in colleges" :key="college" @click="selectCollege(college)"
              :class="['btn', selectedCollege === college ? 'btn-selected' : 'btn-default']">
        {{ college }}
      </button>
    </div>

    <!-- Display table for the selected college -->
    <div v-if="selectedCollege">
      <h2 class="text-xl font-semibold mb-4 text-green-800">{{ selectedCollege }} Students</h2>
      <table class="students-table">
        <thead>
          <tr>
            <th>Student ID</th>
            <th>Username</th>
            <th>Email</th>
            <th>First Name</th>
            <th>Middle Name</th>
            <th>Last Name</th>
            <th>Gender</th>
            <th>Birthdate</th>
            <th>Program</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="student in students" :key="student.student_id">
            <td>{{ student.student_id }}</td>
            <td>{{ student.username }}</td>
            <td>{{ student.email }}</td>
            <td>{{ student.firstname }}</td>
            <td>{{ student.middlename }}</td>
            <td>{{ student.lastname }}</td>
            <td>{{ student.gender }}</td>
            <td>{{ student.birthdate }}</td>
            <td>{{ student.program }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import NavbarAdmin from '@/components/NavbarAdmin.vue';
import axios from 'axios';

export default {
  components: {
    NavbarAdmin,
  },
  data() {
    return {
      colleges: ['BSED', 'BSHM', 'BSTM', 'BTVTED', 'BTLED', 'BSCrim', 'BSIT'],
      selectedCollege: null,
      students: [],
    };
  },
  methods: {
    async selectCollege(college) {
      this.selectedCollege = college;
      this.fetchStudents();
    },
    async fetchStudents() {
      try {
        const token = localStorage.getItem('token');
        const response = await axios.get(`http://localhost:5000/api/students/program/${this.selectedCollege}`, {
          headers: { Authorization: `Bearer ${token}` },
        });
        this.students = response.data;
      } catch (error) {
        console.error('Error fetching students:', error);
      }
    },
  },
};
</script>

<style scoped>
.college-container {
  max-width: 800px;
  margin: auto;
  padding: 20px;
}
.button-group {
  display: flex;
  gap: 10px;
}
.btn {
  padding: 10px 15px;
  font-weight: bold;
  cursor: pointer;
}
.btn-default {
  background-color: #e2e8f0;
  color: #2d3748;
}
.btn-selected {
  background-color: #38a169;
  color: white;
}
.students-table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 10px;
}
.students-table th,
.students-table td {
  padding: 8px;
  border: 1px solid #cbd5e0;
}
</style>