<template>
  <div>
    <NavbarAdmin />
    <div class="container mx-auto p-4">
      <div class="flex flex-col space-y-6">
        <div class="card bg-white shadow-md rounded-lg p-6">
          <h2 class="text-2xl font-semibold mb-4 text-green-800">Admin Heart-to-Heart Room</h2>

          <h3 class="text-lg font-semibold mb-4 text-green-700">Today's Appointments</h3>
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

          <h3 class="text-lg font-semibold mb-4 text-green-700">All Appointments</h3>
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
      </div>
    </div>
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
/* Container styles */
.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
}

/* Card styles */
.card {
  background-color: white;
  border-radius: 1rem;
  padding: 2rem;
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
}

.card:hover {
  transform: translateY(-2px);
  box-shadow: 0 15px 20px -3px rgba(0, 0, 0, 0.15);
}

/* Heading styles */
h2 {
  color: #166534;
  font-size: 2rem;
  margin-bottom: 1.5rem;
  border-bottom: 2px solid #22c55e;
  padding-bottom: 0.5rem;
}

h3 {
  color: #15803d;
  font-size: 1.5rem;
  margin-bottom: 1rem;
}

/* Table styles */
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

/* Status colors */
.text-blue-500 {
  color: blue;
}

.text-orange-500 {
  color: orange;
}

.text-green-500 {
  color: green;
}

/* Input and button styles */
input[type="text"] {
  padding: 0.5rem;
  border: 2px solid #e5e7eb;
  border-radius: 0.5rem;
  transition: all 0.3s ease;
}

input[type="text"]:focus {
  border-color: #22c55e;
  outline: none;
  box-shadow: 0 0 0 3px rgba(34, 197, 94, 0.2);
}

button {
  padding: 0.75rem 1.5rem;
  border-radius: 0.5rem;
  font-weight: 600;
  transition: all 0.3s ease;
}

button:hover {
  transform: translateY(-1px);
}
</style>