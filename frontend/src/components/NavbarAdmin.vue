<template>
  <nav class="navbar">
    <div class="navbar-left">
      <div class="logo-title">
        <img src="../assets/MINSU LOGO.png" alt="Logo" class="logo" />
        <h1 class="navbar-brand">MINDCONNECT</h1>
        <span v-if="isLoggedIn" class="username-display">Logged in as: {{ username }}</span>
      </div>
    </div>

    <div class="navbar-links">
      <div class="nav-item dropdown">
        <button class="nav-link dropdown-toggle" @click="toggleDropdown">
          <i class="fas fa-users"></i>
          <span class="nav-text">Users</span>
        </button>
        <div v-if="dropdownVisible" class="dropdown-menu">
          <router-link to="/admin/users" class="dropdown-item">Manage Users</router-link>
          <router-link to="/admin/suspended-users" class="dropdown-item">Suspended Users</router-link>
          <router-link to="/admin/add-user" class="dropdown-item">Add User</router-link>
        </div>
      </div>
      <div class="nav-item">
        <router-link to="/admin/adminFeed" class="nav-link">
          <i class="fas fa-rss"></i>
          <span class="nav-text">Feed</span>
        </router-link>
      </div>
      <div class="nav-item">
        <router-link to="/admin/adminEmpathyC" class="nav-link">
          <i class="fas fa-heart"></i>
          <span class="nav-text">Empathy Challenge</span>
        </router-link>
      </div>
      <div class="nav-item">
        <router-link to="/admin/moodReport" class="nav-link">
          <i class="fas fa-chart-line"></i>
          <span class="nav-text">Students' Mood</span>
        </router-link>
      </div>
      <div class="nav-item">
        <router-link to="/admin/adminDashboard" class="nav-link">
          <i class="fas fa-tachometer-alt"></i>
          <span class="nav-text">Dashboard</span>
        </router-link>
      </div>
      <div class="nav-item">
        <router-link to="/admin/heartToHeartRoom" class="nav-link">
          <i class="fas fa-comments"></i>
          <span class="nav-text">Heart-to-Heart Room</span>
        </router-link>
      </div>
    </div>

    <div class="navbar-right">
      <div class="nav-item">
        <button @click="logout" class="nav-link logout-button">
          <i class="fas fa-sign-out-alt"></i>
          <span class="nav-text">Logout</span>
        </button>
      </div>
    </div>
  </nav>
</template>

<script>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';

export default {
  name: 'NavbarAdmin',
  setup() {
    const router = useRouter();
    const dropdownVisible = ref(false);
    const isLoggedIn = ref(false);
    const username = ref('');

    const toggleDropdown = () => {
      dropdownVisible.value = !dropdownVisible.value;
    };

    const logout = () => {
      const confirmed = window.confirm("Are you sure you want to log out?");
      if (confirmed) {
        localStorage.removeItem('token');
        localStorage.removeItem('isLoggedIn');
        localStorage.removeItem('username');
        localStorage.removeItem('role');
        router.push('/login');
      } else {
        console.log('Logout canceled');
      }
    };

    onMounted(() => {
      isLoggedIn.value = localStorage.getItem('isLoggedIn') === 'true';
      username.value = localStorage.getItem('username');
    });

    return { logout, toggleDropdown, dropdownVisible, isLoggedIn, username };
  }
};
</script>

<style scoped>
.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 30px;
  background-color: #0f6016;
  color: #ffffff;
}

.navbar-left {
  display: flex;
  align-items: center;
}

.logo-title {
  display: flex;
  align-items: center;
}

.logo {
  width: 50px;
  height: auto;
  margin-right: 5px;
}

.navbar-brand {
  font-size: 1.8rem;
  font-weight: bold;
  color: #ffffff;
}

.username-display {
  font-size: 1.3rem;
  color: #ffffff;
  margin-left: 20px;
}

.navbar-links {
  display: flex;
  gap: 20px;
}

.nav-item {
  position: relative;
}

.nav-link {
  position: relative;
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

.nav-text {
  position: absolute;
  bottom: -25px;
  left: 50%;
  transform: translateX(-50%);
  white-space: nowrap;
  font-size: 0.9rem;
  color: #ffffff;
  background: rgba(0, 0, 0, 0.8);
  padding: 5px 8px;
  border-radius: 3px;
  opacity: 0;
  pointer-events: none;
  transition: opacity 0.3s ease, transform 0.3s ease;
}

.nav-link:hover .nav-text {
  opacity: 1;
  transform: translateX(-50%) translateY(-5px);
}

.navbar-right {
  display: flex;
  align-items: center;
}

.logout-button {
  background: none;
  border: none;
  cursor: pointer;
  font-size: 1.3rem;
  color: #ffffff;
  padding: 8px 15px;
  transition: background-color 0.3s ease;
}

.logout-button i {
  font-size: 1.5rem;
}

.logout-button:hover {
  background-color: rgba(9, 117, 76, 0.3);
}

.logout-button:hover .nav-text {
  opacity: 1;
  transform: translateX(-50%) translateY(-5px);
}

.dropdown {
  position: relative;
}

.dropdown-toggle {
  background: none;
  border: none;
  cursor: pointer;
  font-size: 1.3rem;
  color: #ffffff;
  padding: 8px 15px;
  transition: background-color 0.3s ease;
}

.dropdown-menu {
  position: absolute;
  top: 100%;
  left: 0;
  background-color: #ffffff;
  color: #000000;
  border-radius: 5px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
  z-index: 1000;
}

.dropdown-item {
  display: block;
  padding: 10px 15px;
  color: #000000;
  text-decoration: none;
  font-size: 1rem;
  transition: background-color 0.3s ease;
}

.dropdown-item:hover {
  background-color: rgba(0, 0, 0, 0.1);
}
</style>