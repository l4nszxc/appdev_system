<template>
  <NavbarAdmin/>
    <div>
      <h2 class="text-xl font-semibold mb-4 text-green-800">Mood Reports</h2>
      <div v-for="report in reports" :key="report._id" class="mb-3 bg-green-100 p-4 rounded-lg shadow-md">
        <p><strong>Mood:</strong> {{ report.emotion }}</p>
        <p><strong>Time:</strong> {{ new Date(report.timestamp).toLocaleString() }}</p>
      </div>
    </div>
  </template>
  
  <script>
  import NavbarAdmin from '@/components/NavbarAdmin.vue';
  import axios from 'axios';
  
  export default {
    components:{
      NavbarAdmin,
    },
    data() {
      return {
        reports: [],
      };
    },
    async created() {
      this.fetchReports();
    },
    methods: {
      async fetchReports() {
        const response = await axios.get('http://localhost:5000/api/mood/reports');
        this.reports = response.data;
      },
    },
  };
  </script>
  
  <style scoped>
  h2 {
    font-size: 20px;
    margin-bottom: 1rem;
  }
  </style>
  