<template>
  <div>
    <Navbar :isLoggedIn="isLoggedIn" :username="username" />
    <div class="bg-white rounded-lg shadow-md p-6">
      <h2 class="text-2xl font-semibold mb-4 text-green-800">Heart-to-Heart Room</h2>
      <div v-if="!appointment && !isInSession">
        <h3 class="text-lg font-semibold mb-2 text-green-700">Schedule an Appointment</h3>
        <div class="mb-4">
          <label for="appointmentDate" class="block text-sm font-medium text-gray-700">Date</label>
          <input
            type="date"
            id="appointmentDate"
            v-model="appointmentDate"
            class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring focus:ring-green-500 focus:ring-opacity-50"
          />
        </div>
        <div class="mb-4">
          <label for="appointmentTime" class="block text-sm font-medium text-gray-700">Time</label>
          <select
            id="appointmentTime"
            v-model="appointmentTime"
            class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring focus:ring-green-500 focus:ring-opacity-50"
          >
            <option v-for="time in availableTimes" :key="time" :value="time">{{ time }}</option>
          </select>
        </div>
        <button
          @click="scheduleAppointment"
          class="px-4 py-2 bg-green-600 text-white rounded-md hover:bg-green-700 transition-colors"
        >
          Schedule Appointment
        </button>
      </div>
      <div v-else-if="appointment && !isInSession">
        <p class="text-gray-600 mb-2">Your appointment is scheduled for:</p>
        <p class="font-semibold text-green-700 mb-4">{{ formatAppointment(appointment) }}</p>
        <button
          @click="joinSession"
          :disabled="!isAppointmentTime"
          :class="[
            'px-4 py-2 text-white rounded-md transition-colors',
            isAppointmentTime ? 'bg-green-600 hover:bg-green-700' : 'bg-gray-400 cursor-not-allowed'
          ]"
        >
          Join Video Session
        </button>
      </div>
      <div v-else>
        <div id="video-container" class="mb-4 h-64 bg-black rounded-md overflow-hidden">
          <!-- Video elements will be inserted here by the SDK -->
        </div>
        <button
          @click="endSession"
          class="px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700 transition-colors"
        >
          End Session
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue';
import Navbar from '@/components/Navbar.vue'; // Import the Navbar component

const appointment = ref(null);
const appointmentDate = ref('');
const appointmentTime = ref('');
const isInSession = ref(false);
const availableTimes = [
  '09:00 AM', '10:00 AM', '11:00 AM', '01:00 PM', '02:00 PM', '03:00 PM', '04:00 PM'
];

const isLoggedIn = ref(false);
const username = ref('');

// Check login status on component mount
onMounted(() => {
  isLoggedIn.value = localStorage.getItem('isLoggedIn') === 'true';
  username.value = localStorage.getItem('username') || '';
});

const isAppointmentTime = computed(() => {
  if (!appointment.value) return false;
  const now = new Date();
  const appointmentDateTime = new Date(appointment.value.date + 'T' + appointment.value.time);
  return Math.abs(now - appointmentDateTime) < 5 * 60 * 1000; // Within 5 minutes of appointment time
});

const scheduleAppointment = async () => {
  try {
    const response = await fetch('http://localhost:5000/api/ heart-to-heart/schedule', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ date: appointmentDate.value, time: appointmentTime.value }),
    });
    if (response.ok) {
      appointment.value = await response.json();
    }
  } catch (error) {
    console.error('Error scheduling appointment:', error);
  }
};

const joinSession = async () => {
  try {
    const response = await fetch('http://localhost:5000/api/heart-to-heart/join', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ appointmentId: appointment.value.id }),
    });
    if (response.ok) {
      isInSession.value = true;
      initializeVideoSDK();
    }
  } catch (error) {
    console.error('Error joining session:', error);
  }
};

const endSession = () => {
  isInSession.value = false;
  appointment.value = null;
  // Clean up video session
  const videoContainer = document.getElementById('video-container');
  while (videoContainer.firstChild) {
    videoContainer.removeChild(videoContainer.firstChild);
  }
};

const formatAppointment = (apt) => {
  return `${apt.date} at ${apt.time}`;
};

const initializeVideoSDK = () => {
  // This is a placeholder for video SDK initialization
  console.log('Initializing video SDK');
  const videoContainer = document.getElementById('video-container');
  const localVideo = document.createElement('video');
  localVideo.autoplay = true;
  localVideo.muted = true;
  localVideo.style.width = '50%';
  localVideo.style.height = '100%';
  videoContainer.appendChild(localVideo);

  navigator.mediaDevices.getUserMedia({ video: true, audio: true })
    .then(stream => {
      localVideo.srcObject = stream;
    })
    .catch(error => {
      console.error('Error accessing media devices:', error);
    });
};

onMounted(() => {
  // Check for existing appointment
  fetch('http://localhost:5000/api/heart-to-heart/appointment')
    .then(response => response.json())
    .then(data => {
      if (data.appointment) {
        appointment.value = data.appointment;
      }
    })
    .catch(error => console.error('Error fetching appointment:', error));
});

onUnmounted(() => {
  if (isInSession.value) {
    endSession();
  }
});
</script>

<style scoped>
/* Add any additional styles you want here */
</style>