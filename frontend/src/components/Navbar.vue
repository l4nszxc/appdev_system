<template>
  <nav class="navbar">
    <div class="logo-title">
      <img src="../assets/MINSU LOGO.png" alt="Logo" class="logo" />
      <h1 class="navbar-brand">MINDCONNECT</h1>
      <span v-if="isLoggedIn" class="username-display">Logged in as: {{ username }}</span>
    </div>
    <div class="navbar-links" :class="{ 'show-links': menuVisible }">
      <template v-if="isLoggedIn">
        <div class="vertical-line"></div>
        <router-link to="/feed" class="nav-link">Feed</router-link>
        <router-link to="/feedback" class="nav-link">Feedback</router-link>
        <router-link to="/help-center" class="nav-link">Help Center</router-link>
        <router-link to="/user/userChat" class="nav-link">Chat Support</router-link>
        <router-link to="/user/userHeartToHeartRoom" class="nav-link">Heart-to-Heart Room</router-link>
        <router-link to="/daily-exercise" class="nav-link">Daily Exercise</router-link>
        <div class="profile-menu">
          <img 
            :src="profilePictureUrl"
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
        <router-link to="/login" class="nav-link">Login</router-link>
        <router-link to="/register" class="nav-link">Register</router-link>
      </template>
    </div>
    <div class="hamburger-menu" @click="toggleMenu">
      <span class="bar"></span>
      <span class="bar"></span>
      <span class="bar"></span>
    </div>
  </nav>
</template>

<script>
import { ref, computed } from 'vue';
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
    },
    profilePicture: {
      type: String,
      default: null
    }
  },
  setup(props) {
    const dropdownVisible = ref(false);
    const router = useRouter();
    const menuVisible = ref(false);

    const profilePictureUrl = computed(() => {
      if (props.profilePicture) {
        return `http://localhost:5000${props.profilePicture}`;
      }
      return require('@/assets/defaultProfile.png');
    });

    const toggleDropdown = () => {
      dropdownVisible.value = !dropdownVisible.value;
    };

    const confirmLogout = () => {
      if (confirm('Are you sure you want to log out?')) {
        localStorage.removeItem('token');
        localStorage.removeItem('isLoggedIn');
        localStorage.removeItem('username');
        dropdownVisible.value = false;
        router.push('/login');
      }
    };

    const toggleMenu = () => {
      menuVisible.value = !menuVisible.value;
    };

    return {
      toggleDropdown,
      confirmLogout,
      toggleMenu,
      dropdownVisible,
      menuVisible,
      profilePictureUrl,
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
  position: relative;
}

.navbar-brand {
  font-size: 1.8rem;
  font-weight: bold;
  color: #ffffff;
  margin-right: 20px;
}

.username-display {
  font-size: 1.3rem;
  color: #ffffff;
  margin-right: 20px;
}

.navbar-links {
  display: flex;
  gap: 20px;
  align-items: center;
}

.navbar-links.show-links {
  display: block;
}

.profile-menu {
  position: relative;
}

.profile-icon {
  width: 40px;
  height: 40px;
  cursor: pointer;
}

.dropdown-content {
  position: absolute;
  top: 100%;
  right: 0;
  background-color: #ffffff;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
  border-radius: 5px;
  z-index: 1000;
}

.dropdown-item {
  display: block;
  padding: 10px 15px;
  color: #000;
  text-decoration: none;
  font-size: 1rem;
  transition: background-color 0.3s ease;
}

.dropdown-item:hover {
  background-color: rgba(0, 0, 0, 0.1);
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

/* Hamburger menu */
.hamburger-menu {
  display: none;
  cursor: pointer;
  flex-direction: column;
  gap: 5px;
}

.hamburger-menu .bar {
  width: 30px;
  height: 4px;
  background-color: #ffffff;
  border-radius: 5px;
}

@media (max-width: 768px) {
  .navbar-links {
    display: none;
    width: 100%;
    flex-direction: column;
    gap: 10px;
    align-items: flex-start;
  }

  .hamburger-menu {
    display: flex;
  }

  .navbar-links.show-links {
    display: flex;
  }
  .profile-icon {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  object-fit: cover;
  cursor: pointer;
}
}
</style>