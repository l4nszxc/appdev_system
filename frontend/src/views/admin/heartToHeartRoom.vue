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
          <th class="border border-gray-300 p-2">Status</th>
          <th class="border border-gray-300 p-2">Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-if="todayAppointments.length === 0">
          <td colspan="5" class="text-center border border-gray-300 p-2">No appointments scheduled for today.</td>
        </tr>
        <tr v-for="appointment in todayAppointments" :key="appointment.id">
          <td class="border border-gray-300 p-2">{{ formatDate(appointment.date) }}</td>
          <td class="border border-gray-300 p-2">{{ formatTime(appointment.start_time) }} - {{ formatTime(appointment.end_time) }}</td>
          <td class="border border-gray-300 p-2">{{ appointment.firstname }} {{ appointment.lastname }}</td>
          <td :class="statusClass(appointment.status)" class="border border-gray-300 p-2">{{ appointment.status }}</td>
          <td class="border border-gray-300 p-2">
            <button @click="showMeetLinkInput(appointment.id)" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
              Meet
            </button>
            <div v-if="appointment.id === activeMeetingId" class="mt-2">
              <input v-model="meetingLink" type="text" placeholder="Enter meeting link" class="border p-2 mr-2">
              <button @click="sendMeetingLink(appointment.id)" class="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded">
                Send Link
              </button>
            </div>
            <button @click="completeAppointment(appointment.id)" class="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded mt-2">
              Complete
            </button>
          </td>
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
          <td :class="statusClass(appointment.status)" class="border border-gray-300 p-2">{{ appointment.status }}</td>
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
    const activeMeetingId = ref(null);
    const meetingLink = ref('');

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

    const showMeetLinkInput = (appointmentId) => {
      activeMeetingId.value = appointmentId;
      meetingLink.value = '';
    };

    const sendMeetingLink = async (appointmentId) => {
      try {
        const token = localStorage.getItem('token');
        await axios.post(`http://localhost:5000/api/appointments/${appointmentId}/meeting-link`, 
          { meetingLink: meetingLink.value },
          { headers: { Authorization: `Bearer ${token}` } }
        );
        await axios.put(`http://localhost:5000/api/appointments/${appointmentId}/status`, 
          { status: 'on going' },
          { headers: { Authorization: `Bearer ${token}` } }
        );
        alert('Meeting link sent successfully!');
        activeMeetingId.value = null;
        meetingLink.value = '';
        updateAppointmentStatus(appointmentId, 'on going');
      } catch (error) {
        console.error('Error sending meeting link:', error);
        alert('Failed to send meeting link. Please try again.');
      }
    };

    const completeAppointment = async (appointmentId) => {
      try {
        const token = localStorage.getItem('token');
        await axios.put(`http://localhost:5000/api/appointments/${appointmentId}/status`, 
          { status: 'complete' },
          { headers: { Authorization: `Bearer ${token}` } }
        );
        updateAppointmentStatus(appointmentId, 'complete');
      } catch (error) {
        console.error('Error completing appointment:', error);
        alert('Failed to complete appointment. Please try again.');
      }
    };

    const updateAppointmentStatus = (appointmentId, status) => {
      const appointment = todayAppointments.value.find(a => a.id === appointmentId);
      if (appointment) {
        appointment.status = status;
      }
    };

    const statusClass = (status) => {
      switch (status) {
        case 'scheduled':
          return 'text-blue-500';
        case 'pending':
          return 'text-orange-500';
        case 'on going':
          return 'text-orange-500';
        case 'complete':
          return 'text-green-500';
        default:
          return '';
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
      activeMeetingId,
      meetingLink,
      showMeetLinkInput,
      sendMeetingLink,
      completeAppointment,
      statusClass,
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
.text-blue-500 {
  color: blue;
}
.text-orange-500 {
  color: orange;
}
.text-yellow-500 {
  color: yellow;
}
.text-green-500 {
  color: green;
}
</style>