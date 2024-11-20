<template>
  <NavbarAdmin/>
  <div>
    <h1>Admin Heart-to-Heart Room</h1>
    
    <h2>Today's Appointments</h2>
    <table class="table-auto w-full border-collapse border border-gray-300 mb-6">
      <thead>
        <tr>
          <th class="border border-gray-300 p-2">Date</th>
          <th class="border border-gray-300 p-2">Time</th>
          <th class="border border-gray-300 p-2">Student</th>
        </tr>
      </thead>
      <tbody>
        <tr v-if="todayAppointments.length === 0">
          <td colspan="3" class="text-center border border-gray-300 p-2">No appointments scheduled for today.</td>
        </tr>
        <tr v-for="appointment in todayAppointments" :key="appointment.id">
          <td class="border border-gray-300 p-2">{{ formatDate(appointment.date) }}</td>
          <td class="border border-gray-300 p-2">{{ formatTime(appointment.start_time) }} - {{ formatTime(appointment.end_time) }}</td>
          <td class="border border-gray-300 p-2">{{ appointment.firstname }} {{ appointment.lastname }}</td>
        </tr>
      </tbody>
    </table>

    <h2>All Appointments</h2>
    <table class="table-auto w-full border-collapse border border-gray-300">
      <thead>
        <tr>
          <th class="border border-gray-300 p-2">Date</th>
          <th class="border border-gray-300 p-2">Time</th>
          <th class="border border-gray-300 p-2">Student</th>
          <th class="border border-gray-300 p-2">Status</th>
        </tr>
      </thead>
      <tbody>
        <tr v-if="allAppointments.length === 0">
          <td colspan="4" class="text-center border border-gray-300 p-2">No appointments found.</td>
        </tr>
        <tr v-for="appointment in allAppointments" :key="appointment.id">
          <td class="border border-gray-300 p-2">{{ formatDate(appointment.date) }}</td>
          <td class="border border-gray-300 p-2">{{ formatTime(appointment.start_time) }} - {{ formatTime(appointment.end_time) }}</td>
          <td class="border border-gray-300 p-2">{{ appointment.firstname }} {{ appointment.lastname }}</td>
          <td class="border border-gray- 300 p-2">{{ appointment.status }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import NavbarAdmin from '@/components/NavbarAdmin.vue';
import axios from 'axios';
import { ref, onMounted } from 'vue';

export default {
  components: {
    NavbarAdmin,
  },
  setup() {
    const todayAppointments = ref([]);
    const allAppointments = ref([]);

    const formatTime = (time) => {
      return new Date(`2000-01-01T${time}`).toLocaleTimeString([], {
        hour: '2-digit',
        minute: '2-digit'
      });
    };

    const formatDate = (date) => {
      return new Date(date).toLocaleDateString('en-US', {
        weekday: 'long',
        year: 'numeric',
        month: 'long',
        day: 'numeric'
      });
    };

    const loadTodaysAppointments = async () => {
      try {
        const token = localStorage.getItem('token');
        const response = await axios.get('http://localhost:5000/api/appointments/today', {
          headers: { Authorization: `Bearer ${token}` }
        });
        todayAppointments.value = response.data;
      } catch (error) {
        console.error('Error loading today\'s appointments:', error);
      }
    };

    const loadAllAppointments = async () => {
      try {
        const token = localStorage.getItem('token');
        const response = await axios.get('http://localhost:5000/api/appointments/all', {
          headers: { Authorization: `Bearer ${token}` }
        });
        allAppointments.value = response.data;
      } catch (error) {
        console.error('Error loading all appointments:', error);
      }
    };

    onMounted(() => {
      loadTodaysAppointments();
      loadAllAppointments();
    });

    return {
      todayAppointments,
      allAppointments,
      formatTime,
      formatDate,
    };
  },
};
</script>

<style scoped>
.table-auto {
  width: 100%;
  border-collapse: collapse;
}
.table-auto th, .table-auto td {
  border: 1px solid #ccc;
  padding: 8px;
  text-align: left;
}
.table-auto th {
  background-color: #f2f2f2;
}
</style>