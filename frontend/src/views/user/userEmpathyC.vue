<template>
    <Navbar :isLoggedIn="isLoggedIn" :username="username" :profilePicture="userInfo.profile_picture" />
  </template>
  
  <script>
  import { ref, onMounted } from 'vue';
  import axios from 'axios';
  import Navbar from '@/components/Navbar.vue';
  
  export default {
    name: 'UserEmpathyC',
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
  </style>