<template>
  <div>
    <Navbar :isLoggedIn="isLoggedIn" :username="username" />
    <div class="user-profile">
      <h2>User Profile</h2>
      <p><strong>Student ID:</strong> {{ userInfo.student_id }}</p>
      <p><strong>Username:</strong> {{ userInfo.username }}</p>
      <p><strong>Email:</strong> {{ userInfo.email }}</p>
      <p><strong>First Name:</strong> {{ userInfo.firstname }}</p>
      <p><strong>Middle Name:</strong> {{ userInfo.middlename }}</p>
      <p><strong>Last Name:</strong> {{ userInfo.lastname }}</p>
      <p><strong>Gender:</strong> {{ userInfo.gender }}</p>
      <p><strong>Birthdate:</strong> {{ userInfo.birthdate }}</p>
      <p><strong>Program:</strong> {{ userInfo.program }}</p>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import Navbar from '../../components/Navbar.vue';
import axios from 'axios';

export default {
  name: 'UserProfile',
  components: {
    Navbar,
  },
  setup() {
    const isLoggedIn = ref(false);
    const username = ref('');
    const userInfo = ref({});

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

    return {
      isLoggedIn,
      username,
      userInfo,
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
</style>