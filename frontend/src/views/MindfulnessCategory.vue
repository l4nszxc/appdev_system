<template>
    <div class="category-card mt-3">
      <h2 class="text-success">{{ category.name }}</h2>
      <div class="card mt-3">
        <div class="card-body">
          <h5 class="card-title">{{ exercise?.title }}</h5>
          <p class="card-text">{{ exercise?.description }}</p>
          <a :href="exercise?.link" target="_blank" class="btn btn-success">Start Exercise</a>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    props: {
      category: Object,
    },
    data() {
      return {
        exercise: null,
      };
    },
    mounted() {
      this.fetchExercise();
    },
    methods: {
      fetchExercise() {
        fetch(`/api/mindfulness/exercises/${this.category.name.toLowerCase().replace(' ', '-')}`)
          .then((response) => response.json())
          .then((data) => {
            this.exercise = data;
          })
          .catch((error) => {
            console.error('Error fetching exercise:', error);
          });
      },
    },
  };
  </script>
  
  <style scoped>
  .card {
    border-radius: 15px;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    background: #f9fdf9;
  }
  
  .card:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
  }
  </style>
  