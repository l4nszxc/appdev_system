<template>
  <div>
    <Navbar :isLoggedIn="isLoggedIn" :username="username" :profilePicture="userInfo.profile_picture" />
    <div class="container mx-auto p-4">
      <div class="bg-white rounded-lg shadow-md p-6">
        <h2 class="text-2xl font-semibold mb-4 text-green-800">Heart-to-Heart Room</h2>

        <!-- Appointment Scheduling Section -->
        <div v-if="!currentAppointment">
          <h3 class="text-lg font-semibold mb-4 text-green-700">Schedule an Appointment</h3>
          
          <!-- Date Selection -->
          <div class="mb-6">
            <label class="block text-sm font-medium text-gray-700 mb-2">Select Date</label>
            <input
              type="date"
              v-model="selectedDate"
              class="w-full p-2 border rounded focus:ring-green-500 focus:border-green-500"
              :min="today"
              @change="loadTimeSlots"
            />
          </div>

          <!-- Time Slots -->
          <div v-if="selectedDate" class="mb-6">
            <label class="block text-sm font-medium text-gray-700 mb-2">Available Time Slots</label>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
              <button
                v-for="slot in timeSlots"
                :key="slot.time"
                @click="selectTimeSlot(slot)"
                :disabled="!slot.available"
                :class="[
                  'p-3 rounded-lg text-center transition-colors',
                  slot.available 
                    ? 'bg-green-100 hover:bg-green-200 text-green-800' 
                    : 'bg-gray-100 text-gray-400 cursor-not-allowed'
                ]"
              >
                {{ formatTime(slot.time) }}
              </button>
            </div>
          </div>

          <div v-if="error" class="text-red-600 mb-4">
            {{ error }}
          </div>
        </div>

        <!-- Current Appointment Display -->
        <div v-else class="mt-4">
          <h3 class="text-lg font-semibold mb-2 text-green-700">Your Current Appointment</h3>
          <div class="bg-green-50 p-4 rounded-lg">
            <p class="mb-2">
              <span class="font-medium">Date:</span> 
              {{ formatDate(currentAppointment.date) }}
            </p>
            <p class="mb-4">
              <span class="font-medium">Time:</span>
              {{ formatTime(currentAppointment.start_time) }} - {{ formatTime(currentAppointment.end_time) }}
            </p>
            <button
              @click="cancelAppointment"
              class="px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700 transition-colors"
            >
              Cancel Appointment
            </button>
          </div>
        </div>

      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import Navbar from '@/components/Navbar.vue';
import axios from 'axios';

export default {
  name: 'UserHeartToHeartRoom',
  components: {
    Navbar
  },
  setup() {
    const isLoggedIn = ref(false);
    const username = ref('');
    const userInfo = ref({});
    const selectedDate = ref('');
    const timeSlots = ref([
      { time: '08:00:00', available: true },
      { time: '09:00:00', available: true },
      { time: '10:00:00', available: true },
      { time: '11:00:00', available: true },
      { time: '13:00:00', available: true },
      { time: '14:00:00', available: true },
      { time: '15:00:00', available: true },
      { time: '16:00:00', available: true },
    ]);
    const currentAppointment = ref(null);
    const error = ref('');

    const today = new Date().toISOString().split('T')[0];

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

    const loadTimeSlots = async () => {
      if (!selectedDate.value) return;
      
      try {
        error.value = '';
        const token = localStorage.getItem('token');
        const response = await axios.get(`http://localhost:5000/api/appointments`, {
          params: { date: selectedDate.value },
          headers: { Authorization: `Bearer ${token}` }
        });
        
        // Reset all slots to available
        timeSlots.value = timeSlots.value.map(slot => ({ ...slot, available: true }));
        
        // Mark slots as unavailable based on existing appointments
        response.data.forEach(appointment => {
          const slot = timeSlots.value.find(s => s.time === appointment.start_time);
          if (slot) {
            slot.available = false;
          }
        });

        // If there are already 2 appointments, mark all remaining slots as unavailable
        if (response.data.length >= 2) {
          timeSlots.value = timeSlots.value.map(slot => ({ ...slot, available: false }));
        }
      } catch (err) {
        console.error('Error loading time slots:', err);
        error.value = err.response?.data?.message || 'Failed to load available time slots';
      }
    };

    const selectTimeSlot = async (slot) => {
      if (!slot.available) return;
      
      try {
        error.value = '';
        const token = localStorage.getItem('token');
        const response = await axios.post('http://localhost:5000/api/appointments', {
          date: selectedDate.value,
          start_time: slot.time
        }, {
          headers: { Authorization: `Bearer ${token}` }
        });

        // Update current appointment and reload slots
        currentAppointment.value = response.data;
        await loadCurrentAppointment();
        await loadTimeSlots();
      } catch (err) {
        console.error('Error scheduling appointment:', err);
        error.value = err.response?.data?.message || 'Failed to schedule appointment';
      }
    };

    const cancelAppointment = async () => {
      if (!currentAppointment.value) return;
      
      try {
        error.value = '';
        const token = localStorage.getItem('token');
        await axios.delete(`http://localhost:5000/api/appointments/${currentAppointment.value.id}`, {
          headers: { Authorization: `Bearer ${token}` }
        });

        currentAppointment.value = null;
        await loadTimeSlots();
      } catch (err) {
        console.error('Error canceling appointment:', err);
        error.value = err.response?.data?.message || 'Failed to cancel appointment';
      }
    };

    const loadCurrentAppointment = async () => {
      try {
        const token = localStorage.getItem('token');
        const response = await axios.get('http://localhost:5000/api/appointments/current', {
          headers: { Authorization: `Bearer ${token}` }
        });
        currentAppointment.value = response.data;
      } catch (err) {
        console.error('Error loading current appointment:', err);
        error.value = err.response?.data?.message || 'Failed to load current appointment';
      }
    };

    onMounted(async () => {
      const token = localStorage.getItem('token');
      isLoggedIn.value = !!token;
      username.value = localStorage.getItem('username') || '';

      if (isLoggedIn.value) {
        try {
          const response = await axios.get('http://localhost:5000/user', {
            headers: { Authorization: `Bearer ${token}` }
          });
          userInfo.value = response.data;
          await loadCurrentAppointment();
        } catch (error) {
          console.error('Failed to fetch user details:', error);
        }
      }
    });

    return {
      isLoggedIn,
      username,
      userInfo,
      selectedDate,
      timeSlots,
      currentAppointment,
      error,
      today,
      formatTime,
      formatDate,
      loadTimeSlots,
      selectTimeSlot,
      cancelAppointment
    };
  }
};
</script>

<style scoped>
/* Add any additional styles you want here */
</style>