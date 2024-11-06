<template>
    <div class="home">
      <h1>Welcome to MindConnect</h1>
      <p>Your daily companion for mental wellness</p>
      <div class="features">
        <router-link to="/mindfulness" class="feature-card">
          <h2>Mindfulness Exercises</h2>
          <p>Start your daily mindfulness practice</p>
        </router-link>
        <!-- Add more feature cards as needed -->
      </div>
    </div>
  </template>
  
  <script>
  export default {
    name: 'Home'
  }
  </script>
  
  <style scoped>
  .home {
    padding: 20px;
    text-align: center;
  }
  
  .features {
    display: flex;
    justify-content: center;
    gap: 20px;
    margin-top: 40px;
  }
  
  .feature-card {
    background-color: #2a9d8f;
    color: white;
    padding: 20px;
    border-radius: 8px;
    text-decoration: none;
    width: 250px;
    transition: transform 0.3s ease;
  }
  
  .feature-card:hover {
    transform: translateY(-5px);
  }
  
  h1 {
    color: #2a9d8f;
    margin-bottom: 20px;
  }
  
  h2 {
    margin: 0;
    margin-bottom: 10px;
  }
  
  p {
    margin: 0;
  }
  </style>