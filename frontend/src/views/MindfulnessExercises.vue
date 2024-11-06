<!-- <template>
    <div class="mindfulness-container">
      <h2>Daily Mindfulness Exercise</h2>
      <div v-if="currentExercise">
        <h3>{{ currentExercise.title }}</h3>
        <p>{{ currentExercise.description }}</p>
        <button @click="startExercise" v-if="!isExerciseActive">Start Exercise</button>
        <div v-else>
          <p>{{ timerDisplay }}</p>
          <button @click="stopExercise">Stop</button>
        </div>
      </div>
    </div>
  </template> -->
  <template>
    <div class="mindfulness-page">
      <div class="mindfulness-container">
        <h2>Daily Mindfulness Exercise</h2>
        <div v-if="currentExercise" class="exercise-content">
          <h3>{{ currentExercise.title }}</h3>
          <p>{{ currentExercise.description }}</p>
          <div class="timer-section">
            <button @click="startExercise" v-if="!isExerciseActive" class="start-button">
              Start Exercise
            </button>
            <div v-else class="timer-display">
              <p class="timer">{{ timerDisplay }}</p>
              <button @click="stopExercise" class="stop-button">Stop</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  import { ref, onMounted } from 'vue';
  
  export default {
    setup() {
      const exercises = [
        {
          title: "Deep Breathing",
          description: "Breathe in slowly for 4 seconds, hold for 4 seconds, then exhale for 4 seconds.",
          duration: 300 // 5 minutes
        },
        {
          title: "Body Scan Meditation",
          description: "Starting from your toes, focus your attention on each part of your body, noticing any sensations.",
          duration: 600 // 10 minutes
        },
        // Add more exercises here
      ];
  
      const currentExercise = ref(null);
      const isExerciseActive = ref(false);
      const timerDisplay = ref('');
      let timer;
  
      const selectRandomExercise = () => {
        const lastExerciseDate = localStorage.getItem('lastExerciseDate');
        const today = new Date().toDateString();
  
        if (lastExerciseDate !== today) {
          const randomIndex = Math.floor(Math.random() * exercises.length);
          currentExercise.value = exercises[randomIndex];
          localStorage.setItem('lastExerciseDate', today);
          localStorage.setItem('currentExerciseIndex', randomIndex);
        } else {
          const savedIndex = localStorage.getItem('currentExerciseIndex');
          currentExercise.value = exercises[savedIndex];
        }
      };
  
      const startExercise = () => {
        isExerciseActive.value = true;
        let remainingTime = currentExercise.value.duration;
        
        timer = setInterval(() => {
          remainingTime--;
          const minutes = Math.floor(remainingTime / 60);
          const seconds = remainingTime % 60;
          timerDisplay.value = `${minutes}:${seconds < 10 ? '0' : ''}${seconds}`;
          
          if (remainingTime <= 0) {
            stopExercise();
          }
        }, 1000);
      };
  
      const stopExercise = () => {
        isExerciseActive.value = false;
        clearInterval(timer);
        timerDisplay.value = '';
      };
  
      onMounted(() => {
        selectRandomExercise();
      });
  
      return {
        currentExercise,
        isExerciseActive,
        timerDisplay,
        startExercise,
        stopExercise
      };
    }
  }
  </script>
  
  <style scoped>
  .mindfulness-container {
    max-width: 600px;
    margin: 0 auto;
    padding: 20px;
    background-color: #f0f4f8;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }
  
  h2, h3 {
    color: #2a9d8f;
  }
  
  button {
    background-color: #2a9d8f;
    color: white;
    border: none;
    padding: 10px 20px;
    border-radius: 4px;
    cursor: pointer;
    font-size: 16px;
    margin-top: 10px;
  }
  
  button:hover {
    background-color: #238b7e;
  }
  </style>