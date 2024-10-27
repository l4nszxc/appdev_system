<template>
    <nav class="navbar">
      <div class="navbar-brand">MINDCONNECT</div>
      <div class="navbar-links">
        <router-link to="/login" class="nav-link">Login</router-link>
        <router-link to="/register" class="nav-link">Register</router-link>
      </div>
    </nav>
  </template>
  
  <script>
  export default {
    name: 'Navbar',
  };
  </script>
  
  <style scoped>
  /* Navbar styles */
  .navbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 15px 30px;
    background-color: #0f3460; /* Dark background color to match the register page */
    color: #ffffff; /* White text color */
  }
  
  .navbar-brand {
    font-size: 1.8rem; /* Slightly larger font size for the brand */
    font-weight: bold;
    color: #e94560; /* Brand color for emphasis */
  }
  
  .navbar-links {
    display: flex;
    gap: 20px;
  }
  
  .nav-link {
    padding: 8px 15px;
    text-decoration: none;
    border-radius: 5px;
    color: #ffffff;
    font-size: 1rem;
    transition: background-color 0.3s ease;
  }
  
  .nav-link:hover {
    background-color: rgba(233, 69, 96, 0.3); /* Hover effect with a slight red tint */
  }
  </style>
  