<template>
  <div>
    <Navbar :isLoggedIn="isLoggedIn" :username="username" :profilePicture="userInfo.profile_picture" />
    <div class="container mx-auto p-4">
      <div class="flex flex-col space-y-6">

        <!-- Heart-to-Heart Section -->
        <div class="card bg-white shadow-md rounded-lg p-6">
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
                class="w-full p-3 border rounded-lg focus:ring-green-500 focus:border-green-500"
                :min="today"
                @change="loadTimeSlots"
              />
            </div>

            <!-- Time Slots -->
            <div v-if="selectedDate" class="mb-6">
              <label class="block text-sm font-medium text-gray-700 mb-2">Available Time Slots</label>
              <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-4">
                <div
                  v-for="slot in timeSlots"
                  :key="slot.time"
                  :class="[
                    'time-slot',
                    slot.available ? 'available' : 'unavailable',
                    slot.past ? 'unavailable' : ''
                  ]"
                  @click="selectTimeSlot(slot)"
                >
                  {{ formatTime(slot.time) }}
                </div>
              </div>
            </div>

            <div v-if="error" class="text-red-600 mb-4">
              {{ error }}
            </div>
          </div>

          <!-- Current Appointment Display -->
          <div v-if="currentAppointment" class="current-appointment">
            <h3 class="text-lg font-semibold mb-2 text-green-700">Your Current Appointment</h3>
            <div class="card bg-green-50 p-6 rounded-lg">
              <p class="mb-2">
                <span class="font-medium">Date:</span>
                {{ formatDate(currentAppointment.date) }}
              </p>
              <p class="mb-2">
                <span class="font-medium">Time:</span>
                {{ formatTime(currentAppointment.start_time) }} - {{ formatTime(currentAppointment.end_time) }}
              </p>
              <br>
              <a
                :href="currentAppointment.meeting_link"
                target="_blank"
                class="text-blue-600 hover:underline"
              >
                {{ currentAppointment.meeting_link }}
              </a>
              <br><br>
              <button
                @click="cancelAppointment"
                class="cancel w-full"
              >
                Cancel Appointment
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    <Footer />
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import Navbar from '@/components/Navbar.vue';
import axios from 'axios';
import Footer from "@/components/Footer.vue";

export default {
  name: 'UserHeartToHeartRoom',
  components: {
    Navbar,
    Footer
  },
  setup() {
    const isLoggedIn = ref(false);
    const username = ref('');
    const userInfo = ref({});
    const selectedDate = ref('');
    const timeSlots = ref([
      { time: '08:00:00', available: true, past: false },
      { time: '09:00:00', available: true, past: false },
      { time: '10:00:00', available: true, past: false },
      { time: '11:00:00', available: true, past: false },
      { time: '13:00:00', available: true, past: false },
      { time: '14:00:00', available: true, past: false },
      { time: '15:00:00', available: true, past: false },
      { time: '16:00:00', available: true, past: false },
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
      try {
        error.value = '';
        const token = localStorage.getItem('token');
        const response = await axios.get(`http://localhost:5000/api/appointments`, {
          params: { date: selectedDate.value },
          headers: { Authorization: `Bearer ${token}` }
        });

        // Reset all slots to available and not past
        const now = new Date();
        timeSlots.value = timeSlots.value.map(slot => {
          const slotTime = new Date(`2000-01-01T${slot.time}`);
          const isPast = selectedDate.value === today && slotTime.getHours() < now.getHours();
          return { ...slot, available: true, past: isPast };
        });

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
      if (!slot.available || slot.past) return;

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
          console.log('Current Appointment:', currentAppointment.value); // Log the current appointment
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
/* Container styles */
.container {
  max-width: 600px;
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

/* Form elements */
input[type="date"] {
  width: 100%;
  padding: 0.75rem;
  border: 2px solid #e5e7eb;
  border-radius: 0.5rem;
  transition: all 0.3s ease;
}

input[type="date"]:focus {
  border-color: #22c55e;
  outline: none;
  box-shadow: 0 0 0 3px rgba(34, 197, 94, 0.2);
}

/* Time slots grid */
.grid {
  gap: 1rem;
  margin-top: 1rem;
}

.time-slot {
  padding: 1rem;
  border-radius: 0.5rem;
  text-align: center;
  cursor: pointer;
  transition: all 0.2s ease;
}

.time-slot.available {
  background-color: #dcfce7;
  color: #166534;
  border: 2px solid #86efac;
}

.time-slot.available:hover {
  background-color: #bbf7d0;
  transform: scale(1.05);
}

.time-slot.unavailable {
  background-color: #f3f4f6;
  color: #9ca3af;
  border: 2px solid #e5e7eb;
}

/* Current appointment card */
.current-appointment {
  background-color: #f0fdf4;
  border: 2px solid #86efac;
  border-radius: 0.75rem;
  padding: 1.5rem;
  margin-top: 1.5rem;
}

.current-appointment p {
  margin-bottom: 0.75rem;
  color: #374151;
}

/* Buttons */
button {
  padding: 0.75rem 1.5rem;
  border-radius: 0.5rem;
  font-weight: 600;
  transition: all 0.3s ease;
}

button.cancel {
  background-color: #dc2626;
  color: white;
  border: none;
}

button.cancel:hover {
  background-color: #b91c1c;
  transform: translateY(-1px);
}

/* Error message */
.error {
  color: #dc2626;
  background-color: #fee2e2;
  padding: 0.75rem;
  border-radius: 0.5rem;
  margin-top: 1rem;
  font-size: 0.875rem;
}

/* Meeting link */
a.meeting-link {
  color: #2563eb;
  text-decoration: none;
  font-weight: 500;
  transition: color 0.2s ease;
}

a.meeting-link:hover {
  color: #1d4ed8;
  text-decoration: underline;
}
</style>