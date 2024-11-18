<template>
    <div class="exercise-wrapper py-5">
      <div class="container">
        <h1 class="text-center text-success mb-4 fw-bold">Mindfulness Exercises</h1>
        <p class="text-center text-muted">
          Discover a daily exercise for each category to help you relax and focus.
        </p>
  
        <!-- Loop through categories -->
        <div v-for="category in categories" :key="category.name" class="category-section mt-5">
          <MindfulnessCategory :category="category" />
        </div>
      </div>
    </div>
  </template>
  
  <script>
  import MindfulnessCategory from '@/views/MindfulnessCategory.vue';
  
  export default {
    name: 'Exercise',
    components: {
      MindfulnessCategory,
    },
    data() {
      return {
        categories: [
          { name: 'Breathing Exercises' },
          { name: 'Meditation Practices' },
          { name: 'Mindful Movement' },
          { name: 'Body Scan Techniques' },
          { name: 'Stress Relief Practices' },
        ],
      };
    },
  };
  </script>
  
  <style scoped>
  .exercise-wrapper {
    background: linear-gradient(to bottom right, #e8f5e9, #ffffff);
    min-height: 100vh;
    padding-top: 2rem;
  }
  
  h1 {
    font-family: 'Arial', sans-serif;
    letter-spacing: 1.5px;
  }
  
  .card {
    border-radius: 15px;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    background: #f9fdf9;
  }
  
  .card:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
  }
  
  .btn-success {
    background-color: #28a745;
    border-color: #28a745;
  }
  
  .btn-success:hover {
    background-color: #218838;
    border-color: #1e7e34;
  }
  </style>
  