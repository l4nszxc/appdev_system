<template>
    <nav class="navbar">
      <div class="logo-title">
        <img src="../assets/MINSU LOGO.png" alt="Logo" class="logo" />
        <h1 class="navbar-brand">MINDCONNECT</h1>
      </div>
      <div class="navbar-links">
        <router-link to="/users" class="nav-link">Users</router-link>
        <router-link to="/students-mood" class="nav-link">Students' Mood</router-link>
        <router-link to="/message" class="nav-link">Message</router-link>
        <router-link to="/heart-to-heart-room" class="nav-link">Heart-to-Heart Room</router-link>
        <div class="dropdown">
          <router-link to="#" class="nav-link dropdown-toggle">Posts Request</router-link>
          <div class="dropdown-content">
            <router-link to="/posts-request/light" class="dropdown-item">Light</router-link>
            <router-link to="/posts-request/slightly-heavy" class="dropdown-item">Slightly Heavy</router-link>
            <router-link to="/posts-request/heavy" class="dropdown-item">Heavy</router-link>
          </div>
        </div>
      </div>
    </nav>
  </template>
  
  <script>
  export default {
    name: 'Navbar',
  };
  </script>
  
  <style scoped>
  .logo-title {
    display: flex;
    align-items: center;
  }
  .logo {
    width: 50px;
    height: auto;
    margin-right: 5px;
  }
  .navbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 15px 30px;
    background-color: #0f6016;
    color: #ffffff;
  }
  .navbar-brand {
    font-size: 1.8rem;
    font-weight: bold;
    color: #ffffff;
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
    font-size: 1.3rem;
    transition: background-color 0.3s ease;
  }
  .nav-link:hover {
    background-color: rgba(9, 117, 76, 0.3);
  }
  .dropdown {
    position: relative;
  }
  .dropdown-toggle::after {
    content: ' ▼';
  }
  .dropdown-content {
    display: none;
    position: absolute;
    background-color: #ffffff;
    min-width: 160px;
    box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.2);
    z-index: 1;
  }
  .dropdown:hover .dropdown-content {
    display: block;
  }
  .dropdown-item {
    color: #333;
    padding: 8px 12px;
    text-decoration: none;
    display: block;
  }
  .dropdown-item:hover {
    background-color: rgba(9, 117, 76, 0.2);
  }
  </style>
  