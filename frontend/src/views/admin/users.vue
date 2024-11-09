<template>
    <div class="college-container">
      <h1 class="text-2xl font-bold mb-4 text-green-800">Manage Students by College</h1>
  
      <!-- Buttons to switch between colleges -->
      <div class="button-group mb-6">
        <button v-for="college in colleges" :key="college" @click="selectCollege(college)"
                :class="['btn', selectedCollege === college ? 'btn-selected' : 'btn-default']">
          {{ college }}
        </button>
      </div>
  
      <!-- Display table and CRUD form for the selected college -->
      <div v-if="selectedCollege">
        <h2 class="text-xl font-semibold mb-4 text-green-800">{{ selectedCollege }} Students</h2>
        <form @submit.prevent="addOrUpdateStudent">
          <input type="text" v-model="studentForm.studentId" placeholder="Student ID" required class="input" />
          <input type="text" v-model="studentForm.name" placeholder="Name" required class="input" />
          <button type="submit" class="btn-submit">{{ studentForm.id ? 'Update' : 'Add' }} Student</button>
        </form>
  
        <table class="students-table">
          <thead>
            <tr>
              <th>Student ID</th>
              <th>Name</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="student in students" :key="student._id">
              <td>{{ student.studentId }}</td>
              <td>{{ student.name }}</td>
              <td>
                <button @click="editStudent(student)" class="btn-edit">Edit</button>
                <button @click="deleteStudent(student._id)" class="btn-delete">Delete</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </template>
  
  <script>
  import axios from 'axios';
  
  export default {
    data() {
      return {
        colleges: ['CCS', 'CBM', 'CCJE', 'BTVTED', 'CTE'],
        selectedCollege: null,
        students: [],
        studentForm: {
          id: null,
          studentId: '',
          name: '',
        },
      };
    },
    methods: {
      async selectCollege(college) {
        this.selectedCollege = college;
        this.fetchStudents();
      },
      async fetchStudents() {
        try {
          const response = await axios.get(`http://localhost:3000/api/students/${this.selectedCollege}`);
          this.students = response.data;
        } catch (error) {
          console.error('Error fetching students:', error);
        }
      },
      async addOrUpdateStudent() {
        try {
          if (this.studentForm.id) {
            // Update existing student
            await axios.put(`http://localhost:3000/api/students/${this.studentForm.id}`, {
              studentId: this.studentForm.studentId,
              name: this.studentForm.name,
            });
          } else {
            // Add new student
            await axios.post('http://localhost:3000/api/students', {
              studentId: this.studentForm.studentId,
              name: this.studentForm.name,
              college: this.selectedCollege,
            });
          }
          this.resetForm();
          this.fetchStudents();
        } catch (error) {
          console.error('Error saving student:', error);
        }
      },
      editStudent(student) {
        this.studentForm = { ...student, id: student._id };
      },
      async deleteStudent(id) {
        try {
          await axios.delete(`http://localhost:3000/api/students/${id}`);
          this.fetchStudents();
        } catch (error) {
          console.error('Error deleting student:', error);
        }
      },
      resetForm() {
        this.studentForm = { id: null, studentId: '', name: '' };
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
  .input {
    margin-right: 10px;
    padding: 8px;
    border: 1px solid #cbd5e0;
    border-radius: 4px;
  }
  .btn-submit {
    background-color: #38a169;
    color: white;
    padding: 8px 12px;
    border-radius: 4px;
    cursor: pointer;
  }
  .btn-edit {
    margin-right: 5px;
    color: #2b6cb0;
    cursor: pointer;
  }
  .btn-delete {
    color: #e53e3e;
    cursor: pointer;
  }
  </style>
  