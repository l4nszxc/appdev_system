<template>
  <nav class="navbar">
    <div class="logo-title">
      <img src="../assets/MINSU LOGO.png" alt="Logo" class="logo" />
      <h1 class="navbar-brand">MINDCONNECT</h1>
    </div>
    <div class="navbar-links">
      <template v-if="isLoggedIn">
        <span class="username-display">Logged in as: {{ username }}</span>
<<<<<<< HEAD
        <router-link to="/feed" class="nav-link">Feed</router-link>
=======
        <router-link to="/feed" class="nav-link">Feed</router-link> <!-- Add this line -->
>>>>>>> 0f2941a0bc1337b7083106f0e75ce9460af8ff9e
        <div class="profile-menu">
          <img 
            src="../assets/logo.png" 
            alt="Profile" 
            class="profile-icon"
            @click="toggleDropdown" 
          />
          <div v-if="dropdownVisible" class="dropdown-content">
            <router-link to="/user/userprofile" class="dropdown-item">View Profile</router-link>
            <button @click="confirmLogout" class="dropdown-item">Logout</button>
          </div>
        </div>
      </template>
      <template v-else>
        <router-link to="/admin-home" class="nav-link">Admin</router-link>
        <router-link to="/login" class="nav-link">Login</router-link>
        <router-link to="/register" class="nav-link">Register</router-link>
      </template>
    </div>
  </nav>
</template>

<script>
import { ref } from 'vue';
import { useRouter } from 'vue-router';

export default {
  name: 'Navbar',
  props: {
    isLoggedIn: {
      type: Boolean,
      required: true
    },
    username: {
      type: String,
      required: true
    }
  },
  setup(props) {
    const dropdownVisible = ref(false);
    const router = useRouter();

    const toggleDropdown = () => {
      dropdownVisible.value = !dropdownVisible.value; // Toggle dropdown visibility
    };

    const confirmLogout = () => {
      if (confirm('Are you sure you want to log out?')) {
        localStorage.removeItem('token');
        localStorage.removeItem('isLoggedIn');
        localStorage.removeItem('username');
        dropdownVisible.value = false; // Hide dropdown
        router.push('/login'); // Redirect to login
      }
    };

    return {
      toggleDropdown,
      confirmLogout,
      dropdownVisible,
    };
  },
};
</script>

<style scoped>
/* Logo and title container */
.logo-title {
  display: flex;
  align-items: center;
}

.logo {
  width: 50px;
  height: auto;
  margin-right: 5px;
}

/* Navbar styles */
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
  align-items: center;
}

.profile-menu {
  position: relative; /* Position for dropdown */
}

.profile-icon {
  width: 40px; /* Adjust size of profile icon */
  height: 40px; /* Adjust size of profile icon */
  cursor: pointer;
}

.dropdown-content {
  position: absolute;
  top: 100%; /* Position dropdown below the icon */
  right: 0; /* Align dropdown to the right */
  background-color: #ffffff; /* Background color of dropdown */
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); /* Shadow for dropdown */
  border-radius: 5px; /* Rounded corners */
  z-index: 1000; /* Make sure it appears above other elements */
}

.dropdown-item {
  display: block;
  padding: 10px 15px;
  color: #000; /* Text color for dropdown items */
  text-decoration: none;
  font-size: 1rem; /* Font size for dropdown items */
  transition: background-color 0.3s ease;
}

.dropdown-item:hover {
  background-color: rgba(0, 0, 0, 0.1); /* Hover effect for dropdown items */
}

.nav-link {
  padding: 8px 15px;
  text-decoration: none;
  border-radius: 5px;
  color: #ffffff;
  font-size: 1.3rem;
  transition: background-color 0.3s ease;
}

/* Separate hover effect for .nav-link */
.nav-link:not(.logout-button):hover {
  background-color: rgba(9, 117, 76, 0.3);
}

.username-display {
  font-size: 1.3rem;
  color: #ffffff;
  margin-right: 10px;
}
</style>
