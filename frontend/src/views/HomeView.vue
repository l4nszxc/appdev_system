<template>
  <div>
    <nav class="navbar">
      <div class="navbar-brand">MINDCONNECT</div>
      <div class="navbar-links">
        <router-link to="/login" class="nav-link">Login</router-link>
        <router-link to="/register" class="nav-link">Register</router-link>
      </div>
    </nav>
    <div class="home-container">
      <h1 class="welcome-title">Welcome to Homepage</h1>
    </div>
  </div>
</template>

<script>
export default {
  name: 'HomeView',
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

/* Home container styles */
.home-container {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  height: calc(100vh - 80px); /* Adjusted height for navbar */
  background: linear-gradient(to bottom right, #1a1a2e, #16213e);/* Dark background to match register style */
  color: #ffffff;
  text-align: center;
  font-family: 'Arial', sans-serif;
}

.welcome-title {
  font-size: 2.5rem;
  margin-bottom: 20px;
  color: #e94560; /* Matching primary color for consistency */
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .welcome-title {
    font-size: 2rem;
  }
  .nav-link {
    padding: 8px 10px;
    font-size: 0.9rem;
  }
}
</style>
