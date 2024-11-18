<template>
  <div class="user-heart-to-heart-room">
    <Navbar :isLoggedIn="isLoggedIn" :username="username" :profilePicture="userInfo.profile_picture" />
    <div>
      <h2 class="mb-4">Schedule a Heart-to-Heart Session</h2>
      <div class="calendar mb-5">
        <VCalendar
          :attributes="calendarAttributes"
          @dayclick="onDayClick"
        />
      </div>
      <div v-if="selectedDate && availableSlots.length" class="available-slots mb-5">
        <h3 class="mb-3">Available Slots for {{ formatDate(selectedDate) }}</h3>
        <div class="d-flex flex-wrap gap-2">
          <button
            v-for="slot in availableSlots"
            :key="slot.time"
            class="btn btn-outline-primary"
            @click="scheduleSession(slot)"
          >
            {{ formatTime(slot.time) }}
          </button>
        </div>
      </div>
      <div v-else-if="selectedDate && !availableSlots.length" class="no-slots">
        <p>No available slots for the selected date. Please try another day.</p>
      </div>
      <div v-if="userSchedule" class="user-schedule">
        <h3 class="mb-3">Your Scheduled Session</h3>
        <div class="card">
          <div class="card-body">
            <p class="card-text"><strong>Date:</strong> {{ formatDate(userSchedule.date) }}</p>
            <p class="card-text"><strong>Time:</strong> {{ formatTime(userSchedule.time) }}</p>
            <a :href="userSchedule.google_meet_link" target="_blank" rel="noopener noreferrer" class="btn btn-primary">Join Google Meet</a>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, computed, onMounted } from 'vue';
import { useStore } from 'vuex';
import { Calendar } from 'v-calendar';
import 'v-calendar/dist/style.css';
import Navbar from '../../components/Navbar.vue'; // Adjust the path based on your file structure

export default {
  name: 'userHeartToHeartRoom',
  components: {
    VCalendar: Calendar,
    Navbar, // Register Navbar component
  },
  setup() {
    const store = useStore();
    const selectedDate = ref(null);
    const availableSlots = computed(() => store.state.availableSlots || []); // Fallback to empty array
    const userSchedule = computed(() => store.state.userSchedule);
    const isLoggedIn = ref(false);
    const username = ref('');
    const userInfo = ref({});

    const calendarAttributes = computed(() => [
      {
        highlight: {
          color: 'blue',
          fillMode: 'light',
        },
        dates: availableSlots.value.map(slot => new Date(slot.date)),
      },
    ]);

    const onDayClick = async (day) => {
      selectedDate.value = day.date;
      try {
        await store.dispatch('fetchAvailableSlots', day.date);
      } catch (error) {
        console.error('Error fetching available slots:', error);
      }
    };

    const scheduleSession = async (slot) => {
      try {
        // Schedule the session for the user
        await store.dispatch('scheduleSession', { date: selectedDate.value, slot });

        // Relay the scheduling information to the admin's heart-to-heart room
        await store.dispatch('adminScheduleSession', { date: selectedDate.value, slot });

        await store.dispatch('fetchUserSchedule');
        alert('Session successfully scheduled!');
      } catch (error) {
        console.error('Error scheduling session:', error);
        alert('Failed to schedule session. Please try again.');
      }
    };

    const formatDate = (dateString) => {
      const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
      return new Date(dateString).toLocaleDateString(undefined, options);
    };

    const formatTime = (timeString) => {
      const options = { hour: 'numeric', minute: 'numeric', hour12: true };
      return new Date(`2000-01-01T${timeString}`).toLocaleTimeString(undefined, options);
    };

    onMounted(async () => {
      try {
        isLoggedIn.value = localStorage.getItem('isLoggedIn') === 'true';
        username.value = localStorage.getItem('username') || '';
        const token = localStorage.getItem('token');
        if (isLoggedIn.value) {
          const response = await fetch('http://localhost:5000/user', {
            headers: { Authorization: `Bearer ${token}` },
          });
          userInfo.value = await response.json();
        }
        await store.dispatch('fetchUserSchedule');
      } catch (error) {
        console.error('Error fetching user schedule or user details:', error);
      }
    });

    return {
      selectedDate,
      availableSlots,
      userSchedule,
      calendarAttributes,
      onDayClick,
      scheduleSession,
      formatDate,
      formatTime,
      isLoggedIn,
      username,
      userInfo,
    };
  },
};
</script>

<style scoped>
.user-heart-to-heart-room {
  padding: 20px;
  margin: 0 auto;
}

.calendar {
  max-width: 400px;
  margin: 0 auto;
}

.available-slots button {
  margin: 5px;
}

.no-slots {
  text-align: center;
  color: gray;
}

.user-schedule {
  background-color: #f8f9fa;
  border-radius: 5px;
  padding: 15px;
  margin-top: 20px;
}

.btn-primary {
  background-color: #2a9d8f;
  border-color: #2a9d8f;
}

.btn-primary:hover {
  background-color: #238b7e;
  border-color: #238b7e;
}
</style>
