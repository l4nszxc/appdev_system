<template>
  <nav class="navbar">
    <div class="logo-title">
      <router-link to="/user-home" class="no-underline">
        <img src="../assets/MINSU LOGO.png" alt="Logo" class="logo" />
      </router-link>
      <router-link to="/user-home" class="navbar-brand no-underline">
        MINDCONNECT
      </router-link>
      <span v-if="isLoggedIn" class="username-display">Logged in as: {{ username }}</span>
    </div>
    <div class="navbar-links" :class="{ 'show-links': menuVisible }">
      <template v-if="isLoggedIn">
        <div class="vertical-line"></div>
        <router-link to="/feed" class="nav-link">
          <i class="fas fa-home"></i>
          <span class="link-text">Feed</span>
        </router-link>
        <router-link to="/user/userChat" class="nav-link">
          <i class="fas fa-comments"></i>
          <span class="link-text">Chat Support</span>
        </router-link>
        <router-link to="/daily-exercise" class="nav-link">
          <i class="fas fa-running"></i>
          <span class="link-text">Daily Exercise</span>
        </router-link>
        <router-link to="/feedback" class="nav-link">
          <i class="fas fa-comment"></i>
          <span class="link-text">Feedback</span>
        </router-link>
        <router-link to="/mood-tracker" class="nav-link">
          <i class="fas fa-grin"></i>
          <span class="link-text">Mood Tracker</span>
        </router-link>
        <router-link to="/user/userEmpathyC" class="nav-link">
          <i class="fas fa-hand-holding-heart"></i>
          <span class="link-text">Empathy Challenge</span>
        </router-link>
        <router-link to="/user/userHeartToHeartRoom" class="nav-link">
          <i class="fas fa-heart"></i>
          <span class="link-text">Heart to Heart</span>
        </router-link>
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
        <router-link to="/login" class="nav-link">
          <i class="fas fa-sign-in-alt"></i>
          <span class="link-text">Login</span>
        </router-link>
        <router-link to="/register" class="nav-link">
          <i class="fas fa-user-plus"></i>
          <span class="link-text">Register</span>
        </router-link>
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
.no-underline {
  text-decoration: none;
}

.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 30px;
  background-color: #0f6016;
  color: #ffffff;
  position: relative;
}

.nav-link {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  position: relative;
  color: #ffffff;
  text-decoration: none;
  font-size: 1.5rem;
  padding: 8px 15px;
  transition: background-color 0.3s ease, color 0.3s ease;
}

.nav-link:hover {
  background-color: rgba(9, 117, 76, 0.3);
}

.link-text {
  display: none;
  position: absolute;
  bottom: -20px;
  background-color: #ffffff;
  color: #0f6016;
  padding: 5px;
  border-radius: 5px;
  font-size: 0.9rem;
  white-space: nowrap;
}

.nav-link:hover .link-text {
  display: block;
  z-index: 1;
}

.profile-icon {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  object-fit: cover;
  cursor: pointer;
}

/* Media Queries for Responsive Design */
@media (max-width: 768px) {
  .navbar-links {
    display: none;
    flex-direction: column;
    gap: 10px;
  }

  .navbar-links.show-links {
    display: flex;
  }

  .hamburger-menu {
    display: flex;
    flex-direction: column;
    gap: 5px;
    cursor: pointer;
  }

  .hamburger-menu .bar {
    width: 30px;
    height: 4px;
    background-color: #ffffff;
    border-radius: 5px;
  }
}
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