<template>
  <nav class="navbar">
    <div class="logo-title">
      <img src="../assets/MINSU LOGO.png" alt="Logo" class="logo" />
      <h1 class="navbar-brand">MINDCONNECT</h1>
    </div>
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
  /* Logo and title alignment */
  .logo-title {
    display: flex;                  /* Use flexbox for horizontal layout */
    align-items: center;           /* Center items vertically */
  }
  
  .logo {
    width: 50px;                   /* Adjust the size of the logo */
    height: auto;                  /* Maintain aspect ratio */
    margin-right: 10px;            /* Space between the logo and title */
  }
  
  /* Navbar styles */
  .navbar {
    display: flex;
    justify-content: space-between; /* Space between logo/title and links */
    align-items: center;            /* Center items vertically */
    padding: 15px 30px;
    background-color: #2a9d8f;     /* Dark background color */
    color: #ffffff;                 /* White text color */
  }
  
  .navbar-brand {
    font-size: 1.8rem;             /* Larger font size for the brand */
    font-weight: bold;
    color: #FFFFFF;                /* Brand color for emphasis */
  }
  
  .navbar-links {
    display: flex;
    gap: 20px;                     /* Space between links */
  }
  
  .nav-link {
    padding: 8px 15px;
    text-decoration: none;
    border-radius: 5px;
    color: #ffffff;
    font-size: 1.5rem;
    transition: background-color 0.3s ease;
  }
  
  .nav-link:hover {
    background-color: rgba(233, 69, 96, 0.3); /* Hover effect */
  }
  </style>
  