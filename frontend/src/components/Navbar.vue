<template>
  <nav class="navbar">
    <div class="logo-title">
      <img src="../assets/MINSU LOGO.png" alt="Logo" class="logo" />
      <h1 class="navbar-brand">MINDCONNECT</h1>
    </div>
    <div class="navbar-links">
      <template v-if="isLoggedIn">
        <span class="username-display">Logged in as: {{ username }}</span>
        <button @click="confirmLogout" class="nav-link logout-button">Logout</button>
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
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';

export default {
  name: 'Navbar',
  setup() {
    const isLoggedIn = ref(false);
    const username = ref('');
    const router = useRouter();

    // Check login status and retrieve username on component mount
    onMounted(() => {
      isLoggedIn.value = localStorage.getItem('isLoggedIn') === 'true';
      username.value = localStorage.getItem('username') || '';
    });

    const confirmLogout = () => {
      if (confirm('Are you sure you want to log out?')) {
        localStorage.removeItem('token');
        localStorage.removeItem('isLoggedIn');
        localStorage.removeItem('username');
        isLoggedIn.value = false;
        username.value = '';
        router.push('/login');
      }
    };

    return {
      isLoggedIn,
      username,
      confirmLogout,
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

.nav-link {
  padding: 8px 15px;
  text-decoration: none;
  border-radius: 5px;
  color: #ffffff;
  font-size: 1.3rem;
  transition: background-color 0.3s ease;
}

.logout-button {
  background: none;
  border: none;
  color: #ffffff;
  font-size: 1.3rem;
  cursor: pointer;
  padding: 8px 15px;
  border-radius: 5px;
  transition: background-color 0.3s ease;
}

.nav-link:hover,
.logout-button:hover {
  background-color: rgba(9, 117, 76, 0.3);
}

.username-display {
  font-size: 1.3rem;
  color: #ffffff;
  margin-right: 10px;
}
</style>
