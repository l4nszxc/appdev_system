<template>
  <NavbarAdmin />
  <div class="college-container">
    <h1 class="text-2xl font-bold mb-4 text-green-800">Manage Students by Program</h1>

    <!-- Buttons to switch between colleges -->
    <div class="button-group mb-6">
      <button
        v-for="college in colleges"
        :key="college"
        @click="selectCollege(college)"
        :class="['btn', selectedCollege === college ? 'btn-selected' : 'btn-default']"
      >
        {{ college }}
      </button>
    </div>
 
    <!-- Display table for the selected college -->
    <div v-if="selectedCollege">
      <h2 class="text-xl font-semibold mb-4 text-green-800">{{ selectedCollege }} Students</h2>
      <div class="table-container">
        <div class="table-responsive">
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
      colleges: ['BSED', 'BSHM', 'BSTM', 'BTVTED', 'BTLED', 'BSCrim', 'BSIT', 'ALL STUDENTS'],
      selectedCollege: null,
      students: [],
    };
  },
  methods: {
    async selectCollege(college) {
      this.selectedCollege = college;
      this.fetchStudents();
    },
    // In Users.vue
async fetchStudents() {
  try {
    const token = localStorage.getItem('token');
    let endpoint;
    
    if (this.selectedCollege === 'ALL STUDENTS') {
      endpoint = 'http://localhost:5000/api/students/program/ALL STUDENTS';
    } else {
      endpoint = `http://localhost:5000/api/students/program/${this.selectedCollege}`;
    }

    const response = await axios.get(endpoint, {
      headers: { Authorization: `Bearer ${token}` },
    });

    if (response.data) {
      this.students = response.data;
    } else {
      this.students = [];
      console.error('No data received from server');
    }
  } catch (error) {
    console.error('Error fetching students:', error);
    this.students = [];
  }
}
  },
};
</script>

<style scoped>
.college-container {
  max-width: 1200px;
  margin: auto;
  padding: 20px;
}

h1 {
  font-family: 'Poppins', sans-serif;
  font-weight: 700;
  text-align: center;
}

.button-group {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
  justify-content: center;
}

.btn {
  padding: 10px 15px;
  font-weight: bold;
  cursor: pointer;
  border-radius: 8px;
  transition: all 0.3s ease;
}

.btn-default {
  background-color: #e2e8f0;
  color: #2d3748;
}

.btn-selected {
  background-color: #38a169;
  color: white;
}

.btn:hover {
  transform: scale(1.05);
}

/* Enhanced Table Styling */
.table-container {
  background-color: #ffffff;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  margin-top: 10px;
}

.table-responsive {
  overflow-x: auto;
}

.students-table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 10px;
}

.students-table th {
  background-color: #343a40;
  color: #ffffff;
  font-size: 16px;
  font-weight: bold;
  padding: 12px;
  text-align: center;
  text-transform: uppercase;
}

.students-table td {
  padding: 10px;
  font-size: 14px;
  text-align: center;
  color: #555555;
}

.students-table tbody tr:hover {
  background-color: #f1f1f1;
}

.students-table th:first-child,
.students-table td:first-child {
  border-top-left-radius: 8px;
  border-bottom-left-radius: 8px;
}

.students-table th:last-child,
.students-table td:last-child {
  border-top-right-radius: 8px;
  border-bottom-right-radius: 8px;
}

/* Media Queries for Responsiveness */
@media (max-width: 768px) {
  .students-table th,
  .students-table td {
    padding: 8px;
    font-size: 12px;
  }
}

@media (max-width: 480px) {
  .students-table th,
  .students-table td {
    padding: 6px;
    font-size: 10px;
  }

  .college-container {
    padding: 10px;
  }

  .btn {
    padding: 8px 12px;
  }
}
</style>