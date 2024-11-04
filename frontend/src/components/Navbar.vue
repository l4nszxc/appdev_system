<template>
  <nav class="navbar">
    <div class="logo-title">
    <img src="../assets/MINSU LOGO.png" alt="Logo" class="logo" />
    <h1 class="navbar-brand">MINDCONNECT</h1>
  </div>
    <div class="navbar-links">
      <router-link to="/admin" class="nav-link">Admin</router-link>
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
.logo-title {
  display: flex;                 /* Use flexbox for alignment */
  align-items: center;          /* Center align items vertically */
         
}
.logo {
  width: 50px;                  /* Adjust the size of the logo */
  height: auto;                 /* Maintain aspect ratio */
  margin-right: 5px;           /* Space between the logo and title */
}

/* Navbar styles */
.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 30px;
  background-color: #0f6016; /* Dark background color to match the register page */
  color: #ffffff; /* White text color */
}

.navbar-brand {
  font-size: 1.8rem; /* Slightly larger font size for the brand */
  font-weight: bold;
  color: #ffffff; /* Brand color for emphasis */
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
  background-color: rgba(9, 117, 76, 0.3); /* Hover effect with a slight red tint */
}
</style>
