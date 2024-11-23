<template>
  <div>
    <Navbar :isLoggedIn="isLoggedIn" :username="username" :profilePicture="userInfo.profile_picture" />
    <div class="user-profile">
      <h2>User Profile</h2>
      <div class="profile-picture">
        <img :src="profilePictureUrl" alt="Profile Picture" class="profile-image" />
      </div>
      <p><strong>Student ID:</strong> {{ userInfo.student_id }}</p>
      <p><strong>Username:</strong> {{ userInfo.username }}</p>
      <p><strong>Email:</strong> {{ userInfo.email }}</p>
      <p><strong>First Name:</strong> {{ userInfo.firstname }}</p>
      <p><strong>Middle Name:</strong> {{ userInfo.middlename }}</p>
      <p><strong>Last Name:</strong> {{ userInfo.lastname }}</p>
      <p><strong>Gender:</strong> {{ userInfo.gender }}</p>
      <p><strong>Birthdate:</strong> {{ userInfo.birthdate }}</p>
      <p><strong>Program:</strong> {{ userInfo.program }}</p>
      <button @click="goToEditProfile" class="edit-profile-btn">EDIT PROFILE</button>
    </div>
  </div>
  <Footer />
</template>

<script>
import { ref, onMounted, computed } from 'vue';
import { useRouter } from 'vue-router';
import Navbar from '../../components/Navbar.vue';
import axios from 'axios';
import Footer from "@/components/Footer.vue";

export default {
  name: 'UserProfile',
  components: {
    Navbar,
  },
  setup() {
    const isLoggedIn = ref(false);
    const username = ref('');
    const userInfo = ref({});
    const router = useRouter();

    const profilePictureUrl = computed(() => {
      if (userInfo.value.profile_picture) {
        return `http://localhost:5000${userInfo.value.profile_picture}`;
      }
      return require('@/assets/defaultProfile.png');
    });

    onMounted(async () => {
      isLoggedIn.value = localStorage.getItem('isLoggedIn') === 'true';
      username.value = localStorage.getItem('username') || '';

      if (isLoggedIn.value) {
        try {
          const token = localStorage.getItem('token');
          const response = await axios.get('http://localhost:5000/user', {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          });
          userInfo.value = response.data;
        } catch (error) {
          console.error('Failed to fetch user details:', error);
          alert('Failed to fetch user details. Please try again later.');
        }
      }
    });

    const goToEditProfile = () => {
      router.push('/update-profile');
    };

    return {
      isLoggedIn,
      username,
      userInfo,
      goToEditProfile,
      profilePictureUrl,
    };
  },
};
</script>

<style scoped>
.user-profile {
  padding: 20px;
  background-color: #f9f9f9;
  border-radius: 10px;
  max-width: 600px;
  margin: 20px auto;
}
.edit-profile-btn {
  background-color: #0f6016;
  color: white;
  padding: 10px 20px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  font-size: 16px;
  margin-top: 20px;
}
.edit-profile-btn:hover {
  background-color: #0d4f12;
}
.profile-picture {
  width: 150px;
  height: 150px;
  margin: 0 auto 20px;
  border-radius: 50%;
  overflow: hidden;
}

.profile-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
</style>