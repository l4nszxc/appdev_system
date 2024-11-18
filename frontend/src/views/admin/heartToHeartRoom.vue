<template>
    <NavbarAdmin />
    <div class="heart-to-heart-room container py-5">
      <h2 class="mb-4 text-center text-success">Heart-to-Heart Room Management</h2>
      
      <div class="row">
        <!-- Room Availability Management -->
        <div class="col-lg-6 mb-5">
          <div class="card shadow-sm">
            <div class="card-body">
              <h3 class="card-title mb-4 text-success">Room Availability</h3>
              <div v-for="day in weekdays" :key="day" class="mb-4">
                <h5 class="mb-3">{{ day }}</h5>
                <div class="d-flex flex-wrap gap-2">
                  <button
                    v-for="hour in availableHours"
                    :key="hour"
                    :class="['btn', 'time-slot', isAvailable(day, hour) ? 'btn-success' : 'btn-outline-success']"
                    @click="toggleAvailability(day, hour)"
                  >
                    {{ hour }}:00
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
  
        <!-- Time and Link Management -->
        <div class="col-lg-6 mb-5">
          <div class="card shadow-sm">
            <div class="card-body">
              <h3 class="card-title mb-4 text-success">Time & Link Management</h3>
              <div class="mb-3">
                <label for="timePicker" class="form-label">Set Preferred Time</label>
                <input
                  id="timePicker"
                  type="time"
                  v-model="selectedTime"
                  class="form-control"
                  @change="updatePreferredTime"
                />
              </div>
              <div class="mb-3">
                <label for="googleMeetLink" class="form-label">Google Meet Link</label>
                <input
                  id="googleMeetLink"
                  type="url"
                  v-model="googleMeetLink"
                  class="form-control"
                  placeholder="Enter Google Meet Link"
                  @change="updateGoogleLink"
                />
              </div>
              <button @click="updateSettings" class="btn btn-success w-100">Update Settings</button>
            </div>
          </div>
        </div>
  
        <!-- Schedules -->
        <div class="col-12">
          <div class="card shadow-sm">
            <div class="card-body">
              <h3 class="card-title mb-4 text-success">Upcoming Schedules</h3>
              <ul class="list-group">
                <li v-for="schedule in sortedSchedules" :key="schedule.id" class="list-group-item d-flex justify-content-between align-items-center">
                  <span>
                    {{ formatDate(schedule.date) }} {{ schedule.time }}
                  </span>
                  <span class="badge bg-success rounded-pill">{{ schedule.User.username }}</span>
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  import NavbarAdmin from '@/components/NavbarAdmin.vue';
  import { ref, computed, onMounted } from 'vue';
  import { useStore } from 'vuex';
  
  export default {
    components: {
      NavbarAdmin,
    },
    name: 'heartToHeartRoom',
    setup() {
      const store = useStore();
      const weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
      const availableHours = ref([13, 14]); // Default to 1–2 PM
      const availability = ref({});
      const selectedTime = ref('13:00'); // Default start time
      const googleMeetLink = ref('');
  
      const sortedSchedules = computed(() => {
        const schedules = store.state.schedules || [];
        return [...schedules].sort((a, b) => new Date(a.date) - new Date(b.date));
      });
  
      const isAvailable = (day, hour) => availability.value[day]?.[hour] ?? false;
  
      const toggleAvailability = (day, hour) => {
        if (!availability.value[day]) {
          availability.value[day] = {};
        }
        availability.value[day][hour] = !availability.value[day][hour];
      };
  
      const updateSettings = () => {
        store.dispatch('updateAvailability', availability.value);
        store.dispatch('updatePreferredTime', selectedTime.value);
        store.dispatch('updateGoogleMeetLink', googleMeetLink.value);
      };
  
      const formatDate = (dateString) => {
        const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
        return new Date(dateString).toLocaleDateString(undefined, options);
      };
  
      onMounted(async () => {
        try {
          await store.dispatch('fetchSchedules');
          availability.value = store.state.availability || {};
          selectedTime.value = store.state.preferredTime || '13:00';
          googleMeetLink.value = store.state.googleMeetLink || '';
        } catch (error) {
          console.error('Error during setup:', error);
        }
      });
  
      return {
        weekdays,
        availableHours,
        sortedSchedules,
        isAvailable,
        toggleAvailability,
        formatDate,
        selectedTime,
        googleMeetLink,
        updateSettings,
      };
    },
  };
  </script>
  
  <style scoped>
  .heart-to-heart-room {
    background-color: #f8f9fa;
  }
  
  .card {
    border: none;
    transition: transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
  }
  
  .card:hover {
    transform: translateY(-5px);
    box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15) !important;
  }
  
  .time-slot {
    width: 80px;
    transition: all 0.3s ease;
  }
  
  .time-slot:hover {
    transform: scale(1.05);
  }
  
  .btn-success, .btn-outline-success {
    border-radius: 20px;
  }
  
  .btn-success {
    background-color: #2ecc71;
    border-color: #2ecc71;
  }
  
  .btn-outline-success {
    color: #2ecc71;
    border-color: #2ecc71;
  }
  
  .btn-outline-success:hover {
    background-color: #2ecc71;
    color: white;
  }
  
  .text-success {
    color: #2ecc71 !important;
  }
  
  .badge {
    font-size: 0.9em;
    font-weight: 500;
  }
  </style>